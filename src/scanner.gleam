import gleam/string
import gleam/io
import gleam/list

/// TODO:
/// Need to move all the token stuff to glox/token
/// TokenKind, Token, and token methods
pub type TokenKind {
     LPAREN
     RPAREN
     NLINE
     PLUS
     NUMBER
     FLOAT
     EOF
}

pub type Token {
     Token(kind: TokenKind, value: String)
     NoToken
}

pub fn new_token(kind, value) {
    Token(kind: kind, value: value)
}

pub type TokenAcc {
    TokenAcc(list: List(Token), temp: Token, value: String)
}

pub fn new_acc(list, temp, value) {
    TokenAcc(list: list, temp: temp, value: value)
}


/// Maybe I can use fold with 
pub fn scan(source) {
    source
    |> string.to_graphemes
    |> list.fold(new_acc([NoToken], NoToken, ""), token_reducer)
    |> print_token_acc
}

pub fn print_token_acc(acc: TokenAcc) {
    acc.list
    |> list.each(fn(x) { io.debug(x) })
}

pub fn add_final_token(list: TokenAcc, token: Token) -> TokenAcc {
    case token {
             Token(kind, value) ->  new_acc(
                       list.append(list.list, [token]),
                       NoToken,
                       value
                )
             _ -> list
                }
}

pub fn handle_complex_token(acc: TokenAcc, t: String) -> TokenAcc {
   case t {
      " " ->
         case acc.temp {
            Token(kind, value) -> add_final_token(acc, new_token(kind, value))
            _ -> acc
      }
      _ -> acc
   }
   
}

fn token_reducer(acc: TokenAcc, t: String) {
   case t {
        "(" -> add_final_token(acc, new_token(LPAREN, t))
        ")" -> add_final_token(acc, new_token(RPAREN, t))
        "+" -> add_final_token(acc, new_token(PLUS, t))
        "\n" -> acc
        _ -> handle_complex_token(acc, t)
   }

}