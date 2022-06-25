import gleam/string
import gleam/io
import gleam/list
import token.{Token, TokenAcc, new_acc, new_token} as tok

/// Maybe I can use fold with
pub fn new_nope() {
  Token(tok.NOPE, "nope")
}

pub fn scan(source) {
  let chars =
    source
    |> string.to_graphemes

  let tokens =
    list.index_fold(
      chars,
      new_acc([new_nope()], new_nope(), chars),
      token_reducer,
    )

  io.debug(#(">>>>> TOKENS", tokens))
}

pub fn print_token_acc(acc: TokenAcc) {
  acc.list
  |> list.each(fn(x) { io.debug(x) })
}

pub fn add_final_token(acc: TokenAcc, token: Token) -> TokenAcc {
  case token {
    Token(kind, value) ->
      new_acc(list.append(acc.list, [token]), new_nope(), acc.source)
    _ -> acc
  }
}

pub fn add_temp_token(acc: TokenAcc, temp: Token) -> TokenAcc {
  // TODO: to be implemented
  new_acc(acc.list, temp, acc.source)
}

pub fn handle_complex_token(acc: TokenAcc, t: String, index: Int) -> TokenAcc {
  case t {
    " " ->
      case acc.temp {
        Token(kind, value) -> add_final_token(acc, new_token(kind, value))
        _ -> acc
      }
    is_number -> handle_number(acc, t, index)
    _ -> acc
  }
}

pub fn is_number(t: String) -> Bool {
  case t {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}

pub fn check_next_type(acc: TokenAcc, index: Int) {
  let next = list.at(acc.source, index + 1)
  case next {
    Ok(a) ->
      case a {
        is_number -> tok.NUMBER
        _ -> tok.EOF
      }
    Error(e) -> tok.EOF
  }
}

pub fn case_token(token: Token) {
  case token {
    Token(kind, value) -> new_token(kind, value)
    _ -> new_token(tok.NOPE, "")
  }
}

pub fn handle_number(acc: TokenAcc, t: String, index: Int) -> TokenAcc {
  case acc.temp {
    Token(tok.NUMBER, value) ->
      add_temp_token(
        acc,
        new_token(tok.NUMBER, string.concat([acc.temp.value, t])),
      )
    _ ->
      case t {
        is_number -> add_temp_token(acc, new_token(tok.NUMBER, t))
        _ -> add_final_token(acc, new_token(tok.NUMBER, t))
      }
  }
}

fn token_reducer(acc: TokenAcc, t: String, index: Int) -> TokenAcc {
  case t {
    "(" -> add_final_token(acc, new_token(tok.LPAREN, t))
    ")" -> add_final_token(acc, new_token(tok.RPAREN, t))
    "+" -> add_final_token(acc, new_token(tok.PLUS, t))
    "\n" -> acc
    _ -> handle_complex_token(acc, t, index)
  }
}
