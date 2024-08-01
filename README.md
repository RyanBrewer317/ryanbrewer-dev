# ryanbrewer-dev

hosted by Firebase at http://ryanbrewer.dev. 

My intention is to pull out a core library/stack from this project, to help others with SSG-based websites. There are many interesting challenges I've had to solve in limiting myself this way. I like that I can completely run the website with a basic python localhost server, or with free Firebase Hosting, since there's no server-side. I also like how fast the pages are; unless you have a highly-interactive site, this build process is producing something comparable to SSR for performance: everything is hard-coded into the HTML.

The codebase quality has come a long way in my effort to make it usable by others. However, there are still things I need to do:
- Caching: There's some lame caching of diagrams right now but I want it to be much less manual, and not just diagrams. In particular, for each already-rendered post there should be a hash of the document used to generate it, so we can check if it's changed before re-rendering it. And for each diagram, hashing might be more of a bottleneck than just comparing the code character-by-character anyway, so we might just store the original code for the diagram to check if it has changed before re-rendering it. This caching data should be stored in a SQLite database.
- Markup: I currently have my own markup language for posts. If I could find or crank out a markdown parser, so people can use a language they're more familiar with, that would be great. I'd just use code blocks for math blocks and diagrams, via ` ```math` and ` ```diagram`. In this effort, I'd also need to support images, bold text, ordered and unordered lists, and more. Which are things I'd like to support eventually anyway. It would be good to improve parsing in other ways too, like performance, recoverability, etc. so it'd be great if I finally finished `ramble` lol.
- Wiki: Personally, I really want this to support wiki-style pages, in addition to interactive pages and blog posts like it supports now. So people can easily put out richly-structured knowledge with a web of hyperlinks, using the same markup language as blog posts. I think I'll tackle this soon, because I want to have my own wiki.
- Light mode: This should be easy to take out, but sometimes people want their users to be able to switch between light mode and dark mode, instead of forcing one or the other.

I don't have to support *everything,* like choosing between sticky or non-sticky nav bars for example, since folks are expected to hack on their websites themselves. This won't be the kind of library that hides its internals for "principled coding," though I do appreciate those kinds of libraries. This should just be modular scaffolding that can be hacked away at with the same level of expressivity as just forking the code, but hopefully more convenient than that. Anyway, I hope to at least support the above.

The commands are in `commands/`.

 - `commands/deploy.sh` will prompt for a commit message and then build, push to git, and deploy to prod.
 - `commands/kill-port.sh` cleans up the port used by the preview server
 - `commands/new-post.sh` will prompt for an id and title and create a template post in `drafts/`. It will also complain and stop if the id is already in use by another post in `drafts/` or `posts/`.
 - `commands/preview.sh` will build and start a preview server and open it in the browser. It will only serve things in `posts/` but a potential post can be moved there from `drafts/` to see how it looks, find markdown bugs etc. and then move it back to `drafts/` if necessary before deploying.