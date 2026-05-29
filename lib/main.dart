import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'core/providers/audio_provider.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  // We don't necessarily need to open the themeBox here because ThemeProvider does it, 
  // but it's good to ensure it's available synchronously if needed, or wait for ThemeProvider.
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: const EidMagicApp(),
    ),
  );
}

class EidMagicApp extends StatelessWidget {
  const EidMagicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Eid Magic',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
