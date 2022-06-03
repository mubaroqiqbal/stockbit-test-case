part of '../cubit/sessions_cubit.dart';

abstract class SessionsState {
  const SessionsState();
}

class SessionsInitial extends SessionsState {
  const SessionsInitial();
}

class SessionsLoading extends SessionsState {
  const SessionsLoading();
}

class GetSessionsSuccess extends SessionsState {
  final List<SettleSessionData> listSessions;

  const GetSessionsSuccess(this.listSessions);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetSessionsSuccess && other.listSessions == listSessions;
  }

  @override
  int get hashCode => listSessions.hashCode;
}

class GetSessionsError extends SessionsState {
  final String message;
  const GetSessionsError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetSessionsError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
