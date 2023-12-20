import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
    final String apiKey = dotenv.env['API_KEY'] ?? 'default';
    final String ip = dotenv.env['BACKEND_IP'] ?? 'default';

    Future<String> getUsername() async {
      const FlutterSecureStorage secureStorage = FlutterSecureStorage();
      String? jwt = await secureStorage.read(key: 'JWT') ?? 'Default';
      final headers = <String, String>{'Api-Key': apiKey, 'Authorization': jwt};
      final url =
      'http://$ip/auth/info';

      try {
        final response = await http.get(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          return response.body;

        } else {
          print('Failed to fetch username. Status code: ${response.statusCode}');
          return 'default';
        }
      } catch (error) {
        print('Error fetching username: $error');
        // Handle error, e.g., show an error message to the user
        // Return an appropriate value or throw an exception based on your requirements
        return 'default';
      }
    }
}