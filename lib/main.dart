import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/provider/auth_provider.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/provider/chat_provider.dart';
import 'package:yuva_ride/provider/ride_share_provider.dart';
import 'package:yuva_ride/utils/theme.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/chat_screen_new.dart';
import 'package:yuva_ride/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

double screenHeight = 0;
double screenWidth = 0;

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookRideProvider()),
        ChangeNotifierProvider(create: (_) => ColorNotifier()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => RideSharingProvider()),
      ],
      child: MaterialApp(
          theme: RAppTheme.lightTheme,
          darkTheme: RAppTheme.darkTheme,
          themeMode: ThemeMode.system,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Yuva Ride User',
          home: const SplashScreen()),
    );
  }
}
