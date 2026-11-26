(** Rendering pages with their templates.

    Templates are [Jingoo] templates. Each one receives these variables:
    - the attributes of the front matter of the page, [title] included;
    - [content], the content of the page as HTML;
    - [url], the address of the page;
    - [base_url], the address of the site;
    - [pages], the list of all the pages of the site. Each element holds the
      front matter attributes, the [content] and the [url] of a page.

    Values are not escaped: a template inserts them as they are. *)

type t = {
  page : Page.t;  (** The page that was rendered. *)
  content : string;  (** The text produced by the template. *)
}
(** A rendered page. *)

val page :
  templates_dir:Fpath.t ->
  base_url:Uri.t ->
  pages:Page.t list ->
  Page.t ->
  (t, Error.t) result
(** [page ~templates_dir ~base_url ~pages p] renders [p] with its template,
    which is looked up in [templates_dir]. [pages] are all the pages of the
    site.

    It is an error if the template cannot be loaded or rendered. The error
    message starts with the name of the template. *)

val pages :
  templates_dir:Fpath.t ->
  base_url:Uri.t ->
  Page.t list ->
  (t list, Error.t) result
(** [pages ~templates_dir ~base_url ps] renders each page of [ps] with
    {!val-page}, with [ps] as the pages of the site. The result is in the order
    of [ps]. It stops at the first error. *)
