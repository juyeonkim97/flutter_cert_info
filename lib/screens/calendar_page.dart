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

  bool _showCalendar = true;
  bool _isLoading = true;

  List<Item> items = [];
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
        _isLoading = false;
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
          centerTitle: false,
          leading: IconButton(
              tooltip: 'Change List View',
              icon: const Icon(Icons.format_list_bulleted_outlined),
              onPressed: () {
                setState(() {
                  _showCalendar = !_showCalendar;
                });
              }),
          title: _showCalendar ? Text(_appbarTitle) : null,
          actions: _showCalendar
              ? [
                  IconButton(
                    tooltip: 'Go to current date',
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _showCurrentMonth,
                  ),
                ]
              : null,
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _addEvent,
        //   child: const Icon(Icons.add),
        // ),
        body: _isLoading // 로딩 중이지 않건
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _showCalendar
                ? calendarWidget()
                : buildText());
  }

  Widget buildText() {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return ExpansionTile(
            textColor: eventColors[0],
            title: Text(item.getFieldDescription('implSeq'),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            children: <Widget>[
              ListTile(
                  title: Text(
                      '${item.getFieldDescription('docRegStartDt')} : ${item.docRegStartDt} ~ ${item.docRegEndDt}')),
              ListTile(
                  title: Text(
                      '${item.getFieldDescription('docExamStartDt')} : ${item.docExamStartDt} ~ ${item.docExamEndDt}')),
              ListTile(
                  title: Text(
                      '${item.getFieldDescription('docPassDt')} : ${item.docPassDt}')),
              ListTile(
                  title: Text(
                      '${item.getFieldDescription('pracRegStartDt')} : ${item.pracRegStartDt} ~ ${item.pracRegEndDt}')),
              ListTile(
                  title: Text(
                      '${item.getFieldDescription('pracExamStartDt')} : ${item.pracExamStartDt} ~ ${item.pracExamEndDt}')),
              ListTile(
                  title: Text(
                      '${item.getFieldDescription('pracPassDt')} : ${item.pracPassDt}')),
            ],
          );
        });
  }

  Widget calendarWidget() {
    return Column(
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
                  fontSize: 16, color: violet, fontWeight: FontWeight.w600),
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

  void fetchEvents() {
    List<CalendarEventModel> events = [];

    items.forEach((element) {
      // 필기 원서접수
      if (element.docRegStartDt != "") {
        var calendarEventModel = CalendarEventModel(
          name: element.getFieldDescription("implSeq") +
              element.getFieldDescription("docRegStartDt"),
          begin: DateTime.parse(element.docRegStartDt ?? ""),
          end: DateTime.parse(element.docRegEndDt ?? ""),
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
