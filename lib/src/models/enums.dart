/// Enum representing the various statuses a payment can have.
      ///
      /// The `PaymentStatus` enum is used to define the possible states of a payment
      /// during its lifecycle, such as preparation, settlement, or refund.
      enum PaymentStatus {
        /// The payment is being prepared.
        prepare,

        /// The payment has been successfully settled.
        settled,

        /// The payment is pending and awaiting further action.
        pending,

        /// The payment requires 3D Secure authentication.
        require3ds,

        /// The payment requires a redirect to an external page.
        redirect,

        /// The payment has been declined.
        decline,

        /// The payment has been refunded.
        refund,

        /// The payment has been reversed.
        reversal,

        /// The payment has been voided.
        voided,

        /// The payment has resulted in a chargeback.
        chargeback,
      }

      /// Converts a `PaymentStatus` enum value to its corresponding string representation.
      ///
      /// This function maps each `PaymentStatus` value to a specific string that
      /// represents the status in a human-readable format.
      ///
      /// - [status]: The `PaymentStatus` value to convert.
      /// - Returns: A `String` representing the status.
      String statusToString(PaymentStatus status) {
        switch (status) {
          case PaymentStatus.prepare:
            return 'prepare';
          case PaymentStatus.settled:
            return 'settled';
          case PaymentStatus.pending:
            return 'pending';
          case PaymentStatus.require3ds:
            return '3ds';
          case PaymentStatus.redirect:
            return 'redirect';
          case PaymentStatus.decline:
            return 'decline';
          case PaymentStatus.refund:
            return 'refund';
          case PaymentStatus.reversal:
            return 'reversal';
          case PaymentStatus.voided:
            return 'void';
          case PaymentStatus.chargeback:
            return 'chargeback';
        }
      }

      /// Converts a string representation of a payment status to its corresponding `PaymentStatus` enum value.
      ///
      /// This function maps a string to the appropriate `PaymentStatus` value. If the string
      /// does not match any known status, an exception is thrown.
      ///
      /// - [status]: The string representation of the payment status.
      /// - Returns: The corresponding `PaymentStatus` enum value.
      /// - Throws: An `Exception` if the string does not match any known status.
      PaymentStatus stringToStatus(String status) {
        switch (status) {
          case 'prepare':
            return PaymentStatus.prepare;
          case 'settled':
            return PaymentStatus.settled;
          case 'pending':
            return PaymentStatus.pending;
          case '3ds':
            return PaymentStatus.require3ds;
          case 'redirect':
            return PaymentStatus.redirect;
          case 'decline':
            return PaymentStatus.decline;
          case 'refund':
            return PaymentStatus.refund;
          case 'reversal':
            return PaymentStatus.reversal;
          case 'void':
            return PaymentStatus.voided;
          case 'chargeback':
            return PaymentStatus.chargeback;
          default:
            throw Exception('Unknown status: $status');
        }
      }