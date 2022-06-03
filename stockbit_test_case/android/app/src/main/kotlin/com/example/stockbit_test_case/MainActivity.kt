package com.example.stockbit_test_case

import android.R.attr.identifier
import android.content.Context
import android.util.Log
import com.google.gson.Gson
import com.walletconnect.walletconnectv2.*
import com.walletconnect.walletconnectv2.client.Sign
import com.walletconnect.walletconnectv2.client.SignClient
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity(), EventChannel.StreamHandler {
    private val METHOD_CHANNEL_NAME = "com.stockbit.testcase/methods"
    private val WALLET_CHANNEL_NAME = "com.stockbit.testcase/wallet"

    private val PROJECT_ID = "60bc3be8dff37bdc9897ddf5230ff9ec"
    private val WALLET_CONNECT_PROD_RELAY_URL = "relay.walletconnect.com"

    private var methodChannel : MethodChannel? = null
    private var walletChannel : EventChannel? = null
//    private var walletStreamHandler : StreamHandler? = null

    private var eventSink: EventChannel.EventSink? = null
    private var signInClient : SignClient = SignClient

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        setupChannel(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    private fun setupChannel(context: Context, messenger: BinaryMessenger){
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        walletChannel = EventChannel(messenger, WALLET_CHANNEL_NAME)

        // WALLET CONNECT

        val initString = Sign.Params.Init(
            application = this.application,
            relayServerUrl = "wss://$WALLET_CONNECT_PROD_RELAY_URL?projectId=$PROJECT_ID",   //TODO: register at https://walletconnect.com/register to get a project ID
            metadata = Sign.Model.AppMetaData(
                name = "Stockbit Test Case Wallet",
                description = "Wallet description",
                url = "stockbit.testcase.wallet",
                icons = listOf("https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media")
            )
        )

        signInClient.initialize(initString) { error ->
            android.util.Log.e("WalletManager", error.throwable.stackTraceToString())
        }

        methodChannel!!.setMethodCallHandler{ call, result->
            when (call.method) {
                "connect" -> {
                    connect(call, result)
                }
                "disconnect" -> {
                    disconnect(call, result)
                }
                "pair" -> {
                    pair(call, result)
                }
                "approve" -> {
                    approve(call, result)
                }
                "reject" -> {
                    reject(call, result)
                }
                "update" -> {
                    update(call, result)
                }
                "getListOfSettledPairings" -> {
                    getListOfSettledPairings(call, result)
                }
                "getListOfSettledSessions" -> {
                    getListOfSettledSessions(call, result)
                }
            }
        }

//        walletStreamHandler = StreamHandler()
        walletChannel!!.setStreamHandler(this)

    }

    private fun teardownChannels(){
        methodChannel!!.setMethodCallHandler(null)
        walletChannel!!.setStreamHandler(null)
    }

    override fun onDestroy() {
        teardownChannels()
        super.onDestroy()
    }

    private fun approve(call : MethodCall, result : MethodChannel.Result){
        try {
            val selectedAccounts: Map<EthChains, String> = mapOfAllAccounts[1] ?: throw Exception("Can't find account")
            val proposerData = Gson().fromJson(Gson().toJson(call.arguments), Sign.Model.SessionProposal::class.java)
            val sessionNamespaces: Map<String, Sign.Model.Namespace.Session> = selectedAccounts.filter { (chain: EthChains, _) ->
                "${chain.chainNamespace}:${chain.chainReference}" in proposerData.requiredNamespaces.values.flatMap { it.chains }
            }.toList().groupBy { (chain: EthChains, _: String) ->
                chain.chainNamespace
            }.map { (namespaceKey: String, chainData: List<Pair<EthChains, String>>) ->
                val accounts = chainData.map { (chain: EthChains, accountAddress: String) ->
                    "${chain.chainNamespace}:${chain.chainReference}:${accountAddress}"
                }
                val methods = proposerData.requiredNamespaces.values.flatMap { it.methods }
                val events = proposerData.requiredNamespaces.values.flatMap { it.events }

                namespaceKey to Sign.Model.Namespace.Session(accounts = accounts, methods = methods, events = events, extensions = null)
            }.toMap()

            val params = Sign.Params.Approve(proposerData.proposerPublicKey, sessionNamespaces, proposerData.relayData)
            signInClient.approveSession(params) { error ->
                run {
                    android.util.Log.e(tag(this), error.throwable.stackTraceToString())
                    result.error("400", error.throwable.message, error.throwable)
                }
            }
            result.success(true)
        } catch ( e : Throwable){
            result.error("400", e.message, e)
        }
    }

    private fun reject(call : MethodCall, result : MethodChannel.Result){
        try {
            val proposerData = Gson().fromJson(Gson().toJson(call.arguments), Sign.Model.SessionProposal::class.java)
            val rejectionReason = "Reject Session"
            val reject = Sign.Params.Reject(
                proposerPublicKey = proposerData.proposerPublicKey,
                reason = rejectionReason,
                code = 406
            )

            SignClient.rejectSession(reject) { error ->
                run {
                    android.util.Log.e(tag(this), error.throwable.stackTraceToString())
                    result.error("400", error.throwable.message, error.throwable)
                }
            }
            result.success(true)
        } catch ( e : Throwable){
            result.error("400", e.message, e)
        }
    }

    private fun pair(call : MethodCall, result : MethodChannel.Result){
        try {
            val uri = call.arguments as String
            val pair = Sign.Params.Pair(uri)

            SignClient.pair(pair) { error ->
                run {
                    android.util.Log.e(tag(this), error.throwable.stackTraceToString())
                    result.error("400", error.throwable.message, error.throwable)
                }
            }
        } catch ( e : Throwable){
            result.error("400", e.message, e)
        }
    }

    private fun connect(call : MethodCall, result : MethodChannel.Result){
        try {
//            val params = Sign.Params.Connect()
//            signInClient.connect(params)
        } catch ( e : Throwable){
            result.error("400", e.message, e)
        }
    }

    private fun disconnect(call : MethodCall, result : MethodChannel.Result){
        try {
//            val params = Sign.Params.Disconnect()
//            signInClient.disconnect(params) { error ->
//                run {
//                    android.util.Log.e(tag(this), error.throwable.stackTraceToString())
//                    result.error("400", error.throwable.message, error.throwable)
//                }
//            }
        } catch ( e : Throwable){
            result.error("400", e.message, e)
        }
    }

    private fun update(call : MethodCall, result : MethodChannel.Result){
        try {
//            val params = Sign.Params.Update()
//            signInClient.update(params) { error ->
//                run {
//                    android.util.Log.e(tag(this), error.throwable.stackTraceToString())
//                    result.error("400", error.throwable.message, error.throwable)
//                }
//            }

            result.success(true)
        } catch ( e : Throwable){
            result.error("400", e.message, e)
        }
    }

    private fun getListOfSettledPairings(call : MethodCall, result : MethodChannel.Result){
        try {
            result.success(Gson().toJson(signInClient.getListOfSettledPairings()))
        } catch ( e : Throwable){
            result.error("400", e.message, e)
        }
    }

    private fun getListOfSettledSessions(call : MethodCall, result : MethodChannel.Result){
        try {
            result.success(Gson().toJson(signInClient.getListOfSettledSessions()))
        } catch ( e : Throwable){
            result.error("400", e.message, e)
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events

        val walletDelegate = object : SignClient.WalletDelegate {

            override fun onSessionProposal(sessionProposal: Sign.Model.SessionProposal) {
                // Triggered when wallet receives the session proposal sent by a Dapp
                runOnUiThread {
                    val result: HashMap<String, Any> = HashMap()
                    result["eventName"] = "onSessionProposal"
                    result["params"] = Gson().toJson(sessionProposal)

                    eventSink?.success(result)
                }
            }

            override fun onSessionRequest(sessionRequest: Sign.Model.SessionRequest) {
                // Triggered when a Dapp sends SessionRequest to sign a transaction or a message
                runOnUiThread {
                    val result: HashMap<String, Any> = HashMap()
                    result["eventName"] = "onSessionRequest"
                    result["params"] = Gson().toJson(sessionRequest)

                    eventSink?.success(result)
                }
            }

            override fun onSessionDelete(deletedSession: Sign.Model.DeletedSession) {
                // Triggered when the session is deleted by the peer
                runOnUiThread {
                    val result: HashMap<String, Any> = HashMap()
                    result["eventName"] = "onSessionDelete"
                    result["params"] = Gson().toJson(deletedSession)

                    eventSink?.success(result)
                }
            }

            override fun onSessionSettleResponse(settleSessionResponse: Sign.Model.SettledSessionResponse) {
                // Triggered when wallet receives the session settlement response from Dapp
                runOnUiThread {
                    val result: HashMap<String, Any> = HashMap()
                    result["eventName"] = "onSessionSettleResponse"
                    result["params"] = Gson().toJson(settleSessionResponse)

                    eventSink?.success(result)
                }
            }

            override fun onSessionUpdateResponse(sessionUpdateResponse: Sign.Model.SessionUpdateResponse) {
                // Triggered when wallet receives the session update response from Dapp
                runOnUiThread {
                    val result: HashMap<String, Any> = HashMap()
                    result["eventName"] = "onSessionUpdateResponse"
                    result["params"] = Gson().toJson(sessionUpdateResponse)

                    eventSink?.success(result)
                }
            }

            override fun onConnectionStateChange(state: Sign.Model.ConnectionState) {
                //Triggered whenever the connection state is changed
                runOnUiThread {
                    val result: HashMap<String, Any> = HashMap()
                    result["eventName"] = "onSessionUpdateResponse"
                    result["params"] = Gson().toJson(state)

                    eventSink?.success(result)
                }
            }
        }

        signInClient.setWalletDelegate(walletDelegate)
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
