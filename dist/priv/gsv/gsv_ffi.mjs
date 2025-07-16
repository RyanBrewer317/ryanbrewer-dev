export function slice(string, start, size) {
  return string.slice(start, start + size);
}

export function drop_bytes(string, bytes) {
  return string.slice(bytes);
}
