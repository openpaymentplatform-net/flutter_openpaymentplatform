/// A model class representing an order in the OpenPaymentPlatform system.
///
/// This class encapsulates the details of an order, including its number, amount,
/// currency, and description.
class OpenPaymentPlatformOrder {
  ///Required
  /// max: 255
  /// [a-z A-Z 0-9 -!"#$%&'()*+,./:;&@]
  /// Order ID
  /// Example: order-1234
  final String number;

  /// Required
  /// Greater then 0
  /// [0-9]
  /// max: 255
  /// Format depends on currency.
  /// Send Integer type value for currencies with zero-exponent. Example: 1000
  /// Send Float type value for currencies with exponents 2, 3, 4.
  /// Format for 2-exponent currencies: XX.XX Example: 100.99
  /// Pay attention that currencies 'UGX', 'JPY', 'KRW', 'CLP' must be send
  /// in the format XX.XX, with the zeros after comma. Example: 100.00
  /// Format for 3-exponent currencies: XXX.XXX Example: 100.999.
  /// Format for 4-exponent currencies: XXX.XXXX Example: 100.9999
  /// ⚠️ Note! For crypto currencies use the exponent as appropriate for
  /// the specific currency.
  /// For purchase operation with crypto:
  /// Do not send parameter at all if you want to create a transaction with
  /// an unknown amount - for cases when the amount is set by the payer outside
  /// the merchant site (for example, in an app). As well, you have to omit
  /// "amount" parameter for hash calculation for such cases.
  /// For transfer operation:
  /// Send amount if you want to show default value in the amount field on
  /// the Checkout. The customers can change the value manually on the payment
  /// form.Send "-1" value if you want to show empty amount field on
  /// the Checkout so that the Customers could enter the value manually.
  final String amount;

  /// The currency of the order, represented as a 3-6 character code
  /// (e.g., USD, EUR).
  final String currency;

  /// A description of the order.
  final String description;

  /// Creates an instance of `OpenPaymentPlatformOrder`.
  const OpenPaymentPlatformOrder({
    required this.number,
    required this.amount,
    required this.currency,
    required this.description,
  });

  /// Creates an `OpenPaymentPlatformOrder` instance from a JSON map.
  factory OpenPaymentPlatformOrder.fromJson(Map<String, dynamic> json) =>
      OpenPaymentPlatformOrder(
        number: json['number'],
        amount: json['amount'],
        currency: json['currency'],
        description: json['description'],
      );

  /// Converts the `OpenPaymentPlatformOrder` instance to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'number': number,
        'amount': amount,
        'currency': currency,
        'description': description,
      };

  /// Validates the order details.
  bool isValid() {
    final numberValid = number.isNotEmpty && number.length <= 255;

    final amountValid =
        double.tryParse(amount) != null &&
        double.parse(amount) > 0 &&
        amount.length <= 255;

    final currencyValid = RegExp(r'^[A-Z]{3,6}$').hasMatch(currency);

    final descriptionValid =
        description.length >= 2 && description.length <= 1024;

    return numberValid && amountValid && currencyValid && descriptionValid;
  }
}
