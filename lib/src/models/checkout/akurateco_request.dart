import 'package:akurateco_flutter/akurateco_flutter.dart';

import '../akurateco_order.dart';
import '../customer.dart';
import 'billing_address.dart';

/// Enum representing the types of operations that can be performed in the Akurateco system.
enum AkuratecoOperation {
  /// Represents a purchase operation.
  purchase,

  /// Represents a debit operation.
  debit,

  /// Represents a transfer operation.
  transfer,
}

/// A model class representing a request in the Akurateco checkout system.
///
/// This class encapsulates the details of a payment request, including the operation type,
/// URLs for various payment outcomes, order details, customer information, billing addresses,
/// and additional parameters.
/// - [operation]: The type of operation to be performed.
/// - [successUrl]: The URL to redirect the user to upon successful payment.
/// - [order]: The order details for the payment.
/// - [methods]: A list of payment methods to be used (optional).
/// - [channelId]: The channel ID for the payment request (optional).
/// - [sessionExpiry]: The session expiry time in seconds (optional).
/// - [cancelUrl]: The URL to redirect the user to if the payment is canceled (optional).
/// - [expiryUrl]: The URL to redirect the user to if the payment expires (optional).
/// - [errorUrl]: The URL to redirect the user to if an error occurs (optional).
/// - [urlTarget]: The target for opening the URL (optional).
/// - [reqToken]: Indicates whether a token is required (optional).
/// - [cardToken]: A list of card tokens to be used (optional).
/// - [formId]: The unique identifier for the payment form (optional).
/// - [recurringInit]: Indicates whether this is a recurring payment initialization (optional).
/// - [scheduleId]: The schedule ID for recurring payments (optional).
/// - [vatCalc]: Indicates whether VAT calculation is required (optional).
/// - [customer]: The customer information (optional).
/// - [billingAddress]: The billing address of the customer (optional).
/// - [payee]: The payee information (optional).
/// - [payeeBillingAddress]: The billing address of the payee (optional).
/// - [parameters]: Additional parameters for the payment request (optional).
/// - [customData]: Custom data to be included in the payment request (optional).
class AkuratecoRequest {
  /// Defines a payment transaction
  /// Possible values: purchase, debit, transfer
  /// Send the “purchase” value so that the payment page for sale initiation will be shown to the customer.
  /// Send the “debit” value so that the payment page for debit initiation will be shown to the customer.
  /// Send the “transfer” value so that the payment page for transfer initiation will be shown to the customer.
  /// Example: purchase
  final AkuratecoOperation operation;

  /// Required
  /// Valid URL
  /// max: 1024
  /// URL to redirect the Customer in case of the successful payment
  /// Example: https://example.domain.com/success
  /// The return of additional parameters can be configured for success_url. See the “Customer return after payment” section for details.
  final String successUrl;

  /// An array of payment methods. Limits the available methods on the Checkout page (the list of the possible values in the Payment methods section). In the case of parameter absence, the pre-routing rules are applied. If pre-routing rules are not configured, all available payment methods are displayed.
  /// Condition: for purchase operation only
  /// For purchase and debit operations.
  /// Example: card, paypal, googlepay
  final List<String>? methods;

  /// Optional
  /// max: 16
  /// This parameter is used to direct payments to a specific sub-account (channel).
  /// If the channel is configured for Merchant Mapping, the system matches the value with the corresponding channel_id value in the request to route the payment.
  ///
  /// Note: The channel must correspond to one of the payment methods (brands) listed in the methods array. If the methods array is empty, only the channel_id will affect the selection of the payment method (Merchant Mapping).
  final String? channelId;

  /// Optional
  /// Values from 1 to 720 min
  /// Session expiration time in minutes.
  /// Default value = 60.
  /// Could not be zero.
  /// Example: 60
  final int? sessionExpiry;

