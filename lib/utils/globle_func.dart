import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void showCustomToast({
  required String title,
  ToastGravity gravity = ToastGravity.BOTTOM,
  Toast toastLength = Toast.LENGTH_SHORT,
  Color backgroundColor = Colors.black54,
  Color textColor = Colors.white,
  double fontSize = 16.0,
}) {
  Fluttertoast.showToast(
    msg: title,
    toastLength: toastLength,
    gravity: gravity,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

pop(context) {
  Navigator.pop(context);
}



bool getDataEmptyOrNot(var finalRes) {
  if (finalRes['data'] == null || finalRes['data'].isEmpty) {
    return true;
  }
  return false;
}

// bool successStatus = (201 || 201);
isSuccess(int statusCode) {
  print('status code ++++++ $statusCode');
  if (statusCode == 201 || statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

isFailed(int statusCode) {
  print('status code ++++++ $statusCode');
  if (statusCode == 404) {
    return true;
  } else {
    return false;
  }
}

String formatData(dynamic data) {
  if (data == null) {
    return ''; // Return empty string if data is null
  } else if (data is String) {
    return data; // Return string if data is already a string
  } else if (data is double || data is int) {
    return data.toString(); // Convert double/int to string
  } else {
    return ''; // Return empty string for any other type
  }
}

String stringData(dynamic data) {
  if (data == null) {
    return ''; // Return empty string if data is null
  } else if (data is String) {
    return data; // Return string if data is already a string
  } else if (data is double || data is int) {
    return data.toString(); // Convert double/int to string
  } else {
    return ''; // Return empty string for any other type
  }
}

int intData(dynamic value) {
  try {
    // Check if the value is already an integer
    if (value is int) {
      return value;
    } else if (value is String) {
      // Try parsing the string to an integer
      return int.parse(value);
    } else if (value is double) {
      // Convert the double to an integer (using truncation)
      return value.toInt();
    } else {
      // If the value is of an unsupported type, throw an error
      throw FormatException("Cannot convert value to integer: $value");
    }
  } catch (e) {
    // Catch any errors that might occur during conversion
    print("Error: Failed to convert value to integer. Error details: $e");
    return 0; // Return 0 (or another default value) if conversion fails
  }
}

double doubleData(dynamic value) {
  try {
    // Check if the value is already a double
    if (value is double) {
      return value;
    } else if (value is String) {
      // Try parsing the string to a double
      return double.parse(value);
    } else if (value is int) {
      // Convert the integer to a double
      return value.toDouble();
    } else {
      // If the value is of an unsupported type, throw an error
      throw FormatException("Cannot convert value to double: $value");
    }
  } catch (e) {
    // Catch any errors that might occur during conversion
    print("Error: Failed to convert value to double. Error details: $e");
    return 0.0; // Return 0.0 (or another default value) if conversion fails
  }
}

bool boolData(dynamic value) {
  try {
    if (value is bool) {
      return value;
    } else if (value is String) {
      String lowerValue = value.toLowerCase();
      if (lowerValue == 'true') {
        return true;
      } else if (lowerValue == 'false') {
        return false;
      } else {
        throw FormatException("Cannot convert value to bool: $value");
      }
    } else if (value is int) {
      if (value == 1) {
        return true;
      } else if (value == 0) {
        return false;
      } else {
        throw FormatException("Cannot convert value to bool: $value");
      }
    } else {
      throw FormatException("Cannot convert value to bool: $value");
    }
  } catch (e) {
    print("Error: Failed to convert value to bool. Error details: $e");
    return false;
  }
}

bool hasNoData(data) {
  print('-------${data.runtimeType}----${data}-------');
  return (data == null || data.isEmpty);
}

String formatDate(String dateString) {
  if (dateString.isEmpty) {
    return '';
  }
  // Parsing the input date string
  DateTime dateTime = DateTime.parse(dateString);

  // Formatting to desired output format (e.g., April 20 2024)
  String formattedDate = DateFormat('MMMM dd yyyy').format(dateTime);

  return formattedDate;
}

 

String formatDate2(String isoDate) {
  final dateTime = DateTime.parse(isoDate).toLocal();
  return DateFormat('d MMMM yyyy').format(dateTime);
}
