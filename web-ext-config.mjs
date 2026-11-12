// Settings for `npx web-ext build` and `npx web-ext sign`.
// Keeps the Amazon Ember files and repo-only files out of the package;
// the packaged extension loads Ember from AWS's CDN instead.
export default {
  ignoreFiles: [
    'fonts',
    '__fonts',
    'fetch-fonts.ps1',
    'web-ext-config.mjs',
    'README.md',
    'LICENSE',
  ],
  build: {
    overwriteDest: true,
  },
};
