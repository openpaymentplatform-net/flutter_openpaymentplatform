import 'dart:convert';

    import 'package:crypto/crypto.dart';

    import '../../akurateco_flutter.dart';

    /// Utility class for generating secure hashes for various Akurateco operations.
    ///
    /// This class provides static methods to generate hashes for checkout, payment ID,
    /// and refund operations. The generated hashes are used for secure communication
    /// with the Akurateco backend.
    final class AkuratecoHashUtils {
      /// Generates a hash for the checkout operation.
      ///
      /// This method combines the order details and password, converts the result to uppercase,
      /// and applies MD5 and SHA-1 hashing to generate a secure hash.
      ///
      /// - [order]: The `AkuratecoOrder` object containing order details.
      /// - [password]: The password used for hashing.
      /// - Returns: A `String` representing the generated hash.
      static String generateCheckoutHash({
        required AkuratecoOrder order,
        required String password,
      }) {
        var toMd5 =
            order.number +
            order.amount +
            order.currency +
            order.description +
            password;

        return _generateHash(toMd5);
      }

      /// Generates a hash for the payment ID operation.
      ///
      /// This method combines the payment ID and password, converts the result to uppercase,
      /// and applies MD5 and SHA-1 hashing to generate a secure hash.
      ///
      /// - [id]: The payment ID as a `String`.
      /// - [password]: The password used for hashing.
      /// - Returns: A `String` representing the generated hash.
      static String generatePaymentIdHash({
        required String id,
        required String password,
      }) {
        var toMd5 = id + password;
        return _generateHash(toMd5);
      }

      /// Generates a hash for the refund operation.
      ///
      /// This method combines the payment ID, amount, and password, converts the result to uppercase,
      /// and applies MD5 and SHA-1 hashing to generate a secure hash.
      ///
      /// - [paymentId]: The payment ID as a `String`.
      /// - [amount]: The refund amount as a `String`.
      /// - [password]: The password used for hashing.
      /// - Returns: A `String` representing the generated hash.
      static generateRefundHash({
        required String paymentId,
        required String amount,
        required String password,
      }) {
        var toMd5 = paymentId + amount + password;
        return _generateHash(toMd5);
      }

      /// Internal method to generate a hash using MD5 and SHA-1 algorithms.
      ///
      /// This method converts the input string to uppercase, applies MD5 hashing,
      /// and then applies SHA-1 hashing to the MD5 result to generate a secure hash.
      ///
      /// - [toMd5]: The input string to be hashed.
      /// - Returns: A `String` representing the final hash.
      static String _generateHash(String toMd5) {
        final upper = toMd5.toUpperCase();
        final md5Hex =
            md5
                .convert(utf8.encode(upper))
                .bytes
                .map((b) => b.toRadixString(16).padLeft(2, '0'))
                .join();
        final sha1Digest = sha1.convert(utf8.encode(md5Hex));
        var result =
            sha1Digest.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
        print(result);
        return result;
      }
    }