import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:stockbit_test_case/model/settle_session_data.dart';

part '../state/sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final _methodChannel = const MethodChannel("com.stockbit.testcase/methods");

  SessionsCubit() : super(const SessionsInitial());

  Future<void> getListSessions() async {
    emit(const SessionsLoading());

    dynamic sessions = await _methodChannel.invokeMethod("getListOfSettledSessions").onError((error, stackTrace) {
      final errorMsg = error as PlatformException;
      print("errorMsg");
      print(errorMsg.message);

      Get.snackbar(
        "Error",
        errorMsg.message ?? "",
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        margin: const EdgeInsets.all(16),
      );
    });

    final List<SettleSessionData> result = [];

    json.decode(sessions).map((dynamic i) {
      result.add(SettleSessionData.fromJson(i as Map<String, dynamic>));
    }).toList();

    emit(GetSessionsSuccess(result));
  }

  Future<void> finish() async {
    emit(const SessionsInitial());
  }
}
