import 'package:get/get.dart';

import 'api.dart';

class BaseProvider extends GetConnect {
  final String baseApiUrl;

  BaseProvider(this.baseApiUrl);

  @override
  void onInit() {
    httpClient.baseUrl = baseApiUrl;
    httpClient.addRequestModifier(requestInterceptor);
    httpClient.addResponseModifier(responseInterceptor);
  }
}
