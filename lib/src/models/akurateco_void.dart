
import 'package:akurateco_flutter/akurateco_flutter.dart';

/// A model class representing the result of a void payment operation.
///
/// This class encapsulates the details of a void payment, including the payment status,
/// payment ID, date of the operation, reason for the void, and the associated order details.
class AkuratecoVoid {
  /// The status of the payment after the void operation.
  final PaymentStatus status;

  /// The unique identifier of the payment.
  final String paymentId;

  /// The date and time when the void operation was performed.
  final DateTime date;

  /// The reason for the void operation (optional).
  final String? reason;

  /// The order details associated with the void payment.
  final AkuratecoOrder order;

  /// Creates an instance of `AkuratecoVoid`.
  ///
  /// - [status]: The status of the payment after the void operation.
  /// - [paymentId]: The unique identifier of the payment.
  /// - [date]: The date and time when the void operation was performed.
  /// - [reason]: The reason for the void operation (optional).
  /// - [order]: The order details associated with the void payment.
  AkuratecoVoid({
    required this.status,
    required this.paymentId,
    required this.date,
    required this.reason,
    required this.order,
  });

  /// Creates an `AkuratecoVoid` instance from a JSON map.
  ///
  /// This factory constructor parses the provided JSON map to initialize
  /// an `AkuratecoVoid` object.
  ///
  /// - [json]: A `Map<String, dynamic>` containing the void payment data.
  /// - Returns: An `AkuratecoVoid` instance.
  factory AkuratecoVoid.fromJson(Map<String, dynamic> json) {
    return AkuratecoVoid(
      status: stringToStatus(json['status']),
      paymentId: json['payment_id'],
      date: DateTime.parse(json['date']),
      reason: json['reason'],
      order: AkuratecoOrder.fromJson(json['order']),
    );
  }

  /// Converts the `AkuratecoVoid` instance to a JSON-compatible map.
  ///
  /// This method serializes the void payment details into a map that can be
  /// used for JSON encoding.
  ///
  /// - Returns: A `Map<String, dynamic>` representing the serialized void payment.
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
