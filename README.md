# balzac

A small static website generator, written in OCaml.

It takes your content and templates and turns them into ready-to-publish
HTML pages. Content is written in Markdown, and templates use
[Jingoo](https://github.com/tategakibunko/jingoo), which follows Jinja2
closely.

The user guide is online at <https://fr4nk-13.github.io/balzac/>. That
site is itself built with balzac.

## Install

balzac is not on opam yet. Build it from the sources:

```sh
git clone https://github.com/fr4nk-13/balzac.git
cd balzac
opam install . --deps-only
dune build
```

## Usage

A site is a folder with a `config.yml` file, a `content/` folder and a
`templates/` folder. `examples/blog` is a complete one.

Build it into an output folder:

```sh
dune exec -- balzac build examples/blog output
```

Or serve it locally while you write. The site is rebuilt when a file
changes:

```sh
dune exec -- balzac serve examples/blog output
```

The site is then at <http://127.0.0.1:1799/>.

The [user guide](https://fr4nk-13.github.io/balzac/articles.html)
covers pages, templates, and recipes for a tag page, a sitemap and an
RSS feed.

## To do

- [ ] Tests (yes, yes, test-driven development 🤗)
- [ ] Code documentation
- [ ] A release on opam
- [ ] Copy hidden files such as `.nojekyll` from `content/`
- [ ] Clean the output folder, so that deleted pages do not stay in it
- [ ] Reload the browser when `serve` rebuilds the site
- [ ] A `--base-url` option on `build`, to publish to several addresses
- [ ] Drafts: pages that `serve` shows and `build` leaves out
- [ ] Build the list of pages once, not once per rendered page
- [ ] Publish the guide from a GitHub Action instead of committing `docs/`
- [ ] ...

## Use of AI

I designed balzac and wrote its OCaml code myself.

AI is used for two things:

- research: finding libraries, reading their documentation, reviewing my
  code;
- everything that needs polished English: this README, the user guide
  and the example site that holds it (`examples/blog`, published from
  `docs/`), and the documentation of the code.
