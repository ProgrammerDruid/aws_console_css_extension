# AWS Console Font Fix

A tiny browser extension for Firefox and Chrome that undoes the November 2026 restyle of the AWS Management Console:

- puts the Amazon Ember font back
- makes links blue again, underlined only on hover

It is a single stylesheet that the browser injects on `*.console.aws.amazon.com` (and the GovCloud console) before the page paints. There is no JavaScript and it requests no permissions beyond those domains. The font is loaded from AWS's own public CDN.

## Install

### Firefox

1. Download the latest `.xpi` from the [releases page](https://github.com/ProgrammerDruid/aws_console_css_extension/releases) using Firefox
2. Firefox asks whether to add the extension. Click **Add**
3. Reload any open console tabs

The package is signed by Mozilla, so it stays installed across restarts.

### Chrome, Edge, Brave and other Chromium browsers

1. Get the code, either with git or with **Code > Download ZIP** on GitHub (then unzip it):

   ```sh
   git clone https://github.com/ProgrammerDruid/aws_console_css_extension.git
   ```

2. Open `chrome://extensions` (`edge://extensions` in Edge)
3. Turn on **Developer mode**
4. Click **Load unpacked** and pick the folder that contains `manifest.json`
5. Reload any open console tabs

The extension stays installed across restarts as long as the folder stays where it is. To update, `git pull` and click the reload icon on the extension's card.

### Firefox from source

1. Clone the repo as above
2. Open `about:debugging#/runtime/this-firefox`
3. Click **Load Temporary Add-on...** and pick `manifest.json`
4. Reload any open console tabs

A temporary add-on is removed when Firefox closes. To keep it, use the signed package or sign your own build (see below). Needs Firefox 128 or newer.

## Building and signing your own Firefox package

Release Firefox only installs packages signed by Mozilla. Signing an unlisted add-on is free and automated:

1. Change the `id` in `manifest.json` to something of your own, since each ID can only be registered once
2. Create API credentials at https://addons.mozilla.org/developers/addon/api/key/
3. Run:

   ```sh
   npx web-ext sign --channel=unlisted --api-key=<JWT issuer> --api-secret=<JWT secret>
   ```

The signed `.xpi` lands in `web-ext-artifacts/`. `web-ext-config.mjs` keeps repo-only files out of the package.

`npx web-ext build` makes an unsigned package, which only installs on Firefox Developer Edition, Nightly or ESR with `xpinstall.signatures.required` set to `false` in `about:config`.

## Customize

Everything lives in `fix.css`. After editing, reload the extension (the **Reload** button in `about:debugging` on Firefox, the reload icon on the extension's card on Chrome) and refresh the console tab.

- **Different font:** put your font first in the `font-family` list, for example `"Segoe UI"` or `"Inter"`.
- **Link colours:** change the `--console-fix-link` variables. There is one pair for light mode and one for dark mode.
- **Keep the new link style:** delete everything from the `Links:` comment down.

## Known limits

- AWS only publishes Light, Regular and Bold, so italics are synthesized by the browser and medium-weight text is shown in Bold.
- Code blocks, editors, terminals and icon fonts are deliberately left alone. If a monospace area ends up in Ember, or some text keeps the new font, add or remove a selector in the first `:not()` list in `fix.css`.
- Buttons, tabs, menus and the top and side navigation are excluded from the link rule. If something turns blue that should not, add it to the second and third `:not()` lists.
- Pages outside the console domains (sign-in, docs) are not touched. Add more patterns to `matches` in `manifest.json` if you want them.
- The selectors are based on the console's current markup and will need updating if AWS changes it.
- Chrome may list a warning about the `browser_specific_settings` manifest key. That key is for Firefox and the warning is harmless.

## License

MIT, see [LICENSE](LICENSE). That covers this extension's code only, not Amazon Ember.
