import 'package:calendar_scheduler2/model/schedule_model.dart';
import 'package:calendar_scheduler2/repository/schedule_repository,.dart';
import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository repository;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Map<DateTime, List<ScheduleModel>> cache = {};

  // constructor
  ScheduleProvider({
    required this.repository,
  }) {
    repository.getSchedules(date: selectedDate);
  }

  void getSchedules({
    required DateTime date,
  }) async {
    final resp = await repository.getSchedules(date: date);

    // cache라는 map에 date라는 key가 존재유무에 따라 2번인자, 3번인자에 해당하는 함수를 실행함.
    cache.update(date, (value) => resp, ifAbsent: () => resp);

    // 리스너들은 언제부터 등록되는거지?
    // 현재 클래스를 watch()하는 모든 위젯들의 build()함수를 다시 실행한다.
    notifyListeners();
  }

  void createSchedule({
    required ScheduleModel schedule,
  }) async {
    final targetDate = schedule.date;
    final savedSchedule = await repository.createSchedule(schedule: schedule);

    cache.update(
        targetDate,
        (value) => [
              ...value,
              // ?????
              schedule.copyWith(
                id: savedSchedule,
              ),
            ]..sort((a, b) => a.startTime.compareTo(
                b.startTime)), // ..은 캐스케이드 표기법임. 객체의 메소드를 호출한다음 해당 객체를 반환함.
        ifAbsent: () => [schedule]);

    notifyListeners();
  }

  void deleteSchedule({
    required DateTime date,
    required String id,
  }) async {
    final resp = await repository.deleteSchedule(id: id);

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    notifyListeners();
  }

  // 아직 왜 필요한지 잘 모르겠음. notifyListeners를 왜쓰는지?
  void changeSelectedDate({
    required DateTime date,
  }) {
    selectedDate = date;
    notifyListeners();
  }
}
