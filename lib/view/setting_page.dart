import 'package:auto_route/auto_route.dart';
import 'package:get_emg_data/provider/model_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_emg_data/component/app_scaffold.dart';
import 'package:get_emg_data/component/app_button.dart';
import 'package:get_emg_data/foundation/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_emg_data/data/model/user.dart';
import 'package:get_emg_data/data/model/setting.dart';
import 'package:get_emg_data/util/logger.dart';

class SettingPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cntImpStable = useState(ref
        .watch(settingProvider.select((value) => value.setting.cntImpStable)));
    final bestBreathTotal = useState(ref.watch(
        settingProvider.select((value) => value.setting.bestBreathTotal)));
    final cntImpStableController = useTextEditingController(
        text:
            "${ref.watch(settingProvider.select((value) => value.setting.cntImpStable))}");
    final bestBreathTotalController = useTextEditingController(
        text:
            "${ref.watch(settingProvider.select((value) => value.setting.bestBreathTotal))}");
    //final bestBreathInController =
    //    useTextEditingController(text: "${bestBreathIn.value}");
    //final bestBreathExController =
    //    useTextEditingController(text: "${bestBreathEx.value}");
    //final cntImpStable = useState(Setting.defaultCntImpStable);
    double w = 400;
    User? user = ref.watch(userProvider.select((value) => value.user));
    Setting setting =
        ref.watch(settingProvider.select((value) => value.setting));

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AppScaffold(
            appBar: AppBar(
              title: const Text(""),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                  const SizedBox(
                    height: 80,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 50),
                      child: Text(
                        '設定',
                        style: AppText.h4,
                      )),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      "ユーザーネーム:                       ${user?.name}",
                      style: AppText.body16,
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      "アプリVersion:                         ${setting.appVersion}",
                      style: AppText.body16,
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      "ファームウェアVersion:               ${setting.firmwareVersion} ",
                      style: AppText.body16,
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      "インピ安定回数",
                      style: AppText.body16,
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    Flexible(
                        child: TextField(
                      controller: cntImpStableController,
                      enabled: true,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (e) {
                        logger.i(cntImpStable.value);
                        if (e == "") {
                          cntImpStable.value = 0;
                        } else {
                          cntImpStable.value = int.parse(e);
                        }
                      },
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      "呼吸時間",
                      style: AppText.body16,
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    Flexible(
                        child: TextField(
                      controller: bestBreathTotalController,
                      enabled: true,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (e) {
                        logger.i(bestBreathTotal.value);
                        logger.i(e);
                        if (e == "") {
                          bestBreathTotal.value = 0.0;
                        } else {
                          bestBreathTotal.value = double.parse(e);
                        }
                      },
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  //Row(
                  //    mainAxisAlignment: MainAxisAlignment.start,
                  //    children: [
                  //      const SizedBox(
                  //        width: 40,
                  //      ),
                  //      Text(
                  //        "吸気時間",
                  //        style: AppText.body16,
                  //      ),
                  //      const SizedBox(
                  //        width: 60,
                  //      ),
                  //      Flexible(
                  //          child: TextField(
                  //        controller: bestBreathInController,
                  //        enabled: true,
                  //        decoration: const InputDecoration(
                  //          fillColor: Colors.white,
                  //          filled: true,
                  //          border: OutlineInputBorder(),
                  //        ),
                  //        onChanged: (e) {
                  //          if (e == "") {
                  //            bestBreathIn.value = 0.0;
                  //          } else {
                  //            bestBreathIn.value = double.parse(e);
                  //          }
                  //        },
                  //      )),
                  //      const SizedBox(
                  //        width: 20,
                  //      ),
                  //    ]),
                  //const SizedBox(
                  //  height: 20,
                  //),
                  //Row(
                  //    mainAxisAlignment: MainAxisAlignment.start,
                  //    children: [
                  //      const SizedBox(
                  //        width: 40,
                  //      ),
                  //      Text(
                  //        "呼気時間",
                  //        style: AppText.body16,
                  //      ),
                  //      const SizedBox(
                  //        width: 60,
                  //      ),
                  //      Flexible(
                  //          child: TextField(
                  //        controller: bestBreathExController,
                  //        enabled: true,
                  //        decoration: const InputDecoration(
                  //          fillColor: Colors.white,
                  //          filled: true,
                  //          border: OutlineInputBorder(),
                  //        ),
                  //        onChanged: (e) {
                  //          if (e == "") {
                  //            bestBreathEx.value = 0.0;
                  //          } else {
                  //            bestBreathEx.value = double.parse(e);
                  //          }
                  //        },
                  //      )),
                  //      const SizedBox(
                  //        width: 20,
                  //      ),
                  //    ]),
                ]))));
  }
}
