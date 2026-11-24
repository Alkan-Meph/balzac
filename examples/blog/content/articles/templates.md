---
template: "article.html"
title: "Writing templates"
description: "What a template receives, and how pages share a layout."
order: 3
tags: [article, templates]
---

Templates live in the `templates/` folder. They are text files with a few
extra tags: `{{ name }}` prints a value, and `{% ... %}` holds logic.

The language is [Jingoo](https://tategakibunko.github.io/jingoo/), which
follows Jinja2 closely.

## What a template receives

| Name      | Contents                                        |
| --------- | ----------------------------------------------- |
| `title`   | The title from the front matter                 |
| `content` | The body of the page, already converted to HTML |
| `url`     | The full address of the page                    |
| `base_url`| The address of the site, ending with `/`        |
| `pages`   | Every page of the site                          |

Every other key of the front matter is available under its own name. With
`tags: [article, news]` in a page, its template can use `tags`.

A name that was never set prints nothing, so an optional key is tested
with a plain `if`:

```html
{% if description %}
<meta name="description" content="{{ description }}">
{% endif %}
```

Values are printed as they are, without escaping. That is what lets
`{{ content }}` output HTML.

### Addresses

`base_url` is the `base-url` of `config.yml`. A final `/` is added if it
is missing, so a file name can be appended to it directly.

`url` is `base_url` followed by the path of the page. With
`base-url: "https://example.org/"`, the page `articles/first.md` gets
`https://example.org/articles/first.html`.

### The list of pages

Each entry of `pages` has the same fields as the current page: `title`,
`content`, `url` and the keys of its front matter.

```html
<ul>
{% for page in pages %}
    <li><a href="{{ page.url }}">{{ page.title }}</a></li>
{% endfor %}
</ul>
```

## Sharing a layout

Put what every page has in common in one file, and leave named holes in
it. Here is a `base.html`:

```html
<!doctype html>
<title>{{ title }}</title>
<link rel="stylesheet" href="{{ base_url }}style.css">
<main>
    {% block main %}{% endblock %}
</main>
```

Another template fills the holes by extending it:

```html
{% extends "base.html" %}

{% block main %}
<h1>{{ title }}</h1>
{{ content }}
{% endblock %}
```

A smaller piece can also be pulled in where you need it:

```html
{% include "footer.html" %}
```

## Linking to files and pages

Build the address of a stylesheet, a script or another page from
`base_url`:

```html
<link rel="stylesheet" href="{{ base_url }}style.css">
<a href="{{ base_url }}articles.html">Articles</a>
```

A link written as `/style.css` only works when the site is published at
the root of its domain. With `base_url`, the site can also live in a
folder, such as `https://example.org/docs/`.

## Differences with Jinja2

A few habits from Jinja2 do not carry over:

- A loop cannot be filtered with `{% for page in pages if ... %}`. Put an
  `{% if %}` inside the loop.
- `a not in b` is not understood. Write `not (a in b)`.
- `pages | map(attribute="tags")` does not work. Collect values with a
  loop, as the [tags page recipe](recipes.html#a-tags-page)
  does.

`sort(attribute="order")`, `reverse`, `unique`, `join` and `length` behave
as expected.
