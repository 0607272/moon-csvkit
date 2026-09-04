# moon-csvkit Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Deliver a publishable MoonBit CSV library and CLI with RFC 4180 parsing, validation, formatting, JSON Lines conversion, tests, documentation, CI, and package metadata by 2026-09-24.

**Architecture:** Keep CSV syntax in a state-machine parser, reusable record/header and JSON Lines conversion in a codec layer, and argument/I/O/exit-code concerns in a thin CLI layer. Each layer has focused tests and the CLI depends on the library rather than duplicating parsing logic.

**Tech Stack:** MoonBit toolchain, MoonBit standard library, GitHub Actions, OSI-approved MIT license, mooncakes.io package metadata.

**Spec:** `docs/superpowers/specs/2026-09-04-moon-csvkit-design.md`

## Global Constraints

- MoonBit must be the primary implementation language.
- The repository must remain public with meaningful, traceable commits, Issues/PRs, and update notes.
- The final project must include README, runnable example, complete core tests, CI, OSI-approved licensing, and mooncakes.io publication metadata.
- Existing or migrated functionality must include substantial, independently verifiable work during this competition period.
- Do not use empty, duplicate, or mechanically split commits to satisfy the ten-commit proposal requirement.

### Task 1: Initialize MoonBit package and test harness

**Files:**
- Create: `moon.mod.json` or the MoonBit module file selected by the installed toolchain.
- Create: `src/lib.mbt` with the public package entry point.
- Create: `src/lib_test.mbt` with a smoke test.
- Create: `examples/basic.mbt` with a runnable parse/serialize example.
- Create: `LICENSE`.

**Interfaces:**
- Produces the module/package name `moon-csvkit` and a test command that can run in CI.
- Exposes an initial `parse(input : String) -> Result[Array[Array[String]], CsvError]` shape, refined only if the toolchain requires a package-specific equivalent.

- [ ] Inspect the installed `moon` command and create the smallest valid module with its native initializer.
- [ ] Add a smoke test proving the package builds and a trivial record can be parsed.
- [ ] Run the native formatter, build, and test commands; record exact commands in the plan's implementation notes.
- [ ] Commit the independently working scaffold with message `chore: initialize moon-csvkit package`.

### Task 2: Implement RFC 4180 parser with failing-first tests

**Files:**
- Create: `src/parser.mbt`.
- Modify: `src/lib.mbt` to export parser types/functions.
- Modify: `src/lib_test.mbt` with parser unit tests.

**Interfaces:**
- `CsvError` includes a message/category and 1-based row/column or byte position.
- `parse(input : String) -> Result[Array[Array[String]], CsvError]` parses records.
- `parse_with_options(input, strict : Bool) -> Result[ParseOutput, CsvError]` supports strict and permissive behavior if supported by the toolchain's public type conventions.
- `serialize(rows : Array[Array[String]]) -> String` quotes fields containing comma, quote, or newline and doubles embedded quotes.

- [ ] Add failing tests for empty input, plain rows, quoted commas, embedded newlines, doubled quotes, CRLF, unclosed quotes, and inconsistent column counts.
- [ ] Run only parser tests and verify they fail for the expected missing implementation.
- [ ] Implement an explicit character-state machine with states for field start, unquoted field, quoted field, and post-quote validation.
- [ ] Return structured location information for malformed quoting and strict column-count errors.
- [ ] Add permissive-mode tests and implementation without changing strict defaults.
- [ ] Run parser tests, formatter, and full package tests.
- [ ] Commit `feat: add RFC 4180 CSV parser`.

### Task 3: Add headers and JSON Lines codec

**Files:**
- Create: `src/codec.mbt`.
- Create: `src/codec_test.mbt`.
- Modify: `src/lib.mbt` to export codec APIs.

**Interfaces:**
- `CsvTable` contains optional headers and data rows.
- `parse_table(input, has_header : Bool) -> Result[CsvTable, CsvError]`.
- `to_jsonl(table : CsvTable) -> Result[String, CodecError]` emits one JSON object per data row keyed by headers.
- `from_jsonl(input : String, headers : Array[String]) -> Result[Array[Array[String]], CodecError]` preserves requested header order and reports malformed JSON or missing required fields.

- [ ] Add failing round-trip tests for header mapping, field order, escaped JSON strings, missing fields, and malformed JSON lines.
- [ ] Implement table construction on top of the parser and serializer; do not duplicate CSV tokenization.
- [ ] Implement JSON Lines conversion using MoonBit's available JSON standard-library API.
- [ ] Run codec tests plus parser regression tests.
- [ ] Commit `feat: add table and JSON Lines codecs`.

### Task 4: Implement CLI commands and integration tests

**Files:**
- Create: `cmd/moon-csvkit/main.mbt`.
- Create: `cmd/moon-csvkit/cli_test.mbt` or the toolchain-supported integration-test location.
- Modify: module metadata to expose the executable.

**Interfaces:**
- Commands: `check`, `format`, `to-jsonl`, `from-jsonl`.
- All commands accept `-` for stdin/stdout and return non-zero status on invalid input.
- `check` prints a concise success message or row/column error.

- [ ] Add failing integration tests for each command using stdin and captured stdout/stderr.
- [ ] Implement argument parsing and command dispatch in the CLI only.
- [ ] Wire commands to library APIs; ensure parser errors are not swallowed.
- [ ] Test malformed input, missing headers, and unknown commands with expected exit behavior.
- [ ] Commit `feat: add moon-csvkit command line interface`.

### Task 5: Documentation, examples, CI, and package compliance

**Files:**
- Create: `README.md`.
- Create: `.github/workflows/ci.yml`.
- Create: `moon.pkg.json`/package metadata required for mooncakes.io.
- Modify: `examples/basic.mbt` with copy-pasteable usage.

- [ ] Document project value, four usage scenarios, API and CLI installation/use, limitations, test commands, license, and contribution workflow.
- [ ] Add a runnable example covering quoted CSV and JSON Lines conversion.
- [ ] Configure CI to run formatting, build, and all tests on a clean checkout.
- [ ] Validate metadata and run the local publication/package validation command available in the installed toolchain.
- [ ] Commit `docs: add usage, CI, and package metadata`.

### Task 6: Competition readiness audit

**Files:**
- Modify: `README.md` with final reproducibility checklist and development log link.
- Create: `CHANGELOG.md`.

- [ ] Run all formatter, build, unit, integration, and example commands from a clean checkout.
- [ ] Verify the repository is public, license is OSI-approved, and no third-party source is copied without attribution.
- [ ] Verify at least ten meaningful commits exist before proposal submission; use Issues/PRs and changelog entries to make development traceable.
- [ ] Compare final features against the design spec and explicitly remove any unimplemented claim from README.
- [ ] Commit `chore: complete competition readiness audit`.

