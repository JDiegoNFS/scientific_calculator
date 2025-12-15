import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/calculator_provider.dart';
import 'providers/history_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/matrix_provider.dart';
import 'providers/graph_provider.dart';
import 'providers/unit_provider.dart';
import 'providers/settings_provider.dart';
import 'services/data_persistence_service.dart';
import 'screens/calculator_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final persistenceService = DataPersistenceService();
  await persistenceService.init();

  runApp(MyApp(persistenceService: persistenceService));
}

class MyApp extends StatelessWidget {
  final DataPersistenceService persistenceService;

  const MyApp({super.key, required this.persistenceService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider(persistenceService)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(persistenceService)),
        ChangeNotifierProvider(create: (_) => MatrixProvider()),
        ChangeNotifierProvider(create: (_) => GraphProvider()),
        ChangeNotifierProvider(create: (_) => GraphProvider()),
        ChangeNotifierProvider(create: (_) => UnitProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider(persistenceService)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Scientific Stats Calculator',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const CalculatorScreen(),
          );
        },
      ),
    );
  }
}
