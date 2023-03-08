import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cert_info/utills/extensions.dart';
import 'package:flutter_cert_info/widgets/week_days_widget.dart';

import '../res/colors.dart';
import '../utills/constants.dart';
import 'day_events_bottom_sheet.dart';
import 'day_item_widget.dart';
import 'event_widget.dart';

class CalendarWidget extends StatefulWidget {
  final List<CalendarEventModel> events;

  CalendarWidget({required this.events});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final _currentDate = DateTime.now();

  late CrCalendarController _controller;
  late String _viewDate;

  @override
  void initState() {
    super.initState();
    _setTexts(_currentDate.year, _currentDate.month);
    _controller = CrCalendarController(
        events: widget.events, onSwipe: _onCalendarPageChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(children: [
          /// Calendar control row.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  _changeCalendarPage(showNext: false);
                },
              ),
              Text(
                _viewDate,
                // _controller.date.format(kMonthFormat),
                style: const TextStyle(
                    fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  _changeCalendarPage(showNext: true);
                },
              ),
            ],
          ),

          /// Calendar view.
          Expanded(
              child: CrCalendar(
            firstDayOfWeek: WeekDay.sunday,
            eventsTopPadding: 32,
            initialDate: _currentDate,
            maxEventLines: 3,
            controller: _controller,
            forceSixWeek: true,
            dayItemBuilder: (builderArgument) =>
                DayItemWidget(properties: builderArgument),
            weekDaysBuilder: (day) => WeekDaysWidget(day: day),
            eventBuilder: (drawer) => EventWidget(drawer: drawer),
            onDayClicked: _showDayEventsInModalSheet,
          )),
        ]));
  }

  void _setTexts(int year, int month) {
    final date = DateTime(year, month);
    _viewDate = date.format(kAppBarDateFormat);
  }

  void _showDayEventsInModalSheet(
      List<CalendarEventModel> events, DateTime day) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
        isScrollControlled: true,
        context: context,
        builder: (context) => DayEventsBottomSheet(
              events: events,
              day: day,
              screenHeight: MediaQuery.of(context).size.height,
            ));
  }

  void _changeCalendarPage({required bool showNext}) => showNext
      ? _controller.swipeToNextMonth()
      : _controller.swipeToPreviousPage();

  void _onCalendarPageChanged(int year, int month) {
    setState(() {
      _setTexts(year, month);
    });
  }
}
