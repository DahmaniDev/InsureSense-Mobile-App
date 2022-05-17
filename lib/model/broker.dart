class Broker {
  final int? brokerID;
  final String? fullName;

  const Broker({this.brokerID, this.fullName});

  factory Broker.fromJson(Map<String, dynamic> json) {
    return Broker(
      brokerID: json['BrokerID'] as int,
      fullName: json['BrokerFullName'],
    );
  }
}
