//
//  Response.swift
//  SwiftUI+Combine+Stripe
//
//  Created by DTVD on 2021/04/26.
//

import Foundation

enum ClientError: Error {
    case serverResponse
    case badStatusCode(statusCode: Int)
}

struct PaymentSheetResponse: Codable {
    let paymentIntent: String
    let ephemeralKey: String
    let customer: String
}
