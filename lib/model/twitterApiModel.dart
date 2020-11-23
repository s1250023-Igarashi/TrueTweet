import 'dart:convert';

import 'package:true_tweet/model/userModel.dart';
import 'package:true_tweet/service/tweetService.dart';
import 'package:twitter_1user/twitter_1user.dart';
import '../userSession.dart';
import 'tweetModel.dart';

class TwitterApi {
  static final String apiKey = 'API key';
  static final String apiSecret = 'API secret';
  static final String accessToken = 'Access token';
  static final String accessSecret = 'access secret';

  static Future<List<Tweet>> getTimeLine() async {
    Twitter twitter = new Twitter(apiKey, apiSecret, accessToken, accessSecret);

    String response = await twitter.request('get', 'statuses/home_timeline.json', {'count': '10', 'include_entities': 'true',});
    
    final tweetsJson = jsonDecode(response);

    List<Tweet> tweets = [];

    for (int i = 0; i < tweetsJson.length; i++) {
      User user = new User(tweetsJson[i]['user']['name'],
          tweetsJson[i]['user']['screen_name'],
          tweetsJson[i]['user']['profile_image_url_https'],
          tweetsJson[i]['user']["profile_banner_url"],
          tweetsJson[i]['user']['description'],
          tweetsJson[i]['user']['friends_count'],
          tweetsJson[i]['user']['followers_count'],
          tweetsJson[i]['user']['verified']
      );

      Tweet tweet = new Tweet(user,
          tweetsJson[i]['text'],
          '', // TODO: Image URL
          tweetsJson[i]['favorite_count'],
          tweetsJson[i]['favorited'],
          tweetsJson[i]['retweet_count'],
          tweetsJson[i]['retweeted'],
          tweetsJson[i]['reply_count'],
          '', // TODO: Timestamp
          false
      );

      if (await TweetService.setMisinformationAndGetNumberOfCorrections(tweet, tweetsJson[i]['text']) < await UserSession().getHidingCriteria()) tweets.add(tweet);
    }

    return tweets;
  }
}