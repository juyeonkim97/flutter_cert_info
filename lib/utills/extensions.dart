import 'package:cr_calendar/cr_calendar.dart';
import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String format(String formatPattern) => DateFormat(formatPattern).format(this);
}

extension WeekDayExt on WeekDay {
  String convertKo() {
    switch (this) {
      case WeekDay.sunday:
        return '일';
      case WeekDay.monday:
        return '월';
      case WeekDay.tuesday:
        return '화';
      case WeekDay.wednesday:
        return '수';
      case WeekDay.thursday:
        return '목';
      case WeekDay.friday:
        return '금';
      case WeekDay.saturday:
        return '토';
    }
    return 'null';
  }
}
