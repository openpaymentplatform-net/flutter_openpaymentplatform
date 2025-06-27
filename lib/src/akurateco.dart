import '../akurateco_flutter.dart';
  import 'http/http_service.dart';
  import 'models/akurateco_void.dart';
  import 'models/check_status_model.dart';

  /// The `Akurateco` class serves as a singleton interface for interacting with the Akurateco payment system.
  ///
  /// This class provides methods to initialize the payment system, fetch payment URLs,
  /// check the status of payments, process refunds, and void payments.
  class Akurateco {
    /// The singleton instance of the `Akurateco` class.
    static final Akurateco _instance = Akurateco._internal();

    /// The backend URL of the Akurateco service.
    late String backendUrl;

    /// The merchant key used for authentication with the Akurateco service.
    late String merchantKey;

    /// The password used for secure communication with the Akurateco service.
    late String password;

    /// The HTTP service responsible for making API requests to the Akurateco backend.
    late HttpServiceService _httpService;

    /// Private constructor for the singleton pattern.
    Akurateco._internal();

    /// Factory constructor to return the singleton instance of the `Akurateco` class.
    factory Akurateco() {
      return _instance;
    }

    /// Initializes the Akurateco payment system.
    ///
    /// This method must be called before using any other methods of the `Akurateco` class.
    /// It sets up the backend URL, merchant key, and password, and initializes the HTTP service.
    ///
    /// - [backendUrl]: The base URL of the Akurateco backend.
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
      );
    }

    /// Fetches the payment URL for a given payment request.
    ///
    /// This method sends the payment request to the Akurateco backend and retrieves the URL
    /// where the user can complete the payment process.
    ///
    /// - [request]: The payment request containing all necessary details.
    /// - Returns: A `Future` that resolves to the payment URL as a `String`.
    Future<String> fetchPaymentUrl(AkuratecoRequest request) async {
      return _httpService.fetchPaymentUrl(request);
    }

    /// Checks the status of a payment.
    ///
    /// This method queries the Akurateco backend to retrieve the current status of a payment
    /// using the provided payment ID.
    ///
    /// - [paymentId]: The unique identifier of the payment. This parameter is optional.
    /// - Returns: A `Future` that resolves to a `CheckStatusResult` containing the payment status.
    Future<CheckStatusResult> checkStatus({String? paymentId}) async {
      return _httpService.checkStatus(paymentId: paymentId);
    }

    /// Processes a refund for a payment.
    ///
    /// This method sends a refund request to the Akurateco backend for the specified payment ID
    /// and amount.
    ///
    /// - [paymentId]: The unique identifier of the payment to be refunded.
    /// - [amount]: The amount to be refunded.
    /// - Returns: A `Future` that resolves to a `String` indicating the result of the refund operation.
    Future<String> refundPayment({
      required String paymentId,
      required String amount,
    }) async {
      return _httpService.refund(paymentId: paymentId, amount: amount);
    }

    /// To make a void for an operation which was performed the same financial day you can use Void request.
    /// The Void request is allowed for the payments in SETTLED status only.
    /// Use payment public ID from Payment Platform in the request.
    /// This method sends a void request to the Akurateco backend for the specified payment ID.
    ///
    /// - [paymentId]: The unique identifier of the payment to be voided.
    /// - Returns: A `Future` that resolves to an `AkuratecoVoid` object indicating the result of the void operation.
    Future<AkuratecoVoid> voidPayment({
      required String paymentId,
    }) async {
      return _httpService.voidOperation(paymentId: paymentId);
    }
  }