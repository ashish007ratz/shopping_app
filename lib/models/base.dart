import 'package:shopping_app/models/http.dart';

class BaseModel {
 String endPoint = "";
 String listEndPoint = "";

 Map<String,dynamic> toJson()=>{};


 /// send data to server
 Future SendData({Map<String, String>? qp}) async {
   return http.PostData(this.endPoint,body: this.toJson());
 }

 /// Get data from server
 Future GetData({Map<String, String>? qp}) async {
   return http.GetData(this.endPoint);
 }
 /// Get data from server
 Future List({Map<String, String>? qp}) async {
   return http.GetData(this.listEndPoint);
 }

}
