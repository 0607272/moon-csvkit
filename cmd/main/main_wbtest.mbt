///|
test "check command reports valid CSV" {
  assert_eq(run(["check", "name,age\nAda,36\n"]), "valid CSV rows=2")
}

///|
test "format command returns normalized CSV" {
  assert_eq(
    run(["format", "name,note\nAda,\"hello, world\"\n"]),
    "name,note\nAda,\"hello, world\"\n",
  )
}

///|
test "to-jsonl command maps headers" {
  assert_eq(
    run(["to-jsonl", "name,age\nAda,36\n"]),
    "{\"name\":\"Ada\",\"age\":\"36\"}\n",
  )
}

///|
test "from-jsonl command preserves requested header order" {
  assert_eq(
    run(["from-jsonl", "{\"age\":\"36\",\"name\":\"Ada\"}\n", "name,age"]),
    "Ada,36\n",
  )
}

///|
test "check command reports malformed CSV" {
  assert_eq(
    run(["check", "name,\"Ada\n"]),
    "invalid CSV: unterminated quoted field",
  )
}

///|
test "command runner reports missing arguments" {
  assert_eq(
    run(["from-jsonl", "{\"name\":\"Ada\"}\n"]),
    "usage: moon-csvkit from-jsonl <input> <header1,header2,...>",
  )
}
