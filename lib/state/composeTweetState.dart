import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:true_tweet/model/tweetModel.dart';
import 'package:true_tweet/service/tweetService.dart';
import 'package:true_tweet/widget/composeTweet.dart';

class ComposeTweetState extends State<ComposeTweet> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(widget.context).primaryColorDark,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkResponse(child: Icon(Icons.close, color: Colors.blue), onTap: () => Navigator.of(context).pop()),
                Expanded(child: SizedBox()),
                RaisedButton(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  onPressed: _controller.text.isNotEmpty
                      ? () async {
                    if (await TweetService.containMisLeadingContent(_controller.text)) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("Warning"),
                            content: Text("This tweet is likely to be misinformation"),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text("Tweet"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop(Tweet(
                                    widget.user,
                                    _controller.text,
                                    null,
                                    0,
                                    false,
                                    0,
                                    false,
                                    0,
                                    'just now',
                                    true,
                                  ));
                                },
                              ),
                              CupertinoDialogAction(
                                child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Navigator.of(context).pop(Tweet(
                        widget.user,
                        _controller.text,
                        null,
                        0,
                        false,
                        0,
                        false,
                        0,
                        DateTime.now().millisecondsSinceEpoch.toString(),
                        false,
                      ));
                    }
                  }
                      : null,
                  child: Text('Tweet', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                  color: Colors.blue,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(widget.user.avatar, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      maxLines: 10,
                      maxLength: 240,
                      controller: _controller,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'What\'s happening?',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 8),
                        counterText: '',
                        counterStyle: TextStyle(fontSize: 0),
                      ),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}