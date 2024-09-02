export function get_x() {
    return document.getElementById("sprite-bounds").getBoundingClientRect().x;
}

export function get_y() {
    return document.getElementById("sprite-bounds").getBoundingClientRect().y;
}

export function get_width() {
    return document.getElementById("sprite-bounds").getBoundingClientRect().width;
}

export function get_height() {
    return document.getElementById("sprite-bounds").getBoundingClientRect().height;
}

export function screen_width() {
    return window.innerWidth;
}