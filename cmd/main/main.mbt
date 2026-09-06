///|
/// Entry point for the CLI or runnable program in this template.
/// Keep main focused; move logic into the library package.
/// Run with `moon run cmd/main` from the project root.
fn run(args : Array[String]) -> String {
  if args.length() < 2 {
    "usage: moon-csvkit <check|format|to-jsonl|from-jsonl> <input>"
  } else {
    match args[0] {
      "check" =>
        match @lib.parse(args[1]) {
          Ok(rows) => "valid CSV rows=" + rows.length().to_string()
          Err(error) => "invalid CSV: " + error
        }
      "format" =>
        match @lib.parse(args[1]) {
          Ok(rows) => @lib.serialize(rows)
          Err(error) => "invalid CSV: " + error
        }
      "to-jsonl" =>
        match @lib.parse_table(args[1], true) {
          Ok(table) => table.to_jsonl().unwrap()
          Err(error) => "invalid CSV: " + error
        }
      "from-jsonl" =>
        if args.length() < 3 || args[2] == "" {
          "usage: moon-csvkit from-jsonl <input> <header1,header2,...>"
        } else {
          let headers = args[2].split(",").map(x => x.to_owned()).to_array()
          match @lib.from_jsonl(args[1], headers) {
            Ok(rows) => @lib.serialize(rows)
            Err(error) => "invalid JSON Lines: " + error
          }
        }
      _ => "unknown command"
    }
  }
}

///|
fn main {
  let args = @env.args()
  if args.length() < 3 {
    println(run([]))
  } else if args[1] == "from-jsonl" {
    println(
      run([args[1], args[2], if args.length() > 3 { args[3] } else { "" }]),
    )
  } else {
    println(run([args[1], args[2]]))
  }
}
