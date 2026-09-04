# Hackathon 2026 Proposal: NyaCSV Maintenance and Strict Validation

## Project and maintenance direction

This submission targets the existing MoonBit community project
[`moonbit-community/NyaCSV`](https://github.com/moonbit-community/NyaCSV),
version 0.3.3, under the hackathon direction "existing ecosystem project
maintenance and upgrade". NyaCSV already provides CSV parsing from strings,
buffers, and bytes, configurable delimiters and quoting, multiline fields,
headers, and formatted output. Its README explicitly welcomes issues and pull
requests.

The goal is not to publish a duplicate CSV library. It is to contribute a
focused strict-validation layer upstream while preserving the existing API and
behavior.

## Maintenance goals during the competition

1. Add `CSV::parse_string_strict`, returning `Result[CSV, CSVParseError]`.
2. Report malformed quoting and ragged records instead of silently accepting
   them, with a stable error message and one-based line/column location.
3. Keep the existing `CSV::parse_string`, `parse_buffer`, and `parse_bytes`
   APIs compatible for permissive callers.
4. Add regression tests for unterminated quotes, illegal characters after a
   closing quote, inconsistent field counts, CRLF, multiline fields, and valid
   escaped quotes.
5. Update the upstream README with the strict API and migration guidance.
6. Publish public, reviewable commits and an upstream Issue/PR; record links
   and review outcomes here as they become available.

## Verification and deliverables

- MoonBit source and tests are the primary implementation.
- `moon fmt --check`, `moon test`, `moon build`, and CI are required before
  submitting the PR.
- The contribution retains NyaCSV's Apache-2.0 license and does not copy code
  from unrelated CSV projects.
- The local `moon-csvkit` repository is only a reproducible work log and
  validation harness; the actual feature is prepared as a patch against NyaCSV
  for upstream review.

## Out of scope

No new CSV package, SQL engine, network service, GUI, type inference system,
or unrelated refactor is proposed.
