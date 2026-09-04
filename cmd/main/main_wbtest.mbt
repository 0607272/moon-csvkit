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
