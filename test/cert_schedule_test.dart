// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cert_info/model/cert_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_cert_info/main.dart';

void main() {
  test('Parsing CertificateResponse from JSON', () {
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
                    "implSeq": 101,
                    "qualgbCd": "T",
                    "qualgbNm": "국가기술자격",
                    "description": "국가기술자격 기능사 (2023년도 제101회)",
                    "docRegStartDt": "",
                    "docRegEndDt": "",
                    "docExamStartDt": "",
                    "docExamEndDt": "",
                    "docPassDt": "",
                    "pracRegStartDt": "20230203",
                    "pracRegEndDt": "20230203",
                    "pracExamStartDt": "20230213",
                    "pracExamEndDt": "20230317",
                    "pracPassDt": "20230323"
                },
                {
                    "implYy": "2023",
                    "implSeq": 22,
                    "qualgbCd": "S",
                    "qualgbNm": "국가전문자격",
                    "description": "전문자격 (2023년도 22회 면접)",
                    "docRegStartDt": "20231113",
                    "docRegEndDt": "20231117",
                    "docExamStartDt": "20231211",
                    "docExamEndDt": "20231216",
                    "docPassDt": "20231227",
                    "pracRegStartDt": "",
                    "pracRegEndDt": "",
                    "pracExamStartDt": "",
                    "pracExamEndDt": "",
                    "pracPassDt": ""
                }
            ],
            "numOfRows": 2,
            "pageNo": 1,
            "totalCount": 106
        }
    }
  ''';

    final jsonResponse = jsonDecode(jsonStr);
    final response = CertScheduleResponse.fromJson(jsonResponse);

    expect(response.header.resultCode, '00');
    expect(response.header.resultMsg, 'NORMAL SERVICE');
    expect(response.body.numOfRows, 2);
    expect(response.body.pageNo, 1);
    expect(response.body.totalCount, 106);
    expect(response.body.items.length, 2);
    response.body.items.forEach((element) {
      print('원서접수 일정 ${element.docRegStartDt} ~ ${element.docRegEndDt}');
    });
  });
}
