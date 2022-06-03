part of '../cubit/approval_cubit.dart';

abstract class ApprovalState {
  const ApprovalState();
}

class ApprovalInitial extends ApprovalState {
  const ApprovalInitial();
}

class ApprovalLoading extends ApprovalState {
  const ApprovalLoading();
}

class ApproveSuccess extends ApprovalState {
  const ApproveSuccess();
}

class RejectSuccess extends ApprovalState {
  const RejectSuccess();
}

class ApprovalError extends ApprovalState {
  final String message;
  const ApprovalError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApprovalError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
