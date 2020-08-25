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
  }
}