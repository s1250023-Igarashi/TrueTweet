import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:true_tweet/model/tweetModel.dart';
import 'package:true_tweet/widget/profile.dart';

import 'homeState.dart';

class ProfileState extends State<Profile> {
  final _controller = ScrollController();
  final Color _color = Colors.blue;
  var _opacity = 0.0;
  var _threshold = 85.0;

  void _animateAppBar() {
    _controller.addListener(() {
      if (_controller.offset <= 85) {
        var percentage = (((_threshold - _controller.offset) / 100) - 1).abs();
        if (percentage >= 0 || percentage <= 100) {
          setState(() => _opacity = percentage < 0.2 ? 0 : percentage > 0.9 ? 1 : percentage);
        }
      } else {
        setState(() => _opacity = 1);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _animateAppBar();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final smallDevice = size.width < 360;
    return Material(
      color: Theme.of(widget.context).primaryColorDark,
      child: Stack(
        children: [
          ListView(
              controller: _controller,
              children: [
                Container(
                  child: Stack(
                    children: [
                      Column(children: [
                        Container(
                          height: 150,
                          width: size.width,
                          child: Image.network(widget.user.banner, fit: BoxFit.cover),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          color: Theme.of(widget.context).primaryColorDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RaisedButton(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        side: BorderSide(color: Colors.blue, width: 2)),
                                    onPressed: () {},
                                    child: Text('Follow',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                            fontSize: smallDevice ? 12 : 14)),
                                    color: Colors.transparent,
                                  ),
                                ],
                              ),
                              Text(widget.user.name,
                                  style: TextStyle(fontSize: smallDevice ? 15 : 18, fontWeight: FontWeight.w600)),
                              SizedBox(height: 4),
                              Opacity(
                                opacity: 0.6,
                                child:
                                Text('@${widget.user.username}', style: TextStyle(fontSize: smallDevice ? 13 : 15)),
                              ),
                              SizedBox(height: 8),
                              Text(widget.user.bio, style: TextStyle(fontSize: smallDevice ? 13 : 15)),
                              SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${widget.user.following}', style: TextStyle(fontWeight: FontWeight.w600)),
                                  SizedBox(width: 2),
                                  Opacity(opacity: 0.6, child: Text('Following')),
                                  SizedBox(width: 15),
                                  Text('${widget.user.followers}', style: TextStyle(fontWeight: FontWeight.w600)),
                                  SizedBox(width: 2),
                                  Opacity(opacity: 0.6, child: Text('Followers')),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(height: 1, color: Theme.of(context).selectedRowColor),
                        SizedBox(height: 10),
                      ]),
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: smallDevice ? 110 : 100),
                        child: Container(
                          width: smallDevice ? 80 : 100,
                          height: smallDevice ? 80 : 100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(smallDevice ? 40 : 50),
                              color: Theme.of(widget.context).primaryColorDark),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(smallDevice ? 40 : 50),
                            child: Image.network(widget.user.avatar, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
                  .followedBy(widget.list
                  .where((item) => item.user.username == widget.user.username)
                  .toList()
                  .map((twt) => _twtWidget(twt, smallDevice)))
                  .toList()),
          PreferredSize(
            preferredSize: Size(size.width, 50),
            child: Container(
              height: smallDevice ? 50 : 60,
              color: _color.withOpacity(_opacity),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkResponse(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: smallDevice ? 30 : 40,
                        height: smallDevice ? 30 : 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black12),
                        child: Center(
                          child: Icon(Icons.arrow_back, color: Colors.white, size: smallDevice ? 20 : 25),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: smallDevice ? 30 : 40,
                          height: smallDevice ? 30 : 40,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black12),
                          child: Center(
                            child: Icon(Icons.more_vert, color: Colors.white, size: smallDevice ? 20 : 25),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //INFO: Profile Twt Item
  Widget _twtWidget(Tweet twt, bool smallDevice) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: smallDevice ? 40 : 50,
                  height: smallDevice ? 40 : 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(smallDevice ? 20 : 25)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(smallDevice ? 20 : 25),
                    child: Image.network(twt.user.avatar, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(twt.user.name,
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: smallDevice ? 12 : 14)),
                          Visibility(
                            visible: twt.user.verified,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 4),
                                if (widget.themeState != null)
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                        '.com/o/twtr%2F${widget.themeState.isDart ? 'verified_white' : 'verified_blue'}'
                                        '.png?alt=media',
                                    width: 15,
                                  )
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Opacity(
                              opacity: 0.6,
                              child: Text('@${twt.user.username}', style: TextStyle(fontSize: smallDevice ? 12 : 14))),
                          SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Opacity(opacity: 0.6, child: Text('.')),
                          ),
                          SizedBox(width: 5),
                          Opacity(
                              opacity: 0.6,
                              child: Text(HomeState.timeAgo(twt.timestamp),
                                  style: TextStyle(fontSize: smallDevice ? 12 : 14))),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(twt.twt, style: TextStyle(fontSize: smallDevice ? 12 : 14)),
                      if (twt.image != null)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(twt.image, fit: BoxFit.fitWidth),
                            ),
                          ],
                        ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                    '.com/o/twtr%2Fcomment.png?alt=media',
                                width: 15,
                              ),
                              SizedBox(width: 8),
                              Text('${twt.comments}', style: TextStyle(fontSize: smallDevice ? 12 : 14))
                            ],
                          ),
                          InkResponse(
                            onTap: twt.retwted
                                ? () {
                              setState(() {
                                twt.retwts = twt.retwts - 1;
                                twt.retwted = false;
                              });
                            }
                                : () {
                              setState(() {
                                twt.retwts = twt.retwts + 1;
                                twt.retwted = true;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                      '.com/o/twtr%2F${twt.retwted ? 'retwt_selected' : 'retwt'}.png?alt=media',
                                  width: 15,
                                ),
                                SizedBox(width: 8),
                                Text('${twt.retwts}', style: TextStyle(fontSize: smallDevice ? 12 : 14))
                              ],
                            ),
                          ),
                          InkResponse(
                            onTap: twt.liked
                                ? () {
                              setState(() {
                                twt.likes = twt.likes - 1;
                                twt.liked = false;
                              });
                            }
                                : () {
                              setState(() {
                                twt.likes = twt.likes + 1;
                                twt.liked = true;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                      '.com/o/twtr%2F${twt.liked ? 'liked' : 'like'}.png?alt=media',
                                  width: 15,
                                ),
                                SizedBox(width: 8),
                                Text('${twt.likes}', style: TextStyle(fontSize: smallDevice ? 12 : 14))
                              ],
                            ),
                          ),
                          Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                '.com/o/twtr%2Fshare.png?alt=media',
                            width: 15,
                          ),
                          SizedBox()
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(height: 1, color: Theme.of(context).selectedRowColor),
        ],
      ),
    );
  }
}