// lib/swipe_main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tasks_manager/presentation/blocs/auth/auth_bloc.dart';
import 'package:tasks_manager/presentation/screens/login.dart';
import 'package:tasks_manager/shared/observer/app_observer.dart';
import 'package:tasks_manager/shared/ui/app_scroll_behavior.dart';

import 'di/di.dart';
import 'goey_edge/demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  init();
  final FlutterSecureStorage secureStorage = getIt<FlutterSecureStorage>();
  final accessToken = await secureStorage.read(key: 'accessToken');
  runApp(MyApp(
    accessToken: accessToken,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.accessToken,
  });

  final String? accessToken;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    ));
    final theme = ThemeData(
      brightness: Brightness.dark,
      canvasColor: Color(0xFF161719),
      textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white, fontFamily: 'OpenSans'),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
    );
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: MaterialApp(
        title: 'Task Manager',
        scrollBehavior: AppScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: Color(0xffc932d9),
          ),
        ),
        home: accessToken != null
            ? GooeyEdgeDemo(
                title: 'Tasks Manager',
              )
            : LoginScreen(),
      ),
    );
  }
}
