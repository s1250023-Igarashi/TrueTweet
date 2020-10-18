import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:true_tweet/widget/home.dart';
import 'package:true_tweet/widget/login.dart';
import 'package:true_tweet/model/twitterApiModel.dart';
import 'package:true_tweet/model/userModel.dart';

import '../userSession.dart';

class LoginState extends State<Login> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    String _username;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'username'),
              textInputAction: TextInputAction.next,
              onSaved: (value) {
                _username = value;
              },
            ),
            FlatButton(
              child: Text('Login'),
              color: Colors.blue,
              onPressed: () async {
                // get and save user id
                UserSession.setUserId(await TwitterApi.getUserId(_username));
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}