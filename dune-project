(lang dune 3.24)

(name balzac)

(generate_opam_files true)

(source
 (github fr4nk-13/balzac))

(authors "fr4nk-13")

(maintainers "fr4nk-13")

(package
 (name balzac)
 (synopsis "A small static website generator")
 (description
  "A tool for building static websites. It takes your content and templates and turns them into ready-to-publish HTML pages.")
 (depends
  ocaml
  fpath
  re
  bos
  (cmdliner
   (>= 1.1.0))
  yaml
  ppx_deriving_yaml
  cmarkit
  jingoo
  uri
  tiny_httpd)
 (tags
  (blog "static site generator" markdown)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
