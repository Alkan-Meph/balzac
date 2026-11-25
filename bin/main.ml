open Cmdliner

let main_cmd =
  let info = Cmd.info "balzac" ~version:"0.1.1" ~doc:"Blog generator" in
  Cmd.group info [ Build.cmd; Serve.cmd ]

let () = exit (Cmd.eval' main_cmd)
