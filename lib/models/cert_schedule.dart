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
  final String? docRegStartDt;
  final String? docRegEndDt;
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
        return '제${implSeq}회 ';
      case 'docRegStartDt':
        return '필기 원서접수';
      // case 'docRegEndDt':
      //   return '필기 원서접수 종료';
      case 'docExamStartDt':
        return '필기 시험';
      // case 'docExamEndDt':
      //   return '필기 시험 종료';
      case 'docPassDt':
        return '필기 합격자 발표';
      case 'pracRegStartDt':
        return '실기 원서접수';
      // case 'pracRegEndDt':
      //   return '실기 원서접수 종료';
      case 'pracExamStartDt':
        return '실기 시험';
      // case 'pracExamEndDt':
      //   return '실기 시험 종료';
      case 'pracPassDt':
        return '실기 합격자 발표';
    }
    return 'null';
  }
}
