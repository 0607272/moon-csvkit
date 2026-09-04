///|
fn main {
  let csv = "name,note\nAda,\"hello, world\"\n"
  let rows = @csvkit.parse(csv).unwrap()
  println(@csvkit.serialize(rows))
}
