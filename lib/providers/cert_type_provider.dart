import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_cert_info/models/cert_type.dart';

class CertTypeProvider {
  Future<List<CertType>> fetchCertType() async {
    final jsonString =  await rootBundle.loadString('assets/cert_type.json');
    final jsonData = jsonDecode(jsonString.toString()) as List<dynamic>;
    return jsonData.map((item) => CertType.fromJson(item)).toList();
  }
}
