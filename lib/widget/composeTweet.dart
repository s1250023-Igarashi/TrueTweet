import 'package:flutter/cupertino.dart';
import 'package:true_tweet/state/composeTweetState.dart';

class ComposeTweet extends StatefulWidget {
  final context;
  final user;

  const ComposeTweet({Key key, this.context, this.user}) : super(key: key);

  @override
  ComposeTweetState createState() => ComposeTweetState();
}