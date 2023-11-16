import gleam from "vite-gleam";
import ClosePlugin from './vite-plugin-close.ts'

export default {
  plugins: [gleam(), ClosePlugin()],
};