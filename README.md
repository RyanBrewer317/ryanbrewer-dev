# ryanbrewer-dev

hosted by Firebase at http://ryanbrewer.dev. 

The commands are in `commands/`.

 - `commands/deploy.sh` will prompt for a commit message and then build, push to git, and deploy to prod.
 - `commands/kill-port.sh` cleans up the port used by the preview server
 - `commands/new-post.sh` will prompt for an id and title and create a template post in `drafts/`. It will also complain and stop if the id is already in use by another post in `drafts/` or `posts/`.
 - `commands/preview.sh` will build and start a preview server and open it in the browser. It will only serve things in `posts/` but a potential post can be moved there from `drafts/` to see how it looks, find markdown bugs etc. and then move it back to `drafts/` if necessary before deploying.