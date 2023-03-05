// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter_cert_info/models/cert_schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  test('한 회차에 필기접수 세개 있는 거 정제 테스트', () {
    const jsonStr = '''
      {
    "header": {
        "resultCode": "00",
        "resultMsg": "NORMAL SERVICE"
    },
    "body": {
        "items": [
            {
                "implYy": "2023",
                "implSeq": 4,
                "qualgbCd": "T",
                "qualgbNm": "국가기술자격",
                "description": "국가기술자격 기사 (2023년도 제4회)",
                "docRegStartDt": "20230807",
                "docRegEndDt": "20230810",
                "docExamStartDt": "20230902",
                "docExamEndDt": "20230917",
                "docPassDt": "20230922",
                "pracRegStartDt": "20231010",
                "pracRegEndDt": "20231013",
                "pracExamStartDt": "20231104",
                "pracExamEndDt": "20231117",
                "pracPassDt": "20231129"
            },
            {
                "implYy": "2023",
                "implSeq": 2,
                "qualgbCd": "T",
                "qualgbNm": "국가기술자격",
                "description": "국가기술자격 기사 (2023년도 제2회)",
                "docRegStartDt": "20230417",
                "docRegEndDt": "20230420",
                "docExamStartDt": "20230513",
                "docExamEndDt": "20230604",
                "docPassDt": "20230614",
                "pracRegStartDt": "20230627",
                "pracRegEndDt": "20230630",
                "pracExamStartDt": "20230722",
                "pracExamEndDt": "20230806",
                "pracPassDt": "20230817"
            },
            {
                "implYy": "2023",
                "implSeq": 1,
                "qualgbCd": "T",
                "qualgbNm": "국가기술자격",
                "description": "국가기술자격 기사 (2023년도 제1회)",
                "docRegStartDt": "20230207",
                "docRegEndDt": "20230208",
                "docExamStartDt": "20230213",
                "docExamEndDt": "20230315",
                "docPassDt": "20230321",
                "pracRegStartDt": "20230328",
                "pracRegEndDt": "20230331",
                "pracExamStartDt": "20230422",
                "pracExamEndDt": "20230507",
                "pracPassDt": "20230609"
            },
            {
                "implYy": "2023",
                "implSeq": 1,
                "qualgbCd": "T",
                "qualgbNm": "국가기술자격",
                "description": "국가기술자격 기사 (2023년도 제1회)",
                "docRegStartDt": "20230116",
                "docRegEndDt": "20230119",
                "docExamStartDt": "20230213",
                "docExamEndDt": "20230315",
                "docPassDt": "20230321",
                "pracRegStartDt": "20230328",
                "pracRegEndDt": "20230331",
                "pracExamStartDt": "20230422",
                "pracExamEndDt": "20230507",
                "pracPassDt": "20230609"
            },
            {
                "implYy": "2023",
                "implSeq": 1,
                "qualgbCd": "T",
                "qualgbNm": "국가기술자격",
                "description": "국가기술자격 기사 (2023년도 제1회)",
                "docRegStartDt": "20230110",
                "docRegEndDt": "20230113",
                "docExamStartDt": "20230213",
                "docExamEndDt": "20230315",
                "docPassDt": "20230321",
                "pracRegStartDt": "20230328",
                "pracRegEndDt": "20230331",
                "pracExamStartDt": "20230422",
                "pracExamEndDt": "20230507",
                "pracPassDt": "20230609"
            }
        ],
        "numOfRows": 30,
        "pageNo": 1,
        "totalCount": 5
    }
}
    ''';

    final jsonResponse = jsonDecode(jsonStr);
    final response = CertScheduleResponse.fromJson(jsonResponse);
    List<CertSchedule> items = response.getItems();

    List<dynamic> filteredItems = [];
    List<CertSchedule> duplicateItems = []; // 중복되는 애들 모아뒀다가 다시 조립할 것임

    for (final item in items) {
      final implSeq = item.implSeq;

      final matchingItem = filteredItems.firstWhere(
        (element) => element.implSeq == implSeq,
        orElse: () => null, // 빈 객체를 반환하도록 수정
      );

      if (matchingItem != null) {
        duplicateItems.add(matchingItem);

        filteredItems.remove(matchingItem);
        filteredItems.add(item);
      } else {
        filteredItems.add(item);
      }
    }
    duplicateItems
        .sort((a, b) => a.docRegStartDt?.compareTo(b.docRegStartDt ?? '') ?? 0);

    var updateDocRegEndDt = duplicateItems.first.docRegEndDt;
    var updateAddDocRegStartDt = duplicateItems.last.docRegStartDt;
    var updateAddDocRegEndDt = duplicateItems.last.docRegEndDt;
    var duplicateImplSeq = duplicateItems.first.implSeq;
    CertSchedule updateItem = filteredItems
        .firstWhere((element) => element.implSeq == duplicateImplSeq);
    var newItem = CertSchedule(
        implYy: updateItem.implYy,
        implSeq: updateItem.implSeq,
        docRegStartDt: updateItem.docRegStartDt,
        docRegEndDt: updateDocRegEndDt,
        addDocRegStartDt: updateAddDocRegStartDt,
        addDocRegEndDt: updateAddDocRegEndDt);

    // // 기존에 있던 거 지우고
    filteredItems.remove(updateItem);
    // // 새로 만든 거 넣어줌
    filteredItems.add(newItem);

    filteredItems.forEach((element) {
      print('${element.getFieldDescription('implSeq')}');
      print('필기원서 접수 시작 : ${element.docRegStartDt}');
      print('필기원서 접수 종료 : ${element.docRegEndDt}');
      print('필기원서 빈자리 접수 시작 : ${element.addDocRegStartDt}');
      print('필기원서 빈자리 접수 종료 : ${element.addDocRegEndDt}');
    });

    List<CertSchedule> cast = filteredItems.cast<CertSchedule>();
  });
}
