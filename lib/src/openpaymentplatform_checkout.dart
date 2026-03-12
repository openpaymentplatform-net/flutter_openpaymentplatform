import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'checkout_controller.dart';
import 'exceptions/exceptions.dart';
import 'openpaymentplatform.dart';

/// A widget that provides a WebView-based checkout experience for OpenPaymentPlatform payments.
class OpenPaymentPlatformCheckout extends StatefulWidget {
  /// The controller that manages the payment process and callbacks.
  final CheckoutController controller;

  /// Creates an instance of [OpenPaymentPlatformCheckout].
  ///
  /// [controller] is required to handle the payment flow and callbacks.
  const OpenPaymentPlatformCheckout({super.key, required this.controller});

  @override
  State<OpenPaymentPlatformCheckout> createState() =>
      _OpenPaymentPlatformCheckoutState();
}

class _OpenPaymentPlatformCheckoutState
    extends State<OpenPaymentPlatformCheckout> {
  /// The WebViewController is used to control the WebView widget.
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Initialize the WebView controller and start the payment process.
    _initWebViewController();
    _initializePayment();
  }

  /// Configures the WebViewController with JavaScript support and navigation handling.
  void _initWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      ) // Enable JavaScript for the WebView.
      ..setNavigationDelegate(
        NavigationDelegate(
          // Handle navigation requests (e.g., success, error, or cancel URLs).
          onNavigationRequest: _handleNavigationRequest,
          // Handle errors that occur during WebView navigation.
          onWebResourceError: _handleWebError,
        ),
      );
  }

  /// Handles navigation requests and triggers appropriate callbacks based on the URL.
  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    final url = request.url;

    // Check if the URL matches the success URL.
    if (url.contains(widget.controller.paymentRequest.successUrl)) {
      widget.controller.onSuccessRedirect?.call(url);
    }
    // Check if the URL matches the error URL.
    else if (widget.controller.paymentRequest.errorUrl != null &&
        url.contains(widget.controller.paymentRequest.errorUrl!)) {
      widget.controller.onErrorRedirect?.call(url);
    }
    // Check if the URL matches the cancel URL.
    else if (widget.controller.paymentRequest.cancelUrl != null &&
        url.contains(widget.controller.paymentRequest.cancelUrl!)) {
      widget.controller.onCancelRedirect?.call(url);
    }
    // Handle any other redirection URLs.
    else {
      widget.controller.onRedirectCallback?.call(url);
    }
    return NavigationDecision.navigate;
  }

  /// Handles WebView errors and triggers the error callback.
  void _handleWebError(WebResourceError error) {
    widget.controller.onError?.call(
      PaymentWebViewException('WebView error: ${error.description}'),
    );
  }

  /// Initializes the payment process by fetching the payment URL and loading it in the WebView.
  Future<void> _initializePayment() async {
    try {
      // Fetch the payment URL from the OpenPaymentPlatform service.
      final url = await OpenPaymentPlatform().fetchPaymentUrl(
        widget.controller.paymentRequest,
      );
      // Load the fetched URL into the WebView.
      _webViewController.loadRequest(Uri.parse(url));
    } catch (e) {
      // Handle specific payment exceptions.
      if (e is PaymentException) {
        widget.controller.onError?.call(e);
        return;
      }
      // Handle unexpected errors during payment initialization.
      else {
        widget.controller.onError?.call(
          PaymentInitializationException('Unexpected error: $e'),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the WebView widget and return it as the UI for this screen.
    return WebViewWidget(controller: _webViewController);
  }
}
