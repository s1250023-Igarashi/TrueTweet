import 'package:flutter/cupertino.dart';
import 'package:true_tweet/model/tweetModel.dart';
import 'package:true_tweet/model/userModel.dart';
import 'package:true_tweet/state/profileState.dart';

import '../theme.dart';

class Profile extends StatefulWidget {
  final User user;
  final List<Tweet> list;
  final BuildContext context;
  final CustomThemeState themeState;

  const Profile({Key key, this.user, this.list, this.context, this.themeState}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}