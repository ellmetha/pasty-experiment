module.exports = require('babel-jest').createTransformer({
  presets: [
    '@babel/preset-env',
  ],
  plugins: [
    '@babel/plugin-proposal-class-properties',
    '@babel/plugin-transform-regenerator',
  ],
});
