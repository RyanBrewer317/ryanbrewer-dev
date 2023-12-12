import lustre/element.{type Element}
import birl/time
import gleam/int
import gleam/order.{type Order, negate}

pub type DateTime =
  time.DateTime

pub fn string_to_date(s: String) -> Result(DateTime, Nil) {
  time.from_naive(s)
}

pub fn pretty_date(date: DateTime) -> String {
  let time.Date(year, _, day) = time.get_date(date)
  time.string_month(date) <> " " <> int.to_string(day) <> ", " <> int.to_string(
    year,
  )
}

pub fn before(p1: Post, p2: Post) -> Order {
  time.compare(p1.date, p2.date)
}

pub fn after(p1: Post, p2: Post) -> Order {
  negate(before(p1, p2))
}

pub type Post {
  Post(
    title: String,
    id: String,
    date: DateTime,
    tags: List(String),
    description: String,
    body: List(Element(Nil)),
  )
}
