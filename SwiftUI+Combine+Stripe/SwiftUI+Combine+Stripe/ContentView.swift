//
//  ContentView.swift
//  SwiftUI+Combine+Stripe
//
//  Created by DTVD on 2021/04/26.
//

import SwiftUI
import Stripe

struct ContentView: View {
    @ObservedObject var model = SimpleModel()

    var body: some View {
        VStack {
            if let paymentSheet = model.paymentSheet {
                PaymentSheet.PaymentButton(
                    paymentSheet: paymentSheet,
                    onCompletion: model.onPaymentCompletetion) {
                    Text("Buy")
                }
            } else {
                Text("Loading...")
            }
            if let result = model.paymentResult {
                switch result {
                case .completed(let paymentIntent):
                    Text("Complete: \(paymentIntent.stripeId)")
                case .failed(let error, _):
                    Text("Failed: \(error.localizedDescription)")
                case .canceled:
                    Text("Cancel")
                }
            }
        }.onAppear { model.preparePaymentSheet() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum ClientError: Error {
    case serverResponse
    case badStatusCode(statusCode: Int)
}

struct PaymentSheetResponse: Codable {
    let paymentIntent: String
    let ephemeralKey: String
    let customer: String
}

class SimpleModel: ObservableObject {
    let backendCheckoutUrl = URL(string: "https://jealous-innovative-ranunculus.glitch.me/payment-sheet")!
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentResult?

    init() {
        STPAPIClient.shared.publishableKey = "pk_test_51ISGYJDS4a4iRDwPsjPZaXJdtiv5i94XJTQ7gCTu9jVxGCJMnrLlDOeYavr8bbCg5wLsEioCmHNjV45SMrmLQlbR00Idc3A1bB"
    }

    func preparePaymentSheet() {
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        let session = URLSession.shared
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        session.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ClientError.serverResponse
                }
                guard httpResponse.statusCode == 200 else {
                    throw ClientError.badStatusCode(statusCode: httpResponse.statusCode)
                }
                return data
            }
            .decode(type: PaymentSheetResponse.self, decoder: decoder)
            .map { response -> PaymentSheet in
                var config = PaymentSheet.Configuration()
                config.merchantDisplayName = "Simple UI"
                config.customer = .init(id: response.customer, ephemeralKeySecret: response.ephemeralKey)
                return PaymentSheet(paymentIntentClientSecret: response.paymentIntent, configuration: config)
            }
            .eraseToAnyPublisher()
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$paymentSheet)
    }

    func onPaymentCompletetion(result: PaymentResult) {
        paymentResult = result
    }
}
