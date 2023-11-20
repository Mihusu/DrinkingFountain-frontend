import 'package:jwt_decoder/jwt_decoder.dart';

class RoleService {
  Future<bool> isUserLoggedIn(secureStorage) async {
    final authToken = await secureStorage.read(key: 'JWT');

    return authToken != null;
  }

  Future<bool> isAdmin(secureStorage) async {
    final authToken = await secureStorage.read(key: 'JWT');

    if (authToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(authToken);

      String role = decodedToken['role'];

      return role == 'ADMIN';
    }

    return false;
  }
}
