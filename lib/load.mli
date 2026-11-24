val scan_dir : Fpath.t -> (Fpath.t list * Fpath.t list, Error.t) result

val of_files :
  content_dir:Fpath.t ->
  base_url:Uri.t ->
  Fpath.t list ->
  (Page.t list, Error.t) result
