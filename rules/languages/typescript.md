---
paths: ["**/*.ts", "**/*.tsx", "**/*.js", "**/*.mjs", "**/*.svelte", "**/package.json"]
---
# TypeScript and JavaScript

- **Checks before commit:** `tsc --noEmit` (or `svelte-check`), `eslint --max-warnings 0`,
  the test runner, and the build. Expose them as `npm run typecheck`, `lint`, `test`,
  `build` so agents and CI call the same names.
- **Strict mode on** (`"strict": true`), plus `noUncheckedIndexedAccess` in new projects.
  No `any` without a comment saying why.
- **ESM** (`"type": "module"`) for new Node code, on a current LTS Node.
- **Validate at the boundary** with a schema library (Zod). Handlers read the validated
  value, never the raw `req.body`. Keep schemas and API docs in sync with a test.
- **Errors:** throw typed errors from one `errors/` module and render them in one handler.
  Never swallow a rejected promise; every `async` call is awaited or explicitly handled.
- **Tests:** Vitest or Jest for units, Playwright for end-to-end. ESM and `jest.mock` don't
  mix; mock with dependency injection or the runner's ESM API.
- **Framework versions move fast.** Read the installed framework's own docs (often under
  `node_modules/<pkg>/dist/docs/`) before writing framework code, and heed deprecation
  warnings.
- **Lockfile committed,** dependency updates through Dependabot or Renovate.
