import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cert_info/models/cert_schedule.dart';
import 'package:flutter_cert_info/utills/extensions.dart';

import '../providers/cert_schedule_providers.dart';
import '../res/colors.dart';
import '../utills/constants.dart';
import '../widgets/day_events_bottom_sheet.dart';
import '../widgets/day_item_widget.dart';
import '../widgets/event_widget.dart';
import '../widgets/week_days_widget.dart';

/// Main calendar page.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _currentDate = DateTime.now();
  late CrCalendarController _calendarController;
  late String _appbarTitle;
  late String _monthName;

  List<Item> items = [];
  bool isLoading = true;
  CertScheduleProviders certScheduleProviders = CertScheduleProviders();

  Future initNews() async {
    items = await certScheduleProviders.fetchCertSchedule(
        _currentDate.year, "7910");
    fetchEvents();
  }

  @override
  void initState() {
    _setTexts(_currentDate.year, _currentDate.month);
    initNews().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        // centerTitle: false,
        leading: IconButton(
          tooltip: 'Change List View',
          icon: const Icon(Icons.format_list_bulleted_outlined),
          onPressed: _showCurrentMonth,
        ),
        title: Text(_appbarTitle),
        actions: [
          IconButton(
            tooltip: 'Go to current date',
            icon: const Icon(Icons.calendar_today),
            onPressed: _showCurrentMonth,
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _addEvent,
      //   child: const Icon(Icons.add),
      // ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
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
                      _monthName,
                      style: const TextStyle(
                          fontSize: 16,
                          color: violet,
                          fontWeight: FontWeight.w600),
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
                    controller: _calendarController,
                    forceSixWeek: true,
                    dayItemBuilder: (builderArgument) =>
                        DayItemWidget(properties: builderArgument),
                    weekDaysBuilder: (day) => WeekDaysWidget(day: day),
                    eventBuilder: (drawer) => EventWidget(drawer: drawer),
                    onDayClicked: _showDayEventsInModalSheet,
                  ),
                ),
              ],
            ),
    );
  }

  /// Control calendar with arrow buttons.
  void _changeCalendarPage({required bool showNext}) => showNext
      ? _calendarController.swipeToNextMonth()
      : _calendarController.swipeToPreviousPage();

  void _onCalendarPageChanged(int year, int month) {
    setState(() {
      _setTexts(year, month);
    });
  }

  /// Set app bar text and month name over calendar.
  void _setTexts(int year, int month) {
    final date = DateTime(year, month);
    _appbarTitle = date.format(kAppBarDateFormat);
    _monthName = date.format(kMonthFormat);
  }

  /// Show current month page.
  void _showCurrentMonth() {
    _calendarController.goToDate(_currentDate);
  }

  // /// Show [CreateEventDialog] with settings for new event.
  // Future<void> _addEvent() async {
  //   final event = await showDialog(
  //       context: context, builder: (context) => const CreateEventDialog());
  //   if (event != null) {
  //     _calendarController.addEvent(event);
  //   }
  // }

  // void _createExampleEvents() {
  //   final now = _currentDate;
  //   _calendarController = CrCalendarController(
  //     onSwipe: _onCalendarPageChanged,
  //     events: createEvents(now),
  //   );
  // }

  void fetchEvents() {
    List<CalendarEventModel> events = [];

    items.forEach((element) {
      // 필기 원서접수
      if (element.docRegStartDt != "") {
        var calendarEventModel = CalendarEventModel(
          name: element.getFieldDescription("implSeq") +
              element.getFieldDescription("docRegStartDt"),
          begin: DateTime.parse(element.docRegStartDt ?? ""),
          end: DateTime.parse(element.docExamEndDt ?? ""),
          eventColor: eventColors[0],
        );
        events.add(calendarEventModel);
      }
      // 필기 시험
      if (element.docExamStartDt != "") {
        var calendarEventModel = CalendarEventModel(
          name: element.getFieldDescription("implSeq") +
              element.getFieldDescription("docExamStartDt"),
          begin: DateTime.parse(element.docExamStartDt ?? ""),
          end: DateTime.parse(element.docExamEndDt ?? ""),
          eventColor: eventColors[0],
        );
        events.add(calendarEventModel);
      }
      // 필기 합격자 발표
      if (element.docPassDt != "") {
        var calendarEventModel = CalendarEventModel(
          name: element.getFieldDescription("implSeq") +
              element.getFieldDescription("docPassDt"),
          begin: DateTime.parse(element.docPassDt ?? ""),
          end: DateTime.parse(element.docPassDt ?? ""),
          eventColor: eventColors[0],
        );
        events.add(calendarEventModel);
      }
      // 실기 원서 접수
      if (element.pracRegStartDt != "") {
        var calendarEventModel = CalendarEventModel(
          name: element.getFieldDescription("implSeq") +
              element.getFieldDescription("pracRegStartDt"),
          begin: DateTime.parse(element.pracRegStartDt ?? ""),
          end: DateTime.parse(element.pracRegEndDt ?? ""),
          eventColor: eventColors[0],
        );
        events.add(calendarEventModel);
      }
      // 실기 시험
      if (element.pracExamStartDt != "") {
        var calendarEventModel = CalendarEventModel(
          name: element.getFieldDescription("implSeq") +
              element.getFieldDescription("pracExamStartDt"),
          begin: DateTime.parse(element.pracExamStartDt ?? ""),
          end: DateTime.parse(element.pracExamEndDt ?? ""),
          eventColor: eventColors[0],
        );
        events.add(calendarEventModel);
      }
      // 실기 합격자 발표
      if (element.pracPassDt != "") {
        var calendarEventModel = CalendarEventModel(
          name: element.getFieldDescription("implSeq") +
              element.getFieldDescription("pracPassDt"),
          begin: DateTime.parse(element.pracPassDt ?? ""),
          end: DateTime.parse(element.pracPassDt ?? ""),
          eventColor: eventColors[0],
        );
        events.add(calendarEventModel);
      }
    });
    _calendarController = CrCalendarController(
      onSwipe: _onCalendarPageChanged,
      events: events,
    );
  }

  List<CalendarEventModel> createEvents(DateTime now) {
    return [
      CalendarEventModel(
        name: '1 event',
        begin: DateTime(now.year, now.month, (now.day).clamp(1, 28)),
        end: DateTime(now.year, now.month, (now.day).clamp(1, 28)),
        eventColor: eventColors[0],
      ),
      CalendarEventModel(
        name: '2 event',
        begin: DateTime(now.year, now.month - 1, (now.day - 2).clamp(1, 28)),
        end: DateTime(now.year, now.month, (now.day + 2).clamp(1, 28)),
        eventColor: eventColors[1],
      ),
      CalendarEventModel(
        name: '3 event',
        begin: DateTime(now.year, now.month, (now.day - 3).clamp(1, 28)),
        end: DateTime(now.year, now.month + 1, (now.day + 4).clamp(1, 28)),
        eventColor: eventColors[2],
      ),
      CalendarEventModel(
        name: '4 event',
        begin: DateTime(now.year, now.month - 1, (now.day).clamp(1, 28)),
        end: DateTime(now.year, now.month + 1, (now.day + 5).clamp(1, 28)),
        eventColor: eventColors[3],
      ),
      CalendarEventModel(
        name: '5 event',
        begin: DateTime(now.year, now.month + 1, (now.day + 1).clamp(1, 28)),
        end: DateTime(now.year, now.month + 2, (now.day + 7).clamp(1, 28)),
        eventColor: eventColors[4],
      ),
    ];
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
}
