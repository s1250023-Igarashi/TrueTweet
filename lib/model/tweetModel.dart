import 'userModel.dart';

class Tweet {
  User user;
  String twt;
  String image;
  int likes;
  int retwts;
  int comments;
  int timestamp;
  bool retwted;
  bool liked;

  Tweet(this.user, this.twt, this.image, this.likes, this.liked, this.retwts, this.retwted, this.comments,
      this.timestamp);
}