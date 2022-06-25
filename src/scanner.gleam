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

pub type CharList = List(String)

pub type Token {
     Token(kind: TokenKind, value: String)
     NoToken
}

pub type TokenAcc {
    TokenAcc(list: List(Token), temp: Token, source: CharList)
}

pub fn new_token(kind, value) {
    Token(kind: kind, value: value)
}

pub fn new_acc(list: List(Token), temp: Token, source: CharList) {
    TokenAcc(list: list, temp: temp, source: source)
}


/// Maybe I can use fold with 
pub fn scan(source) {
    let chars =
    source
    |> string.to_graphemes
    
    list.index_fold(chars, new_acc([NoToken], NoToken, chars), token_reducer)
    |> print_token_acc
}

pub fn print_token_acc(acc: TokenAcc) {
    acc.list
    |> list.each(fn(x) { io.debug(x) })
}

pub fn add_final_token(acc: TokenAcc, token: Token) -> TokenAcc {
    case token {
             Token(kind, value) ->  new_acc(
                       list.append(acc.list, [token]),
                       NoToken,
                       acc.source
                )
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
     "0" | "1" | "2" | "3" | "4" |
     "5" | "6" | "7" | "8" | "9" -> handle_number(acc, t, index)
      _ -> acc
   }
}

pub fn is_number(t: String) -> Bool {
    case t {
     "0" | "1" | "2" | "3" | "4" |
     "5" | "6" | "7" | "8" | "9" -> True
     _ -> False
     }

}


pub fn handle_number(acc: TokenAcc, t: String, index: Int) -> TokenAcc {
    let next = list.at(acc.source, index + 1)
    io.debug(next)
    case next {
         Ok(a) ->
             case acc.temp { 
                      Token(kind, value) -> {
                                  io.debug(#("has next", a))
                                  case is_number(a) {
                                       False -> add_temp_token(acc, new_token(NUMBER, t))
                                       True -> acc
                                  }
                                  }
                     _ -> {

                        io.debug(#("has next", a, "current", t))
                        case is_number(a) {
                             False -> add_final_token(acc, new_token(NUMBER, t))
                             True -> acc
                        }
                     }
             }
         Error(e) -> acc
    }

}

fn token_reducer(acc: TokenAcc, t: String, index: Int) -> TokenAcc {
   case t {
        "(" -> add_final_token(acc, new_token(LPAREN, t))
        ")" -> add_final_token(acc, new_token(RPAREN, t))
        "+" -> add_final_token(acc, new_token(PLUS, t))
        "\n" -> acc
        _ -> handle_complex_token(acc, t, index)
   }
}