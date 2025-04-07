import { CustomType as $CustomType } from "../../gleam.mjs";
import * as $duration from "../../gleam/time/duration.mjs";
import { local_time_offset_seconds } from "../../gleam_time_ffi.mjs";

export class Date extends $CustomType {
  constructor(year, month, day) {
    super();
    this.year = year;
    this.month = month;
    this.day = day;
  }
}

export class TimeOfDay extends $CustomType {
  constructor(hours, minutes, seconds, nanoseconds) {
    super();
    this.hours = hours;
    this.minutes = minutes;
    this.seconds = seconds;
    this.nanoseconds = nanoseconds;
  }
}

export class January extends $CustomType {}

export class February extends $CustomType {}

export class March extends $CustomType {}

export class April extends $CustomType {}

export class May extends $CustomType {}

export class June extends $CustomType {}

export class July extends $CustomType {}

export class August extends $CustomType {}

export class September extends $CustomType {}

export class October extends $CustomType {}

export class November extends $CustomType {}

export class December extends $CustomType {}

export function local_offset() {
  return $duration.seconds(local_time_offset_seconds());
}

export function month_to_string(month) {
  if (month instanceof January) {
    return "January";
  } else if (month instanceof February) {
    return "February";
  } else if (month instanceof March) {
    return "March";
  } else if (month instanceof April) {
    return "April";
  } else if (month instanceof May) {
    return "May";
  } else if (month instanceof June) {
    return "June";
  } else if (month instanceof July) {
    return "July";
  } else if (month instanceof August) {
    return "August";
  } else if (month instanceof September) {
    return "September";
  } else if (month instanceof October) {
    return "October";
  } else if (month instanceof November) {
    return "November";
  } else {
    return "December";
  }
}

export const utc_offset = $duration.empty;
