import '../customer.dart';
import '../openpaymentplatform_order.dart';
import 'billing_address.dart';
import 'payee.dart';

/// Enum representing the types of operations that can be performed in the OpenPaymentPlatform system.
enum OpenPaymentPlatformOperation {
  /// Represents a purchase operation.
  purchase,

  /// Represents a debit operation.
  debit,

  /// Represents a transfer operation.
  transfer,
}

/// A model class representing a request in the OpenPaymentPlatform checkout system.
class OpenPaymentPlatformRequest {
  /// Defines a payment transaction
  final OpenPaymentPlatformOperation operation;

  /// URL to redirect the Customer in case of the successful payment
  final String successUrl;

  /// An array of payment methods.
  final List<String>? methods;

  /// This parameter is used to direct payments to a specific sub-account (channel).
  final String? channelId;

  /// Session expiration time in minutes.
  final int? sessionExpiry;

  /// URL to return Customer in case of a payment cancellation
  final String? cancelUrl;

  /// URL where the payer will be redirected in case of session expiration
  final String? expiryUrl;

  /// URL to return Customer in case of undefined transaction status.
  final String? errorUrl;

  /// Name of, or keyword for a browsing context where Customer should be returned.
  String? urlTarget;

  /// Special attribute pointing for further tokenization
  final bool? reqToken;

  /// Credit card token value
  final List<String>? cardToken;

  /// Payment form identifier
  final String? formId;

  /// Initialization of the transaction with possible following recurring
  final bool? recurringInit;

  /// Schedule ID for recurring payments
  final String? scheduleId;

  /// Indicates the need of calculation for the VAT amount
  final bool? vatCalc;

  /// Information about an order
  final OpenPaymentPlatformOrder order;

  /// Customer's information.
  final Customer? customer;

  /// Billing address information.
  final BillingAddress? billingAddress;

  /// Payee's information.
  final Payee? payee;

  /// Billing address information for Payee.
  final BillingAddress? payeeBillingAddress;

  /// Extra-parameters required for specific payment method
  final Map<String, dynamic>? parameters;

  /// Custom data
  final Map<String, dynamic>? customData;

  OpenPaymentPlatformRequest({
    required this.operation,
    required this.successUrl,
    required this.order,
    this.methods,
    this.channelId,
    this.sessionExpiry,
    this.cancelUrl,
    this.expiryUrl,
    this.errorUrl,
    this.urlTarget,
    this.reqToken,
    this.cardToken,
    this.formId,
    this.recurringInit,
    this.scheduleId,
    this.vatCalc,
    this.customer,
    this.billingAddress,
    this.payee,
    this.payeeBillingAddress,
    this.parameters,
    this.customData,
  });

  /// Converts the `OpenPaymentPlatformRequest` instance to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'operation': operation.name,
      'success_url': successUrl,
      if (methods != null) 'methods': methods,
      if (channelId != null) 'channel_id': channelId,
      if (sessionExpiry != null) 'session_expiry': sessionExpiry,
      if (cancelUrl != null) 'cancel_url': cancelUrl,
      if (expiryUrl != null) 'expiry_url': expiryUrl,
      if (errorUrl != null) 'error_url': errorUrl,
      if (urlTarget != null) 'url_target': urlTarget,
      if (reqToken != null) 'req_token': reqToken,
      if (cardToken != null) 'card_token': cardToken,
      if (formId != null) 'form_id': formId,
      if (recurringInit != null) 'recurring_init': recurringInit,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (vatCalc != null) 'vat_calc': vatCalc,
      'order': order.toJson(),
      if (customer != null) 'customer': customer!.toJson(),
      if (billingAddress != null) 'billing_address': billingAddress!.toJson(),
      if (payee != null) 'payee': payee,
      if (payeeBillingAddress != null)
        'payee_billing_address': payeeBillingAddress,
      if (parameters != null) 'parameters': parameters,
      if (customData != null) 'custom_data': customData,
    };
  }
}
