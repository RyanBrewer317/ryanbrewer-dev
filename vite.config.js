import gleam from "vite-gleam";
import ClosePlugin from './vite-plugin-close.ts'
import { defineConfig } from "vite";
import * as fs from "fs";

// I'm sure there's a better way to do this

const input_obj = fs.readdirSync("arctic_build/posts").reduce((obj, filename)=>{
  if (filename != "index.html")
    obj[filename] = "arctic_build/posts/"+filename+"/index.html";
  return obj;
}, { main: "arctic_build/index.html", posts: "arctic_build/posts/index.html", wiki: "arctic_build/wiki/index.html", contact: "arctic_build/contact/index.html", demos: "arctic_build/demos/index.html", "404": "arctic_build/404/index.html", cricket: "arctic_build/cricket/index.html"})

const input_obj2 = fs.readdirSync("arctic_build/wiki").reduce((obj, filename)=>{
  if (filename != "index.html")
    obj[filename] = "arctic_build/wiki/"+filename+"/index.html";
  return obj;
}, input_obj);

console.log(input_obj2);

export default defineConfig({
  root: "artic_build",
  build: {
    outDir: "../dist",
    rollupOptions: {
      input: input_obj2,
    },
  },
  plugins: [gleam(), ClosePlugin()],
});