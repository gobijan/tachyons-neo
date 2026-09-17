// Run with playwright-cli run-code --filename scripts/browser-check.js after
// opening a locally served Jekyll build. No test framework or CSS build required.
async (page) => {
  const origin = page.url().match(/^https?:\/\/[^/]+/)[0];
  const assert = (condition, message) => {
    if (!condition) throw new Error(message);
  };
  const visit = async (path) => {
    const response = await page.goto(origin + path, { waitUntil: "domcontentloaded" });
    await page.waitForFunction(() => Array.from(document.querySelectorAll('link[rel="stylesheet"]')).every(link => link.sheet));
    return response;
  };
  const paths = [
    "/", "/docs/", "/docs/layout/", "/docs/color/", "/docs/responsive/",
    "/docs/spacing/", "/docs/tokens/", "/docs/typography/", "/docs/app-css/",
    "/demos/", "/demos/app.html", "/demos/card.html", "/demos/buttons.html",
    "/demos/inputs.html", "/demos/form-field.html", "/demos/dropdown.html",
    "/demos/modal.html", "/demos/tooltip.html", "/demos/flash.html",
    "/demos/shell.html", "/demos/ui-wip.html"
  ];

  for (const width of [390, 1280]) {
    await page.setViewportSize({ width, height: 900 });
    for (const path of paths) {
      const response = await visit(path);
      assert(response.ok(), `${path}: HTTP ${response.status()}`);
      const overflow = await page.evaluate(() => document.documentElement.scrollWidth > innerWidth + 1);
      assert(!overflow, `${path}: horizontal overflow at ${width}px`);
    }
  }

  await visit("/demos/app.html");
  const readTheme = () => page.evaluate(() => {
    const color = (selector) => getComputedStyle(document.querySelector(selector)).color;
    return {
      body: color("body"), scoped: color('[data-theme="dark"]'),
      accent: color(".on-accent"), danger: color(".on-danger"),
      success: color(".on-success"), warning: color(".on-warning"), info: color(".on-info")
    };
  });
  const themes = {};
  for (const scheme of ["light", "dark"]) {
    await page.emulateMedia({ colorScheme: scheme, reducedMotion: "no-preference" });
    themes[scheme] = await readTheme();
    // WCAG non-text contrast: default focus indicators against every app surface.
    const ratios = await page.evaluate(() => {
      const probe = document.createElement("span");
      probe.style.color = "var(--focus)";
      document.body.append(probe);
      const canvas = document.createElement("canvas");
      canvas.width = canvas.height = 1;
      const context = canvas.getContext("2d");
      const luminance = (color) => {
        context.clearRect(0, 0, 1, 1);
        context.fillStyle = color;
        context.fillRect(0, 0, 1, 1);
        const linear = Array.from(context.getImageData(0, 0, 1, 1).data).slice(0, 3).map(value => {
          const channel = value / 255;
          return channel <= 0.04045 ? channel / 12.92 : ((channel + 0.055) / 1.055) ** 2.4;
        });
        return linear[0] * 0.2126 + linear[1] * 0.7152 + linear[2] * 0.0722;
      };
      const focus = luminance(getComputedStyle(probe).color);
      const ratios = {};
      for (const surface of ["base", "1", "2", "3", "4"]) {
        probe.style.backgroundColor = `var(--surface-${surface})`;
        const background = luminance(getComputedStyle(probe).backgroundColor);
        ratios[surface] = (Math.max(focus, background) + 0.05) / (Math.min(focus, background) + 0.05);
      }
      probe.remove();
      return ratios;
    });
    for (const [surface, ratio] of Object.entries(ratios)) {
      assert(ratio >= 3, `Focus contrast on ${scheme} surface-${surface}: ${ratio.toFixed(2)}:1`);
    }
  }
  assert(themes.light.body !== themes.dark.body, "Root theme must follow the selected color scheme");
  assert(themes.light.scoped === themes.dark.scoped, "Scoped dark theme must stay dark");
  assert(themes.light.body !== themes.light.scoped, "Scoped theme must differ from the light root");

  const layout = await page.evaluate(() => {
    const fixture = document.createElement("div");
    fixture.className = "root";
    fixture.innerHTML = '<div class="pa1 pa3-ns pa4-m pa5-l"></div><div class="grid-lanes gtc2"></div>';
    document.body.append(fixture);
    const padding = {};
    for (const width of [479, 480, 767, 768, 1023, 1024]) {
      fixture.style.width = width + "px";
      padding[width] = getComputedStyle(fixture.firstElementChild).padding;
    }
    const grid = getComputedStyle(fixture.lastElementChild).display;
    const lanesSupported = CSS.supports("display", "grid-lanes");
    const pre = {};
    for (const name of ["pre", "pre-ns", "pre-m", "pre-l"]) {
      fixture.firstElementChild.className = name;
      const style = getComputedStyle(fixture.firstElementChild);
      pre[name] = [style.whiteSpace, style.overflowX, style.overflowY];
    }
    fixture.remove();
    return { padding, grid, lanesSupported, pre };
  });
  for (const [width, expected] of Object.entries({479:"4px",480:"16px",767:"16px",768:"32px",1023:"32px",1024:"64px"})) {
    assert(layout.padding[width] === expected, `Container padding at ${width}px: ${layout.padding[width]}`);
  }
  assert(layout.grid === (layout.lanesSupported ? "grid-lanes" : "grid"), "Grid lanes must have a regular-grid fallback");
  for (const [name, values] of Object.entries(layout.pre)) {
    assert(JSON.stringify(values) === JSON.stringify(["pre", "scroll", "scroll"]), `${name}: inconsistent whitespace/overflow`);
  }

  await page.getByRole("button", { name: "Export", exact: true }).click();
  await page.locator("#order-export-menu").waitFor({ state: "visible" });
  await page.keyboard.press("Escape");
  assert(await page.locator("#order-export-menu").evaluate(e => !e.matches(":popover-open")), "Escape must close popovers");

  await page.emulateMedia({ reducedMotion: "reduce" });
  await page.getByRole("button", { name: "Export", exact: true }).click();
  const motion = await page.locator("#order-export-menu").evaluate(e => ({
    visible: getComputedStyle(e).visibility,
    duration: getComputedStyle(e).transitionDuration,
    running: e.getAnimations().filter(a => a.playState === "running").length
  }));
  assert(motion.visible === "visible" && motion.duration === "0s" && motion.running === 0, "Reduced-motion popovers must open immediately");
  await page.keyboard.press("Escape");
  await visit("/demos/card.html");
  await page.locator(".grow").hover();
  const grow = await page.locator(".grow").evaluate(e => ({
    transform: getComputedStyle(e).transform, duration: getComputedStyle(e).transitionDuration
  }));
  assert(grow.transform === "none" && grow.duration === "0s", "Reduced motion must disable interaction scaling");
  await visit("/");
  assert(await page.evaluate(() => getComputedStyle(document.documentElement).scrollBehavior) === "auto", "Reduced motion must disable smooth scrolling");

  await visit("/demos/modal.html");
  await page.getByRole("button", { name: "Delete post", exact: true }).click();
  assert(await page.locator("dialog").evaluate(e => e.open), "Modal must open");
  await page.getByRole("button", { name: "Cancel", exact: true }).click();
  assert(await page.locator("dialog").evaluate(e => !e.open), "Modal must close");
  await visit("/demos/tooltip.html");
  await page.keyboard.press("Tab");
  await page.getByRole("tooltip").waitFor({ state: "visible" });
  assert(await page.getByRole("button").getAttribute("aria-describedby") === "demo-tooltip", "Tooltip must describe its trigger");

  // Exercise the shipped fallback even in a browser supporting contrast-color().
  await page.route("**/app.css", async route => {
    const response = await route.fetch();
    const body = (await response.text()).replace("@supports (color: contrast-color(white))", "@supports (color: unsupported-neo-color(white))");
    await route.fulfill({ response, body });
  });
  try {
    await visit("/demos/app.html");
    for (const scheme of ["light", "dark"]) {
      await page.emulateMedia({ colorScheme: scheme });
      const fallback = await readTheme();
      assert(JSON.stringify(fallback) === JSON.stringify(themes[scheme]), `Contrast fallback differs in ${scheme}: ${JSON.stringify({ native: themes[scheme], fallback })}`);
    }
  } finally {
    await page.unroute("**/app.css");
    await page.emulateMedia({ colorScheme: "light", reducedMotion: "no-preference" });
  }
  return { pages: paths.length, widths: [390, 1280], themes: "passed", containers: "passed", motion: "passed", interactions: "passed", contrastFallback: "passed", focusContrast: "passed" };
}
