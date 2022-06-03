package com.example.stockbit_test_case

inline fun <reified T : Any> tag(currentClass: T): String {
    return ("Wallet" + currentClass::class.java.canonicalName!!.substringAfterLast(".")).take(23)
}
