let state = {id: "", counter: 0};

export function get_id() {
    return state.id;
}

export function set_id(id) {
    state.id = id;
}

export function get_counter() {
    return state.counter;
}

export function inc_counter() {
    state.counter++;
}

export function reset_counter() {
    state.counter = 0;
}