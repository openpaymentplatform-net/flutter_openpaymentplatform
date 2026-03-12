import 'enums.dart';

import 'openpaymentplatform_order.dart';

/// A model class representing the result of a void payment operation.
///
/// This class encapsulates the details of a void payment, including the payment status,
/// payment ID, date of the operation, reason for the void, and the associated order details.
class OpenPaymentPlatformVoid {
  /// The status of the payment after the void operation.
  final PaymentStatus status;

  /// The unique identifier of the payment.
  final String paymentId;

  /// The date and time when the void operation was performed.
  final DateTime date;

  /// The reason for the void operation (optional).
  final String? reason;

  /// The order details associated with the void payment.
  final OpenPaymentPlatformOrder order;

  /// Creates an instance of `OpenPaymentPlatformVoid`.
  OpenPaymentPlatformVoid({
    required this.status,
    required this.paymentId,
    required this.date,
    required this.reason,
    required this.order,
  });

  /// Creates an `OpenPaymentPlatformVoid` instance from a JSON map.
  factory OpenPaymentPlatformVoid.fromJson(Map<String, dynamic> json) {
    return OpenPaymentPlatformVoid(
      status: stringToStatus(json['status']),
      paymentId: json['payment_id'],
      date: DateTime.parse(json['date']),
      reason: json['reason'],
      order: OpenPaymentPlatformOrder.fromJson(json['order']),
    );
  }

  /// Converts the `OpenPaymentPlatformVoid` instance to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'status': statusToString(status),
      'payment_id': paymentId,
      'date': date.toIso8601String(),
      'reason': reason,
      'order': order.toJson(),
    };
  }
}
