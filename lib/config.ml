open Syntax

module Url = struct
  type t = Uri.t

  let of_yaml = function
    | `String s -> Ok (Uri.of_string s)
    | _ -> Error.msgf "url expects a string"

  let to_yaml t = `String (Uri.to_string t)
end

type t = { base_url : Url.t [@key "base-url"] } [@@deriving yaml]

let of_file path =
  let* source = Bos.OS.File.read path in
  match
    let* yaml = Yaml.of_string source in
    of_yaml yaml
  with
  | Ok _ as result -> result
  | Error (`Msg msg) -> Error.msgf "%a: %s" Fpath.pp path msg
