import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';

class AppNavigation {
  static navigationPush(BuildContext context, Widget screenName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => screenName), // Navigate to home screen
    );
  }
  static navigationReplacement(BuildContext context, Widget screenName) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => screenName), // Navigate to home screen
    );
  }
   static pushAndRemoveUntil(BuildContext context, Widget screenName) {
    Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => screenName), (route) => false // Navigate to home screen
    );
  }
}
