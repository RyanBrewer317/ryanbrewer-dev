import gleam from "vite-gleam";
import ClosePlugin from './vite-plugin-close.ts'
import { defineConfig } from "vite";
import * as fs from "fs";

// I'm sure there's a better way to do this

const input_obj = fs.readdirSync("site/posts").reduce((obj, filename)=>{
  if (filename != "index.html")
    obj[filename] = "site/posts/"+filename+"/index.html";
  return obj;
}, { main: "site/index.html", posts: "site/posts/index.html", wiki: "site/wiki/index.html", contact: "site/contact/index.html", demos: "site/demos/index.html", "404": "site/404/index.html" })

const input_obj2 = fs.readdirSync("site/wiki").reduce((obj, filename)=>{
  if (filename != "index.html")
    obj[filename] = "site/wiki/"+filename+"/index.html";
  return obj;
}, input_obj);

console.log(input_obj2);

export default defineConfig({
  root: "site",
  build: {
    outDir: "../dist",
    rollupOptions: {
      input: input_obj2,
    },
  },
  plugins: [gleam(), ClosePlugin()],
});