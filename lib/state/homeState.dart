import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:true_tweet/model/tweetModel.dart';
import 'package:true_tweet/model/userModel.dart';
import 'package:true_tweet/model/twitterApiModel.dart';
import 'package:true_tweet/userSession.dart';
import 'package:true_tweet/widget/composeTweet.dart';
import 'package:true_tweet/widget/home.dart';
import 'package:true_tweet/widget/login.dart';
import 'package:true_tweet/widget/profile.dart';

import '../theme.dart';

class HomeState extends State<Home> {
  ScrollController _controller;
  CustomThemeState _themeState;

  var _scaffold = GlobalKey<ScaffoldState>();
  var _bottomIndex = 0;
  var _theme = 0;

  // Login User
  static User loginUser = User(
    '',
    '',
    '',
    '',
    '',
    0,
    0,
    false,
  );

  // Tweets
  List<Tweet> tweets = List<Tweet>();

  void _changeTheme(BuildContext buildContext, ThemeKeys key) {
    if (_themeState == null) {
      _themeState = CustomTheme.instanceOf(buildContext);
      _themeState.changeTheme(key);
    } else {
      _themeState.changeTheme(key);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    Future.delayed(Duration(seconds: 0), () {
      _changeTheme(context, ThemeKeys.LIGHT);
    });
    setLoginUserInfo();
    load();
    setState(() {});
  }

  Future<void> setLoginUserInfo() async {
    loginUser = await TwitterApi.getLoginUser();
  }

  Future<void> load() async {
    tweets = await TwitterApi.getTimeLine();
  }

  Future<Null> _refresh() {
    return Future.delayed(Duration(milliseconds: 800), () {
      load();
      setState(() {});
    });
  }

  // Main Build
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffold,
      appBar: _appBar(size),
      drawer: _drawer(size),
      bottomNavigationBar: _bottomBar(size),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          controller: _controller,
          itemBuilder: (context, index) {
            final Tweet tweet = tweets[index];
            return _tweetWidget(tweet, size);
          },
          itemCount: tweets.length,
        ),
      ),
      floatingActionButton: _fab(),
    );
  }

  // Tweet
  Widget _tweetWidget(Tweet tweet, Size size) {
    final smallDevice = size.width < 360;
    return Column(
      children: [
        Container(
          color: tweet.misinformation && (tweet.retweeted || tweet.user == loginUser) ? Colors.yellow : Colors.white,
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Profile(
                    user: tweet.user,
                    list: tweets,
                    context: context,
                    themeState: _themeState,
                  ),
                )),
                child: Container(
                  width: smallDevice ? 40 : 50,
                  height: smallDevice ? 40 : 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(smallDevice ? 20 : 25)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(tweet.user.avatar, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text(tweet.user.name,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: smallDevice ? 12 : 14)),
                        Visibility(
                          visible: tweet.user.verified,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 4),
                              if (_themeState != null)
                                Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                      '.com/o/twtr%2F${_themeState.isDart ? 'verified_white' : 'verified_blue'}'
                                      '.png?alt=media',
                                  width: 15,
                                )
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Opacity(
                            opacity: 0.6,
                            child: Text(
                              '@${tweet.user.username}',
                              style: TextStyle(fontSize: smallDevice ? 12 : 14),
                            )),
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Opacity(opacity: 0.6, child: Text('.')),
                        ),
                        SizedBox(width: 5),
                        Opacity(
                            opacity: 0.6,
                            child: Text(tweet.timestamp, style: TextStyle(fontSize: smallDevice ? 12 : 14))),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(tweet.tweet, style: TextStyle(fontSize: smallDevice ? 12 : 14, color: tweet.misinformation && (!tweet.retweeted && tweet.user != loginUser) ? Colors.grey : Colors.black)),
                    if (tweet.image != null)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(tweet.image, fit: BoxFit.fitWidth),
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
                            Text('${tweet.comments}', style: TextStyle(fontSize: smallDevice ? 12 : 14))
                          ],
                        ),
                        InkResponse(
                          onTap: tweet.retweeted
                              ? () {
                            setState(() {
                              TwitterApi.unretweet(tweet.idStr);
                              tweet.retweets = tweet.retweets - 1;
                              tweet.retweeted = false;
                            });
                          }
                              : () {
                            if (tweet.misinformation) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text("Warning"),
                                    content: Text("This tweet is likely to be misinformation"),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text("Retweet"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            TwitterApi.retweet(tweet.idStr);
                                            tweet.retweets = tweet.retweets + 1;
                                            tweet.retweeted = true;
                                          });
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
                              setState(() {
                                TwitterApi.retweet(tweet.idStr);
                                tweet.retweets = tweet.retweets + 1;
                                tweet.retweeted = true;
                              });
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                    '.com/o/twtr%2F${tweet.retweeted ? 'retwt_selected' : 'retwt'}.png?alt=media',
                                width: 15,
                              ),
                              SizedBox(width: 8),
                              Text('${tweet.retweets}', style: TextStyle(fontSize: smallDevice ? 12 : 14))
                            ],
                          ),
                        ),
                        InkResponse(
                          onTap: tweet.liked
                              ? () {
                            setState(() {
                              TwitterApi.unfavorite(tweet.idStr);
                              tweet.likes = tweet.likes - 1;
                              tweet.liked = false;
                            });
                          }
                              : () {
                            setState(() {
                              TwitterApi.favorite(tweet.idStr);
                              tweet.likes = tweet.likes + 1;
                              tweet.liked = true;
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                    '.com/o/twtr%2F${tweet.liked ? 'liked' : 'like'}.png?alt=media',
                                width: 15,
                              ),
                              SizedBox(width: 8),
                              Text('${tweet.likes}', style: TextStyle(fontSize: smallDevice ? 12 : 14))
                            ],
                          ),
                        ),
                        InkResponse(
                          onTap: tweet.user == loginUser
                              ? () {
                            TwitterApi.deleteTweet(tweet.idStr);
                            _refresh();
                          }
                              : () {
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(tweet.user == loginUser ? 'Delete' : '', style: TextStyle(fontSize: smallDevice ? 12 : 14))
                            ],
                          ),
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
    );
  }

  Widget _drawer(Size size) {
    final smallDevice = size.width < 360;
    return Container(
      width: smallDevice ? 240 : 280,
      height: size.height,
      color: Theme.of(context).primaryColorDark,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Profile(user: loginUser, list: tweets, context: context, themeState: _themeState),
                      ));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(top: 15, left: 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(loginUser.avatar, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(loginUser.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Opacity(
                      opacity: 0.6,
                      child: Text('@${loginUser.username}'),
                    ),
                  ),
                  SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${loginUser.following}', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(width: 2),
                        Opacity(opacity: 0.6, child: Text('Following')),
                        SizedBox(width: 15),
                        Text('${loginUser.followers}', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(width: 2),
                        Opacity(opacity: 0.6, child: Text('Followers')),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(height: 1, color: Theme.of(context).selectedRowColor),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                '.com/o/twtr%2Flists.png?alt=media',
                            width: smallDevice ? 20 : 25),
                        SizedBox(width: 14),
                        Text('Lists', style: TextStyle(fontSize: smallDevice ? 14 : 18)),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                '.com/o/twtr%2Ftopics.png?alt=media',
                            width: smallDevice ? 20 : 25),
                        SizedBox(width: 14),
                        Text('Topics', style: TextStyle(fontSize: smallDevice ? 14 : 18)),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                '.com/o/twtr%2Fbookmarks.png?alt=media',
                            width: smallDevice ? 20 : 25),
                        SizedBox(width: 14),
                        Text('Bookmarks', style: TextStyle(fontSize: smallDevice ? 14 : 18)),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                                '.com/o/twtr%2Fmoments.png?alt=media',
                            width: smallDevice ? 20 : 25),
                        SizedBox(width: 14),
                        Text('Moments', style: TextStyle(fontSize: smallDevice ? 14 : 18)),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(height: 1, color: Theme.of(context).selectedRowColor),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Settings and privacy', style: TextStyle(fontSize: smallDevice ? 14 : 18)),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Help Center', style: TextStyle(fontSize: smallDevice ? 14 : 18)),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Container(height: 1, color: Theme.of(context).selectedRowColor),
          Container(
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showThemes();
                  },
                  child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                          '.com/o/twtr%2Ftheme.png?alt=media',
                      width: 22),
                ),
                SizedBox(width: 80),
                GestureDetector(
                  child: Text('Logout',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();

                    UserSession().logout();

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login())
                    );
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot'
                            '.com/o/twtr%2Fqrcode.png?alt=media',
                        width: 22),
                  ),
                ),
                SizedBox(width: 15),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      foregroundColor: Theme.of(context).accentColor,
      backgroundColor: Theme.of(context).accentColor,
      onPressed: () async {
        var tweet = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ComposeTweet(context: context, user: loginUser),
          fullscreenDialog: true,
        ));
        if (tweet != null) {
          setState(() => tweets.insert(0, tweet));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot.com/o/twtr%2Fcompose.png?alt=media',
          width: 30,
        ),
      ),
    );
  }

  Widget _bottomBar(Size size) {
    return Container(
      height: 56,
      child: Column(
        children: [
          Container(
            height: 1,
            width: size.width,
            color: Theme.of(context).selectedRowColor,
          ),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(canvasColor: Theme.of(context).primaryColorDark),
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot.com/o/twtr%2Fhome.png?alt=media',
                        width: 24,
                      ),
                      activeIcon: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot.com/o/twtr%2Fhome_selected.png?alt=media',
                        width: 24,
                      ),
                      title: Text('')),
                  BottomNavigationBarItem(
                      icon: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot.com/o/twtr%2Fsearch'
                            '.png?alt=media',
                        width: 24,
                      ),
                      activeIcon: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot.com/o/twtr%2Fsearch_selected'
                            '.png?alt=media',
                        width: 24,
                      ),
                      title: Text('')),
                  BottomNavigationBarItem(
                      icon: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot.com/o/twtr%2Fnotif.png?alt=media',
                        width: 24,
                      ),
                      activeIcon: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot.com/o/twtr%2Fnotif_selected'
                            '.png?alt=media',
                        width: 24,
                      ),
                      title: Text('')),
                  BottomNavigationBarItem(
                      icon: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot.com/o/twtr%2Fdm'
                            '.png?alt=media',
                        width: 24,
                      ),
                      activeIcon: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot.com/o/twtr%2Fdm_selected'
                            '.png?alt=media',
                        width: 24,
                      ),
                      title: Text('')),
                ],
                elevation: 0,
                currentIndex: _bottomIndex,
                onTap: (index) => setState(() => _bottomIndex = index),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar(Size size) {
    return PreferredSize(
      preferredSize: Size(size.width, 50),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _scaffold.currentState.isDrawerOpen
                    ? _scaffold.currentState.openEndDrawer()
                    : _scaffold.currentState.openDrawer(),
                child: Container(
                  width: 50,
                  height: 49,
                  child: Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(loginUser.avatar, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _controller.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.decelerate),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot.com/o/twtr%2Ftwt_icon.png?alt=media',
                          width: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 49,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/flutter-yeti.appspot.com/o/twtr%2Ftrends.png?alt=media',
                        width: 25,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            width: size.width,
            color: Theme.of(context).selectedRowColor,
          )
        ],
      ),
    );
  }

  void _showThemes() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  SizedBox(height: 10),
                  Container(height: 1, color: Theme.of(context).selectedRowColor),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text('Light', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Radio(
                            value: 0,
                            groupValue: _theme,
                            onChanged: (index) {
                              setState(() => _theme = index);
                              _changeTheme(context, ThemeKeys.LIGHT);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(height: 1, color: Theme.of(context).selectedRowColor),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text('Dark', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Radio(
                            value: 1,
                            groupValue: _theme,
                            onChanged: (index) {
                              setState(() => _theme = index);
                              _changeTheme(context, ThemeKeys.DARK);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(height: 1, color: Theme.of(context).selectedRowColor),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text('Darker', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Radio(
                            value: 2,
                            groupValue: _theme,
                            onChanged: (index) {
                              setState(() => _theme = index);
                              _changeTheme(context, ThemeKeys.DARKER);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(height: 1, color: Theme.of(context).selectedRowColor),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
      backgroundColor: Colors.transparent,
    );
  }
}