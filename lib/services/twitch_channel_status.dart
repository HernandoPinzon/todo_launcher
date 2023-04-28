import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> checkIfUserIsStreaming(String username) async {
  const clientId = 'kimne78kx3ncx6brgo4mv6wki5h1ko';
  final url = Uri.parse('https://gql.twitch.tv/gql');
  final query =
      'query {\n  user(login: "$username") {\n    stream {\n      id\n    }\n  }\n}';
  final response = await http.post(
    url,
    headers: {'client-id': clientId},
    body: jsonEncode({'query': query, 'variables': {}}),
  );
  final responseData = jsonDecode(response.body);
  return responseData['data']['user']['stream'] != null;
}
