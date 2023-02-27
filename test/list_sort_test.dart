import 'dart:convert';

import 'package:flutter_cert_info/models/cert_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('list sort test', () {
    const jsonString = '''
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

    final jsonResponse = jsonDecode(jsonString);
    final response = CertScheduleResponse.fromJson(jsonResponse);
    // "implSeq"를 기준으로 오름차순 정렬
    var items = response.getItems();
    items.sort((a, b) => a.implSeq.compareTo(b.implSeq));

    expect(items.first.implSeq, 22);
  });
}
