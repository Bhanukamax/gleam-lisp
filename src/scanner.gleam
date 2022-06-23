import gleam/string
import gleam/io
import gleam/list

type TokenKind {
     Lparen
     Rparen
     NLine
     Plus
     NUMBER
     EOF
}

type Token {
 Token(kind: TokenKind, value: String)
}

pub fn scan(source) {
    source
    |> string.to_graphemes
    |> list.map(scan_token)
    |> list.each(fn(x: Token) { io.debug(x) })
}

fn scan_token(token: String)  {
   case token {
        t if t == "(" -> Token(Lparen, "(")
        t if t == ")" -> Token(Lparen, ")")
        t if t == "+" -> Token(Plus, "+") 
        t if t == "\n" -> Token(NLine, "\n")
        _ -> Token(EOF, "/0")
   }
}