import 'package:badwallet_app/core/constants/api_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('platform helpers return emulator and local hosts', () {
    expect(
      ApiConstants.baseUrlForPlatform(isAndroid: true),
      'http://10.0.2.2:8080',
    );
    expect(
      ApiConstants.baseUrlForPlatform(isAndroid: false),
      'http://127.0.0.1:8080',
    );
    expect(
      ApiConstants.paymentServiceBaseUrlForPlatform(isAndroid: true),
      'http://10.0.2.2:8081',
    );
    expect(
      ApiConstants.paymentServiceBaseUrlForPlatform(isAndroid: false),
      'http://127.0.0.1:8081',
    );
  });
}
