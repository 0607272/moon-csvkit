# moon-csvkit

MoonBit CSV parser and command-line toolkit for practical data workflows.

## Why

CSV is deceptively simple: commas, quotes, and embedded newlines make line-based processing unreliable. `moon-csvkit` provides a small, testable RFC 4180 parser and conversion APIs for MoonBit projects.

## Library

```moonbit
let rows = @moon-csvkit.parse("name,age\nAda,36\n")
let table = @moon-csvkit.parse_table("name,age\nAda,36\n", true)
let jsonl = table.unwrap().to_jsonl()
```

The parser supports quoted fields, embedded commas and newlines, doubled quotes, CRLF input, empty fields, and strict column-count validation. JSON Lines conversion currently treats values as strings and preserves the requested header order.

## Development

Install MoonBit, then run:

```text
moon fmt
moon test
moon info
moon run cmd/main -- check "name,age\nAda,36\n"
```

The project is developed in public with meaningful commits and tests. Contributions should include a focused test and preserve the MIT license and third-party attribution requirements.

## Competition scope

This repository is being developed for the 2026 MoonBit September Hackathon. The current delivery targets a reusable parser, table/JSON Lines codecs, and a thin CLI with reproducible examples and CI.

## License

MIT. See [LICENSE](LICENSE).
