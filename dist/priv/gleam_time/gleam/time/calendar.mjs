import { Ok, Error, CustomType as $CustomType, remainderInt } from "../../gleam.mjs";
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

export function month_to_int(month) {
  if (month instanceof January) {
    return 1;
  } else if (month instanceof February) {
    return 2;
  } else if (month instanceof March) {
    return 3;
  } else if (month instanceof April) {
    return 4;
  } else if (month instanceof May) {
    return 5;
  } else if (month instanceof June) {
    return 6;
  } else if (month instanceof July) {
    return 7;
  } else if (month instanceof August) {
    return 8;
  } else if (month instanceof September) {
    return 9;
  } else if (month instanceof October) {
    return 10;
  } else if (month instanceof November) {
    return 11;
  } else {
    return 12;
  }
}

export function month_from_int(month) {
  if (month === 1) {
    return new Ok(new January());
  } else if (month === 2) {
    return new Ok(new February());
  } else if (month === 3) {
    return new Ok(new March());
  } else if (month === 4) {
    return new Ok(new April());
  } else if (month === 5) {
    return new Ok(new May());
  } else if (month === 6) {
    return new Ok(new June());
  } else if (month === 7) {
    return new Ok(new July());
  } else if (month === 8) {
    return new Ok(new August());
  } else if (month === 9) {
    return new Ok(new September());
  } else if (month === 10) {
    return new Ok(new October());
  } else if (month === 11) {
    return new Ok(new November());
  } else if (month === 12) {
    return new Ok(new December());
  } else {
    return new Error(undefined);
  }
}

export function is_leap_year(year) {
  let $ = (remainderInt(year, 400)) === 0;
  if ($) {
    return true;
  } else {
    let $1 = (remainderInt(year, 100)) === 0;
    if ($1) {
      return false;
    } else {
      return (remainderInt(year, 4)) === 0;
    }
  }
}

export function is_valid_date(date) {
  let year = date.year;
  let month = date.month;
  let day = date.day;
  let $ = day < 1;
  if ($) {
    return false;
  } else {
    if (month instanceof January) {
      return day <= 31;
    } else if (month instanceof February) {
      let _block;
      let $1 = is_leap_year(year);
      if ($1) {
        _block = 29;
      } else {
        _block = 28;
      }
      let max_february_days = _block;
      return day <= max_february_days;
    } else if (month instanceof March) {
      return day <= 31;
    } else if (month instanceof April) {
      return day <= 30;
    } else if (month instanceof May) {
      return day <= 31;
    } else if (month instanceof June) {
      return day <= 30;
    } else if (month instanceof July) {
      return day <= 31;
    } else if (month instanceof August) {
      return day <= 31;
    } else if (month instanceof September) {
      return day <= 30;
    } else if (month instanceof October) {
      return day <= 31;
    } else if (month instanceof November) {
      return day <= 30;
    } else {
      return day <= 31;
    }
  }
}

export function is_valid_time_of_day(time) {
  let hours = time.hours;
  let minutes = time.minutes;
  let seconds = time.seconds;
  let nanoseconds = time.nanoseconds;
  return (((((((hours >= 0) && (hours <= 23)) && (minutes >= 0)) && (minutes <= 59)) && (seconds >= 0)) && (seconds <= 59)) && (nanoseconds >= 0)) && (nanoseconds <= 999_999_999);
}

export const utc_offset = $duration.empty;
