import 'dart:convert';

class UserData {
  final String name;
  final String email;
  final String? avatar;

  UserData({required this.name, required this.email, required this.avatar});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserData other) {
    if (identical(this, other)) return true;

    return other.name == name && other.email == email && other.avatar == avatar;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ avatar.hashCode;
}
