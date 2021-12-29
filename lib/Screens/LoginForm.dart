import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet/Comm/comHelper.dart';
import 'package:projet/Comm/getTextFormFiled.dart';
import 'package:projet/DatabaseHandler/DbHelper.dart';
import 'package:projet/Screens/SignupForm.dart';

import 'HomeForm.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = new GlobalKey<FormState>();
  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  login() async {
    String uid = _conUserId.text;
    String passwd = _conPassword.text;

    if (uid.isEmpty) {
      alertDialog(context, "Please Enter User Email");
    } else if (passwd.isEmpty) {
      alertDialog(context, "Please Enter Password");
    } else {
      await dbHelper.getLoginUser(uid, passwd).then((userData) {
        print(userData.email);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomeForm()),
            (Route<dynamic> route) => false);
      }).catchError((error) {
        print(error);
        alertDialog(context, 'Error Data Fail');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50.0),
                Text(
                  'Login',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 30.0),
                ),
                SizedBox(height: 10.0),
                Image.asset(
                  "assets/images/logo.png",
                  height: 150.50,
                  width: 150.50,
                ),
                SizedBox(height: 10.0),
                Text(
                  'GStock',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                      fontSize: 25.0),
                ),
                SizedBox(height: 10.0),
                getTextFormField(
                  controller: _conUserId,
                  icon: Icons.person,
                  hintName: 'Email',
                ),
                SizedBox(height: 5.0),
                getTextFormField(
                  controller: _conPassword,
                  icon: Icons.lock,
                  hintName: 'Password',
                  isObscureText: true,
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: login,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.blue,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Does not have account?"),
                      FlatButton(
                        textColor: Colors.blue,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => SignupForm()));
                        },
                        child: Text('Signup'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
