// @ts-check
const tseslint = require("@typescript-eslint/eslint-plugin");
const tsParser = require("@typescript-eslint/parser");
const angularEslint = require("@angular-eslint/eslint-plugin");
const angularTemplateParser = require("@angular-eslint/template-parser");
const angularTemplatePlugin = require("@angular-eslint/eslint-plugin-template");

module.exports = [
  {
    ignores: ["src/environments/environment.prod.ts", "src/test.ts"]
  },
  {
    files: ["src/**/*.ts"],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        project: ["tsconfig.app.json", "tsconfig.spec.json"],
        createDefaultProgram: true,
      },
    },
    plugins: {
      "@typescript-eslint": tseslint,
      "@angular-eslint": angularEslint,
    },
    rules: {
      "@angular-eslint/component-class-suffix": "error",
      "@angular-eslint/directive-class-suffix": "error",
      "@angular-eslint/no-input-rename": "error",
      "@angular-eslint/no-output-rename": "error",
      "@angular-eslint/use-lifecycle-interface": "warn",
      "@typescript-eslint/no-unused-vars": "warn",
      "@typescript-eslint/no-explicit-any": "warn",
      "prefer-const": "error",
      "no-var": "error",
      "eqeqeq": ["error", "always"],
    },
  },
  {
    files: ["src/**/*.html"],
    languageOptions: {
      parser: angularTemplateParser,
    },
    plugins: {
      "@angular-eslint/template": angularTemplatePlugin,
    },
    rules: {
      "@angular-eslint/template/banana-in-box": "error",
      "@angular-eslint/template/no-negated-async": "error",
    },
  },
];
