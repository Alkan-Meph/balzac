---
template: "article.html"
title: "Recipes"
description: "An article list, a tags page, a sitemap and an RSS feed."
order: 4
tags: [article, templates, recipes]
---

Balzac has no notion of article, tag or feed. All of these are built with
two things: keys you choose in the front matter, and the `pages` list.

Each recipe below is used by this site.

## A list of articles

First, mark the pages that are articles and give them a position. Any
keys would do; here they are a tag and `order`:

```yaml
---
template: "article.html"
title: "My first article"
order: 1
tags: [article]
---
```

Then add a page whose only job is to list them. Its body is empty:

```yaml
---
template: "articles.html"
title: "Articles"
---
```

Its template loops over `pages` in that order and keeps the tagged ones:

```html
<ol>
{% for page in pages | sort(attribute="order") %}
{% if page.tags and "article" in page.tags %}
    <li><a href="{{ page.url }}">{{ page.title }}</a></li>
{% endif %}
{% endfor %}
</ol>
```

The blog of this site does the same with a `date: "2026-11-24"` key:
dates in that form sort correctly as text, and `| reverse` puts the
latest first.

## A tags page

One page lists every tag, with the pages that carry it. A link such as
`tags.html#tag-news` then jumps to the right section.

The template first collects the tags of all pages, then prints one section
for each:

```html
{% set found = namespace(tags=[]) %}
{% for page in pages %}
{% for tag in page.tags %}
{% set found.tags = found.tags + [tag] %}
{% endfor %}
{% endfor %}

{% for tag in found.tags | unique | sort %}
<section id="tag-{{ tag }}">
    <h2>#{{ tag }}</h2>
    <ul>
    {% for page in pages %}
    {% if page.tags and tag in page.tags %}
        <li><a href="{{ page.url }}">{{ page.title }}</a></li>
    {% endif %}
    {% endfor %}
    </ul>
</section>
{% endfor %}
```

The `namespace` is what lets the inner loop add to a list defined outside
of it.

## A sitemap

A template does not have to produce HTML. The `output` key gives the page
another name and extension:

```yaml
---
template: "sitemap.xml"
title: "Sitemap"
output: "sitemap.xml"
---
```

The template, `templates/sitemap.xml`, lists the address of every page
that kept its default output, which leaves out the sitemap itself:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
{% for page in pages %}{% if not page.output %}
  <url><loc>{{ page.url }}</loc></url>
{% endif %}{% endfor %}
</urlset>
```

The result is written to `sitemap.xml` at the root of the site.

## An RSS feed

A feed is made the same way. On this site it lists the posts of the
blog: pages tagged `post`, each with a date.

```yaml
---
template: "post.html"
title: "My first post"
date: "2026-11-24"
tags: [post]
---
```

The page of the feed gives it a title and a description:

```yaml
---
template: "feed.xml"
title: "My blog"
description: "The latest posts of my blog."
output: "feed.xml"
---
```

The template writes one `<item>` per post, latest first:

```xml
<?xml version="1.0" encoding="UTF-8"?>
{% set months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"] %}
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
  <title>{{ title | escape }}</title>
  <description>{{ description | escape }}</description>
  <atom:link href="{{ url }}" rel="self" type="application/rss+xml"/>
  <link>{{ base_url }}blog.html</link>
  {% for page in pages | sort(attribute="date") | reverse %}
  {% if page.tags and "post" in page.tags %}
  {% set date = page.date | split("-") %}
  <item>
    <title>{{ page.title | escape }}</title>
    <link>{{ page.url }}</link>
    <guid>{{ page.url }}</guid>
    <pubDate>{{ date[2] }} {{ months[(date[1] | int) - 1] }} {{ date[0] }} 00:00:00 GMT</pubDate>
    <description>{{ page.content | escape }}</description>
  </item>
  {% endif %}
  {% endfor %}
</channel>
</rss>
```

Two things are worth a word:

- Text goes through `escape`, because titles and HTML content may hold
  `<` and `&`.
- RSS wants dates such as `24 Nov 2026 00:00:00 GMT`. The template builds
  one from `2026-11-24` by splitting it and looking the month up in a
  list.

Announce the feed in the `<head>` of your pages so that readers find it:

```html
<link rel="alternate" type="application/rss+xml" href="{{ base_url }}feed.xml">
```
