---
template: "article.html"
title: "Getting started"
description: "Install balzac, create a site and build it."
order: 1
tags: [article, guide]
---

This article takes you from an empty folder to a site you can open in a
browser.

## Install

balzac is built from its sources with opam and dune:

```bash
git clone https://github.com/fr4nk-13/balzac.git
cd balzac
opam install . --deps-only
dune build
dune install
```

After that, the `balzac` command is available in your opam switch.

## Create a site

A site is a folder with three things in it:

```text
my-site/
  config.yml
  content/
    index.md
  templates/
    page.html
```

`config.yml` holds the address the site will be published at:

```yaml
base-url: "https://example.org/"
```

`content/index.md` is a page. It starts with a block of settings, then the
text:

```markdown
---
template: "page.html"
title: "Hello"
---

Welcome to my site.
```

`templates/page.html` is the HTML that wraps it:

```html
<!doctype html>
<title>{{ title }}</title>
<h1>{{ title }}</h1>
{{ content }}
```

## Build it

Give balzac the site folder, then the folder to write to:

```bash
balzac build my-site public
```

`public/index.html` now holds the finished page. The folder can be
uploaded as it is to any web host.

## Work on it

While you write, use `serve` instead. It builds the site, serves it on
`http://127.0.0.1:1799/`, and builds it again each time you save a file:

```bash
balzac serve my-site public
```

The browser does not reload by itself: refresh the page to see a change.

## Where to go next

- [Writing pages](pages.html) covers the content folder and the
  settings of a page.
- [Writing templates](templates.html) lists what a template
  receives.
- [Recipes](recipes.html) shows an article list, a tags page, a
  sitemap and an RSS feed.
- [Command reference](commands.html) details `build` and
  `serve`.
