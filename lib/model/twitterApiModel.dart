import 'dart:convert';

import 'package:true_tweet/model/userModel.dart';
import 'package:twitter_1user/twitter_1user.dart';
import 'tweetModel.dart';

class TwitterApi {
  final String apiKey = 'API Key';
  final String apiSecret = 'API secret key';
  final String accessToken = 'Access token';
  final String accessSecret = 'Access token secret';

  Future<List<Tweet>> getTimeLine() async {
    Twitter twitter = new Twitter(apiKey, apiSecret, accessToken, accessSecret);

    String response = await twitter.request(
        'get', 'statuses/user_timeline.json', {});
    
    final tweetsJson = jsonDecode(response);

    List<Tweet> tweets = [];

    for (int i = 0; i < tweetsJson.length; i++) {
      User user = new User(tweetsJson[i]['user']['name'],
          tweetsJson[i]['user']['screen_name'],
          tweetsJson[i]['user']['profile_image_url_https'],
          "banner",
          "bio",
          0,
          0,
          true);

      Tweet tweet = new Tweet(user,
          tweetsJson[i]['text'],
          tweetsJson[i]['entities']['media'][0]['media_url'],
          tweetsJson[i]['favorite_count'],
          tweetsJson[i]['favorited'],
          tweetsJson[i]['retweet_count'],
          tweetsJson[i]['retweeted'],
          tweetsJson[i]['reply_count'],
          tweetsJson[i]['created_at']);

      tweets.add(tweet);
    }

    return tweets;
  }
}