  /// Optional
  /// Valid URL
  /// min: 0 max: 1024
  /// URL to return Customer in case of a payment cancellation (“Close” button on the Checkout page). The logic of redirection on “cancel_url” could be configured in the admin panel (Configuration -> Protocol Mappings section): use the “Maximum count declines” field to set the payment failed attempts quantity before redirection. For example, if the field value is set to "1", then after the first declined attempt, a payer will be redirected to "cancel_url."
  /// Example: https://example.domain.com/cancel
  /// The return of additional parameters can be configured for cancel_url. See the “Customer return after payment” section for details.
  final String? cancelUrl;

  /// Optional
  /// Valid URL
  /// min: 0 max: 1024
  /// URL where the payer will be redirected in case of session expiration
  /// Example: https://example.domain.com/expiry
  final String? expiryUrl;

  /// Optional
  /// Valid URL
  /// min: 0 max: 1024
  /// URL to return Customer in case of undefined transaction status.
  /// If the URL is not specified, the cancel_url is used for redirection.
  /// Example: https://example.domain.com/errorurl
  final String? errorUrl;

  /// Optional
  /// Possible values: _self, _parent, _top.
  /// Find the result of applying the values in the HTML standard description
  /// Name of, or keyword for a browsing context where Customer should be returned according to HTML specification.
  /// Example: _parent  final String? urlTarget;
  String? urlTarget;

  /// Optional
  /// default - false
  /// Special attribute pointing for further tokenization
  /// If the card_token is specified, req_token will be ignored.
  /// For purchase and debit operations.
  /// Example: false
  final bool? reqToken;

  /// Optional
  /// String 64 characters
  /// Credit card token value
  /// For purchase and debit operations.
  /// Example: f5d6a0ab6fcfb6487a39e2256e50fff3c95aaa97

  final List<String>? cardToken;

  /// After developing the payment form, it is necessary to send the project archive, including the source code and all used files, to the manager for review, security testing and placement on the platform resources.
  /// The payment form will be assigned a unique identifier that should be used in Checkout Authentication Request to display this payment form to customers:
  /// {"form_id": "xxxxx-xxxxx-xxxxx"}
  final String? formId;

  /// Optional
  /// default - false
  /// Initialization of the transaction with possible following recurring
  /// Only for purchase operation
  /// Example: true
  final bool? recurringInit;

  /// Optional
  /// It s available when recurring_init = true
  /// Schedule ID for recurring payments
  /// Only for purchase operation
  /// Example: 57fddecf-17b9-4d38-9320-a670f0c29ec0
  final String? scheduleId;

  /// Conditional
  /// true or false
  /// default - false
  /// Indicates the need of calculation for the VAT amount
  /// • 'true' - if VAT calculation needed
  /// • 'false' - if VAT should not be calculated for current payment.
  /// Only for purchase operation
  /// Example: false
  final bool? vatCalc;

  /// Required
  /// Information about an order
  final AkuratecoOrder order;

  /// Conditional
  /// Customer's information. Send an object if a payment method needs
  final Customer? customer;

  /// Conditional
  /// Billing address information.
  /// Condition: If the object or some object's
  /// parameters are NOT specified in the request,
  /// then it will be displayed on the Checkout page (if a payment method needs)
  final BillingAddress? billingAddress;

  /// Conditional
  /// Payee's information.
  /// Specify additional information about Payee for transfer operation
  /// if it is required by payment provider.
  final Payee? payee;

  /// Conditional
  /// Billing address information for Payee.
  final BillingAddress? payeeBillingAddress;

  /// Optional
  /// Extra-parameters required for specific payment method
  /// Example:
  /// "parameters": { "payment_method": { "param1":"val1", "param2":"val2" } }
  final Map<String, dynamic>? parameters;

  /// Optional
  /// Custom data
  /// This block can contain arbitrary data, which will be returned in the callback.
  /// Example:
  /// “custom_data”: {“param1”:”value1”, “param2”:”value2”, “param3”:”value3”}
  final Map<String, dynamic>? customData;

  /// Creates an a copy of `AkuratecoRequest`.
  AkuratecoRequest({
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

  /// Converts the `AkuratecoRequest` instance to a JSON-compatible map.
  ///
  /// This method serializes the request details into a map that can be
  /// used for JSON encoding.
  ///
  /// - Returns: A `Map<String, dynamic>` representing the serialized request.
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
