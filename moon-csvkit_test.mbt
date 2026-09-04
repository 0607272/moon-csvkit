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
test "rejects unterminated quoted fields" {
  assert_true(@moon-csvkit.parse("name,\"Ada\n") is Err(_))
}

///|
test "preserves empty fields" {
  assert_eq(@moon-csvkit.parse("a,,c\n"), Ok([["a", "", "c"]]))
}
// Prefer high-level behaviors over implementation details.
// Run `moon test` to execute and `moon test --update` to refresh snapshots.
