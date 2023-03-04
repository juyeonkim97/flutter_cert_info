import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cert_info/models/cert_schedule.dart';
import 'package:flutter_cert_info/models/cert_type.dart';
import 'package:flutter_cert_info/widgets/calendar_widget.dart';

import '../providers/cert_schedule_providers.dart';
import '../res/colors.dart';

/// Main calendar page.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _currentDate = DateTime.now();
  final _initialCertType = CertType(jmcd: "7910", jmfldnm: "정보처리기사");

  final CertScheduleProviders _certScheduleProviders = CertScheduleProviders();

  late String _viewCertType;
  late List<CertSchedule> _schedules;
  late Widget _calendarWidget;

  List<CalendarEventModel> _events = [];
  bool _isLoading = true;
  bool _showCalendar = true;

  @override
  void initState() {
    super.initState();
    _viewCertType = _initialCertType.jmfldnm;
    _fetchCertSchedule().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
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
              onPressed: () {
                setState(() {
                  _showCalendar = !_showCalendar;
                });
              },
            ),
            title: Text(_viewCertType)),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Visibility(
                    visible: _showCalendar,
                    maintainState: true,
                    child: _calendarWidget,
                  ),
                  Visibility(
                    visible: !_showCalendar,
                    maintainState: true,
                    child: _listWidget(),
                  ),
                ],
              ));
  }

  Future _fetchCertSchedule() async {
    _schedules = await _certScheduleProviders.fetchCertSchedule(
        _currentDate.year, _initialCertType.jmcd);
    _createEventModels();
    _calendarWidget = CalendarWidget(events: _events);
  }

  Widget _listWidget() {
    return ListView.builder(
        itemCount: _schedules.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _schedules[index];
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

  void _createEventModels() {
    _schedules.forEach((element) {
      // 필기 원서접수
      if (element.docRegStartDt != "") {
        var calendarEventModel = CalendarEventModel(
          name: element.getFieldDescription("implSeq") +
              element.getFieldDescription("docRegStartDt"),
          begin: DateTime.parse(element.docRegStartDt ?? ""),
          end: DateTime.parse(element.docExamEndDt ?? ""),
          eventColor: eventColors[0],
        );
        _events.add(calendarEventModel);
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
        _events.add(calendarEventModel);
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
        _events.add(calendarEventModel);
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
        _events.add(calendarEventModel);
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
        _events.add(calendarEventModel);
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
        _events.add(calendarEventModel);
      }
    });
  }
}
