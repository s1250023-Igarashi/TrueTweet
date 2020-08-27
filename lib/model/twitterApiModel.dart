import 'dart:convert';

import 'package:true_tweet/model/userModel.dart';
import 'package:twitter_1user/twitter_1user.dart';
import 'tweetModel.dart';

class TwitterApi {
  static final String apiKey = 'API key';
  static final String apiSecret = 'API secret key';
  static final String accessToken = 'access token';
  static final String accessSecret = 'access secret';

  static Future<List<Tweet>> getTimeLine() async {
    Twitter twitter = new Twitter(apiKey, apiSecret, accessToken, accessSecret);

    String response = await twitter.request(
        'get', 'statuses/home_timeline.json', {'count': '10', 'include_entities': 'true',});
    
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
          '',
          tweetsJson[i]['favorite_count'],
          tweetsJson[i]['favorited'],
          tweetsJson[i]['retweet_count'],
          tweetsJson[i]['retweeted'],
          tweetsJson[i]['reply_count'],
          "0");

      tweets.add(tweet);
    }

    return tweets;
  }

  static String timeAgo(int timestamp) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final timeDiff = currentTime - timestamp;
    if (timeDiff >= (1000 * 60 * 60 * 24)) {
      // Days
      return '${timeDiff ~/ (1000 * 60 * 60 * 24)}d';
    } else if (timeDiff >= (1000 * 60 * 60)) {
      // Hours
      return '${timeDiff ~/ (1000 * 60 * 60)}h';
    } else if (timeDiff >= (1000 * 60)) {
      // Minutes
      return '${timeDiff ~/ (1000 * 60)}m';
    } else if (timeDiff >= 1000) {
      // Seconds
      return '${timeDiff ~/ 1000}s';
    }
    return '0s';
  }
}