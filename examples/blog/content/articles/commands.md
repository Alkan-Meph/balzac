---
template: "article.html"
title: "Command reference"
description: "The build and serve commands, the configuration file and error messages."
order: 5
tags: [article, reference]
---

Balzac has two commands. Both take the site folder, then the output
folder.

## build

```bash
balzac build SITE OUTPUT
```

Reads `SITE/config.yml`, converts every page of `SITE/content/` with the
templates of `SITE/templates/`, and writes the result to `OUTPUT`.

The output folder is created if needed. Existing files are overwritten,
but nothing is deleted.

## serve

```bash
balzac serve SITE OUTPUT [--host ADDR] [--port PORT]
```

Builds the site, serves `OUTPUT` over HTTP, and builds again whenever a
file of `SITE` changes. It is meant for writing, not for hosting.

| Option         | Default     | Purpose                      |
| -------------- | ----------- | ---------------------------- |
| `-h`, `--host` | `127.0.0.1` | Address to listen on, an IP  |
| `-p`, `--port` | `1799`      | Port to listen on            |

While serving:

- The `base-url` of `config.yml` is replaced by the address of the local
  server, so links between pages stay on your machine.
- A build that fails prints its error in the terminal. The last good
  version keeps being served.
- The browser is not reloaded for you.

Keep `OUTPUT` outside of `SITE`. Otherwise each build changes the files
being watched and starts the next one.

## The configuration file

`config.yml` sits at the root of the site folder and has one key:

```yaml
base-url: "https://example.org/"
```

It is required, and no other key is accepted.

## Exit status

| Code  | Meaning                            |
| ----- | ---------------------------------- |
| `0`   | Success                            |
| `123` | The build or the server failed     |
| `124` | The command line could not be read |

## Error messages

An error names the file it comes from, then the problem:

```text
my-site/content/articles/first.md: missing or malformed front matter
my-site/config.yml: url expects a string
article.html: file missing.html not found
```

Two messages are less obvious than the others:

- `Didn't find the function for key: title` means a required key, here
  `title`, is missing from the front matter.
- `Failed to find the case for: name` means `config.yml` has a key that
  balzac does not know.
