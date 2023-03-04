class CertType {
  final String jmcd;
  final String jmfldnm;

  CertType({required this.jmcd, required this.jmfldnm});

  factory CertType.fromJson(Map<String, dynamic> json) {
    return CertType(jmcd: json['jmcd'], jmfldnm: json['jmfldnm']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jmcd'] = this.jmcd;
    data['jmfldnm'] = this.jmfldnm;
    return data;
  }
}
