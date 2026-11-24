type known_attributes = {
  title : string;
  template : string;
  output : Fpath.t option;
}

type front_matter = {
  known_attributes : known_attributes;
  all : (string * Yaml.value) list;
}

type t = {
  front_matter : front_matter;
  content : string;
  output_path : Fpath.t;
  url : Uri.t;
}

val of_string : path:Fpath.t -> base_url:Uri.t -> string -> (t, Error.t) result
