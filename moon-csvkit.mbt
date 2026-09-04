///|
/// Public error text returned when CSV input is invalid.
pub type CsvError = String

///|
/// A CSV table with a stable header order.
pub struct CsvTable {
  headers : Array[String]
  rows : Array[Array[String]]
}

///|
/// Parse CSV rows and optionally use the first row as headers.
pub fn parse_table(
  input : String,
  has_header : Bool,
) -> Result[CsvTable, CsvError] {
  match parse(input) {
    Err(error) => Err(error)
    Ok(parsed) =>
      if has_header {
        if parsed.length() == 0 {
          return Ok({ headers: [], rows: [], })
        }
        let data = []
        let mut i = 1
        while i < parsed.length() {
          data.push(parsed[i])
          i += 1
        }
        Ok({ headers: parsed[0], rows: data, })
      } else {
        let headers = Array::makei(
          if parsed.length() == 0 {
            0
          } else {
            parsed[0].length()
          },
          i => "column_" + (i + 1).to_string(),
        )
        Ok({ headers, rows: parsed, })
      }
  }
}

///|
/// Convert each data row to a JSON object using the table headers.
pub fn CsvTable::to_jsonl(self : CsvTable) -> Result[String, CsvError] {
  let output = StringBuilder()
  for row in self.rows {
    let object = Map([])
    for i, header in self.headers {
      if i < row.length() {
        object[header] = Json::string(row[i])
      }
    }
    output.write_string(Json::object(object).stringify())
    output.write_char('\n')
  }
  Ok(output.to_string())
}

///|
/// Convert JSON objects, one per line, into rows in the requested header order.
pub fn from_jsonl(
  input : String,
  headers : Array[String],
) -> Result[Array[Array[String]], CsvError] {
  let rows = []
  for line_view in input.split("\n") {
    let line = line_view.to_owned()
    if line == "" {
      continue
    }
    let value = @json.parse(line) catch { _ => return Err("invalid JSON line") }
    let object = match value {
      Object(object) => object
      _ => return Err("JSON line must be an object")
    }
    let row = []
    for header in headers {
      match object.get(header) {
        Some(field) =>
          match field {
            String(text) => row.push(text)
            _ => return Err("JSON fields must be strings")
          }
        None => return Err("missing JSON field")
      }
    }
    rows.push(row)
  }
  Ok(rows)
}

///|
/// Parse a basic comma-separated document into rows.
pub fn parse(input : String) -> Result[Array[Array[String]], CsvError] {
  parse_with_options(input, strict=true)
}

///|
/// Parse CSV with optional strict column-count validation.
pub fn parse_with_options(
  input : String,
  strict~ : Bool,
) -> Result[Array[Array[String]], CsvError] {
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
  if strict && rows.length() > 0 {
    let expected = rows[0].length()
    for parsed_row in rows {
      if parsed_row.length() != expected {
        return Err("inconsistent column count")
      }
    }
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
