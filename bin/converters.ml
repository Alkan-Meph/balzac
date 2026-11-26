(** Argument converters for [Cmdliner]. *)

open Cmdliner

(** A path. *)
let fpath = Arg.conv (Fpath.of_string, Fpath.pp)

(** The path of an existing directory. *)
let existing_dir =
  let parse s = Result.bind (Arg.conv_parser Arg.dir s) Fpath.of_string in
  Arg.conv (parse, Fpath.pp)
