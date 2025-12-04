uimport 'package:flutter/material.dart'; 
import 'package:yuva_ride/utils/theme.dart';
import 'package:yuva_ride/view/splash_screen.dart'; 

void main(){
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
    return   MaterialApp(
      theme: RAppTheme.lightTheme,
      darkTheme: RAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
        title: 'Yuva Ride User',4 
        home:const SplashScreen()
    );
  }
}