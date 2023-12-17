import 'dart:async';

import './base_provider.dart';

class BaseApiRepository {
  BaseApiRepository({required this.apiProvider});

  final BaseProvider apiProvider;

  Future<dynamic> base(Map<String, dynamic> payload) async {
    return apiProvider.post('/', payload);
  }
}
