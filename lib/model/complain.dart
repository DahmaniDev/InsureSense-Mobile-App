class Complain {
  final int? complainID;
  final int? complainDateID;
  final int? completionDateID;
  final int? brokerID;
  final int? customerID;
  final int? productID;
  final int? categoryID;
  final int? handledBy;
  final int? complainDuration;
  final String? clientSatisfaction;

  const Complain({
    this.complainID,
    this.complainDateID,
    this.completionDateID,
    this.brokerID,
    this.customerID,
    this.productID,
    this.categoryID,
    this.handledBy,
    this.complainDuration,
    this.clientSatisfaction,
  });

  factory Complain.fromJson(Map<String, dynamic> json) {
    return Complain(
      complainID: json['ID'] as int,
      complainDateID: json['ComplainDateID'] as int,
      completionDateID: json['CompletionDateID'] as int,
      brokerID: json['BrokerID'] as int,
      customerID: json['CustomerID'] as int,
      productID: json['ProductID'] as int,
      categoryID: json['CategoryID'] as int,
      handledBy: json['Handled_by'] as int,
      complainDuration: int.parse(json['ComplainsDuration']),
      clientSatisfaction: json['ClientSatisfaction'] as String,
    );
  }
}
