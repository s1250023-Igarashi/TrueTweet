import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:true_tweet/widget/login.dart';

import '../theme.dart';
import '../userSession.dart';
import 'home.dart';

class TrueTweet extends StatelessWidget {
  Future<bool> isInitialized() async{
    return await UserSession().getAccessKey() != '';
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: isInitialized(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          final hasData = snapshot.hasData;
          if (hasData == false) {
            return CircularProgressIndicator();
          }

          var app = new MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "TrueTweet",
            theme: CustomTheme.of(context),
            home: snapshot.data ? Home() : Login(),
          );
          return app;
        });
  }
}