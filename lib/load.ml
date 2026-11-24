open Syntax

let scan_dir content_dir =
  let classify path ((pages, assets) as files) =
    match Fpath.rem_prefix content_dir path with
    | None -> files
    | Some path ->
        if Fpath.has_ext "md" path then (path :: pages, assets)
        else (pages, path :: assets)
  in
  Bos.OS.Dir.fold_contents ~elements:`Files ~traverse:`Any ~dotfiles:true classify ([], [])
    content_dir

let of_file ~content_dir ~base_url path =
  let source_path = Fpath.(content_dir // path) in
  let* source = Bos.OS.File.read source_path in
  match Page.of_string ~path ~base_url source with
  | Ok _ as result -> result
  | Error (`Msg msg) -> Error.msgf "%a: %s" Fpath.pp source_path msg

let of_files ~content_dir ~base_url paths =
  map_result (of_file ~content_dir ~base_url) paths
