import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $head from "../components/head.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import { toList } from "../gleam.mjs";

export function cricket() {
  return $html.div(
    toList([]),
    toList([
      $head.local_head("Cricket", "The Cricket Programming Language"),
      navbar(),
      $html.div(
        toList([$attribute.id("body")]),
        toList([
          $html.h3(toList([]), toList([text("Cricket")])),
          $html.p(
            toList([]),
            toList([
              text(
                "\nCricket is a tiny little functional language.\nIt can be implemented very quickly on various platforms.\nCricket is lazy, specifically call-by-name.\nSide effects are done with explicitly-forced evaluation.\nCricket is dynamically typed, and uses objects or lambdas for data.\nCricket objects can refer to themselves in their methods, enabling much of OOP.\nCricket is immutable, with object updates returning new objects.\n        ",
              ),
            ]),
          ),
          $html.p(
            toList([]),
            toList([
              text(
                "\nCricket is designed such that ordinary programmers who aren't much into\nthe academic theory behind functional programming can still find it easy and intuitive.\nNo monads, for one.\nHowever, if you like the confidence in your code that comes with such solid theoretical foundations,\nrest assured that Cricket is inspired by fascinating categorical ",
              ),
              $html.a(
                toList([
                  $attribute.href(
                    "https://ncatlab.org/nlab/show/polarity+in+type+theory",
                  ),
                ]),
                toList([text("connections")]),
              ),
              text(
                ".\nThe keywords are call-by-name, negative types, and side effects.\n        ",
              ),
            ]),
          ),
          $html.pre(
            toList([]),
            toList([
              $html.code(
                toList([]),
                toList([
                  text(
                    "\nlet iter = {\n  this.go: args->{\n    val: args.start, \n    next: this.go{start: args.step(args.start), step: args.step}\n  }\n} in \nconsole.write(iter.go{start: 7, step: n->n-1}.next.next.val)\n        ",
                  ),
                ]),
              ),
            ]),
          ),
          $html.p(
            toList([]),
            toList([
              text("To read more about Cricket, look "),
              $html.a(
                toList([
                  $attribute.href("https://github.com/RyanBrewer317/cricket_rs"),
                ]),
                toList([text("here")]),
              ),
              text("."),
            ]),
          ),
        ]),
      ),
      tail(),
    ]),
  );
}
