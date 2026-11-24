type t = { base_url : Uri.t }

val of_file : Fpath.t -> (t, Error.t) result
