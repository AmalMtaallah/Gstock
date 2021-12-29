import 'package:flutter/material.dart';
import 'package:projet/Comm/comHelper.dart';
import 'package:projet/Comm/getTextFormFiled.dart';
import 'package:projet/DatabaseHandler/DbHelper.dart';
import 'package:projet/Model/Admin.dart';
import 'package:projet/Screens/LoginForm.dart';
import 'package:toast/toast.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();
  final _conEmail = TextEditingController();
  final _conUserName = TextEditingController();
  final _conCPassword = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  signUp() async {
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String passwd = _conPassword.text;
    String cpasswd = _conCPassword.text;
    if (_formKey.currentState!.validate()) {
      /* if (passwd != cpasswd) {
      alertDialog(context, 'Password Mismatch');
    }else{*/
      _formKey.currentState!.save();
      Admin uModel = Admin(uname, email, passwd);
      await dbHelper.saveData(uModel).then((userData) {
        alertDialog(context, 'Successfully saved');
      }).catchError((error) {
        print(error);
        alertDialog(context, 'Error Data Fail');
      });
    }

    /*if (_formKey.currentState.validate()) {
   if (passwd != cpasswd) {
      alertDialog(context, 'Password Mismatch');
    print('ff');
    }else {
      _formKey.currentState!.save();
      UserModel uModel= UserModel(uid, uname, email, passwd);
      dbHelper.saveData(uModel);
      alertDialog(context, 'Successfully saved');
    }
  }
*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.0),
                  Text(
                    'Sign Up',
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
                    controller: _conUserName,
                    icon: Icons.person_outline,
                    inputType: TextInputType.name,
                    hintName: 'User Name',
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conEmail,
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    hintName: 'Email',
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conPassword,
                    icon: Icons.lock,
                    hintName: 'Password',
                    isObscureText: true,
                  ),
                  SizedBox(height: 5.0),
                  getTextFormField(
                    controller: _conCPassword,
                    icon: Icons.lock,
                    hintName: 'Confirm Password',
                    isObscureText: true,
                  ),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: signUp,
                      child: Text(
                        'Sign Up',
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
                        Text("Do you have account?"),
                        FlatButton(
                          textColor: Colors.blue,
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => LoginForm()),
                                (Route<dynamic> route) => false);
                          },
                          child: Text('Sign In'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
