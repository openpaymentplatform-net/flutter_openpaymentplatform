import 'http/http_service.dart';
import 'models/check_status_model.dart';
import 'models/checkout/openpaymentplatform_request.dart';
import 'models/openpaymentplatform_void.dart';

/// The `OpenPaymentPlatform` class serves as a singleton interface for interacting with the
/// OpenPaymentPlatform payment system.
///
/// This class provides methods to initialize the payment system, fetch payment URLs,
/// check the status of payments, process refunds, and void payments.
class OpenPaymentPlatform {
  /// The singleton instance of the `OpenPaymentPlatform` class.
  static final OpenPaymentPlatform _instance = OpenPaymentPlatform._internal();

  /// The backend URL of the OpenPaymentPlatform service.
  late String backendUrl;

  /// The merchant key used for authentication with the OpenPaymentPlatform service.
  late String merchantKey;

  /// The password used for secure communication with the OpenPaymentPlatform service.
  late String password;

  /// The HTTP service responsible for making API requests to the OpenPaymentPlatform backend.
  late HttpServiceService _httpService;

  /// Private constructor for the singleton pattern.
  OpenPaymentPlatform._internal();

  /// Factory constructor to return the singleton instance of the `OpenPaymentPlatform` class.
  factory OpenPaymentPlatform() {
    return _instance;
  }

  /// Initializes the OpenPaymentPlatform payment system.
  ///
  /// This method must be called before using any other methods of the `OpenPaymentPlatform` class.
  /// It sets up the backend URL, merchant key, and password, and initializes the HTTP service.
  ///
  /// - [backendUrl]: The base URL of the OpenPaymentPlatform backend.
  /// - [merchantKey]: The merchant key for authentication.
  /// - [password]: The password for secure communication.
  void initialize({
    required String backendUrl,
    required String merchantKey,
    required String password,
  }) {
    this.backendUrl = backendUrl;
    this.merchantKey = merchantKey;
    this.password = password;
    _httpService = HttpServiceService(
      backendUrl: backendUrl,
      merchantKey: merchantKey,
      password: password,
    );
  }

  /// Fetches the payment URL for a given payment request.
  ///
  /// This method sends the payment request to the OpenPaymentPlatform backend and retrieves the
  /// URL where the user can complete the payment process.
  Future<String> fetchPaymentUrl(OpenPaymentPlatformRequest request) async {
    return _httpService.fetchPaymentUrl(request);
  }

  /// Checks the status of a payment.
  ///
  /// This method queries the OpenPaymentPlatform backend to retrieve the current status of a
  /// payment using the provided payment ID.
  Future<CheckStatusResult> checkStatus({String? paymentId}) async {
    return _httpService.checkStatus(paymentId: paymentId);
  }

  /// Processes a refund for a payment.
  Future<String> refundPayment({
    required String paymentId,
    required String amount,
  }) async {
    return _httpService.refund(paymentId: paymentId, amount: amount);
  }

  /// To make a void for an operation which was performed the same financial day you can use a
  /// Void request.
  ///
  /// The Void request is allowed for the payments in SETTLED status only.
  /// Use payment public ID from Payment Platform in the request.
  Future<OpenPaymentPlatformVoid> voidPayment({
    required String paymentId,
  }) async {
    return _httpService.voidOperation(paymentId: paymentId);
  }
}
