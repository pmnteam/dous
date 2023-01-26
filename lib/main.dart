import 'package:flutter/material.dart';
//
import 'package:provider/provider.dart';
//
import 'package:dous/routes/routes.dart';
import 'package:dous/services/user_service.dart';
import 'package:dous/services/dous_service.dart';

void main() {
  runApp(
    const DousApp(),
  );
}

class DousApp extends StatelessWidget {
  const DousApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => UserService()),
        ),
        ChangeNotifierProvider(
          create: ((context) => DousService()),
        ),
      ],
      child: MaterialApp(
        title: 'DoUs',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink.shade800,
            brightness: Brightness.dark,
            surface: Colors.pink.shade800,
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: RouteHandler.loginPage,
        onGenerateRoute: RouteHandler.generateRoute,
      ),
    );
  }
}
