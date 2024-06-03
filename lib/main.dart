import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:restobook_web/model/repository/abstract_restaurant_repository.dart';
import 'package:restobook_web/model/service/abstract_auth_service.dart';
import 'package:restobook_web/model/service/http_auth_service.dart';
import 'package:restobook_web/model/service/mock_auth_service.dart';
import 'package:restobook_web/view/login_screen.dart';
import 'package:restobook_web/view/restaurants_overview_screen.dart';
import 'package:restobook_web/view_model/application_view_model.dart';
import 'package:restobook_web/view_model/restaurant_view_model.dart';

import 'model/repository/abstract_employee_repository.dart';
import 'model/repository/mock_backend.dart';
import 'model/repository/mock_employee_repository.dart';
import 'package:provider/provider.dart';

import 'model/repository/mock_restaurant_repository.dart';
import 'model/service/api_dio.dart';

void main() {

  var logger = Logger(
      printer: PrettyPrinter()
  );
  GetIt.I.registerSingleton<Logger>(logger);

  final api = Api();
  api.init();
  GetIt.I.registerSingleton<Api>(api);

  GetIt.I.registerSingleton<MockBackend>(MockBackend());
  GetIt.I.registerSingleton<AbstractEmployeeRepository>(
      MockEmployeeRepository());
  GetIt.I.registerSingleton<AbstractRestaurantRepository>(
      MockRestaurantRepository());
  GetIt.I.registerSingleton<AbstractAuthService>(HttpAuthService());

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => RestaurantViewModel()),
    ChangeNotifierProvider(create: (context) => ApplicationViewModel())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget startScreen;
    if (context.read<ApplicationViewModel>().authorized) {
      startScreen = const RestaurantsOverviewScreen();
    } else {
      startScreen = const LoginScreen();
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: startScreen,
    );
  }
}
