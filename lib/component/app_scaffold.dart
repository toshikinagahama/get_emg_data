import 'package:flutter/material.dart';
import 'package:get_emg_data/component/settings_menu.dart';
import 'package:get_emg_data/foundation/app_color.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
    this.appBar,
    this.body,
    //this.onDrawerChanged,
    //this.onWillPop,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget? body;
  //final void Function(bool)? onDrawerChanged;
  //final Future<bool> Function()? onWillPop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColor.bgGradation,
          ),
          child: body),
      drawer: SettingsMenu(),
      drawerScrimColor: AppColor.black80,
      //onDrawerChanged: onDrawerChanged,
    );
  }
}
