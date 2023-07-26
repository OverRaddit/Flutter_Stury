import 'package:calendar_scheduler2/component/main_calendar.dart';
import 'package:calendar_scheduler2/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler2/component/schedule_card.dart';
import 'package:calendar_scheduler2/component/today_banner.dart';
import 'package:calendar_scheduler2/const/colors.dart';
import 'package:calendar_scheduler2/provider/schedule_provider.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler2/database/drift_database.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final selectedDate = provider.selectedDate;
    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
            ),
            isScrollControlled: true,
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalender(
              selectedDate: selectedDate,
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
            ),
            const SizedBox(height: 8.0),
            StreamBuilder(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: schedules.length,
                );
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  return Dismissible(
                    key: ObjectKey(schedule.id), // globalkey랑 차이?
                    direction: DismissDirection.startToEnd,
                    onDismissed: ((DismissDirection direction) {
                      provider.deleteSchedule(
                          date: selectedDate, id: schedule.id);
                    }),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                      child: ScheduleCard(
                        startTime: schedule.startTime,
                        endTime: schedule.endTime,
                        content: schedule.content,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(
      DateTime selectedDate, DateTime focusedDate, BuildContext context) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(date: selectedDate);
    provider.getSchedules(date: selectedDate);
  }
}
