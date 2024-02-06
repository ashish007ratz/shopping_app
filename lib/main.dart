import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/bloc/product/bloc.dart';
import 'package:shopping_app/screens/app_init.dart';
import 'bloc/cart/bloc.dart';
import 'bloc/liked/bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
      providers: [
        BlocProvider(create: (BuildContext context) => ProductsBloc()),
        BlocProvider(create: (BuildContext context) => ProductBloc()),
        BlocProvider(create: (BuildContext context) => FavBloc()),
        BlocProvider(create: (BuildContext context) => CartBloc()),
      ],
    );
  }
}
