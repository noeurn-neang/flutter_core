import 'package:flutter_core/flutter_core.dart';

/// Example HTTP client. Point [baseApiUrl] at your API in real apps.
class DemoProvider extends BaseProvider {
  DemoProvider() : super('https://jsonplaceholder.typicode.com');
}

class DemoRepository extends BaseApiRepository {
  DemoRepository() : super(apiProvider: Get.put(DemoProvider()));

  Future<Response<dynamic>> fetchUser() => getPath('/users/1');
}
