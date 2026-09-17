#!/usr/bin/env ruby
require "cgi"
require "uri"
require "set"

Dir.chdir(File.expand_path("../_site", __dir__))
root = Dir.pwd
pages = Dir["**/*.html"].to_h { |path| [File.expand_path(path), File.read(path)] }
ids = pages.transform_values { |html| html.scan(/\bid=["']([^"']+)["']/).flatten.to_set }
errors = []
pages.each do |path, html|
  html.scan(/\b(?:href|src)=["']([^"']+)["']/).flatten.each do |attribute|
    link = CGI.unescapeHTML(attribute)
    next if link.match?(/\A(?:[a-z][\w+.-]*:|\/\/)/i)
    url = URI.parse(link)
    url_path = URI::DEFAULT_PARSER.unescape(url.path.to_s)
    target = if url_path.empty?
      path
    elsif url_path.start_with?("/")
      File.join(root, url_path.delete_prefix("/"))
    else
      File.expand_path(url_path, File.dirname(path))
    end
    target = File.join(target, "index.html") if File.directory?(target)
    reason = if !File.file?(target)
      "missing file"
    elsif url.fragment && !url.fragment.empty? && ids.key?(target) && !ids[target].include?(URI::DEFAULT_PARSER.unescape(url.fragment))
      "missing anchor"
    end
    errors << "#{path.delete_prefix(root + '/')}: #{link} (#{reason})" if reason
  rescue URI::InvalidURIError
    errors << "#{path.delete_prefix(root + '/')}: invalid local URL #{link}"
  end
end
abort errors.join("\n") unless errors.empty?
puts "Site OK: #{pages.size} pages, all local links and fragments resolve."
