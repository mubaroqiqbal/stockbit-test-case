import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:stockbit_test_case/bloc/connect/cubit/connect_cubit.dart';
import 'package:stockbit_test_case/model/session_request_data.dart';
import 'package:stockbit_test_case/ui/base/dotted_border.dart';
import 'package:stockbit_test_case/ui/connect/proposal_session_screen.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({Key? key}) : super(key: key);

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final pairingCubit = ConnectCubit();
  final TextEditingController _uriController = TextEditingController();
  static const _eventChannel = EventChannel("com.stockbit.testcase/wallet");

  late StreamSubscription _walletSubscription;

  SessionRequestData? _proposalRequestData;

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
          _proposalRequestData = SessionRequestData.fromJson(json.decode(event['params'] ?? {}));

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProposalSessionScreen(
                        proposalRequestData: _proposalRequestData!,
                      )));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet Connect"),
      ),
      body: BlocBuilder(
        bloc: pairingCubit,
        builder: (BuildContext context, ConnectState state) {
          if (state is ConnectLoading) {
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

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DottedBorder(
                      dashPattern: const [4, 3],
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      strokeWidth: 1.5,
                      child: Column(
                        children: [
                          const Center(
                            child: Icon(
                              Icons.qr_code,
                              size: 100,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                              onPressed: () async {
                                var result = await BarcodeScanner.scan();

                                pairingCubit.startPairing(result.rawContent, context);
                              },
                              child: Text("Scan QR Code".toUpperCase()))
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text("or use walletconnect uri"),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextField(
                              controller: _uriController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "wc:...",
                              ),
                            ),
                          ),
                        ),
                        IntrinsicHeight(
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_uriController.text.isNotEmpty) {
                                  pairingCubit.startPairing(_uriController.text, context);
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Kolom tidak boleh kosong",
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.redAccent,
                                    margin: const EdgeInsets.all(16),
                                  );
                                }
                              },
                              child: Text("Connect".toUpperCase())),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
