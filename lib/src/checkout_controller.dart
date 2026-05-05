import 'exceptions/exceptions.dart';
import 'models/checkout/openpaymentplatform_request.dart';

/// A callback type for handling URL redirections during the payment process.
typedef OnRedirectCallback = void Function(String url);

/// A callback type for handling payment errors.
typedef OnPaymentErrorCallback = void Function(PaymentException error);

/// The main controller class for managing OpenPaymentPlatform payment flows.
///
/// For app-to-app 3DS flows, an ACS page may redirect to a banking app using a
/// custom scheme. In that case, listen to deep links in your host app and pass
/// the return URL back into [handleExternalRedirect] to continue redirect
/// handling in Flutter.
class CheckoutController {
  /// The payment request object containing all necessary data for the payment.
  final OpenPaymentPlatformRequest paymentRequest;

  /// Callback for handling successful redirections.
  OnRedirectCallback? _onSuccessRedirect;

  /// Callback for handling error redirections.
  OnRedirectCallback? _onErrorRedirect;

  /// Callback for handling cancellation redirections.
  OnRedirectCallback? _onCancelRedirect;

  /// Callback for handling general redirections.
  OnRedirectCallback? _onRedirectCallback;

  /// Callback for handling any exceptions.
  OnPaymentErrorCallback? _onError;

  /// Internal listeners used by checkout UI to continue loading returned URLs.
  final List<OnRedirectCallback> _externalUrlListener = [];

  /// Getter for the success redirection callback.
  OnRedirectCallback? get onSuccessRedirect => _onSuccessRedirect;

  /// Getter for the error redirection callback.
  OnRedirectCallback? get onErrorRedirect => _onErrorRedirect;

  /// Getter for the cancellation redirection callback.
  OnRedirectCallback? get onCancelRedirect => _onCancelRedirect;

  /// Getter for the general redirection callback.
  OnRedirectCallback? get onRedirectCallback => _onRedirectCallback;

  /// Getter for the payment error callback.
  OnPaymentErrorCallback? get onError => _onError;

  /// Constructor for initializing the CheckoutController.
  ///
  /// [paymentRequest] is required and contains the payment details.
  /// Optional callbacks can be provided for handling success, error,
  /// cancellation, general redirections, and payment errors.
  CheckoutController({
    required this.paymentRequest,
    OnRedirectCallback? onSuccessRedirect,
    OnRedirectCallback? onErrorRedirect,
    OnRedirectCallback? onCancelRedirect,
    OnRedirectCallback? onRedirectCallback,
    OnPaymentErrorCallback? onError,
  }) {
    _onSuccessRedirect = onSuccessRedirect;
    _onErrorRedirect = onErrorRedirect;
    _onCancelRedirect = onCancelRedirect;
    _onRedirectCallback = onRedirectCallback;
    _onError = onError;
  }

  /// Clears all external redirect listeners.
  ///
  /// Useful when the owning widget is disposed.
  void dispose() {
    _externalUrlListener.clear();
  }

  /// Removes a previously registered external redirect listener.
  void removeExternalUrlListener(OnRedirectCallback callback) {
    _externalUrlListener.remove(callback);
  }

  /// Classifies and dispatches a URL returned from an external source.
  ///
  /// Use this when your app receives a deep link after a 3DS app-to-app hop.
  /// The method will call success/error/cancel callbacks when matching URLs are
  /// detected. For regular web URLs it also notifies internal listeners so the
  /// checkout WebView can resume loading the flow.
  void handleExternalRedirect(String url) {
    if (isSuccessUrl(url)) {
      _onSuccessRedirect?.call(url);
    } else if (isErrorUrl(url)) {
      _onErrorRedirect?.call(url);
    } else if (isCancelUrl(url)) {
      _onCancelRedirect?.call(url);
    } else {
      if (!isExternalScheme(url)) {
        for (var listener in _externalUrlListener) {
          listener(url);
        }
      }
    }
  }

  /// Returns `true` when URL scheme is not web (`http`/`https`).
  bool isExternalScheme(String url) {
    final uri = Uri.parse(url);
    return uri.scheme != 'http' && uri.scheme != 'https';
  }

  /// Checks whether URL contains configured success URL.
  bool isSuccessUrl(String url) {
    return url.contains(paymentRequest.successUrl);
  }

  /// Checks whether URL contains configured error URL.
  bool isErrorUrl(String url) {
    final errorUrl = paymentRequest.errorUrl;
    return errorUrl != null && url.contains(errorUrl);
  }

  /// Checks whether URL contains configured cancel URL.
  bool isCancelUrl(String url) {
    final cancelUrl = paymentRequest.cancelUrl;
    return cancelUrl != null && url.contains(cancelUrl);
  }

  /// Adds a listener for non-terminal web redirects returned from external apps.
  ///
  /// This is primarily used by [OpenPaymentPlatformCheckout] to reload WebView
  /// after deep-link return to the merchant app.
  void addExternalUrlListener(OnRedirectCallback callback) {
    _externalUrlListener.add(callback);
  }
}
