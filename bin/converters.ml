open Cmdliner

let fpath = Arg.conv (Fpath.of_string, Fpath.pp)

let existing_dir =
  let parse s = Result.bind (Arg.conv_parser Arg.dir s) Fpath.of_string in
  Arg.conv (parse, Fpath.pp)
