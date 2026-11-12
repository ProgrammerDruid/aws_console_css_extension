# AWS Console Font Fix

A tiny Firefox extension that undoes the November 2026 restyle of the AWS Management Console:

- puts the Amazon Ember font back
- makes links blue again, underlined only on hover

It is a single stylesheet that Firefox injects on `*.console.aws.amazon.com` (and the GovCloud console) before the page paints. There is no JavaScript and it requests no permissions beyond those domains.

## Install

### 1. Get the code

```sh
git clone https://github.com/ProgrammerDruid/aws_console_css_extension.git
cd aws_console_css_extension
```

### 2. Get the fonts (optional but recommended)

Amazon Ember belongs to Amazon, so it is not in this repo. Download it from AWS's public CDN into `fonts/`:

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

If you skip this step, the stylesheet tries to load the same files straight from the CDN instead, which is slower and could be blocked by the console's content security policy.

### 3. Load the extension

**Temporary (gone when Firefox restarts):**

1. Open `about:debugging#/runtime/this-firefox`
2. Click **Load Temporary Add-on...**
3. Pick `manifest.json` from this folder
4. Reload any open console tabs

**Permanent:** release Firefox only keeps signed extensions. Either:

- Sign it yourself as an unlisted add-on (free, needs an addons.mozilla.org account and API key). Change the `id` in `manifest.json` to something of your own first, since each ID can only be registered once:

  ```sh
  npx web-ext sign --channel=unlisted --api-key=<jwt issuer> --api-secret=<jwt secret>
  ```

  Then open the resulting `.xpi` in Firefox.

- Or use Firefox Developer Edition, Nightly or ESR, set `xpinstall.signatures.required` to `false` in `about:config`, zip the folder contents, rename the zip to `.xpi` and install it from `about:addons`.

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
