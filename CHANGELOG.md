# Changelog

## Unreleased

- Added RFC 4180-style parsing with quoted fields, embedded newlines, CRLF handling, and strict column-count validation.
- Added table headers and JSON Lines conversion APIs.
- Added working CLI command dispatch for CSV checking, formatting, and JSON Lines conversion.
- Added configurable-delimiter serialization through `serialize_with_delimiter`.
- Added CRLF, empty quoted field, and JSON Lines validation regression tests.
- Rejected empty header lists in the `from-jsonl` CLI command.
- Expanded runnable examples and added an explicit build step to CI.
