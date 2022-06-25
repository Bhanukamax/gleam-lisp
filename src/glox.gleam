import gleam/io
import gleam/erlang/file
import gleam/erlang.{start_arguments}
import glint.{CommandInput}
import glint/flag
import scanner.{scan}

fn init_with_args() {
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

fn read_file(file_name) {
  io.println(file_name)
  assert Ok(contents) = file.read(file_name)
  scan(contents)
  io.println(contents)
}

fn hello(input: CommandInput) {
  assert Ok(flag.B(caps)) = flag.get_value(from: input.flags, for: "caps")
  io.debug(#("caps >>>", caps))

  let [file_name, ..] = input.args
  read_file(file_name)
}

pub fn main() {
  init_with_args()
  //    read_file("a.glox")
}
