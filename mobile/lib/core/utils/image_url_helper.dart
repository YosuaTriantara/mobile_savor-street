import '../config/env_config.dart';

class ImageUrlHelper {
  ImageUrlHelper._();

  static String build(String pathFromDb) {
    final endpoint = EnvConfig.imageKitUrlEndpoint.endsWith('/')
        ? EnvConfig.imageKitUrlEndpoint
        : '${EnvConfig.imageKitUrlEndpoint}/';
    final path = pathFromDb.startsWith('/')
        ? pathFromDb.substring(1)
        : pathFromDb;
    return '$endpoint$path';
  }
}
