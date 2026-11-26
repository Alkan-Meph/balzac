(** Pages.

    A page is a Markdown file that starts with a front matter: a block of YAML
    between two [---] lines.

    {v
    ---
    title: "Hello"
    template: "post.html"
    ---

    The *Markdown* content.
    v} *)

type known_attributes = {
  title : string;  (** The title of the page. *)
  template : string;
      (** The template that renders the page: a file name, relative to the
          templates directory. *)
  output : Fpath.t option;
      (** Where the page is written, relative to the output directory, when the
          default location does not fit. See {!t.output_path}. *)
}
(** The front matter attributes balzac itself reads. [title] and [template] are
    required. *)

type front_matter = {
  known_attributes : known_attributes;
  all : (string * Yaml.value) list;
      (** Every attribute of the front matter, the known ones included, as
          written in the file. *)
}
(** The front matter of a page. *)

type t = {
  front_matter : front_matter;
  content : string;  (** The content of the page, converted to HTML. *)
  output_path : Fpath.t;
      (** Where the page is written, relative to the output directory. It is the
          [output] attribute if there is one, and the path of the source file
          with the [.html] extension otherwise. *)
  url : Uri.t;  (** The address of the page: the base URL and [output_path]. *)
}
(** A page. *)

val of_string : path:Fpath.t -> base_url:Uri.t -> string -> (t, Error.t) result
(** [of_string ~path ~base_url source] parses [source], the text of the file
    [path]. [path] is relative to the content directory, and [base_url] is the
    address the site is published at.

    The Markdown is CommonMark with the extensions of [Cmarkit]. Headings get an
    [id], and raw HTML is kept as is.

    It is an error if:
    - the front matter is missing, is not valid YAML or is not a mapping;
    - [title] or [template] is missing;
    - [output] is not the path of a file, is absolute or contains [..]. *)
