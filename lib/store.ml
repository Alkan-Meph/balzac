open Syntax

let write ~path content =
  let* _ = Bos.OS.Dir.create (Fpath.parent path) in
  Bos.OS.File.write path content

let page ~output_dir (rendered_page : Render.t) =
  let path = Fpath.(output_dir // rendered_page.page.output_path) in
  write ~path rendered_page.content

let pages ~output_dir pages = iter_result (page ~output_dir) pages

let static ~content_dir ~output_dir path =
  let source_path = Fpath.(content_dir // path) in
  let path = Fpath.(output_dir // path) in
  let* content = Bos.OS.File.read source_path in
  write ~path content

let statics ~content_dir ~output_dir paths =
  iter_result (static ~content_dir ~output_dir) paths
