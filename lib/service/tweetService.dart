import 'dart:convert';
import 'dart:io';

import 'package:string_similarity/string_similarity.dart';
import 'package:true_tweet/model/tweetModel.dart';

class TweetService {
  static Future<String> getMisleadingInformation() async {
    // get misleading information
    HttpClientRequest request = await HttpClient().getUrl(Uri.parse('https://www2.yoslab.net/~kakimoto/rumor_background/get_rumors/rumors.txt'));
    HttpClientResponse response = await request.close();
    String responseBodyText = await utf8.decodeStream(response);
    return responseBodyText;
  }

  static Future<bool> containMisLeadingContent(String text) async {
    for (String line in (await getMisleadingInformation()).split("\n\n")) {
      List<String> info = line.split("\t");
      if (info.length < 6) continue;
      if (text.similarityTo(info[4]) >= 0.5) return true; // TODO: 0.5 is tentative
    }
    return false;
  }

  static Future<int> setMisinformationAndGetNumberOfCorrections(Tweet tweet, String text) async {
    for (String line in (await getMisleadingInformation()).split("\n\n")) {
      List<String> info = line.split("\t");
      if (info.length < 6) continue;
      if (text.similarityTo(info[4]) >= 0.5) { // TODO: 0.5 is tentative
        tweet.misinformation = true;
        return int.parse(info[3]);
      }
    }
    return 0;
  }
}