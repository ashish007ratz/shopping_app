import 'package:hive_flutter/adapters.dart';

class _Storage {
  late Box auth;
  late Box data;

  bool isInitialized = false;

   init()async{
    if(isInitialized){
      await Hive.initFlutter();
      auth = await Hive.openBox("auth");
      data = await Hive.openBox("data_box");
      isInitialized = true;
    }
  }

  dispose()async{
    auth.close();
    data.close();
    isInitialized = false;
  }

}


_Storage storage = _Storage();