class Customer {
  final int? customerID;
  final String? lastName;
  final String? firstName;
  final DateTime? birthDate;
  final int? regionID;
  final int? profileID;

  const Customer(
      {this.customerID,
      this.lastName,
      this.firstName,
      this.birthDate,
      this.regionID,
      this.profileID});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerID: json['CustomerID'],
      lastName: json['LastName'],
      firstName: json['FirstName'],
      birthDate: DateTime.parse(json['BirthDate'].toString()),
      regionID: json['RegiondID'],
      profileID: json['ProfileID'],
    );
  }
}
