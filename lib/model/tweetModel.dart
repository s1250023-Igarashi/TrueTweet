import 'userModel.dart';

class Tweet {
  User user;
  String idStr;
  String tweet;
  String image;
  int likes;
  int retweets;
  int comments;
  String timestamp;
  bool retweeted;
  bool liked;
  bool misinformation;

  Tweet(this.user, this.idStr, this.tweet, this.image, this.likes, this.liked, this.retweets, this.retweeted, this.comments,
      this.timestamp, this.misinformation);
}