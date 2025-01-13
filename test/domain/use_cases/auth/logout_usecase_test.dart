import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/domain/use_cases/log_out.dart';

import '../../../mocks/mocks.mocks.dart';


void main() {
  late MockAuthRepository mockRepository;
  late LogoutUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(mockRepository);
  });

  test('should call logout on repository', () async {
    await useCase();

    verify(mockRepository.logout()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
