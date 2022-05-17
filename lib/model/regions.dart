class Region {
  final int? regionID;
  final String? county;
  final String? state;

  const Region({this.regionID, this.county, this.state});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      regionID: json['id'] as int,
      county: json['country'],
      state: json['State'],
    );
  }
}
