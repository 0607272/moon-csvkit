///|
/// Entry point for the CLI or runnable program in this template.
/// Keep main focused; move logic into the library package.
/// Run with `moon run cmd/main` from the project root.
fn main {
  let args = @env.args()
  if args.length() < 3 {
    println("usage: moon-csvkit <check|format|to-jsonl|from-jsonl> <input>")
  } else {
    match args[1] {
      "check" =>
        match @lib.parse(args[2]) {
          Ok(rows) => println("valid CSV rows=" + rows.length().to_string())
          Err(error) => println("invalid CSV: " + error)
        }
      "format" =>
        match @lib.parse(args[2]) {
          Ok(rows) => println(@lib.serialize(rows))
          Err(error) => println("invalid CSV: " + error)
        }
      "to-jsonl" =>
        match @lib.parse_table(args[2], true) {
          Ok(table) => println(table.to_jsonl().unwrap())
          Err(error) => println("invalid CSV: " + error)
        }
      "from-jsonl" =>
        if args.length() < 4 {
          println("usage: moon-csvkit from-jsonl <input> <header1,header2,...>")
        } else {
          let headers = args[3].split(",").map(x => x.to_owned()).to_array()
          match @lib.from_jsonl(args[2], headers) {
            Ok(rows) => println(@lib.serialize(rows))
            Err(error) => println("invalid JSON Lines: " + error)
          }
        }
      _ => println("unknown command")
    }
  }
}
