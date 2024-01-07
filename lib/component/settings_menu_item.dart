import 'package:flutter/material.dart';
import 'package:get_emg_data/foundation/app_color.dart';
import 'package:get_emg_data/foundation/app_text_theme.dart';

class SettingMenuItem extends StatefulWidget {
  final String title;
  final GestureTapCallback onTap;

  const SettingMenuItem({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  _SettingMenuItemState createState() => _SettingMenuItemState();
}

class _SettingMenuItemState extends State<SettingMenuItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.white10),
        ),
      ),
      child: ListTile(
        tileColor: AppColor.primary,
        title: Text(
          widget.title,
          style: AppText.body14,
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
