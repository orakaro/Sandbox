//
//  SwiftUI_Combine_StripeApp.swift
//  SwiftUI+Combine+Stripe
//
//  Created by DTVD on 2021/04/26.
//

import SwiftUI

@main
struct SwiftUI_Combine_StripeApp: App {
    var body: some Scene {
        WindowGroup {
            FlowContentView()
        }
    }
}

struct Constants {
    // https://glitch.com/edit/#!/remix/stripe-mobile-payment-sheet
    static let backendUrl = "https://absorbing-abalone-pail.glitch.me/"
    static let publishableKey = "pk_test_51ISGYJDS4a4iRDwPsjPZaXJdtiv5i94XJTQ7gCTu9jVxGCJMnrLlDOeYavr8bbCg5wLsEioCmHNjV45SMrmLQlbR00Idc3A1bB"
}
