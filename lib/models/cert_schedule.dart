class CertScheduleResponse {
  final Header header;
  final Body body;

  CertScheduleResponse({required this.header, required this.body});

  factory CertScheduleResponse.fromJson(Map<String, dynamic> json) {
    return CertScheduleResponse(
      header: Header.fromJson(json['header']),
      body: Body.fromJson(json['body']),
    );
  }

  List<CertSchedule> getItems() {
    return body.items;
  }
}

class Header {
  final String resultCode;
  final String resultMsg;

  Header({required this.resultCode, required this.resultMsg});

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      resultCode: json['resultCode'],
      resultMsg: json['resultMsg'],
    );
  }
}

class Body {
  final List<CertSchedule> items;
  final int numOfRows;
  final int pageNo;
  final int totalCount;

  Body({
    required this.items,
    required this.numOfRows,
    required this.pageNo,
    required this.totalCount,
  });

  factory Body.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<CertSchedule> items =
        itemsJson.map((itemJson) => CertSchedule.fromJson(itemJson)).toList();
    return Body(
      items: items,
      numOfRows: json['numOfRows'],
      pageNo: json['pageNo'],
      totalCount: json['totalCount'],
    );
  }
}

class CertSchedule {
  final String implYy;
  final int implSeq;
  final String? qualgbCd;
  final String? qualgbNm;
  final String? description;
  late String? docRegStartDt;
  late String? docRegEndDt;
  final String? addDocRegStartDt;
  final String? addDocRegEndDt;
  final String? docExamStartDt;
  final String? docExamEndDt;
  final String? docPassDt;
  final String? pracRegStartDt;
  final String? pracRegEndDt;
  final String? pracExamStartDt;
  final String? pracExamEndDt;
  final String? pracPassDt;

  CertSchedule({
    required this.implYy,
    required this.implSeq,
    this.qualgbCd,
    this.qualgbNm,
    this.description,
    this.docRegStartDt,
    this.docRegEndDt,
    this.addDocRegStartDt,
    this.addDocRegEndDt,
    this.docExamStartDt,
    this.docExamEndDt,
    this.docPassDt,
    this.pracRegStartDt,
    this.pracRegEndDt,
    this.pracExamStartDt,
    this.pracExamEndDt,
    this.pracPassDt,
  });

  factory CertSchedule.fromJson(Map<String, dynamic> json) {
    return CertSchedule(
      implYy: json['implYy'],
      implSeq: json['implSeq'],
      qualgbCd: json['qualgbCd'],
      qualgbNm: json['qualgbNm'],
      description: json['description'],
      docRegStartDt: json['docRegStartDt'],
      docRegEndDt: json['docRegEndDt'],
      addDocRegStartDt: json['addDocRegStartDt'],
      addDocRegEndDt: json['addDocRegEndDt'],
      docExamStartDt: json['docExamStartDt'],
      docExamEndDt: json['docExamEndDt'],
      docPassDt: json['docPassDt'],
      pracRegStartDt: json['pracRegStartDt'],
      pracRegEndDt: json['pracRegEndDt'],
      pracExamStartDt: json['pracExamStartDt'],
      pracExamEndDt: json['pracExamEndDt'],
      pracPassDt: json['pracPassDt'],
    );
  }

  String getFieldDescription(String fieldName) {
    switch (fieldName) {
      case 'implSeq':
        return '???${implSeq}??? ';
      case 'docRegStartDt':
        return '?????? ????????????';
      case 'addDocRegStartDt':
        return '?????? ????????? ????????????';
      case 'docExamStartDt':
        return '?????? ??????';
      case 'docPassDt':
        return '?????? ????????? ??????';
      case 'pracRegStartDt':
        return '?????? ????????????';
      case 'pracExamStartDt':
        return '?????? ??????';
      case 'pracPassDt':
        return '?????? ????????? ??????';
    }
    return 'null';
  }
}
