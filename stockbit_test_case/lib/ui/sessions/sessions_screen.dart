import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockbit_test_case/bloc/sessions/cubit/sessions_cubit.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final _sessionsCubit = SessionsCubit();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sessionsCubit.getListSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session"),
      ),
      body: SafeArea(
        child: BlocBuilder(
          bloc: _sessionsCubit,
          builder: (BuildContext context, SessionsState state) {
            if (state is GetSessionsSuccess) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
                      child: ListView.builder(
                          itemCount: state.listSessions.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Image.network(state.listSessions[index].metaData!.icons.first),
                                title: Text(state.listSessions[index].metaData!.name),
                                subtitle: Text(state.listSessions[index].metaData!.url),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
