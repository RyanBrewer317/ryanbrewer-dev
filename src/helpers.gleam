// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type Page}
import birl
import gleam/int
import gleam/option.{Some}
import gleam/order.{type Order, negate}

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

pub fn before(p1: Page, p2: Page) -> Order {
  let assert Some(p1_date) = p1.date
  let assert Some(p2_date) = p2.date
  birl.compare(p1_date, p2_date)
}

pub fn after(p1: Page, p2: Page) -> Order {
  negate(before(p1, p2))
}
