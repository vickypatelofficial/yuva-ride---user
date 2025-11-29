import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yuva_ride/utils/app_colors.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor = AppColors.white, 
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.statusBarBrightnessLight,
    this.statusBarColor,
    this.isSafeArea, this.scaffoldKey,
  });

  final Widget body;

  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool? resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool? statusBarBrightnessLight;
  final Color? statusBarColor;
  final bool? isSafeArea;
  final Key? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor??AppColors.primaryColor,
        statusBarIconBrightness: (statusBarBrightnessLight ?? true)
            ? Brightness.light
            : Brightness.dark,
      ), 
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
          persistentFooterButtons: persistentFooterButtons,
          bottomNavigationBar: bottomNavigationBar,
          drawer: drawer,
          endDrawer: endDrawer,
          backgroundColor: backgroundColor,
          drawerScrimColor: drawerScrimColor,
          drawerEdgeDragWidth: drawerEdgeDragWidth,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
        ),
      ),
    );
  }
}
