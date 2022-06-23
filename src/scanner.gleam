import gleam/string.{concat}
import gleam/io
import gleam/list

pub fn scan(source) {
    source
    |> string.to_graphemes
    |> list.each(fn(x) { io.println(x) })
}