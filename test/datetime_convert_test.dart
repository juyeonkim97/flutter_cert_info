import 'package:flutter_test/flutter_test.dart';

void main() {
  test('string convert to datetime', () {
    const originStringDate = '20231113';
    var result = DateTime.parse(originStringDate);

    expect(result, DateTime(2023, 11, 13));
  });
}
