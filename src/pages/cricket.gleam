// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import components/head
import components/navbar.{navbar}
import components/tail.{tail}
import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html

pub fn cricket() -> Element(Nil) {
  html.div([], [
    head.local_head("Cricket", "The Cricket Programming Language"),
    navbar(),
    html.div([attribute.id("body")], [
      html.h3([], [text("Cricket")]),
      html.p([], [
        text(
          "
Cricket is a tiny little functional language.
It can be implemented very quickly on various platforms.
Cricket is lazy, specifically call-by-name.
Side effects are done with explicitly-forced evaluation.
Cricket is dynamically typed, and uses objects or lambdas for data.
Cricket objects can refer to themselves in their methods, enabling much of OOP.
Cricket is immutable, with object updates returning new objects.
        ",
        ),
      ]),
      html.p([], [
        text(
          "
Cricket is designed such that ordinary programmers who aren't much into
the academic theory behind functional programming can still find it easy and intuitive.
No monads, for one.
However, if you like the confidence in your code that comes with such solid theoretical foundations,
rest assured that Cricket is inspired by fascinating categorical ",
        ),
        html.a(
          [
            attribute.href(
              "https://ncatlab.org/nlab/show/polarity+in+type+theory",
            ),
          ],
          [text("connections")],
        ),
        text(
          ".
The keywords are call-by-name, negative types, and side effects.
        ",
        ),
      ]),
      html.pre([], [
        html.code([], [
          text(
            "
let iter = {
  this.go: args->{
    val: args.start, 
    next: this.go{start: args.step(args.start), step: args.step}
  }
} in 
console.write(iter.go{start: 7, step: n->n-1}.next.next.val)
        ",
          ),
        ]),
      ]),
      html.p([], [
        text("To read more about Cricket, look "),
        html.a([attribute.href("https://github.com/RyanBrewer317/cricket_rs")], [
          text("here"),
        ]),
        text("."),
      ]),
    ]),
    tail(),
  ])
}
