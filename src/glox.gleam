import gleam/io
import gleam/erlang.{start_arguments}
import glint.{CommandInput}
import glint/flag

fn hello(input: CommandInput) {
  assert Ok(flag.B(caps)) = flag.get_value(from: input.flags, for: "caps")

  let [file_name, .._] = input.args
  io.println(file_name)
}

pub fn main() {
  glint.new()
  |> glint.add_command(
    at: [],
    do: hello,
    with: [flag.bool("caps", False, "Capitalize the provided name")],
    described: "Prints Hello, <NAME>!",
    used: "'gleam run <NAME>' or 'gleam run <NAME> --caps'",
  )
  |> glint.run(start_arguments())

}


fn hello(input: CommandInput) {
  assert Ok(flag.B(caps)) = flag.get_value(from: input.flags, for: "caps")

  let [file_name, .._] = input.args
  io.println(file_name)

  assert Ok(contents) = file.read(file_name)
  io.println(contents)
}


pub fn main() {
    init_with_args()
}
