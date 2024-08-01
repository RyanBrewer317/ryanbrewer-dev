// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import birl
import gleam/int
import gleam/order.{type Order, negate}
import lustre/element.{type Element}

pub type Date =
  birl.Time

pub fn string_to_date(s: String) -> Result(Date, Nil) {
  birl.from_naive(s)
}

pub fn pretty_date(date: Date) -> String {
  birl.string_month(date)
  <> " "
  <> int.to_string(birl.get_day(date).date)
  <> ", "
  <> int.to_string(birl.get_day(date).year)
}

pub fn before(p1: Post, p2: Post) -> Order {
  birl.compare(p1.date, p2.date)
}

pub fn after(p1: Post, p2: Post) -> Order {
  negate(before(p1, p2))
}

pub type Post {
  Post(
    title: String,
    id: String,
    date: Date,
    tags: List(String),
    description: String,
    body: List(Element(Nil)),
  )
}

pub type Wiki {
  Wiki(title: String, id: String, tags: List(String), body: List(Element(Nil)))
}
