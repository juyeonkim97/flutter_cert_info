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
  final List<Item> items;
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
    List<Item> items =
    itemsJson.map((itemJson) => Item.fromJson(itemJson)).toList();
    return Body(
      items: items,
      numOfRows: json['numOfRows'],
      pageNo: json['pageNo'],
      totalCount: json['totalCount'],
    );
  }
}

class Item {
  final String implYy;
  final int implSeq;
  final String qualgbCd;
  final String qualgbNm;
  final String description;
  final String docRegStartDt;
  final String docRegEndDt;
  final String docExamStartDt;
  final String docExamEndDt;
  final String docPassDt;
  final String pracRegStartDt;
  final String pracRegEndDt;
  final String pracExamStartDt;
  final String pracExamEndDt;
  final String pracPassDt;

  Item({
    required this.implYy,
    required this.implSeq,
    required this.qualgbCd,
    required this.qualgbNm,
    required this.description,
    required this.docRegStartDt,
    required this.docRegEndDt,
    required this.docExamStartDt,
    required this.docExamEndDt,
    required this.docPassDt,
    required this.pracRegStartDt,
    required this.pracRegEndDt,
    required this.pracExamStartDt,
    required this.pracExamEndDt,
    required this.pracPassDt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
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
}
