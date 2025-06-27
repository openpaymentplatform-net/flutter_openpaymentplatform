import 'package:flutter/material.dart';
import 'package:akurateco_flutter/akurateco_flutter.dart';

void main() {
  runApp(const AkuratecoExampleApp());
}

class AkuratecoExampleApp extends StatelessWidget {
  const AkuratecoExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akurateco Flutter Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('Akurateco Example')),
        body: const Center(child: AkuratecoDemo()),
      ),
    );
  }
}

class AkuratecoDemo extends StatefulWidget {
  const AkuratecoDemo({super.key});

  @override
  State<AkuratecoDemo> createState() => _AkuratecoDemoState();
}

class _AkuratecoDemoState extends State<AkuratecoDemo> {
  late final CheckoutController _controller;

  @override
  void initState() {
    super.initState();

    Akurateco().initialize(
      backendUrl: 'https://example.com',
      merchantKey: 'merchant key',
      password: 'password',
    );

    var request = createAkuratecoRequest();
    _controller = CheckoutController(
      paymentRequest: request,
      onSuccessRedirect: (url) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Payment Success")));
      },
    );
  }

  AkuratecoRequest createAkuratecoRequest() {
    var akuratecoOrder = const AkuratecoOrder(
      number: "order-1234",
      amount: "100.00",
      currency: "USD",
      description: "Example purchase",
    );

    return AkuratecoRequest(
      operation: AkuratecoOperation.purchase,
      successUrl: "https://example.com/success",
      order: akuratecoOrder,
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
                  child: AkuratecoCheckout(controller: _controller),
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
