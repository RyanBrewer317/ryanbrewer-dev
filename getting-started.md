# Getting Started

This is a collection of things I learned trying to get this project to work when I switched to a new computer.

I only have Mac-specific stuff at the moment, since I switched from a Mac to another Mac. I hope to switch to Dell soon lol.

Install gleam with
```
brew update
brew install gleam
```

Add the [Gleam LSP](https://marketplace.visualstudio.com/items?itemName=Gleam.gleam) to the editor.

Go through some of the dependencies and manually fix them (I should have tried `gleam fix` but I forgot about it). This means changing `Map` to `Dict`, `map` to `dict`, and adding the `type` keyword in front of some imports. The LSP guides this process.

Lustre SSG was using an older version of Simplifile, where `.write`'s arguments are flipped. This resulted in an Enametoolong error, because its using the text as the path. Simply go through all the `.write` calls and swap the `path` and `html` arguments.

Install Yarn with
```
corepack enable
```

Add the yarn stuff (namely vite-gleam) with
```
yarn
```