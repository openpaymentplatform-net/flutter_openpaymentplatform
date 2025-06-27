/// A model class representing a payee in the checkout system.
///
/// This class encapsulates the details of a payee, including their name
/// and an optional email address.
class Payee {
  /// The name of the payee.
  final String name;

  /// The email address of the payee (optional).
  final String? email;

  /// Creates an instance of `Payee`.
  ///
  /// - [name]: The name of the payee.
  /// - [email]: The email address of the payee (optional).
  Payee({required this.name, this.email});

  /// Creates a `Payee` instance from a JSON map.
  ///
  /// This factory constructor parses the provided JSON map to initialize
  /// a `Payee` object.
  ///
  /// - [json]: A `Map<String, dynamic>` containing the payee data.
  /// - Returns: A `Payee` instance.
  factory Payee.fromJson(Map<String, dynamic> json) {
    return Payee(
      name: json['name'],
      email: json['email'],
    );
  }

  /// Converts the `Payee` instance to a JSON-compatible map.
  ///
  /// This method serializes the payee details into a map that can be
  /// used for JSON encoding.
  ///
  /// - Returns: A `Map<String, dynamic>` representing the serialized payee.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}