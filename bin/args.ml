open Cmdliner

let input_dir =
  Arg.(
    required
    & pos 0 (some Converters.existing_dir) None
    & info [] ~docv:"DIR" ~doc:"Input directory")

let output_dir =
  Arg.(
    required
    & pos 1 (some Converters.fpath) None
    & info [] ~docv:"DIR" ~doc:"Output directory")
