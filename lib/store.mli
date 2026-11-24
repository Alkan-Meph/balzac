val pages : output_dir:Fpath.t -> Render.t list -> (unit, Error.t) result

val statics :
  content_dir:Fpath.t ->
  output_dir:Fpath.t ->
  Fpath.t list ->
  (unit, Error.t) result
