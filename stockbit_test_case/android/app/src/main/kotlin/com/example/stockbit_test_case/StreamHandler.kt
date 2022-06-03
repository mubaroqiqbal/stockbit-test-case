package com.example.stockbit_test_case

import com.walletconnect.walletconnectv2.client.Sign
import com.walletconnect.walletconnectv2.client.SignClient
import io.flutter.plugin.common.EventChannel

class StreamHandler : EventChannel.StreamHandler, SignClient.WalletDelegate{
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onSessionProposal(sessionProposal: Sign.Model.SessionProposal) {
        // Triggered when wallet receives the session proposal sent by a Dapp
        val result: HashMap<String, Any> = HashMap()
        result["eventName"] = "onSessionProposal"
        result["params"] = sessionProposal

        eventSink?.success(result)
    }

    override fun onSessionRequest(sessionRequest: Sign.Model.SessionRequest) {
        // Triggered when a Dapp sends SessionRequest to sign a transaction or a message
        val result: HashMap<String, Any> = HashMap()
        result["eventName"] = "onSessionRequest"
        result["params"] = sessionRequest

        eventSink?.success(result)
    }

    override fun onSessionDelete(deletedSession: Sign.Model.DeletedSession) {
        // Triggered when the session is deleted by the peer
        val result: HashMap<String, Any> = HashMap()
        result["eventName"] = "onSessionDelete"
        result["params"] = deletedSession

        eventSink?.success(result)
    }

    override fun onSessionSettleResponse(settleSessionResponse: Sign.Model.SettledSessionResponse) {
        // Triggered when wallet receives the session settlement response from Dapp
        val result: HashMap<String, Any> = HashMap()
        result["eventName"] = "onSessionSettleResponse"
        result["params"] = settleSessionResponse

        eventSink?.success(result)
    }

    override fun onSessionUpdateResponse(sessionUpdateResponse: Sign.Model.SessionUpdateResponse) {
        // Triggered when wallet receives the session update response from Dapp
        val result: HashMap<String, Any> = HashMap()
        result["eventName"] = "onSessionUpdateResponse"
        result["params"] = sessionUpdateResponse

        eventSink?.success(result)
    }

    override fun onConnectionStateChange(state: Sign.Model.ConnectionState) {
        //Triggered whenever the connection state is changed
        val result: HashMap<String, Any> = HashMap()
        result["eventName"] = "onSessionUpdateResponse"
        result["params"] = state

        eventSink?.success(result)
    }
}