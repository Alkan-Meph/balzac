(** Command line arguments shared by the commands. *)

open Cmdliner

(** The directory of the site. It must exist. *)
let input_dir =
  Arg.(
    required
    & pos 0 (some Converters.existing_dir) None
    & info [] ~docv:"DIR" ~doc:"Input directory")

(** The directory the site is built in. *)
let output_dir =
  Arg.(
    required
    & pos 1 (some Converters.fpath) None
    & info [] ~docv:"DIR" ~doc:"Output directory")
