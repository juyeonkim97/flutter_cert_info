import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cert_info/models/cert_schedule.dart';
import 'package:flutter_cert_info/models/cert_type.dart';
import 'package:flutter_cert_info/widgets/calendar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/cert_schedule_providers.dart';
import '../providers/cert_type_provider.dart';
import '../res/colors.dart';

/// Main calendar page.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _currentDate = DateTime.now();
  final _initialCertType = CertType(jmcd: "1320", jmfldnm: "정보처리기사");

  final CertScheduleProviders _certScheduleProviders = CertScheduleProviders();
  final CertTypeProvider certTypeProvider = CertTypeProvider();

  late String _selectedJmFldNm;
  late String _selectedJmCd;
  late List<CertSchedule> _schedules;
  late Widget _calendarWidget;
  late var prefs;

  List<CertType> _certTypeList = [];
  List<CalendarEventModel> _events = [];
  bool _isLoading = true;
  bool _showCalendar = true;

  Future<void> _fetchData() async {
    await _loadSelectedCertType().then((value) => _fetchCertSchedule(_selectedJmCd));
  }

  @override
  void initState() {
    _fetchData().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
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
            title: Row(
              children: [
                _isLoading
                    ? CircularProgressIndicator()
                    : Text(_selectedJmFldNm),
                IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: _showCertTypeListInModalSheet),
              ],
            )),
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

  Future<void> _loadSelectedCertType() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedJmFldNm =
          prefs.getString('selectedJmFldNm') ?? _initialCertType.jmfldnm;
      _selectedJmCd = prefs.getString('selectedJmCd') ?? _initialCertType.jmcd;
    });
  }

  Future<void> _saveSelectedCertType(String jmfldnm, String jmcd) async {
    await prefs.setString('selectedJmFldNm', jmfldnm);
    await prefs.setString('selectedJmCd', jmcd);
  }

  Future<void> _fetchCertSchedule(String jmcd) async {
    _schedules =
        await _certScheduleProviders.fetchCertSchedule(_currentDate.year, jmcd);
    _createEventModels();
    _calendarWidget = CalendarWidget(events: _events);
  }

  Widget _listWidget() {
    return Container(
        color: Colors.white,
        child: ListView.builder(
            itemCount: _schedules.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _schedules[index];
              return ExpansionTile(
                textColor: eventColors[index % 6],
                title: Text(item.getFieldDescription('implSeq'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
                children: <Widget>[
                  if (item.docRegStartDt != '')
                    ListTile(
                        title: Text(
                            '${item.getFieldDescription('docRegStartDt')} : ${item.docRegStartDt} ~ ${item.docRegEndDt}')),
                  if (item.addDocRegStartDt != null)
                    ListTile(
                        title: Text(
                            '${item.getFieldDescription('addDocRegStartDt')} : ${item.addDocRegStartDt} ~ ${item.addDocRegEndDt}')),
                  if (item.docExamStartDt != '')
                    ListTile(
                        title: Text(
                            '${item.getFieldDescription('docExamStartDt')} : ${item.docExamStartDt} ~ ${item.docExamEndDt}')),
                  if (item.docPassDt != '')
                    ListTile(
                        title: Text(
                            '${item.getFieldDescription('docPassDt')} : ${item.docPassDt}')),
                  if (item.pracRegStartDt != '')
                    ListTile(
                        title: Text(
                            '${item.getFieldDescription('pracRegStartDt')} : ${item.pracRegStartDt} ~ ${item.pracRegEndDt}')),
                  if (item.pracExamStartDt != '')
                    ListTile(
                        title: Text(
                            '${item.getFieldDescription('pracExamStartDt')} : ${item.pracExamStartDt} ~ ${item.pracExamEndDt}')),
                  if (item.pracPassDt != '')
                    ListTile(
                        title: Text(
                            '${item.getFieldDescription('pracPassDt')} : ${item.pracPassDt}')),
                ],
              );
            }));
  }

  void _createEventModels() {
    if (_events.isNotEmpty) {
      _events.clear();
    }
    _schedules.asMap().forEach((index, element) {
      final eventColor = eventColors[index % 6];
      // 필기 원서접수
      if (element.docRegStartDt != "") {
        var calendarEventModel = CalendarEventModel(
          name: element.getFieldDescription("implSeq") +
              element.getFieldDescription("docRegStartDt"),
          begin: DateTime.parse(element.docRegStartDt ?? ""),
          end: DateTime.parse(element.docRegEndDt ?? ""),
          eventColor: eventColor,
        );
        _events.add(calendarEventModel);
      }
      // 필기 빈자리 원서접수
      if (element.addDocRegStartDt != null) {
        var calendarEventModel = CalendarEventModel(
          name: element.getFieldDescription("implSeq") +
              element.getFieldDescription("addDocRegStartDt"),
          begin: DateTime.parse(element.addDocRegStartDt ?? ""),
          end: DateTime.parse(element.addDocRegEndDt ?? ""),
          eventColor: eventColor,
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
          eventColor: eventColor,
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
          eventColor: eventColor,
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
          eventColor: eventColor,
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
          eventColor: eventColor,
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
          eventColor: eventColor,
        );
        _events.add(calendarEventModel);
      }
    });
  }

  Future<void> _showCertTypeListInModalSheet() async {
    _certTypeList = await certTypeProvider.fetchCertType();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _certTypeList.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _certTypeList[index];
            return ListTile(
              title: Text(item.jmfldnm),
              onTap: () => onTap(item),
            );
          },
        );
      },
    );
  }

  void onTap(CertType item) {
    if (_selectedJmFldNm != item.jmfldnm) {
      setState(() {
        _isLoading = true;
        _selectedJmFldNm = item.jmfldnm;
        _selectedJmCd = item.jmcd;
      });
      _saveSelectedCertType(_selectedJmFldNm, _selectedJmCd);
      _fetchCertSchedule(item.jmcd).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      Navigator.pop(context);
    }
  }
}
