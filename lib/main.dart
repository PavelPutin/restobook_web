import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:restobook_web/model/repository/abstract_restaurant_repository.dart';
import 'package:restobook_web/model/repository/http_employee_repository.dart';
import 'package:restobook_web/model/service/abstract_auth_service.dart';
import 'package:restobook_web/model/service/http_auth_service.dart';
import 'package:restobook_web/view/login_screen.dart';
import 'package:restobook_web/view/restaurants_overview_screen.dart';
import 'package:restobook_web/view_model/application_view_model.dart';
import 'package:restobook_web/view_model/restaurant_view_model.dart';

import 'model/repository/abstract_employee_repository.dart';
import 'model/repository/http_restaurant_repository.dart';
import 'model/repository/mock_backend.dart';
import 'package:provider/provider.dart';

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
      HttpEmployeeRepository());
  GetIt.I.registerSingleton<AbstractRestaurantRepository>(
      HttpRestaurantRepository());
  GetIt.I.registerSingleton<AbstractAuthService>(HttpAuthService());

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => RestaurantViewModel()),
    ChangeNotifierProvider(create: (context) => ApplicationViewModel())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> initiatingApplicationViewModel;

  @override
  void initState() {
    super.initState();
    initiatingApplicationViewModel = Provider.of<ApplicationViewModel>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: initiatingApplicationViewModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Widget startScreen;
          if (context.read<ApplicationViewModel>().authorized) {
            startScreen = const RestaurantsOverviewScreen();
          } else {
            startScreen = const LoginScreen();
          }

          return startScreen;
        },
      ),
    );
  }
}
