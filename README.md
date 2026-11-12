# AWS Console Font Fix

A tiny Firefox extension that undoes the November 2026 restyle of the AWS Management Console:

- puts the Amazon Ember font back
- makes links blue again, underlined only on hover

It is a single stylesheet that Firefox injects on `*.console.aws.amazon.com` (and the GovCloud console) before the page paints. There is no JavaScript and it requests no permissions beyond those domains.

## Install

### The quick way: signed package

1. Download the latest `.xpi` from the [releases page](https://github.com/ProgrammerDruid/aws_console_css_extension/releases) using Firefox
2. Firefox asks whether to add the extension. Click **Add**
3. Reload any open console tabs

The package is signed by Mozilla, so it stays installed across restarts. It does not contain the font; it loads Amazon Ember from AWS's own CDN.

### From source

```sh
git clone https://github.com/ProgrammerDruid/aws_console_css_extension.git
cd aws_console_css_extension
```

Then in Firefox:

1. Open `about:debugging#/runtime/this-firefox`
2. Click **Load Temporary Add-on...**
3. Pick `manifest.json` from this folder
4. Reload any open console tabs

A temporary add-on is removed when Firefox closes. To keep it, use the signed package above or sign your own build (see below).

### Optional: bundle the fonts locally

Amazon Ember belongs to Amazon, so it is not in this repo. By default the stylesheet loads it from AWS's public CDN. If you run from source and would rather have a local copy, download it into `fonts/`:

```powershell
./fetch-fonts.ps1
```

On macOS or Linux:

```sh
mkdir -p fonts && cd fonts
for f in Lt Rg Bd; do
  curl -O "https://a0.awsstatic.com/libra-css/fonts/amazon-ember/AmazonEmber_$f.woff2"
done
```

## Building and signing your own package

Release Firefox only installs packages signed by Mozilla. Signing an unlisted add-on is free and automated:

1. Change the `id` in `manifest.json` to something of your own, since each ID can only be registered once
2. Create API credentials at https://addons.mozilla.org/developers/addon/api/key/
3. Run:

   ```sh
   npx web-ext sign --channel=unlisted --api-key=<JWT issuer> --api-secret=<JWT secret>
   ```

The signed `.xpi` lands in `web-ext-artifacts/`. `web-ext-config.mjs` keeps the fonts and repo-only files out of the package.

`npx web-ext build` makes an unsigned package, which only installs on Firefox Developer Edition, Nightly or ESR with `xpinstall.signatures.required` set to `false` in `about:config`.

## Customize

Everything lives in `fix.css`. After editing, click **Reload** on the extension in `about:debugging` and refresh the console tab.

- **Different font:** put your font first in the `font-family` list, for example `"Segoe UI"` or `"Inter"`.
- **Link colours:** change the `--console-fix-link` variables. There is one pair for light mode and one for dark mode.
- **Keep the new link style:** delete everything from the `Links:` comment down.

## Known limits

- AWS only publishes Light, Regular and Bold, so italics are synthesized by the browser and medium-weight text is shown in Bold.
- Code blocks, editors, terminals and icon fonts are deliberately left alone. If a monospace area ends up in Ember, or some text keeps the new font, add or remove a selector in the first `:not()` list in `fix.css`.
- Buttons, tabs, menus and the top and side navigation are excluded from the link rule. If something turns blue that should not, add it to the second and third `:not()` lists.
- Pages outside the console domains (sign-in, docs) are not touched. Add more patterns to `matches` in `manifest.json` if you want them.
- The selectors are based on the console's current markup and will need updating if AWS changes it.

## License

MIT, see [LICENSE](LICENSE). That covers this extension's code only, not Amazon Ember.
