
# openpaymentplatform_flutter

A Flutter package that provides integration with the OpenPaymentPlatform via WebView. It supports full-cycle operations including payment initialization, redirect handling, status checking, refunding, and voiding.

---

## Features

- Seamless checkout experience using WebView
- Support for Purchase, Refund, Void, and Status Check operations
- Easy-to-use API for building custom payment flows
- Full control over redirect and error handling via callbacks

---

## Getting Started

### 1. Install the package

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  openpaymentplatform_flutter: ^1.0.4
```

Then run:

```bash
flutter pub get
```

---

### 2. Initialize the SDK

```dart
OpenPaymentPlatform().initialize(
  backendUrl: 'backend-url',
  merchantKey: 'your-merchant-key',
  password: 'your-api-password',
);
```

---

## Full Example

```dart
import 'package:flutter/material.dart';
import 'package:openpaymentplatform_flutter/openpaymentplatform_flutter.dart';

void main() => runApp(const OpenPaymentPlatformExampleApp());

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
```

Inside `OpenPaymentPlatformDemo`:

```dart
@override
void initState() {
  super.initState();

  OpenPaymentPlatform().initialize(
    backendUrl: 'your-url',
    merchantKey: 'your-merchant-key',
    password: 'your-password',
  );

  var request = OpenPaymentPlatformRequest(
    operation: OpenPaymentPlatformOperation.purchase,
    successUrl: "https://example.com/success",
    cancelUrl: "https://example.com/cancel",
    errorUrl: "https://example.com/error",
    expiryUrl: "https://example.com/expiry",
    order: OpenPaymentPlatformOrder(
      number: "order-1234",
      amount: "100.00",
      currency: "USD",
      description: "Example purchase",
    ),
    customer: Customer(name: "John Doe", email: "john@example.com"),
    billingAddress: BillingAddress(
      country: "US",
      state: "CA",
      city: "Los Angeles",
      district: "Beverlywood",
      address: "Moor Building",
      houseNumber: "17/2",
      zip: "123456",
      phone: "347771112233",
    ),
  );

  _controller = CheckoutController(
    paymentRequest: request,
    onSuccessRedirect: (url) => print("Success: $url"),
    onCancelRedirect: (url) => print("Cancelled: $url"),
    onErrorRedirect: (url) => print("Error: $url"),
    onRedirectCallback: (url) => print("Redirect: $url"),
    onError: (e) => print("Error: ${e.message}"),
  );
}
```

To open the payment screen:

```dart
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
```

---

## API Methods

### Check Payment Status

```dart
final status = await OpenPaymentPlatform().checkStatus(paymentId: '123');
print('Status: ${status.status}');
```

### Refund Payment

```dart
final result = await OpenPaymentPlatform().refundPayment(
  paymentId: '123',
  amount: '100.00',
);
```

### Void Payment

```dart
final result = await OpenPaymentPlatform().voidPayment(paymentId: '123');
```

---

## Redirect Callbacks

| Callback            | Description                              |
|---------------------|------------------------------------------|
| `onSuccessRedirect` | Called on success URL redirect           |
| `onCancelRedirect`  | Called on cancel URL redirect            |
| `onErrorRedirect`   | Called on error URL redirect             |
| `onRedirectCallback`| Called on **any** redirect URL           |
| `onError`           | Called on WebView or initialization error|

## 3DS App-to-App Redirects

Some 3DS providers redirect from WebView to a banking app (custom URL scheme),
then return back to your app via deep link or universal link.

### How it works

1. `OpenPaymentPlatformCheckout` intercepts external-scheme URLs and calls
   `onRedirectCallback`.
2. Your app opens that URL externally (for example with `url_launcher`).
3. After authentication in the banking app, your app receives a return URL.
4. Pass the returned URL into `CheckoutController.handleExternalRedirect(url)`.
5. Controller will trigger success/error/cancel callbacks or continue WebView
   flow when needed.

### Handling external redirect URL

```dart
onRedirectCallback: (url) async {
  // Usually a custom scheme like bankapp://...
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
},
```

### Handling app return deep link

Use your deep link listener (`app_links`, `uni_links`, or platform channel) and
forward incoming URL to checkout controller:

```dart
void onIncomingDeepLink(String url) {
  if(urlsMatch(url, 'your-return-url-scheme://*')) {
    _handleAppReturn(url);
  }else if(urlsMatch(url, 'http*')) {
    _controller.handleExternalRedirect(url);
  }
}
```

### Notes

- Configure Android/iOS deep link setup for your return URL scheme/host.
- `successUrl`, `cancelUrl`, and `errorUrl` should match backend redirect
  configuration.
- If a returned URL is not terminal, checkout will continue loading it in
  WebView.

