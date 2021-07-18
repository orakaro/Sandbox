//
//  FlowContentView.swift
//  SwiftUI+Combine+Stripe
//
//  Created by DTVD on 2021/04/26.
//

import SwiftUI
import Stripe
import Combine

struct FlowContentView: View {
    @ObservedObject var model = FlowModel()
    @State var isConfirmingPayment = false

    var body: some View {
        VStack {
            if let flowController = model.paymentSheetFlowController {
                PaymentSheet.FlowController.PaymentOptionsButton(
                    paymentSheetFlowController: flowController,
                    onSheetDismissed: model.onOptionsCompletion
                ) {
                    HStack {
                        Image(uiImage: flowController.paymentOption?.image ?? UIImage(systemName: "creditcard")!)
                        Text(flowController.paymentOption?.label ?? "Select a payment method")
                    }
                }
                Button(
                    action: {
                        isConfirmingPayment = true
                    },
                    label: {
                        if isConfirmingPayment {
                            Text("Processing...")
                        } else {
                            Text("Buy")
                        }
                    }
                ).paymentConfirmationSheet(
                    isConfirming: $isConfirmingPayment,
                    paymentSheetFlowController: flowController,
                    onCompletion: model.onPaymentCompletetion
                ).disabled(flowController.paymentOption == nil ||  isConfirmingPayment)
            } else {
                Text("Loading...")
            }
            if let result = model.paymentResult {
                switch result {
                case .completed:
                    Text("Complete")
                case .failed(let error):
                    Text("Failed: \(error.localizedDescription)")
                case .canceled:
                    Text("Cancel")
                }
            }
        }.onAppear { model.preparePaymentSheet() }
    }
}

struct FlowContentView_Previews: PreviewProvider {
    static var previews: some View {
        FlowContentView()
    }
}

class FlowModel: ObservableObject {
    let backendCheckoutUrl = URL(string: "\(Constants.backendUrl)/checkout")!
    @Published var paymentSheetFlowController: PaymentSheet.FlowController?
    @Published var paymentResult: PaymentSheetResult?

    init() {
        STPAPIClient.shared.publishableKey = Constants.publishableKey
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
            .flatMap { response -> AnyPublisher<PaymentSheet.FlowController?, Never> in
                var config = PaymentSheet.Configuration()
                config.merchantDisplayName = "Simple UI"
                config.customer = .init(id: response.customer, ephemeralKeySecret: response.ephemeralKey)

                return Future<PaymentSheet.FlowController, Error>() { promise in
                    PaymentSheet.FlowController.create(
                        paymentIntentClientSecret: response.paymentIntent,
                        configuration: config,
                        completion: promise
                    )
                }
                    .map { Optional.some($0) }
                    .replaceError(with: nil)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .assign(to: &$paymentSheetFlowController)
    }

    func onPaymentCompletetion(result: PaymentSheetResult) {
        paymentResult = result
    }

    func onOptionsCompletion() {
        objectWillChange.send()
    }
}
