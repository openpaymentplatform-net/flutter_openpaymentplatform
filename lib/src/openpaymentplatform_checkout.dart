import 'dart:async';

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
  late final OnRedirectCallback _externalUrlListener;

  @override
  void initState() {
    super.initState();
    // Initialize the WebView controller and start the payment process.
    _initWebViewController();

    // After app-to-app 3DS return, load the returned URL back into WebView.
    _externalUrlListener = (url) {
      _webViewController.loadRequest(Uri.parse(url));
    };
    widget.controller.addExternalUrlListener(_externalUrlListener);

    _initializePayment();
  }

  @override
  void dispose() {
    widget.controller.removeExternalUrlListener(_externalUrlListener);
    super.dispose();
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
  FutureOr<NavigationDecision> _handleNavigationRequest(
    NavigationRequest request,
  ) async {
    final url = request.url;

    if (widget.controller.isExternalScheme(url)) {
      // Custom-scheme redirects usually open external banking/3DS apps.
      // WebView navigation is stopped, host app handles this URL externally.
      widget.controller.onRedirectCallback?.call(url);
      return NavigationDecision.prevent;
    }

    if (widget.controller.isSuccessUrl(url)) {
      widget.controller.onSuccessRedirect?.call(url);
    } else if (widget.controller.isErrorUrl(url)) {
      widget.controller.onErrorRedirect?.call(url);
    } else if (widget.controller.isCancelUrl(url)) {
      widget.controller.onCancelRedirect?.call(url);
    } else {
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
