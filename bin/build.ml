(** The [build] command. *)

open Cmdliner
open Balzac
open Balzac.Syntax

(** [build ?base_url ~input_dir ~output_dir ()] builds the site of [input_dir]
    in [output_dir].

    The site is read from [config.yml], [content/] and [templates/] in
    [input_dir]. [base_url] replaces the base URL of the configuration. A base
    URL always ends with [/]: one is added when it is missing. *)
let build ?base_url ~input_dir ~output_dir () =
  let input_dir = Fpath.normalize input_dir in
  let output_dir = Fpath.normalize output_dir in

  let config_path = Fpath.(input_dir / "config.yml") in
  let* config = Config.of_file config_path in

  let content_dir = Fpath.(input_dir / "content") in
  let* page_paths, static_paths = Load.scan_dir content_dir in

  let templates_dir = Fpath.(input_dir / "templates") in

  let base_url = Option.value base_url ~default:config.base_url in
  let base_url =
    let path = Uri.path base_url in
    if String.ends_with ~suffix:"/" path then base_url
    else Uri.with_path base_url (path ^ "/")
  in

  let* pages = Load.of_files ~content_dir ~base_url page_paths in
  let* pages = Render.pages ~templates_dir ~base_url pages in

  let* () = Store.statics ~content_dir ~output_dir static_paths in
  let* () = Store.pages ~output_dir pages in
  Ok ()

(** [run input_dir output_dir] builds the site, reports the outcome and is the
    exit code of the command. *)
let run input_dir output_dir =
  match build ~input_dir ~output_dir () with
  | Ok () ->
      Printf.printf "✨ Build finished with success!\n";
      Cmd.Exit.ok
  | Error (`Msg msg) ->
      Printf.eprintf "💥 An error occurred: %s\n" msg;
      Cmd.Exit.some_error

(** The command itself. *)
let cmd =
  let open Args in
  Cmd.v
    (Cmd.info "build" ~doc:"Build the blog")
    Term.(const run $ input_dir $ output_dir)
