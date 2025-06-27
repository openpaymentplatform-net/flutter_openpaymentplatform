import 'package:http/http.dart';

  /// Abstract base class for payment-related exceptions.
  ///
  /// This class serves as the base for all exceptions related to payment operations.
  /// It includes a message describing the error.
  abstract class PaymentException implements Exception {
    /// The error message describing the exception.
    final String message;

    /// Constructs a `PaymentException` with the given error [message].
    PaymentException(this.message);

    /// Returns a string representation of the exception.
    ///
    /// - Returns: A string containing the runtime type and the error message.
    @override
    String toString() => '$runtimeType: $message. ';
  }

  /// Exception thrown during the initialization of a payment.
  ///
  /// This exception is used to indicate errors that occur while setting up
  /// a payment operation.
  class PaymentInitializationException extends PaymentException {
    /// Constructs a `PaymentInitializationException` with the given error [message].
    PaymentInitializationException(super.message);
  }

  /// Exception thrown when the backend returns an error during a payment operation.
  ///
  /// This exception includes the HTTP response from the backend, if available.
  class PaymentBackendException extends PaymentException {
    /// The HTTP response returned by the backend, if available.
    final Response? response;

    /// Constructs a `PaymentBackendException` with the given error [message]
    /// and an optional HTTP [response].
    PaymentBackendException(super.message, {this.response});

    /// Returns a string representation of the exception, including the status code
    /// and response body if available.
    ///
    /// - Returns: A string containing the runtime type, error message, status code,
    ///   and response body.
    @override
    String toString() {
      final responseBody = response?.body ?? '';
      return '$runtimeType: $message. Status code: ${response?.statusCode}. Response: $responseBody';
    }
  }

  /// Exception thrown when an error occurs in the WebView during a payment operation.
  ///
  /// This exception is used to indicate issues specific to WebView interactions.
  class PaymentWebViewException extends PaymentException {
    /// Constructs a `PaymentWebViewException` with the given error [message].
    PaymentWebViewException(super.message);
  }

  /// Exception thrown when a callback error occurs during a payment operation.
  ///
  /// This exception is used to indicate issues with callback handling.
  class PaymentCallbackException extends PaymentException {
    /// Constructs a `PaymentCallbackException` with the given error [message].
    PaymentCallbackException(super.message);
  }