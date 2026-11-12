// Settings for `npx web-ext build` and `npx web-ext sign`.
// Keeps repo-only files out of the package.
export default {
  ignoreFiles: [
    'web-ext-config.mjs',
    'README.md',
    'LICENSE',
  ],
  build: {
    overwriteDest: true,
  },
};
