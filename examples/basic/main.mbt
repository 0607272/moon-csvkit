///|
fn main {
  let csv = "name,note\nAda,\"hello, world\"\n"
  let rows = @csvkit.parse(csv).unwrap()
  println(@csvkit.serialize(rows))
  let table = @csvkit.parse_table(csv, true).unwrap()
  println(table.to_jsonl().unwrap())
  println(@csvkit.serialize_with_delimiter(rows, ';'))
}
