(** Site configuration, read from the [config.yml] file of a site. *)

type t = {
  base_url : Uri.t;
      (** The address the site is published at. It is the [base-url] key of the
          file. *)
}
(** The configuration of a site. *)

val of_file : Fpath.t -> (t, Error.t) result
(** [of_file path] reads the configuration from the YAML file [path].

    It is an error if the file cannot be read, if it is not valid YAML, or if
    [base-url] is missing or is not a string. *)
