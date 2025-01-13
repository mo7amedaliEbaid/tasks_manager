// test/data/sources/mock_http_client.dart
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() {}
