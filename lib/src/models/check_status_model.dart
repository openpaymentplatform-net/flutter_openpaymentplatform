import 'package:akurateco_flutter/akurateco_flutter.dart';

  /// A model class representing the result of a payment status check.
  ///
  /// This class encapsulates the details of a payment status, including the payment ID,
  /// date, status, reason for the status, recurring token, schedule ID, order details,
  /// and customer information.
  final class CheckStatusResult {
    /// The unique identifier of the payment.
    final String paymentId;

    /// The date and time when the payment status was checked.
    final DateTime date;

    /// The current status of the payment.
    final PaymentStatus status;

    /// The reason for the current payment status (optional).
    final String? reason;

    /// The recurring token associated with the payment (optional).
    final String? recurringToken;

    /// The schedule ID for recurring payments (optional).
    final String? sheduleId;

    /// The order details associated with the payment.
    final AkuratecoOrder order;

    /// The customer information associated with the payment (optional).
    final Customer? customer;

    /// Creates an instance of `CheckStatusResult`.
    ///
    /// - [paymentId]: The unique identifier of the payment.
    /// - [date]: The date and time when the payment status was checked.
    /// - [status]: The current status of the payment.
    /// - [reason]: The reason for the current payment status (optional).
    /// - [recurringToken]: The recurring token associated with the payment (optional).
    /// - [sheduleId]: The schedule ID for recurring payments (optional).
    /// - [order]: The order details associated with the payment.
    /// - [customer]: The customer information associated with the payment (optional).
    CheckStatusResult({
      required this.paymentId,
      required this.date,
      required this.status,
      required this.reason,
      this.recurringToken,
      this.sheduleId,
      required this.order,
      this.customer,
    });

    /// Creates a `CheckStatusResult` instance from a JSON map.
    ///
    /// This factory constructor parses the provided JSON map to initialize
    /// a `CheckStatusResult` object.
    ///
    /// - [json]: A `Map<String, dynamic>` containing the payment status data.
    /// - Returns: A `CheckStatusResult` instance.
    factory CheckStatusResult.fromJson(Map<String, dynamic> json) {
      return CheckStatusResult(
        paymentId: json['payment_id'],
        date: DateTime.parse(json['date']),
        status: stringToStatus(json['status']),
        reason: json['reason'],
        recurringToken: json['recurring_token'],
        sheduleId: json['schedule_id'],
        order: AkuratecoOrder.fromJson(json['order']),
        customer:
            json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      );
    }

    /// Converts the `CheckStatusResult` instance to a JSON-compatible map.
    ///
    /// This method serializes the payment status details into a map that can be
    /// used for JSON encoding.
    ///
    /// - Returns: A `Map<String, dynamic>` representing the serialized payment status.
    Map<String, dynamic> toJson() {
      return {
        'payment_id': paymentId,
        'date': date.toIso8601String(),
        'status': statusToString(status),
        'reason': reason,
        'recurring_token': recurringToken,
        'schedule_id': sheduleId,
        'order': order.toJson(),
        if (customer != null) 'customer': customer!.toJson(),
      };
    }
  }