import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/models/auth.dart';


class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  late String userName;
  late String password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'User name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // keyboardType: TextIn,
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return 'Please enter your Phone number';
                    if (value!.length < 5)
                      return "Phone number must be greater than 5";
                    return null;
                  },
                  onSaved: (value) => setState(() => userName = value!),
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? false)
                      return 'Please enter your password';
                    else
                      return null;
                  },
                  onSaved: (value) => setState(() => password = value!),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: (){},
                  child: Text(
                    'Don\'t have an account? Click here.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                /// stop  tab when already loading
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    isLoading = true;
                    setState(() {});
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await logInUser();
                    }
                    isLoading = false;
                    setState(() {});
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(isLoading ? "Signing..." : 'Sign In'),
                      if (isLoading) ...[
                        SizedBox(width: 20),
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  logInUser() async {
  await LoginUser(userName, password).SendData().then((value){
    if(value is Response && value.statusCode == 200) {
      value.data;

    }
    else{
      isLoading = false;
      setState(() {});
      throw "false credentials";
    }

  }).onError((error, stackTrace) {
    isLoading = false;
    setState(() {});
  });
  }
}
