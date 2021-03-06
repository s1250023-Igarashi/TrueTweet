import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:true_tweet/widget/home.dart';
import 'package:true_tweet/widget/login.dart';
import 'package:true_tweet/model/twitterApiModel.dart';
import 'package:true_tweet/model/userModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../userSession.dart';

class LoginState extends State<Login> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    var auth = TwitterApi.createAuthorizationObject();
    var credentials;
    String verifier;

    auth.requestTemporaryCredentials('oob').then((res) async {
      credentials = res.credentials;
      if (await canLaunch(auth.getResourceOwnerAuthorizationURI(credentials.token))) {
        await launch(auth.getResourceOwnerAuthorizationURI(credentials.token));
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'PIN'),
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  verifier = value;
                },
              ),
            ),
            FlatButton(
              child: Text('Login',
                style: TextStyle(fontSize: 20),
              ),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              ),
              onPressed: () async {
                auth.requestTokenCredentials(credentials, verifier).then((res) {
                  UserSession().setAccessKey(res.credentials.token);
                  UserSession().setAccessKeySecret(res.credentials.tokenSecret);

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home())
                  );
                });
              }
            ),
          ],
        ),
      ),
    );
  }
}