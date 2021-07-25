//
//  CustomView.swift
//  SwiftUI+Combine+Stripe
//
//  Created by DTVD on 2021/07/18.
//

import SwiftUI
import Stripe

struct CustomView: View {
    @ObservedObject var model = CustomModel()
    @State var isConfirmingPayment = false
    @State var paymentMethodParams: STPPaymentMethodParams?

    var body: some View {
        VStack {
            STPPaymentCardTextField.Representable(paymentMethodParams: $paymentMethodParams).padding()

            if let paymentIntentParams = model.paymentIntentParams {
                Button("Buy") {
                    paymentIntentParams.paymentMethodParams = paymentMethodParams
                    isConfirmingPayment = true
                }.paymentConfirmationSheet(isConfirmingPayment: $isConfirmingPayment, paymentIntentParams: paymentIntentParams, onCompletion: model.onCompletion)
                .disabled(isConfirmingPayment)
            } else {
                Text("Loading...")
            }
            if let result = model.paymentStatus {
                switch result {
                case .succeeded:
                    Text("Complete")
                case .failed:
                    Text("Failed: \(model.lastError ?? NSError())")
                case .canceled:
                    Text("Cancel")
                @unknown default:
                    Text("Unknown")
                }
            }
        }.onAppear { model.preparePaymentIntent() }
    }
}

struct CustomView_Previews: PreviewProvider {
    static var previews: some View {
        CustomView()
    }
}

class CustomModel: ObservableObject {
    let backendCheckoutUrl = URL(string: "\(Constants.backendUrl)/checkout")!
    @Published var paymentIntentParams: STPPaymentIntentParams?
    @Published var paymentStatus: STPPaymentHandlerActionStatus?
    @Published var lastError: NSError?

    init() {
        STPAPIClient.shared.publishableKey = Constants.publishableKey
    }

    func preparePaymentIntent() {
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
            .map { response -> STPPaymentIntentParams in
                STPPaymentIntentParams(clientSecret: response.paymentIntent)
            }
            .eraseToAnyPublisher()
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$paymentIntentParams)
    }

    func onCompletion(status: STPPaymentHandlerActionStatus, pi: STPPaymentIntent?, error: NSError?) {
        self.paymentStatus = status
        self.lastError = error

        // MARK: cleanup
        if status == .succeeded {
            self.paymentIntentParams = nil
            preparePaymentIntent()
        }
    }
}
