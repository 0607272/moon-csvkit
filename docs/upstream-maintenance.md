# NyaCSV Upstream Maintenance Log

Target: `moonbit-community/NyaCSV` `0.3.3`

## Prepared contribution

- Added `CSVParseError` with a message and one-based line/column location.
- Added `CSV::parse_string_strict` as a compatibility-preserving strict entry
  point.
- Added tests for unterminated quotes, illegal trailing text after a closing
  quote, and inconsistent record width.
- Documented the API and the permissive-versus-strict behavior in the README.

The working patch is applied to the local upstream snapshot under
`.repos/moonbit-community/NyaCSV/0.3.3/`. That snapshot is intentionally
ignored by the main repository; it mirrors the upstream package used to
prepare a clean Issue/PR.

## Verification

The focused strict tests pass with the bundled MoonBit toolchain:

```text
Total tests: 3, passed: 3, failed: 0.
```

The full snapshot currently reports failures in older `inspect` expectations
because the bundled toolchain renders string arrays without quotation marks.
The new API compiles successfully; the old snapshots should be refreshed in a
separate compatibility commit before opening the upstream PR.

## External actions pending

- Upstream Issue created: https://github.com/moonbit-community/NyaCSV/issues/17
- Open a PR after the maintainer confirms the proposed API shape.
- Record the public Issue/PR links and review outcomes here.
