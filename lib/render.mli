type t = { page : Page.t; content : string }

val page :
  templates_dir:Fpath.t -> base_url:Uri.t -> pages:Page.t list -> Page.t -> (t, Error.t) result

val pages : templates_dir:Fpath.t -> base_url:Uri.t -> Page.t list -> (t list, Error.t) result
