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
  NOPE
}

pub type CharList =
  List(String)

pub type Token {
  Token(kind: TokenKind, value: String)
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
