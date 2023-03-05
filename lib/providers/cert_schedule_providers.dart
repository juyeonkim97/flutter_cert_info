import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/cert_schedule.dart';

class CertScheduleProviders {
  final url = "http://apis.data.go.kr/B490007/qualExamSchd/getQualExamSchdList";
  final dio = Dio();

  Future<List<CertSchedule>> fetchCertSchedule(int year, String jmCd) async {
    print('종목 코드 ${jmCd} 의 시험 일정을 조회합니다...');
    final result = await dio.get(url, queryParameters: {
      "serviceKey": dotenv.env['SCHEDULE_SERVICE_KEY'],
      "numOfRows": 30,
      "pageNo": 1,
      "dataFormat": "json",
      "implYy": year,
      "jmCd": jmCd
    });
    // final result = '''
    //   {
    //       "header": {
    //           "resultCode": "00",
    //           "resultMsg": "NORMAL SERVICE"
    //       },
    //       "body": {
    //           "items": [
    //               {
    //                   "implYy": "2023",
    //                   "implSeq": 101,
    //                   "qualgbCd": "T",
    //                   "qualgbNm": "국가기술자격",
    //                   "description": "국가기술자격 기능사 (2023년도 제101회)",
    //                   "docRegStartDt": "",
    //                   "docRegEndDt": "",
    //                   "docExamStartDt": "",
    //                   "docExamEndDt": "",
    //                   "docPassDt": "",
    //                   "pracRegStartDt": "20230203",
    //                   "pracRegEndDt": "20230203",
    //                   "pracExamStartDt": "20230213",
    //                   "pracExamEndDt": "20230317",
    //                   "pracPassDt": "20230323"
    //               },
    //               {
    //                   "implYy": "2023",
    //                   "implSeq": 22,
    //                   "qualgbCd": "S",
    //                   "qualgbNm": "국가전문자격",
    //                   "description": "전문자격 (2023년도 22회 면접)",
    //                   "docRegStartDt": "20231113",
    //                   "docRegEndDt": "20231117",
    //                   "docExamStartDt": "20231211",
    //                   "docExamEndDt": "20231216",
    //                   "docPassDt": "20231227",
    //                   "pracRegStartDt": "",
    //                   "pracRegEndDt": "",
    //                   "pracExamStartDt": "",
    //                   "pracExamEndDt": "",
    //                   "pracPassDt": ""
    //               }
    //           ],
    //           "numOfRows": 2,
    //           "pageNo": 1,
    //           "totalCount": 106
    //       }
    //   }
    // ''';
    var jsonResponse = jsonDecode(result.toString());
    final response = CertScheduleResponse.fromJson(jsonResponse);
    var items = _updateDuplicateObject(response.getItems());

    items.sort((a, b) => a.implSeq.compareTo(b.implSeq));
    return items;
  }

  List<CertSchedule> _updateDuplicateObject(List<CertSchedule> list) {
    List<dynamic> filteredItems = [];
    List<CertSchedule> duplicateItems = []; // 중복되는 애들 모아뒀다가 다시 조립할 것임

    for (final item in list) {
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

    if (duplicateItems.isNotEmpty) {
      duplicateItems.sort(
          (a, b) => a.docRegStartDt?.compareTo(b.docRegStartDt ?? '') ?? 0);

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
          addDocRegEndDt: updateAddDocRegEndDt,
          docExamStartDt: updateItem.docExamStartDt,
          docExamEndDt: updateItem.docExamEndDt,
          docPassDt: updateItem.docPassDt,
          pracRegStartDt: updateItem.pracRegStartDt,
          pracRegEndDt: updateItem.pracRegEndDt,
          pracExamStartDt: updateItem.pracExamStartDt,
          pracExamEndDt: updateItem.pracExamEndDt,
          pracPassDt: updateItem.pracPassDt
      );

      // // 기존에 있던 거 지우고
      filteredItems.remove(updateItem);
      // // 새로 만든 거 넣어줌
      filteredItems.add(newItem);
    }

    return filteredItems.cast<CertSchedule>();
  }
}
