import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tasks_manager/data/data_sources/auth_remote_data_source.dart';
import 'package:tasks_manager/domain/repositories/auth_repository.dart';
import 'package:tasks_manager/domain/repositories/tasks_repository.dart';


@GenerateMocks([http.Client, AuthRemoteDataSource, AuthRepository, FlutterSecureStorage,TaskRepository])
void main() {}
