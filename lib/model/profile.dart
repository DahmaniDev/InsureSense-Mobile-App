class Profile {
  final int? profileID;
  final String? type;
  final String? sexe;
  final String? age;
  final String? marital_status;

  const Profile(
      {this.profileID, this.type, this.sexe, this.age, this.marital_status});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        profileID: json['ProfileID'],
        type: json['Type'],
        sexe: json['Sexe'],
        age: json['Age'],
        marital_status: json['Marital_Status']);
  }
}
