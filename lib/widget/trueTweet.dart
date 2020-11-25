import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:true_tweet/widget/login.dart';

import '../theme.dart';
import 'home.dart';

class TrueTweet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrueTweet',
      theme: CustomTheme.of(context),
      home: Login(),
    );
  }
}