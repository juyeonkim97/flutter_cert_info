import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_cert_info/models/cert_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('local json parsing test', () async{
    final jsonString =  await rootBundle.loadString('assets/cert_type.json');
    final jsonData = jsonDecode(jsonString.toString()) as List<dynamic>;
    var list = jsonData.map((item) => CertType.fromJson(item)).toList();
    expect(list.first.jmcd, '0740');
  });
}
