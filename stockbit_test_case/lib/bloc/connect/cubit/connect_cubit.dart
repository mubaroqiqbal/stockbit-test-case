import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part '../state/connect_state.dart';

class ConnectCubit extends Cubit<ConnectState> {
  final _methodChannel = const MethodChannel("com.stockbit.testcase/methods");

  ConnectCubit() : super(const ConnectInitial());

  Future<void> startPairing(String uri, BuildContext context) async {
    emit(const ConnectLoading());

    _methodChannel.invokeMethod("pair", uri).onError((error, stackTrace) {
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

    emit(const ConnectSuccess());
  }

  Future<void> finish() async {
    emit(const ConnectInitial());
  }
}
