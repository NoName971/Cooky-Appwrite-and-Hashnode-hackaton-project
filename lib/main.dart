import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/error_view.dart';
import 'package:hackaton_v1/common/loading_view.dart';
import 'package:hackaton_v1/common/logo_widget.dart';
import 'package:hackaton_v1/controllers/auth_controller.dart';
import 'package:hackaton_v1/features/auth/views/login_view.dart';
import 'package:hackaton_v1/features/home/views/home_view.dart';
import 'package:hackaton_v1/models/user_model.dart';
import 'package:hackaton_v1/services/dark_mode_service.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final globalCurrentUserProvider = StateProvider(
  (ref) => UserModel(email: '', name: '', uid: ''),
);

Future main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    const ProviderScope(
      child: Hackaton(),
    ),
  );
}

final logger = Logger();

class Hackaton extends ConsumerWidget {
  const Hackaton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(currentAccountProvider);
    final isDarkMode = ref.watch(darkModeProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: FlexSystemNavBarStyle.transparent,
        useDivider: false,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: FlexThemeData.light(
          useMaterial3: true,
          scheme: FlexScheme.mandyRed,
          fontFamily: 'DMSans',
        ),
        darkTheme: FlexThemeData.dark(
          useMaterial3: true,
          scheme: FlexScheme.mandyRed,
          fontFamily: 'DMSans',
        ),
        home: future.when(
          data: (user) {
            if (user != null) {
              return const HomeView();
            }
            return const LoginView();
          },
          error: (error, stackTrace) {
            if (error is AppwriteException && error.code == 401) {
              return const LoginView();
            }
            return ErrorView(
              provider: authControllerProvider,
            );
          },
          loading: () => const LoadingView(
            logo: LogoLargeWidget(),
          ),
        ),
      ),
    );
  }
}
