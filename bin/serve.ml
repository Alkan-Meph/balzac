(** The [serve] command. *)

open Cmdliner

(** [list_files dir] is the files of [dir] and of its subdirectories, each with
    its modification time. Errors are reported on the standard error and the
    files they concern are left out. *)
let list_files dir =
  let get_mtime path acc =
    match Bos.OS.Path.stat path with
    | Ok stats -> (path, stats.Unix.st_mtime) :: acc
    | Error (`Msg msg) ->
        Format.eprintf "⚠️ impossible to get stats from file %a: %s\n%!" Fpath.pp
          path msg;
        acc
  in
  match
    Bos.OS.Dir.fold_contents ~elements:`Files ~traverse:`Any ~dotfiles:true
      get_mtime [] dir
  with
  | Ok files -> files
  | Error (`Msg msg) ->
      Format.eprintf "⚠️ impossible to list dir %a: %s\n%!" Fpath.pp dir msg;
      []

(** [watch ~input_dir ~output_dir ~base_url files] rebuilds the site each time a
    file of [input_dir] is added, removed or modified. [files] is the last known
    state of [input_dir], as given by {!list_files}.

    It looks for changes every half second and never returns. *)
let rec watch ~input_dir ~output_dir ~base_url files =
  let updated_files = list_files input_dir in
  if updated_files <> files then
    begin match Build.build ~input_dir ~output_dir ~base_url () with
    | Ok () -> Printf.printf "✅ Build successful\n%!"
    | Error (`Msg msg) -> Printf.eprintf "💥 An error occurred: %s\n%!" msg
    end;
  Thread.delay 0.5;
  watch ~input_dir ~output_dir ~base_url updated_files

(** [run input_dir output_dir host port] serves [output_dir] over HTTP on [host]
    and [port], and rebuilds the site when [input_dir] changes. The base URL of
    the site is the address of the server. *)
let run input_dir output_dir host port =
  let base_url = Uri.make ~scheme:"http" ~host ~port ~path:"/" () in
  Format.printf "✨ Serving on %a (input: %a) (output: %a)\n%!" Uri.pp base_url
    Fpath.pp input_dir Fpath.pp output_dir;

  let _watcher =
    Thread.create (fun () -> watch ~input_dir ~output_dir ~base_url []) ()
  in

  let server = Tiny_httpd.create ~addr:host ~port () in
  let config = Tiny_httpd.Dir.config ~dir_behavior:Index () in
  Tiny_httpd.Dir.add_dir_path ~config
    ~dir:(Fpath.to_string output_dir)
    ~prefix:"" server;
  match Tiny_httpd.run server with
  | Ok () -> Cmd.Exit.ok
  | Error exn ->
      Printf.eprintf "💥 An error occurred: %s\n" (Printexc.to_string exn);
      Cmd.Exit.some_error

(** The command itself. *)
let cmd =
  let open Args in
  let host =
    Arg.(
      value & opt string "127.0.0.1"
      & info [ "h"; "host" ] ~docv:"ADDR" ~doc:"Listening host")
  in
  let port =
    Arg.(
      value & opt int 1799
      & info [ "p"; "port" ] ~docv:"PORT" ~doc:"Listening port")
  in
  Cmd.v
    (Cmd.info "serve" ~doc:"Serve a blog (dev only)")
    Term.(const run $ input_dir $ output_dir $ host $ port)
