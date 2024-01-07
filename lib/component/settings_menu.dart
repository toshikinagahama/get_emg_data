import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_emg_data/foundation/app_color.dart';
import 'package:get_emg_data/foundation/app_text_theme.dart';
import 'package:get_emg_data/component/app_scaffold.dart';
import 'package:get_emg_data/provider/database_provider.dart';
import 'package:get_emg_data/foundation/database_const.dart';
import 'package:get_emg_data/component/settings_menu_item.dart';
import "package:get_emg_data/provider/model_providers.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsMenu extends ConsumerWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.read(userProvider.select((value) => value.user));
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AppScaffold(
            appBar: AppBar(
              elevation: 0.0,
              centerTitle: false,
              title: Text(
                'username: ${user?.name}',
                style: AppText.title.bold(),
                textAlign: TextAlign.left,
              ),
              automaticallyImplyLeading: false,
            ),
            body: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          height: 16.0,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColor.white10),
                            ),
                          ),
                        ),
                        SettingMenuItem(
                          title: '設定',
                          onTap: () => {context.router.pushNamed("/setting")},
                        ),
                        Container(
                          height: 16.0,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColor.white10),
                            ),
                          ),
                        ),
                        SettingMenuItem(
                          title: 'ログアウト',
                          onTap: () {
                            ref.read(databaseProvider).update(
                                "m_system_param",
                                {DatabaseConst.system.value: ""},
                                "${DatabaseConst.system.name}='${DatabaseConst.system.accessToken}'");
                            ref.read(userProvider.notifier).signOut();
                            context.router.popUntilRoot();
                          },
                        ),
                        SettingMenuItem(
                          title: 'ヘルプ',
                          onTap: () => {},
                        ),
                        SettingMenuItem(
                          title: 'コピーライト',
                          onTap: () => {},
                        ),
                        SettingMenuItem(
                          title: '利用規約',
                          onTap: () => {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
