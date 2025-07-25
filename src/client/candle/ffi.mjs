// inspired by lpil's javascript-mutable-reference

class Ref {
  constructor(x) {
    this.value = x;
  }
}

export function make(x) {
  return new Ref(x);
}
  
export function get(ref) {
  return ref.value;
}

export function set(ref, x) {
  let prev = ref.value;
  ref.value = x;
  return prev;
}

const meta_state = {
  id: 0,
}

export function next_id() {
  let out = meta_state.id;
  meta_state.id += 1;
  return out;
}