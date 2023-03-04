import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/cert_schedule.dart';

class CertScheduleProviders {

  final url = "http://apis.data.go.kr/B490007/qualExamSchd/getQualExamSchdList";
  final dio = Dio();

  Future<List<CertSchedule>> fetchCertSchedule(int year, String jmCd) async {
    // final result = await dio.get(url, queryParameters: {
    //   "serviceKey": dotenv.env['SCHEDULE_SERVICE_KEY'],
    //   "numOfRows": 2,
    //   "pageNo": 1,
    //   "dataFormat": "json",
    //   "implYy": year,
    //   "jmCd": jmCd
    // });
    final result = '''
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
    var jsonResponse = jsonDecode(result.toString());
    final response = CertScheduleResponse.fromJson(jsonResponse);
    var items = response.getItems();
    items.sort((a, b) => a.implSeq.compareTo(b.implSeq));
    return items;
  }
}
