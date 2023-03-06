import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cert_info/utills/extensions.dart';

import '../res/colors.dart';

/// Widget that represents week days in row above calendar month view.
class WeekDaysWidget extends StatelessWidget {
  const WeekDaysWidget({
    required this.day,
    super.key,
  });

  /// [WeekDay] value from [WeekDaysBuilder].
  final WeekDay day;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Center(
        child: Text(
          day.convertKo(),
          style: TextStyle(
            color: isSunday()
                ? Colors.red.withOpacity(0.9)
                : Colors.black54.withOpacity(0.9),
          ),
        ),
      ),
    );
  }

  bool isSunday() {
    return WeekDay.sunday == day;
  }
}
