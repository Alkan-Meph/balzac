---
template: "article.html"
title: "Writing pages"
description: "The content folder, front matter and Markdown."
order: 2
tags: [article, content]
---

Everything you publish lives in the `content/` folder of your site.

## The content folder

Each file under `content/` ends up in the output folder, at the same
relative path. What happens to it depends on its extension:

- A file ending in `.md` is a **page**. It is converted and written as
  `.html`.
- Any other file is copied unchanged. Stylesheets, scripts and images go
  there too.

So this layout:

```text
content/
  index.md
  about.md
  articles/
    first.md
    photo.jpg
  style.css
```

produces `index.html`, `about.html`, `articles/first.html`,
`articles/photo.jpg` and `style.css`.

Two things to know:

- Files whose name starts with a dot are ignored.
- The output folder is never emptied. A page you delete or rename stays
  there until you remove it yourself.

## Front matter

A page starts with a block of YAML between two `---` lines, called the
front matter. A page without one stops the build.

```yaml
---
template: "article.html"
title: "My first article"
order: 1
tags: [article, news]
---
```

| Key        | Required | Purpose                                       |
| ---------- | -------- | --------------------------------------------- |
| `title`    | yes      | The title of the page                         |
| `template` | yes      | The file in `templates/` that wraps the page  |
| `output`   | no       | Where to write the page, instead of the default |
| any other  | no       | Passed to the template under the same name    |

You are free to invent keys. `order`, `date`, `tags` and `description` on this site
are ordinary keys that its templates happen to use.

### Choosing the output file

By default `articles/first.md` is written to `articles/first.html`. The
`output` key replaces that path, extension included:

```yaml
output: "feed.xml"
```

The path starts at the root of the site, and must name a file inside it:
`/feed.xml`, `../feed.xml` and `feeds/` are refused.

### YAML pitfalls

> Put quotes around dates, and around the words `y`, `n`, `yes`, `no`,
> `on` and `off`. Without them YAML reads the last six as true or false.

Numbers are another surprise: `order: 3` is printed as `3.`, with a
trailing dot. Print it with `{{ order | int }}` to get `3`.

## The body

Whatever follows the front matter is Markdown. It is converted to HTML and
handed to the template as `content`.

On top of standard Markdown you can use:

- tables, like the one above;
- `~~strikethrough~~`;
- task lists, with `- [ ]` and `- [x]`;
- footnotes, with `[^1]` in the text and `[^1]: ...` below.

### Headings get anchors

Each heading receives an `id` derived from its text, so `## The body`
can be reached at `#the-body`.

### Raw HTML is kept

HTML written in a Markdown file is left as it is, which is handy for the
occasional `<figure>` or `<details>` element.

### Template tags are not

`{{ title }}` in a Markdown file is plain text. Only templates understand
those tags.

## Links

balzac does not rewrite links. Point them at the generated file, not at
the Markdown source, and write them relative to the current page:

```markdown
See the [first article](first.html), or the [about page](../about.html).

![A photo](photo.jpg)
```

Relative links keep working wherever the site is published. A link
starting with `/` is only right when the site sits at the root of its
domain.
