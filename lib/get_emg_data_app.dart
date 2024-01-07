import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get_emg_data/foundation/app_text_theme.dart';
import 'package:get_emg_data/route/app_route.gr.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_emg_data/provider/database_provider.dart';

class GetBreathDataApp extends HookConsumerWidget {
  GetBreathDataApp({Key? key}) : super(key: key);

  final Future<void> _init =
      Future<void>.delayed(const Duration(milliseconds: 1), () => {});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = useMemoized(() => AppRouter());

    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        return MaterialApp.router(
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.transparent,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                titleTextStyle: AppText.title,
              ),
              //textTheme: GoogleFonts.yujiBokuTextTheme()
              textTheme: GoogleFonts.notoSansTextTheme()
              //GoogleFonts.notoSansTextTheme(ThemeData.light().textTheme)
              //    .copyWith(),
              ),
          routeInformationParser: appRouter.defaultRouteParser(),
          routerDelegate: appRouter.delegate(),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale("ja"),
          ],
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
