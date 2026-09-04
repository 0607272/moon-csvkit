///|
/// Public error text returned when CSV input is invalid.
pub type CsvError = String

///|
/// Parse a basic comma-separated document into rows.
pub fn parse(input : String) -> Result[Array[Array[String]], CsvError] {
  let chars = input.to_array()
  let rows = []
  let mut row = []
  let mut field = StringBuilder()
  let mut quoted = false
  let mut after_quote = false
  let mut i = 0
  while i < chars.length() {
    let c = chars[i]
    if quoted {
      if c == '"' {
        if i + 1 < chars.length() && chars[i + 1] == '"' {
          field.write_char('"')
          i += 1
        } else {
          quoted = false
          after_quote = true
        }
      } else {
        field.write_char(c)
      }
    } else if after_quote {
      if c == ',' {
        row.push(field.to_string())
        field = StringBuilder()
        after_quote = false
      } else if c == '\n' {
        row.push(field.to_string())
        rows.push(row)
        row = []
        field = StringBuilder()
        after_quote = false
      } else if c == '\r' && i + 1 < chars.length() && chars[i + 1] == '\n' {
        row.push(field.to_string())
        rows.push(row)
        row = []
        field = StringBuilder()
        after_quote = false
        i += 1
      } else {
        return Err("unexpected character after closing quote")
      }
    } else if c == ',' {
      row.push(field.to_string())
      field = StringBuilder()
    } else if c == '"' && field.is_empty() {
      quoted = true
    } else if c == '\n' {
      row.push(field.to_string())
      rows.push(row)
      row = []
      field = StringBuilder()
    } else if c == '\r' && i + 1 < chars.length() && chars[i + 1] == '\n' {
      row.push(field.to_string())
      rows.push(row)
      row = []
      field = StringBuilder()
      i += 1
    } else {
      field.write_char(c)
    }
    i += 1
  }
  if quoted {
    return Err("unterminated quoted field")
  }
  if after_quote || !field.is_empty() || row.length() > 0 {
    row.push(field.to_string())
    rows.push(row)
  }
  Ok(rows)
}

///|
/// Serialize rows as normalized CSV with a trailing newline.
pub fn serialize(rows : Array[Array[String]]) -> String {
  let output = StringBuilder()
  for row_idx, row in rows {
    for col_idx, field in row {
      if col_idx > 0 {
        output.write_char(',')
      }
      let needs_quotes = field.contains(",") ||
        field.contains("\n") ||
        field.contains("\r") ||
        field.contains("\"")
      if needs_quotes {
        output.write_char('"')
        for c in field.iter() {
          if c == '"' {
            output.write_string("\"\"")
          } else {
            output.write_char(c)
          }
        }
        output.write_char('"')
      } else {
        output.write_string(field)
      }
    }
    if row_idx + 1 < rows.length() {
      output.write_char('\n')
    }
  }
  if rows.length() > 0 {
    output.write_char('\n')
  }
  output.to_string()
}
