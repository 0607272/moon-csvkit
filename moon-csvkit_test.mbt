///|
test "parses comma separated records" {
  let result = @moon-csvkit.parse("name,age\nAda,36\n")
  assert_eq(result, Ok([["name", "age"], ["Ada", "36"]]))
}

///|
test "parses quoted commas and embedded newlines" {
  let result = @moon-csvkit.parse(
    "name,note\nAda,\"hello, world\"\nBob,\"line1\nline2\"\n",
  )
  assert_eq(
    result,
    Ok([["name", "note"], ["Ada", "hello, world"], ["Bob", "line1\nline2"]]),
  )
}

///|
test "serializes fields that need quoting" {
  let rows = [["name", "note"], ["Ada", "say \"hi\""]]
  assert_eq(@moon-csvkit.serialize(rows), "name,note\nAda,\"say \"\"hi\"\"\"\n")
}

///|
test "serializes rows with a custom delimiter" {
  assert_eq(
    @moon-csvkit.serialize_with_delimiter(
      [["name", "note"], ["Ada", "x;y"]],
      ';',
    ),
    "name;note\nAda;\"x;y\"\n",
  )
}

///|
test "rejects unterminated quoted fields" {
  assert_true(@moon-csvkit.parse("name,\"Ada\n") is Err(_))
}

///|
test "preserves empty fields" {
  assert_eq(@moon-csvkit.parse("a,,c\n"), Ok([["a", "", "c"]]))
}

///|
test "rejects inconsistent column counts" {
  assert_true(@moon-csvkit.parse("a,b\n1\n") is Err(_))
}

///|
test "parses CRLF records without carriage returns in fields" {
  assert_eq(@moon-csvkit.parse("a,b\r\n1,2\r\n"), Ok([["a", "b"], ["1", "2"]]))
}

///|
test "parses a quoted empty field at end of input" {
  assert_eq(@moon-csvkit.parse("name\n\"\""), Ok([["name"], [""]]))
}

///|
test "permissive mode keeps inconsistent rows" {
  assert_eq(
    @moon-csvkit.parse_with_options("a,b\n1\n", strict=false),
    Ok([["a", "b"], ["1"]]),
  )
}

///|
test "maps header row into JSON Lines" {
  let table = @moon-csvkit.parse_table("name,age\nAda,36\n", true)
  let parsed = table.unwrap()
  assert_eq(parsed.headers, ["name", "age"])
  assert_eq(parsed.rows, [["Ada", "36"]])
  let jsonl = parsed.to_jsonl()
  assert_eq(jsonl, Ok("{\"name\":\"Ada\",\"age\":\"36\"}\n"))
}

///|
test "converts JSON Lines back to CSV rows" {
  let result = @moon-csvkit.from_jsonl("{\"age\":\"36\",\"name\":\"Ada\"}\n", [
    "name", "age",
  ])
  assert_eq(result, Ok([["Ada", "36"]]))
}

///|
test "rejects malformed JSON Lines" {
  assert_eq(
    @moon-csvkit.from_jsonl("not-json\n", ["name"]),
    Err("invalid JSON line"),
  )
}

///|
test "rejects JSON Lines with missing headers" {
  assert_eq(
    @moon-csvkit.from_jsonl("{\"name\":\"Ada\"}\n", ["name", "age"]),
    Err("missing JSON field"),
  )
}

///|
test "rejects JSON Lines values that are not objects" {
  assert_eq(
    @moon-csvkit.from_jsonl("[\"Ada\"]\n", ["name"]),
    Err("JSON line must be an object"),
  )
}

///|
test "rejects non-string JSON fields" {
  assert_eq(
    @moon-csvkit.from_jsonl("{\"age\":36}\n", ["age"]),
    Err("JSON fields must be strings"),
  )
}

///|
test "skips blank JSON Lines records" {
  assert_eq(
    @moon-csvkit.from_jsonl("\n{\"name\":\"Ada\"}\n\n", ["name"]),
    Ok([["Ada"]]),
  )
}
// Prefer high-level behaviors over implementation details.
// Run `moon test` to execute and `moon test --update` to refresh snapshots.
