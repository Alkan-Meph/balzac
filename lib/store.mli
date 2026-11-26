(** Writing a site to the output directory.

    Missing directories are created, and existing files are overwritten. Both
    functions stop at the first error. *)

val pages : output_dir:Fpath.t -> Render.t list -> (unit, Error.t) result
(** [pages ~output_dir rendered] writes each rendered page in [output_dir], at
    the [output_path] of its page. *)

val statics :
  content_dir:Fpath.t ->
  output_dir:Fpath.t ->
  Fpath.t list ->
  (unit, Error.t) result
(** [statics ~content_dir ~output_dir paths] copies the files [paths] from
    [content_dir] to [output_dir]. The paths are relative to [content_dir], and
    each file keeps its path in [output_dir]. *)
