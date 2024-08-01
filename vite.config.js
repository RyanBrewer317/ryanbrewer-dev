import gleam from "vite-gleam";
import ClosePlugin from './vite-plugin-close.ts'
import { defineConfig } from "vite";
import * as fs from "fs";

const input_obj = fs.readdirSync("site/posts").reduce((obj, filename)=>{
  obj[filename] = "site/posts/"+filename+"/index.html";
  return obj;
}, { main: "site/index.html", search: "site/search/index.html", contact: "site/contact/index.html", demos: "site/demos/index.html", "404": "site/404/index.html" })

console.log(input_obj);

export default defineConfig({
  root: "site",
  build: {
    outDir: "../dist",
    rollupOptions: {
      input: input_obj,
    },
  },
  plugins: [gleam(), ClosePlugin()],
});