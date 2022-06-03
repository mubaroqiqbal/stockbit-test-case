import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:stockbit_test_case/bloc/connect/cubit/approval_cubit.dart';
import 'package:stockbit_test_case/model/session_request_data.dart';
import 'package:stockbit_test_case/ui/home.dart';

class ProposalSessionScreen extends StatefulWidget {
  final SessionRequestData proposalRequestData;

  const ProposalSessionScreen({Key? key, required this.proposalRequestData}) : super(key: key);

  @override
  State<ProposalSessionScreen> createState() => _ProposalSessionScreenState();
}

class _ProposalSessionScreenState extends State<ProposalSessionScreen> {
  final approvalCubit = ApprovalCubit();

  static const _eventChannel = EventChannel("com.stockbit.testcase/wallet");

  late StreamSubscription _walletSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listen();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _walletSubscription.cancel();
  }

  listen() async {
    _walletSubscription = _eventChannel.receiveBroadcastStream().listen((event) {
      print("event");
      print(event);

      switch (event['eventName']) {
        case 'onSessionRequest':
          // handler!.onSessionRequest(params['id'], params['data']);
          break;
        case 'onSessionProposal':

          // handler!.onSessionDisconnect(params);
          break;
        case 'onSessionDelete':
          // handler!.onCallRequestPersonalSign(params['id'], params['rawJson']);

          break;
        case 'onSessionSettleResponse':
          // handler!.onCallRequestEthSign(params['id'], params['rawJson']);
          break;
        case 'onSessionUpdateResponse':
          // handler!.onCallRequestEthSignTypedData(params['id'], params['rawJson']);

          break;
        case 'onConnectionStateChange':
          // handler!.onCallRequestEthSendTransaction(params['id'], params['rawJson']);

          break;
        case 'onError':
          // handler!.onError(params);
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (route) => false,
          );

          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
                (route) => false,
              ),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text(
              "Session Proposal",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          body: BlocBuilder(
            bloc: approvalCubit,
            builder: (BuildContext context, ApprovalState state) {
              if (state is ApprovalLoading) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 100),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is ApproveSuccess || state is RejectSuccess) {
                Future.delayed(
                  const Duration(seconds: 1),
                  () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                    (route) => false,
                  ),
                );
              }

              return SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            leading: Image.network(widget.proposalRequestData.icons.first),
                            title: Text(widget.proposalRequestData.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(widget.proposalRequestData.url),
                          ),
                          const Divider(color: Colors.black, thickness: 0.5),
                          const SizedBox(height: 16),
                          Container(
                            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                            child: ListView.builder(
                              itemCount: widget.proposalRequestData.requiredNamespaces.keys.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> map = widget.proposalRequestData.requiredNamespaces.values.toList()[index] as Map<String, dynamic>;

                                String methods = json.encode(map["methods"]).replaceAll("[", "").replaceAll("]", "").replaceAll('"', "").replaceAll(",", ", ");
                                String events = json.encode(map["events"]).replaceAll("[", "").replaceAll("]", "").replaceAll('"', "").replaceAll(",", ", ");

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Review " + widget.proposalRequestData.requiredNamespaces.keys.toList()[index] + " permissions",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Card(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Methods", style: TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 8),
                                            Text(methods),
                                            const SizedBox(height: 16),
                                            const Text("Events", style: TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 8),
                                            Text(events),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                          const Divider(),
                          ElevatedButton(
                              onPressed: () {
                                approvalCubit.approveProposal(widget.proposalRequestData);
                              },
                              child: const Text("Approve")),
                          ElevatedButton(
                              onPressed: () {
                                approvalCubit.rejectProposal(widget.proposalRequestData);
                              },
                              child: const Text("Reject")),
                        ],
                      ),
                    )),
              );
            },
          ),
        ),
      ),
    );
  }
}
