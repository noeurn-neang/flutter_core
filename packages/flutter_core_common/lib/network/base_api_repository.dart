import 'package:get/get.dart';

import './base_provider.dart';

class BaseApiRepository {
  BaseApiRepository({required this.apiProvider});

  final BaseProvider apiProvider;

  Future<Response<dynamic>> getPath(String path, {Map<String, dynamic>? query}) {
    return apiProvider.get(path, query: query);
  }

  Future<Response<dynamic>> postPath(
    String path,
    Map<String, dynamic> payload,
  ) {
    return apiProvider.post(path, payload);
  }

  Future<Response<dynamic>> putPath(
    String path,
    Map<String, dynamic> payload,
  ) {
    return apiProvider.put(path, payload);
  }

  Future<Response<dynamic>> deletePath(String path) {
    return apiProvider.delete(path);
  }
}
