/// A model class representing a customer in the Akurateco system.
///
/// This class encapsulates the customer's details, including their name, email,
/// and an optional digital wallet identifier.
final class Customer {
  /// The name of the customer.
  final String name;

  /// The email address of the customer.
  final String email;

  /// The digital wallet identifier of the customer (optional).
  final String? digitalWallet;

  /// Creates an instance of `Customer`.
  ///
  /// - [name]: The name of the customer.
  /// - [email]: The email address of the customer.
  /// - [digitalWallet]: The digital wallet identifier of the customer (optional).
  const Customer({
    required this.name,
    required this.email,
    this.digitalWallet,
  });

  /// Creates a `Customer` instance from a JSON map.
  ///
  /// This factory constructor parses the provided JSON map to initialize
  /// a `Customer` object.
  ///
  /// - [json]: A `Map<String, dynamic>` containing the customer data.
  /// - Returns: A `Customer` instance.
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        name: json['name'],
        email: json['email'],
        digitalWallet: json['digital_wallet'],
      );

  /// Converts the `Customer` instance to a JSON-compatible map.
  ///
  /// This method serializes the customer details into a map that can be
  /// used for JSON encoding.
  ///
  /// - Returns: A `Map<String, dynamic>` representing the serialized customer.
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        if (digitalWallet != null) 'digital_wallet': digitalWallet,
      };
}