/// A model class representing an order in the Akurateco system.
///
/// This class encapsulates the details of an order, including its number, amount,
/// currency, and description.
class AkuratecoOrder {
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

  /// Creates an instance of `AkuratecoOrder`.
  ///
  /// - [number]: The unique identifier of the order.
  /// - [amount]: The total amount of the order.
  /// - [currency]: The currency of the order.
  /// - [description]: A description of the order.
  const AkuratecoOrder({
    required this.number,
    required this.amount,
    required this.currency,
    required this.description,
  });

  /// Creates an `AkuratecoOrder` instance from a JSON map.
  ///
  /// This factory constructor parses the provided JSON map to initialize
  /// an `AkuratecoOrder` object.
  ///
  /// - [json]: A `Map<String, dynamic>` containing the order data.
  /// - Returns: An `AkuratecoOrder` instance.
  factory AkuratecoOrder.fromJson(Map<String, dynamic> json) => AkuratecoOrder(
    number: json['number'],
    amount: json['amount'],
    currency: json['currency'],
    description: json['description'],
  );

  /// Converts the `AkuratecoOrder` instance to a JSON-compatible map.
  ///
  /// This method serializes the order details into a map that can be
  /// used for JSON encoding.
  ///
  /// - Returns: A `Map<String, dynamic>` representing the serialized order.
  Map<String, dynamic> toJson() => {
    'number': number,
    'amount': amount,
    'currency': currency,
    'description': description,
  };

  /// Validates the order details.
  ///
  /// This method checks if the order details meet the required criteria:
  /// - `number` must be non-empty and have a maximum length of 255 characters.
  /// - `amount` must be a valid positive number and have a maximum length of 255 characters.
  /// - `currency` must match the pattern for 3-6 uppercase letters.
  /// - `description` must have a length between 2 and 1024 characters.
  ///
  /// - Returns: `true` if all details are valid, otherwise `false`.
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
