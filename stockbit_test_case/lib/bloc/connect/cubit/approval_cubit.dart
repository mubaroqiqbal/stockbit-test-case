import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:stockbit_test_case/model/session_request_data.dart';

part '../state/approval_state.dart';

class ApprovalCubit extends Cubit<ApprovalState> {
  final _methodChannel = const MethodChannel("com.stockbit.testcase/methods");

  ApprovalCubit() : super(const ApprovalInitial());

  Future<void> approveProposal(SessionRequestData data) async {
    emit(const ApprovalLoading());
    print("data.toJson()");
    print(data.toJson());

    _methodChannel.invokeMethod("approve", data.toJson()).onError((error, stackTrace) {
      if (error.runtimeType == PlatformException) {
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
      } else {
        print("errorMsg");
        print(error);
      }
    });

    emit(const ApproveSuccess());
  }

  Future<void> rejectProposal(SessionRequestData data) async {
    emit(const ApprovalLoading());

    _methodChannel.invokeMethod("reject", data.toJson()).onError((error, stackTrace) {
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

    Get.snackbar(
      "Success",
      "Rejecting session success",
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.lightGreen,
      margin: const EdgeInsets.all(16),
    );

    emit(const RejectSuccess());
  }

  Future<void> finish() async {
    emit(const ApprovalInitial());
  }
}
