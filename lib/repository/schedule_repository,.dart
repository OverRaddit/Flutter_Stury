import 'dart:io';

import 'package:calendar_scheduler2/model/schedule_model.dart';
import 'package:dio/dio.dart';

class ScheduleRepository {
  final _dio = Dio();
  // 🍟 Platform을 활용해 각 플랫폼별 코드를 작성할 수 있다.
  final _targetUrl =
      'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule';

  Future<List<ScheduleModel>> getSchedules({
    required DateTime date,
  }) async {
    final resp = await _dio.get(
      _targetUrl,
      queryParameters: {
        'date':
            '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      },
    );

    return resp.data
        .map<ScheduleModel>((x) => ScheduleModel.fromJson(json: x))
        .toList();
  }

  Future<String> createSchedule({
    required ScheduleModel schedule,
  }) async {
    final json = schedule.toJson();
    final resp = await _dio.post(
      _targetUrl,
      data: json,
    );

    return resp.data?['id'];
  }

  Future<String> deleteSchedule({
    required String id,
  }) async {
    //final json = schedule.toJson();
    final resp = await _dio.delete(
      _targetUrl,
      data: {'id': id},
    );

    return resp.data?['id'];
  }
}

/*
트위터
https://twitter.com
  /intent
  /tweet
    ?url=https%3A%2F%2Fkr.vonvon.me%2FPO93V&text=%5B%ED%96%A5%EC%88%98+%ED%85%8C%EC%8A%A4%ED%8A%B8%5D+%EB%82%98%EB%8A%94+%EC%96%B4%EB%96%A4+%ED%96%A5%EC%88%98+%EB%B8%8C%EB%9E%9C%EB%93%9C%EC%9D%BC%EA%B9%8C%3F%0A%EC%A7%84%EB%93%9D%ED%95%9C+%EC%99%B8%EA%B3%A8%EC%88%98+%E2%80%98%EB%94%A5%ED%8B%B0%ED%81%AC%E2%80%99%0A%23%ED%96%A5%EC%88%98%ED%85%8C%EC%8A%A4%ED%8A%B8+%23vonvon_kr&hashtags=vonvon_kr+%23%ED%96%A5%EC%88%98%ED%85%8C%EC%8A%A4%ED%8A%B8%EB%82%98%EB%8A%94%EC%96%B4%EB%96%A4%ED%96%A5%EC%88%98%EB%B8%8C%EB%9E%9C%EB%93%9C%EC%9D%BC%EA%B9%8C&related=None

페이스북
https://www.facebook.com
  /sharer
  /sharer.php
    ?u=https%3A%2F%2Fvonvon.co.kr%2Fquiz%2F69&_rdr

카카오톡
https://accounts.kakao.com/login/
  ?continue=
    https://sharer.kakao.com/picker/link?app_key=3d6dc97b2c1e099162059c4ddd7e2d7e&short_key=061254c2-9037-4bb3-a711-a177fca7a043#login
*/
