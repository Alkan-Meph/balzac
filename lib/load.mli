(** Reading a site from the file system. *)

val scan_dir : Fpath.t -> (Fpath.t list * Fpath.t list, Error.t) result
(** [scan_dir content_dir] lists the files of [content_dir] and of its
    subdirectories. The result is [(pages, statics)]: [pages] are the Markdown
    files ([.md]) and [statics] are all the other files. The paths are relative
    to [content_dir], in no particular order. *)

val of_files :
  content_dir:Fpath.t ->
  base_url:Uri.t ->
  Fpath.t list ->
  (Page.t list, Error.t) result
(** [of_files ~content_dir ~base_url paths] reads and parses the pages [paths],
    which are relative to [content_dir], with {!Page.of_string}. The pages are
    in the order of [paths].

    It stops at the first page that cannot be read or parsed. The error message
    starts with the path of that page. *)
