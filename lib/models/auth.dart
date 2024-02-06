import 'package:shopping_app/Storage/Storage.dart';
import 'package:shopping_app/models/base.dart';

class LoginUser extends BaseModel{
  String endPoint = "https://fakestoreapi.com/auth/login";

  String userName;
  String password;

  LoginUser(this.userName,this.password);


  toJson()=>{
    "username":this.userName,
    "password": this.password,
  };
}

class UserToken{
  static String? get refreshToken => storage.auth.get(refreshKey, defaultValue: null);
  static DateTime ? get refreshUpdatedAt {
  var data = storage.auth. get (refreshTime, defaultValue: null);
  if(data != null) return DateTime.parse(data);
  else return null;
}

  static String? get authToken => storage.auth.get(authTokenKey, defaultValue: null);
  static DateTime ? get authUpdatedAt {
      var data = storage.auth.get(refreshTime, defaultValue: null);
      if(data != null) return DateTime.parse(data);
      else return null;
    }

  static String get refreshKey => "refresh_token";
  static String get authTokenKey => "auth_token";
  /// updated at time
  static String get refreshTime => "refresh_time";
  static String get authTime => "auth_time";

  static set setRefreshToken(String token){
    storage.auth.put(refreshKey, token);
    storage.auth.put(refreshTime, DateTime.now().toIso8601String());
  }
  static set setAuthToken(String token){
    storage.auth.put(authTokenKey, token);
    storage.auth.put(authTime, DateTime.now().toIso8601String());
  }
}