#!/usr/bin/env ruby
# Repository contracts, using only Ruby's standard library. CSS stays hand-authored.
require "yaml"
require "set"
require "open3"

Dir.chdir(File.expand_path("..", __dir__))
errors = []
check = ->(condition, message) { errors << message unless condition }

# Read nested layer/query blocks without flattening conditional declarations into
# the defaults. This is a contract reader for our CSS, not a general CSS validator.
def rules(css, context = [])
  css = css.gsub(%r{/\*.*?\*/}m, "")
  result = []
  offset = 0
  while (match = /([^{}]+)\{/.match(css, offset))
    header = match[1].split(";").last.strip
    start = match.end(0)
    depth = 1
    cursor = start
    while cursor < css.length && depth.positive?
      depth += 1 if css[cursor] == "{"
      depth -= 1 if css[cursor] == "}"
      cursor += 1
    end
    raise "Unclosed CSS block: #{header}" unless depth.zero?
    body = css[start...cursor - 1]
    if header.start_with?("@")
      result.concat(rules(body, context + [header]))
    else
      declarations = body.split(";").filter_map do |entry|
        name, value = entry.strip.split(":", 2)
        [name, value.strip.gsub(/\s+/, " ")] if value
      end
      header.split(",").each { |selector| result << [selector.strip, declarations, context] }
    end
    offset = cursor
  end
  result
end

def classes(css)
  rules(css).flat_map { |selector, _, _| selector.scan(/\.([a-zA-Z_][\w-]*)/).flatten }.to_set
end

def variables(css)
  rules(css).flat_map { |_, declarations, _| declarations.map(&:first).grep(/^--/) }.to_set
end

def normalize(value)
  value.delete('"').gsub(/\s+/, " ").strip
end

core = File.read("tachyons.css")
app = File.read("app.css")
core_rules = rules(core)
core_classes = classes(core)
app_classes = classes(app)
known = core_classes | app_classes | classes(File.read("site.css"))
all_variables = variables(core + app)

tokens = core_rules.select { |s, _, c| s == ":root" && c.all? { |a| a.start_with?("@layer ") } }
  .flat_map { |_, d, _| d }.to_h
groups = YAML.load_file("_data/token_groups.yml")
documented = groups.flat_map { |g| g.fetch("tokens") }.to_h
check.call(tokens.keys.to_set == documented.keys.to_set, "Token inventory differs from _data/token_groups.yml")
documented.each { |name, value| check.call(tokens[name] && normalize(tokens[name]) == normalize(value), "Token value differs: #{name}") }
readme = File.read("README.md")
check.call(readme.include?("**#{tokens.size} tokens** across **#{groups.size} groups**"), "README token/group count is stale")

YAML.load_file("_data/colors.yml").each do |group|
  group.fetch("colors").each do |color|
    name = color.fetch("name")
    check.call(tokens["--#{name}"] && normalize(tokens["--#{name}"]) == normalize(color.fetch("value")), "Palette value differs: #{name}")
    [name, "bg-#{name}", "b--#{name}", "hover-#{name}", "hover-bg-#{name}", color.fetch("text")].each do |utility|
      check.call(core_classes.include?(utility), "Palette documents missing class: #{utility}")
    end
  end
end

# Every existing responsive utility must agree with its base and other query steps.
base = Hash.new { |h, k| h[k] = [] }
variants = %w[ns m l].to_h { |suffix| [suffix, Hash.new { |h, k| h[k] = [] }] }
queries = { "ns" => "@container (min-width: 30em)", "m" => "@container (min-width: 48em)", "l" => "@container (min-width: 64em)" }
core_rules.each do |selector, declarations, context|
  next unless selector.match?(/\A\.[\w-]+\z/)
  if (query = context.find { |a| a.start_with?("@container ") })
    suffix = selector[/-(ns|m|l)\z/, 1]
    check.call(suffix && query == queries[suffix], "Wrong responsive query: #{selector}")
    variants[suffix][selector.sub(/-(ns|m|l)\z/, "")].concat(declarations) if suffix
  elsif context.all? { |a| a.start_with?("@layer ") }
    base[selector].concat(declarations)
  end
end
variants.each do |suffix, utilities|
  check.call(utilities.keys.to_set == variants.fetch("ns").keys.to_set, "Responsive inventory differs: -#{suffix}")
  utilities.each { |selector, declarations| check.call(base[selector] == declarations, "Responsive declaration differs: #{selector}-#{suffix}") }
end

YAML.load_file("_data/app_utility_groups.yml").each do |group|
  group.fetch("tokens").each { |token| check.call(all_variables.include?(token), "App docs reference missing token: #{token}") }
  group.fetch("utilities").each do |pattern|
    check.call(app_classes.any? { |name| File.fnmatch?(pattern, name) }, "App docs reference missing utility: #{pattern}")
  end
  next if group.fetch("name") == "Focus and motion"
  group.fetch("tokens").reject { |token| token.start_with?("--on-") }.each do |token|
    name = token.delete_prefix("--")
    prefixes = ["", "bg-", "b--", "hover-", "hover-bg-", "hover-b--"]
    prefixes << "on-" if %w[Accent State].include?(group.fetch("name"))
    prefixes.each { |prefix| check.call(app_classes.include?(prefix + name), "Incomplete semantic family: #{prefix + name}") }
  end
end

# Check runnable examples, including class attributes inside Markdown code fences.
sources = ["README.md", "index.html", "_data/patches.yml"] + Dir["docs/*.md", "demos/*.html", "_layouts/*.html", "_includes/*.html"]
sources.each do |path|
  source = File.read(path).gsub(/<!--.*?-->/m, "")
  available = known
  if path.start_with?("demos/")
    styles = source.scan(/<style\b[^>]*>(.*?)<\/style>/m).flatten.join("\n")
    source.scan(/<link\b[^>]*>/m).each do |link|
      next unless link.match?(/rel=["']stylesheet["']/)
      href = link[/href=["']([^"']+)["']/, 1]
      next unless href && !href.match?(/\A(?:[a-z]+:|\/\/)/i)
      css_path = File.expand_path(href, File.dirname(path))
      check.call(File.file?(css_path), "#{path}: missing stylesheet #{href}")
      styles << File.read(css_path) if File.file?(css_path)
    end
    available = classes(styles)
  end
  source.scan(/\bclass=["']([^"']*)["']/).flatten.each do |attribute|
    next if attribute.include?("{{")
    attribute.gsub(/{%.*?%}/m, "").split.each do |name|
      check.call(available.include?(name), "#{path}: unknown example class #{name}")
    end
  end
  # Tables can promise classes even when there is no runnable HTML example.
  source.scan(/`\.?([a-zA-Z][\w-]*-(?:ns|m|l))`/).flatten.each do |name|
    check.call(known.include?(name), "#{path}: unknown responsive class #{name}")
  end
end

config = YAML.load_file("_config.yml")
version = config.fetch("version")
ref = config.fetch("cdn_ref")
release = ARGV[1] if ARGV[0] == "--release"
check.call(ARGV.empty? || (ARGV.length == 2 && release&.match?(/\Av\d+\.\d+\.\d+\z/)), "Usage: scripts/check.rb [--release vX.Y.Z]")
check.call(["main", "v#{version}"].include?(ref), "cdn_ref must be main or v#{version}")
banner = "v#{version}#{ref == 'main' ? '+dev' : ''}"
check.call(core.lines.first.include?("TACHYONS NEO #{banner} |"), "CSS version banner must be #{banner}")
check.call(YAML.load_file("_data/releases.yml").first.fetch("version") == "v#{version}", "Site version differs from latest changelog entry")
check.call(readme.scan(%r{tachyons-neo@([^/]+)/(?:tachyons|app)\.css}).flatten == [ref, ref], "README downloads must match cdn_ref #{ref}")
status = readme[/<!-- RELEASE:STATUS -->(.*?)<!-- \/RELEASE:STATUS -->/m, 1].to_s
check.call(ref == "main" ? status.include?("Development documentation: main") : status.include?("Released documentation: v#{version}"), "README release status differs from site")
%w[index.html docs/index.md].each do |path|
  check.call(File.read(path).scan("@{{ site.cdn_ref }}").size == 2, "#{path}: both CDN links must use site.cdn_ref")
end

if release&.match?(/\Av\d+\.\d+\.\d+\z/)
  tags, tag_status = Open3.capture2("git", "tag", "--list", "v*")
  latest = tags.lines.map(&:strip).grep(/\Av\d+\.\d+\.\d+\z/).max_by { |tag| tag.delete_prefix("v").split(".").map(&:to_i) }
  check.call(tag_status.success? && latest, "Release check needs fetched version tags")
  if latest
    previous = latest.delete_prefix("v").split(".").map(&:to_i)
    proposed = release.delete_prefix("v").split(".").map(&:to_i)
    check.call((proposed <=> previous) == 1, "Release #{release} must be newer than #{latest}")
    old_css = %w[tachyons.css app.css].map do |path|
      text, result = Open3.capture2("git", "show", "#{latest}:#{path}")
      check.call(result.success?, "Cannot read #{latest}:#{path}")
      text
    end.join("\n")
    removed = (classes(old_css) - (core_classes | app_classes)) | (variables(old_css) - all_variables)
    check.call(removed.empty? || proposed[0] > previous[0], "Public API removed since #{latest}; use a major release: #{removed.to_a.sort.join(', ')}")
  end
elsif ref != "main"
  %w[tachyons.css app.css].each do |path|
    tagged, result = Open3.capture2e("git", "show", "#{ref}:#{path}")
    check.call(result.success? && tagged == File.read(path), "#{path} differs from #{ref}; mark this checkout as development or prepare a release")
  end
end

if errors.any?
  warn errors.map { |message| "FAIL #{message}" }.join("\n")
  exit 1
end
puts "Consistency OK: #{tokens.size} tokens, #{variants.fetch('ns').size} responsive utilities per step, #{sources.size} example sources, #{ref} documentation."
