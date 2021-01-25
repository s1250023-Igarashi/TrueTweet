import 'dart:convert';

import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:true_tweet/model/userModel.dart';
import 'package:true_tweet/service/tweetService.dart';
import 'package:true_tweet/userSession.dart';
import 'package:twitter_1user/twitter_1user.dart';
import 'tweetModel.dart';

class TwitterApi {
  static final String apiKey = 'API key';
  static final String apiSecret = 'API key secret';

  static createAuthorizationObject() {
    var platform = new oauth1.Platform(
        'https://api.twitter.com/oauth/request_token',
        'https://api.twitter.com/oauth/authorize',
        'https://api.twitter.com/oauth/access_token',
        oauth1.SignatureMethods.hmacSha1
    );

    var clientCredentials = new oauth1.ClientCredentials(apiKey, apiSecret);

    return new oauth1.Authorization(clientCredentials, platform);
  }

  static Future<User> getLoginUser() async {
    Twitter twitter = new Twitter(apiKey, apiSecret, await UserSession().getAccessKey(), await UserSession().getAccessKeySecret());

    String response = await twitter.request('get', 'account/verify_credentials.json', {});

    final userJson = jsonDecode(response);

    return new User(userJson['name'],
        userJson['screen_name'],
        userJson['profile_image_url_https'],
        userJson['profile_banner_url'],
        userJson['description'],
        userJson['friends_count'],
        userJson['followers_count'],
        userJson['verified']
    );
  }

  static Future<List<Tweet>> getTimeLine() async {
    Twitter twitter = new Twitter(apiKey, apiSecret, await UserSession().getAccessKey(), await UserSession().getAccessKeySecret());

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
          tweetsJson[i]['id_str'],
          tweetsJson[i]['text'],
          '', // TODO: Image URL
          tweetsJson[i]['favorite_count'],
          tweetsJson[i]['favorited'],
          tweetsJson[i]['retweet_count'],
          tweetsJson[i]['retweeted'],
          0, // TODO: Reply count
          '', // TODO: Timestamp
          false
      );

      if (await TweetService.setMisinformationAndGetNumberOfCorrections(tweet, tweetsJson[i]['text']) < 100) tweets.add(tweet); // TODO: 100 is tentative
    }

    return tweets;
  }

  static Future<void> retweet(String id) async {
    Twitter twitter = new Twitter(apiKey, apiSecret, await UserSession().getAccessKey(), await UserSession().getAccessKeySecret());
    twitter.request('post', 'statuses/retweet/' + id + '.json', {});
  }

  static Future<void> unretweet(String id) async {
    Twitter twitter = new Twitter(apiKey, apiSecret, await UserSession().getAccessKey(), await UserSession().getAccessKeySecret());
    twitter.request('post', 'statuses/unretweet/' + id + '.json', {});
  }

  static Future<void> favorite(String id) async {
    Twitter twitter = new Twitter(apiKey, apiSecret, await UserSession().getAccessKey(), await UserSession().getAccessKeySecret());
    twitter.request('post', 'favorites/create.json', {'id': id});
  }

  static Future<void> unfavorite(String id) async {
    Twitter twitter = new Twitter(apiKey, apiSecret, await UserSession().getAccessKey(), await UserSession().getAccessKeySecret());
    twitter.request('post', 'favorites/destroy.json', {'id': id});
  }

  static Future tweet(String text) async {
    Twitter twitter = new Twitter(apiKey, apiSecret, await UserSession().getAccessKey(), await UserSession().getAccessKeySecret());
    String response = await twitter.request('post', 'statuses/update.json', {'status': text});
    final tweetJson = jsonDecode(response);
    return tweetJson;
  }

  static Future<void> deleteTweet(String id) async {
    Twitter twitter = new Twitter(apiKey, apiSecret, await UserSession().getAccessKey(), await UserSession().getAccessKeySecret());
    twitter.request('post', 'statuses/destroy/' + id + '.json', {});
  }
}