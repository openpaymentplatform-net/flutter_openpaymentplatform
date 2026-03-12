import 'exceptions/exceptions.dart';
import 'models/checkout/openpaymentplatform_request.dart';

/// A callback type for handling URL redirections during the payment process.
typedef OnRedirectCallback = void Function(String url);

/// A callback type for handling payment errors.
typedef OnPaymentErrorCallback = void Function(PaymentException error);

/// The main controller class for managing OpenPaymentPlatform payment flows.
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
}
