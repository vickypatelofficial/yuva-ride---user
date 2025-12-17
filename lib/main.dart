import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/controller/auth_provider.dart';
import 'package:yuva_ride/controller/book_ride_provider.dart';
import 'package:yuva_ride/controller/home_provider.dart';
import 'package:yuva_ride/utils/theme.dart';
import 'package:yuva_ride/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

double screenHeight = 0;
double screenWidth = 0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => BookRideProvider()),
      ],
      child: MaterialApp(
          theme: RAppTheme.lightTheme,
          darkTheme: RAppTheme.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          title: 'Yuva Ride User',
          home: const SplashScreen()),
    );
  }
}
