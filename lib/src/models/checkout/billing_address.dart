/// A model class representing a billing address in the checkout system.
    ///
    /// This class encapsulates the details of a billing address, including the country,
    /// state, city, district, address, house number, zip code, and phone number.
    class BillingAddress {
      /// The country of the billing address.
      final String country;

      /// The state or region of the billing address.
      final String state;

      /// The city of the billing address.
      final String city;

      /// The district or area of the billing address.
      final String district;

      /// The street address of the billing address.
      final String address;

      /// The house or building number of the billing address.
      final String houseNumber;

      /// The zip or postal code of the billing address.
      final String zip;

      /// The phone number associated with the billing address.
      final String phone;

      /// Creates an instance of `BillingAddress`.
      ///
      /// - [country]: The country of the billing address.
      /// - [state]: The state or region of the billing address.
      /// - [city]: The city of the billing address.
      /// - [district]: The district or area of the billing address.
      /// - [address]: The street address of the billing address.
      /// - [houseNumber]: The house or building number of the billing address.
      /// - [zip]: The zip or postal code of the billing address.
      /// - [phone]: The phone number associated with the billing address.
      const BillingAddress({
        required this.country,
        required this.state,
        required this.city,
        required this.district,
        required this.address,
        required this.houseNumber,
        required this.zip,
        required this.phone,
      });

      /// Creates a `BillingAddress` instance from a JSON map.
      ///
      /// This factory constructor parses the provided JSON map to initialize
      /// a `BillingAddress` object.
      ///
      /// - [json]: A `Map<String, dynamic>` containing the billing address data.
      /// - Returns: A `BillingAddress` instance.
      factory BillingAddress.fromJson(Map<String, dynamic> json) => BillingAddress(
            country: json['country'],
            state: json['state'],
            city: json['city'],
            district: json['district'],
            address: json['address'],
            houseNumber: json['house_number'],
            zip: json['zip'],
            phone: json['phone'],
          );

      /// Converts the `BillingAddress` instance to a JSON-compatible map.
      ///
      /// This method serializes the billing address details into a map that can be
      /// used for JSON encoding.
      ///
      /// - Returns: A `Map<String, dynamic>` representing the serialized billing address.
      Map<String, dynamic> toJson() => {
            'country': country,
            'state': state,
            'city': city,
            'district': district,
            'address': address,
            'house_number': houseNumber,
            'zip': zip,
            'phone': phone,
          };
    }