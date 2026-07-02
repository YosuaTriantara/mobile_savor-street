import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env_config.dart';

/// Temporary Dio setup — Anggota 2 owns core/network/ and will likely add
/// interceptors (logging, error mapping) here. Kept minimal for now so
/// cart/order/invoice can integrate with the live API.
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: EnvConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
});
