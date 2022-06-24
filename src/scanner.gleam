import gleam/string
import gleam/io
import gleam/list

type TokenKind {
     LPAREN
     Rparen
     NLine
     Plus
     NUMBER
     EOF
}

type Token {
     Token(kind: TokenKind, value: String)
}

/// Maybe I can use fold with 
pub fn scan(source) {
    source
    |> string.to_graphemes
    |> list.fold(_, "", fn (acc, i) {
       string.append(acc, i)
    })
    |> io.debug
}

fn scan_token(token, prev)  {
   case token {
        t if t == "(" -> Token(LPAREN, "(")
        t if t == ")" -> Token(Rparen, ")")
        t if t == "+" -> Token(Plus, "+") 
        t if t == "\n" -> Token(NLine, "\n")
        _ -> Token(EOF, "/0")
   }
}