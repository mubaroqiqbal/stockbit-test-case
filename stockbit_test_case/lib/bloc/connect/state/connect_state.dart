part of '../cubit/connect_cubit.dart';

abstract class ConnectState {
  const ConnectState();
}

class ConnectInitial extends ConnectState {
  const ConnectInitial();
}

class ConnectLoading extends ConnectState {
  const ConnectLoading();
}

class ConnectSuccess extends ConnectState {
  const ConnectSuccess();
}

class ConnectError extends ConnectState {
  final String message;
  const ConnectError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConnectError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
