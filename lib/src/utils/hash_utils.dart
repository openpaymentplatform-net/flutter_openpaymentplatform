import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../models/openpaymentplatform_order.dart';

/// Utility class for generating secure hashes for various OpenPaymentPlatform operations.
///
/// This class provides static methods to generate hashes for checkout, payment ID,
/// and refund operations. The generated hashes are used for secure communication
/// with the OpenPaymentPlatform backend.
final class OpenPaymentPlatformHashUtils {
  /// Generates a hash for the checkout operation.
  ///
  /// This method combines the order details and password, converts the result to uppercase,
  /// and applies MD5 and SHA-1 hashing to generate a secure hash.
  ///
  /// - [order]: The `OpenPaymentPlatformOrder` object containing order details.
  /// - [password]: The password used for hashing.
  /// - Returns: A `String` representing the generated hash.
  static String generateCheckoutHash({
    required OpenPaymentPlatformOrder order,
    required String password,
  }) {
    final toMd5 = order.number +
        order.amount +
        order.currency +
        order.description +
        password;

    return _generateHash(toMd5);
  }

  /// Generates a hash for the payment ID operation.
  static String generatePaymentIdHash({
    required String id,
    required String password,
  }) {
    final toMd5 = id + password;
    return _generateHash(toMd5);
  }

  /// Generates a hash for the refund operation.
  static String generateRefundHash({
    required String paymentId,
    required String amount,
    required String password,
  }) {
    final toMd5 = paymentId + amount + password;
    return _generateHash(toMd5);
  }

  static String _generateHash(String toMd5) {
    final upper = toMd5.toUpperCase();
    final md5Hex = md5
        .convert(utf8.encode(upper))
        .bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    final sha1Digest = sha1.convert(utf8.encode(md5Hex));
    final result =
        sha1Digest.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return result;
  }
}
