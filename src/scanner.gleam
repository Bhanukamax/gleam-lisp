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
//    io.debug(acc.list)
    acc.list
    |> list.each(fn(x) { io.debug(x) })
}

pub fn add_final_token(list: TokenAcc, kind: TokenKind, value) {
               new_acc(
                       list.append(list.list, [new_token(kind, value)]),
                       NoToken,
                       value
                )
}

fn token_reducer(acc: TokenAcc, token: String) {
   case token {
        t if t == "(" -> add_final_token(acc, LPAREN, t)
        t if t == ")" -> add_final_token(acc, RPAREN, t)
        t if t == "+" -> add_final_token(acc, PLUS, t)
        t if t == "\n" -> acc
        _ -> acc
   }

}