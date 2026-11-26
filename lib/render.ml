open Jingoo.Jg_types
open Syntax

type t = { page : Page.t; content : string }

let rec attribute_of_yaml = function
  | `Null -> Tnull
  | `Bool b -> Tbool b
  | `Float f -> Tfloat f
  | `String s -> Tstr s
  | `A l -> Tlist (List.map attribute_of_yaml l)
  | `O l -> Tobj (attributes_of_yaml l)

and attributes_of_yaml yaml =
  List.map (fun (k, v) -> (k, attribute_of_yaml v)) yaml

let models_of_page page =
  ("content", Tstr page.Page.content)
  :: ("url", Tstr (Uri.to_string page.Page.url))
  :: attributes_of_yaml page.front_matter.all

let make_env ~templates_dir =
  {
    std_env with
    autoescape = false;
    template_dirs = [ Fpath.to_string templates_dir ];
  }

let page ~templates_dir ~base_url ~pages page =
  (* TODO: not optimized to recompute these value for each page. *)
  let page_models = models_of_page page in
  let pages_models = List.map (fun page -> Tobj (models_of_page page)) pages in
  let models =
    ("base_url", Tstr (Uri.to_string base_url))
    :: ("pages", Tlist pages_models)
    :: page_models
  in
  let env = make_env ~templates_dir in
  let template_path =
    Fpath.(
      to_string (templates_dir / page.front_matter.known_attributes.template))
  in
  try
    Ok
      {
        page;
        content = Jingoo.Jg_template.from_file ~env ~models template_path;
      }
  with Failure msg | SyntaxError msg ->
    Error.msgf "%s: %s" page.front_matter.known_attributes.template msg

let pages ~templates_dir ~base_url pages =
  map_result (page ~templates_dir ~base_url ~pages) pages
