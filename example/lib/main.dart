import 'package:flutter/material.dart';
import 'package:openpaymentplatform_flutter/openpaymentplatform_flutter.dart';

void main() {
  runApp(const OpenPaymentPlatformExampleApp());
}

class OpenPaymentPlatformExampleApp extends StatelessWidget {
  const OpenPaymentPlatformExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenPaymentPlatform Flutter Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('OpenPaymentPlatform Example')),
        body: const Center(child: OpenPaymentPlatformDemo()),
      ),
    );
  }
}

class OpenPaymentPlatformDemo extends StatefulWidget {
  const OpenPaymentPlatformDemo({super.key});

  @override
  State<OpenPaymentPlatformDemo> createState() =>
      _OpenPaymentPlatformDemoState();
}

class _OpenPaymentPlatformDemoState extends State<OpenPaymentPlatformDemo> {
  late final CheckoutController _controller;

  @override
  void initState() {
    super.initState();

    OpenPaymentPlatform().initialize(
      backendUrl: 'https://example.com',
      merchantKey: 'merchant key',
      password: 'password',
    );

    final request = createOpenPaymentPlatformRequest();
    _controller = CheckoutController(
      paymentRequest: request,
      onSuccessRedirect: (url) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Payment Success")));
      },
    );

    // Wire your deep-link listener here (app_links/uni_links) and call
    // _controller.handleExternalRedirect(incomingUrl) on app return.
  }

  /// Call this from your app-level deep-link stream handler.
  void onIncomingDeepLink(String url) {
    _controller.handleExternalRedirect(url);
  }

  OpenPaymentPlatformRequest createOpenPaymentPlatformRequest() {
    const order = OpenPaymentPlatformOrder(
      number: "order-1234",
      amount: "100.00",
      currency: "USD",
      description: "Example purchase",
    );

    return OpenPaymentPlatformRequest(
      operation: OpenPaymentPlatformOperation.purchase,
      successUrl: "https://example.com/success",
      order: order,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: SizedBox(
                  width: 400,
                  height: 600,
                  child: OpenPaymentPlatformCheckout(controller: _controller),
                ),
              ),
            );
          },
          child: const Text('Start Payment'),
        ),
      ],
    );
  }
}
