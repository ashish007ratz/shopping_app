import 'dart:convert';
import 'package:shopping_app/models/base.dart';

class UserModel extends BaseModel{
   int? id;
   String? email;
   String? username;
   String? password;
   Name? name;
   Address? address;
   String? phone;

  UserModel({
     this.id,
     this.email,
     this.username,
     this.password,
     this.name,
     this.address,
     this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      name: Name.fromJson(json['name'] as Map<String, dynamic>),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'name': name?.toJson(),
      'address': address?.toJson(),
      'phone': phone,
    };
  }

  static Future<List<UserModel>> fetchUsers() async {
    final response = await UserModel().List();
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List;
      return jsonList.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  static Future<UserModel> fetchUser(int userId) async {
    final response = await UserModel().GetData();
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch user');
    }
  }
}

class Name {
  final String firstname;
  final String lastname;

  Name({
    required this.firstname,
    required this.lastname,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}

class Address {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final Geolocation geolocation;

  Address({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolocation,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] as String,
      street: json['street'] as String,
      number: json['number'] as int,
      zipcode: json['zipcode'] as String,
      geolocation: Geolocation.fromJson(json['geolocation'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'number': number,
      'zipcode': zipcode,
      'geolocation': geolocation.toJson(),
    };
  }
}

class Geolocation {
  final double latitude;
  final double longitude;

  Geolocation({
    required this.latitude,
    required this.longitude,
  });

  factory Geolocation.fromJson(Map<String, dynamic> json) {
    return Geolocation(
      latitude: double.parse(json['lat'] as String),
      longitude: double.parse(json['long'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude.toString(),
      'long': longitude.toString(),
    };
  }
}