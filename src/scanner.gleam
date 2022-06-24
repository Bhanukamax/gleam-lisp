import gleam/string
import gleam/io
import gleam/list

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
    |> io.debug
}

fn token_reducer(acc: TokenAcc, token: String) {

   case token {
        t if t == "(" -> new_acc(
        list.append(acc.list, [new_token(LPAREN, t)]),
        NoToken, t)
        t if t == ")" -> acc
        t if t == "+" -> acc 
        t if t == "\n" -> acc
        _ -> new_acc([new_token(LPAREN,"(")], new_token(PLUS, "+"), "" )

   }

}


fn scan_token(token, prev)  {
   case token {
        t if t == "(" -> Token(LPAREN, "(")
        t if t == ")" -> Token(RPAREN, ")")
        t if t == "+" -> Token(PLUS, "+") 
        t if t == "\n" -> Token(NLINE, "\n")
        _ -> Token(EOF, "/0")
   }
}