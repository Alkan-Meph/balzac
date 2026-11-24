open Syntax

module Path = struct
  type t = Fpath.t

  let of_yaml = function
    | `String s ->
        let* path = Fpath.of_string s in
        let path = Fpath.normalize path in
        if not (Fpath.is_file_path path) then
          Error.msgf "%s is not a regular file" s
        else if Fpath.is_rel path && not (List.mem ".." (Fpath.segs path)) then
          Ok path
        else Error.msgf "%s must stay inside the site root directory" s
    | _ -> Error.msgf "path expects a string"

  let to_yaml t = `String (Fpath.to_string t)
end

type known_attributes = {
  title : string;
  template : string;
  output : Path.t option;
}
[@@deriving yaml ~skip_unknown]

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

let front_matter_re =
  let re =
    Re.Perl.re ~opts:[ `Dotall ] {|\A---\r?\n(.*?)\r?\n---\r?\n?(.*)\z|}
  in
  Re.compile re

let split_front_matter source =
  match Re.exec_opt front_matter_re source with
  | Some g -> Ok Re.Group.(get g 1, get g 2)
  | None -> Error.msgf "missing or malformed front matter"

let parse_front_matter front_matter =
  match Yaml.of_string front_matter with
  | Ok (`O fields as yaml) ->
      let* known_attributes = known_attributes_of_yaml yaml in
      Ok { known_attributes; all = fields }
  | Ok _ -> Error.msgf "key-value fields expected"
  | Error _ as error -> error

let html_of_markdown markdown =
  markdown
  |> Cmarkit.Doc.of_string ~strict:false ~heading_auto_ids:true
  |> Cmarkit_html.of_doc ~safe:false

let url_of_path ~base_url path =
  let base_path = Uri.path base_url in
  let base_path =
    if String.ends_with ~suffix:"/" base_path then base_path
    else base_path ^ "/"
  in
  let path = Fpath.to_string path in
  Uri.with_path base_url (base_path ^ path)

let of_string ~path ~base_url source =
  let* front_matter, markdown = split_front_matter source in
  let content = html_of_markdown markdown in
  let* front_matter = parse_front_matter front_matter in
  let output_path =
    Option.value front_matter.known_attributes.output
      ~default:(Fpath.set_ext ".html" path)
  in
  let url = output_path |> url_of_path ~base_url in
  Ok { front_matter; content; output_path; url }
