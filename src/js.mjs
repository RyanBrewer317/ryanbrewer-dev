// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

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