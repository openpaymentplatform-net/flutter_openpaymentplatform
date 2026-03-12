import 'dart:convert';

import 'package:http/http.dart' as http;

import '../exceptions/exceptions.dart';
import '../models/checkout/openpaymentplatform_request.dart';
import '../models/openpaymentplatform_void.dart';
import '../models/check_status_model.dart';
import '../utils/hash_utils.dart';

/// A service class for handling HTTP requests to the OpenPaymentPlatform backend.
///
/// This class provides methods to interact with the OpenPaymentPlatform API, including
/// fetching payment URLs, checking payment statuses, processing refunds, and
/// voiding payments.
class HttpServiceService {
  /// The base URL of the OpenPaymentPlatform backend.
  final String backendUrl;

  /// The merchant key used for authentication with the OpenPaymentPlatform backend.
  final String merchantKey;

  /// The password used for secure communication with the OpenPaymentPlatform backend.
  final String password;

  /// Creates an instance of `HttpServiceService`.
  ///
  /// - [backendUrl]: The base URL of the OpenPaymentPlatform backend.
  /// - [merchantKey]: The merchant key for authentication.
  /// - [password]: The password for secure communication.
  HttpServiceService({
    required this.backendUrl,
    required this.merchantKey,
    required this.password,
  });

  /// Fetches the payment URL for a given payment request.
  ///
  /// This method sends the payment request to the OpenPaymentPlatform backend and retrieves
  /// the URL where the user can complete the payment process.
  ///
  /// - [request]: The `OpenPaymentPlatformRequest` object containing payment details.
  /// - Returns: A `Future` that resolves to the payment URL as a `String`.
  /// - Throws: `PaymentBackendException` if the server returns an error,
  ///   or `PaymentInitializationException` for unexpected errors.
  Future<String> fetchPaymentUrl(OpenPaymentPlatformRequest request) async {
    var body = request.toJson();
    body['merchant_key'] = merchantKey;
    body['hash'] = OpenPaymentPlatformHashUtils.generateCheckoutHash(
      order: request.order,
      password: password,
    );

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/v1/session'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw PaymentBackendException('Server error', response: response);
      }

      final data = jsonDecode(response.body);
      final url = data['redirect_url'];

      if (url == null || url is! String) {
        throw PaymentBackendException(
          'Missing or invalid redirect_url',
          response: response,
        );
      }

      return url;
    } catch (e) {
      if (e is PaymentException) rethrow;
      throw PaymentInitializationException('Unexpected error: $e');
    }
  }

  /// Checks the status of a payment.
  ///
  /// This method queries the OpenPaymentPlatform backend to retrieve the current status
  /// of a payment using the provided payment ID or order ID.
  ///
  /// - [paymentId]: The unique identifier of the payment (optional).
  /// - [orderId]: The unique identifier of the order (optional).
  /// - Returns: A `Future` that resolves to a `CheckStatusResult` object.
  /// - Throws: `PaymentBackendException` if the server returns an error,
  ///   or `PaymentInitializationException` for unexpected errors.
  Future<CheckStatusResult> checkStatus({
    String? paymentId,
    String? orderId,
  }) async {
    var body = {
      'merchant_key': merchantKey,
      if (paymentId != null) 'payment_id': paymentId,
      if (orderId != null) 'order_id': orderId,
      'hash': OpenPaymentPlatformHashUtils.generatePaymentIdHash(
        id: paymentId ?? orderId!,
        password: password,
      ),
    };

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/v1/payment/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw PaymentBackendException('Server error', response: response);
      }

      final data = jsonDecode(response.body);
      return CheckStatusResult.fromJson(data);
    } catch (e) {
      if (e is PaymentException) rethrow;
      throw PaymentInitializationException('Unexpected error: $e');
    }
  }

  /// Processes a refund for a payment.
  ///
  /// This method sends a refund request to the OpenPaymentPlatform backend for the specified
  /// payment ID and amount.
  ///
  /// - [paymentId]: The unique identifier of the payment to be refunded.
  /// - [amount]: The amount to be refunded.
  /// - Returns: A `Future` that resolves to a `String` indicating the result of the refund operation.
  /// - Throws: `PaymentBackendException` if the server returns an error,
  ///   or `PaymentInitializationException` for unexpected errors.
  Future<String> refund({
    required String paymentId,
    required String amount,
  }) async {
    var body = {
      'merchant_key': merchantKey,
      'payment_id': paymentId,
      'amount': amount,
      'hash': OpenPaymentPlatformHashUtils.generateRefundHash(
        paymentId: paymentId,
        amount: amount,
        password: password,
      ),
    };

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/v1/payment/refund'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw PaymentBackendException('Server error', response: response);
      }

      final data = jsonDecode(response.body);
      return data['result'] ?? 'Unknown result';
    } catch (e) {
      if (e is PaymentException) rethrow;
      throw PaymentInitializationException('Unexpected error: $e');
    }
  }

  /// Voids a payment.
  ///
  /// This method sends a void request to the OpenPaymentPlatform backend for the specified
  /// payment ID.
  ///
  /// - [paymentId]: The unique identifier of the payment to be voided.
  /// - Returns: A `Future` that resolves to an `OpenPaymentPlatformVoid` object indicating the result of the void operation.
  /// - Throws: `PaymentBackendException` if the server returns an error,
  ///   or `PaymentInitializationException` for unexpected errors.
  Future<OpenPaymentPlatformVoid> voidOperation(
      {required String paymentId}) async {
    var body = {
      'merchant_key': merchantKey,
      'payment_id': paymentId,
      'hash': OpenPaymentPlatformHashUtils.generatePaymentIdHash(
        id: paymentId,
        password: password,
      ),
    };

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/v1/payment/void'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw PaymentBackendException('Server error', response: response);
      }

      final data = jsonDecode(response.body);
      return OpenPaymentPlatformVoid.fromJson(data);
    } catch (e) {
      if (e is PaymentException) rethrow;
      throw PaymentInitializationException('Unexpected error: $e');
    }
  }
}
