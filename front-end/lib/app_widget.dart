import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste/app/routes/app_routes.dart';
import 'package:teste/app/views/pass_request_page.dart';
import 'package:teste/app/views/profile_page.dart';
import 'package:teste/app/views/register_page.dart';
import 'package:teste/app_controller.dart';
import 'package:teste/app/views/help_page.dart';
import 'package:teste/app/views/home_page.dart';
import 'package:teste/app/views/login_page.dart';
import 'package:teste/provider/users.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => Users()),
          ],
          child: MaterialApp(
            theme: ThemeData(
                //alterar essa parte para mudar a cor caso o modo noturno esteja ativado
                primarySwatch: Colors.blue,
                //ternario
                brightness: AppController.instance.isDarkTheme
                    ? Brightness.dark
                    : Brightness.light),
            initialRoute: '/',
            routes: {
              AppRoutes.LOGIN: (_) => LoginPage(),
              AppRoutes.HOME: (_) => HomePage(),
              AppRoutes.PASS_REQUEST: (_) => PassRequestPage(),
              AppRoutes.PROFILE: (_) => ProfilePage(),
              AppRoutes.HELP: (_) => HelpPage(),
              AppRoutes.REGISTER: (_) => RegisterPage(),
            },
          ),
        );
      },
    );
  }
}
