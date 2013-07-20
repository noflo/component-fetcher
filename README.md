# component-fetcher [![Build Status](https://secure.travis-ci.org/noflo/component-fetcher.png?branch=master)](http://travis-ci.org/noflo/component-fetcher)

NoFlo tool that fetches libraries and their components from [GitHub](https://github.com/) and creates [Jekyll](http://jekyllrb.com/) posts for them. The posts created include:

* A post for each library at `library/_posts` with the metadata as [YAML front matter](http://jekyllrb.com/docs/frontmatter/) and the library README as the post content
* A post for each component at `library/components/_posts` with metadata as YAML front matter, and a [Docco](http://jashkenas.github.io/docco/) generated literate programming document of the source code as the content

## Installation

Fetch this project from GitHub and run:

    $ npm install

## Running

Because of [GitHub API rate limits](http://developer.github.com/v3/rate_limit/), this tool needs to be run as an authenticated user. It is a good idea to generate a [application-specific access token](https://github.com/settings/applications) for it.

Set this to an environment variable:

    $ export GITHUB_API_KEY=xyz123

Then just run the tool:

    $ ./node_modules/.bin/noflo graphs/GetLibraries.fbp
