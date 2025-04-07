// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type Page}
import gleam/int
import gleam/option.{Some}
import gleam/order.{type Order, negate}
import gleam/time/calendar
import gleam/time/timestamp.{type Timestamp}

pub type Date =
  Timestamp

pub fn string_to_date(s: String) -> Result(Date, Nil) {
  timestamp.parse_rfc3339(s)
}

pub fn pretty_date(ts: Date) -> String {
  let date = timestamp.to_calendar(ts, calendar.utc_offset).0
  calendar.month_to_string(date.month)
  <> " "
  <> int.to_string(date.day)
  <> ", "
  <> int.to_string(date.year)
}

pub fn before(p1: Page, p2: Page) -> Order {
  let assert Some(p1_date) = p1.date
  let assert Some(p2_date) = p2.date
  timestamp.compare(p1_date, p2_date)
}

pub fn after(p1: Page, p2: Page) -> Order {
  negate(before(p1, p2))
}
