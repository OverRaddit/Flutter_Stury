import 'package:calendar_scheduler2/provider/schedule_provider.dart';
import 'package:calendar_scheduler2/repository/schedule_repository,.dart';
import 'package:calendar_scheduler2/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_scheduler2/database/drift_database.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();
  // 의존성 주입 + 프로젝트 전역에서 사용가능
  GetIt.I.registerSingleton<LocalDatabase>(database);

  // init provider
  final repository = ScheduleRepository();
  final scheduleProvider = ScheduleProvider(repository: repository);

  runApp(ChangeNotifierProvider(
    create: (_) => scheduleProvider,
    child: const MaterialApp(
      home: HomeScreen(),
    ),
  ));
}
