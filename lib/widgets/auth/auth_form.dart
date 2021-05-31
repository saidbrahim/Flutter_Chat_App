import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function(String email, String password, String username, File image,
      bool isLogin, BuildContext ctx) submitFuc;
  final bool isLoading;

  AuthForm(this.submitFuc, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _username = "";
  String _password = "";
  String _email = "";
  File _userImageFile;

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!_isLogin && _userImageFile == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please enter an image"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFuc(_email.trim(), _password.trim(), _username.trim(),
          _userImageFile, _isLogin, context);
    }
  }

  void _pickImage(File pickedImage) {
    setState(() {
      _userImageFile = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(_pickImage),
                TextFormField(
                  key: ValueKey('email'),
                  validator: (val) {
                    if (val.isEmpty || !val.contains("@")) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                  onSaved: (val) => _email = val,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address"),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey("username"),
                    validator: (val) {
                      if (val.isEmpty || val.length < 4) {
                        return "Please enter at least 4 characters";
                      }
                      return null;
                    },
                    onSaved: (val) => _username = val,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                TextFormField(
                  key: ValueKey("password"),
                  validator: (val) {
                    if (val.isEmpty || val.length < 7) {
                      return "Please enter at least 7 characters";
                    }
                    return null;
                  },
                  onSaved: (val) => _password = val,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  RaisedButton(
                    onPressed: _submit,
                    child: Text(_isLogin ? "Login" : "Sign Up"),
                  ),
                if (!widget.isLoading)
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? "Create a new account"
                        : "I already have an account"),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
