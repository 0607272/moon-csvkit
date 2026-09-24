# NyaCSV Upstream Maintenance Log

This is a separate ecosystem contribution made during development of
`moon-csvkit`. NyaCSV is not the code base, upstream source, or submission
subject of `moon-csvkit`; no NyaCSV code is included in the main project.

Target: `moonbit-community/NyaCSV` `0.3.3`

## Prepared contribution

- Added `CSVParseError` with a message and one-based line/column location.
- Added `CSV::parse_string_strict` as a compatibility-preserving strict entry
  point.
- Added tests for unterminated quotes, illegal trailing text after a closing
  quote, and inconsistent record width.
- Documented the API and the permissive-versus-strict behavior in the README.

The working patch is applied to the local upstream snapshot under
`.repos/0607272/NyaCSV/`. That snapshot is intentionally
ignored by the main repository; it mirrors the upstream package used to
prepare a clean Issue/PR.

## Verification

The focused strict tests pass with the bundled MoonBit toolchain:

```text
Total tests: 3, passed: 3, failed: 0.
```

The full snapshot currently reports failures in older `inspect` expectations
because the bundled toolchain renders string arrays without quotation marks.
The new API compiles successfully. The upstream PR is open and the maintainer
can decide whether those legacy snapshots should be refreshed separately.

## Public contribution records

- Upstream Issue created: https://github.com/moonbit-community/NyaCSV/issues/17
- Upstream PR opened: https://github.com/moonbit-community/NyaCSV/pull/18
- PR source branch: `0607272/NyaCSV:codex/strict-validation`
- PR target branch: `moonbit-community/NyaCSV:main`
- The PR is open with no merge conflicts; its workflow is awaiting approval
  from an upstream maintainer because it comes from a public fork.
