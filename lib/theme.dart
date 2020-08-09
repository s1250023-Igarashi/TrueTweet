import 'package:flutter/material.dart';

enum ThemeKeys { LIGHT, DARK, DARKER }

class Themes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    accentColor: Colors.blue,
    brightness: Brightness.light,
    textTheme: TextTheme(headline6: TextStyle(color: Colors.grey[850]), subtitle1: TextStyle(color: Colors.grey[850])),
    primaryColorLight: Colors.grey[700],
    primaryColorDark: Colors.white,
    selectedRowColor: Colors.grey[300],
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    accentColor: Colors.blue,
    brightness: Brightness.dark,
    textTheme: TextTheme(headline6: TextStyle(color: Colors.white), subtitle1: TextStyle(color: Colors.white)),
    primaryColorLight: Colors.grey[400],
    primaryColorDark: Colors.grey[850],
    selectedRowColor: Colors.grey[700],
  );

  static final ThemeData darkerTheme = ThemeData(
    primaryColor: Colors.black,
    accentColor: Colors.blue,
    brightness: Brightness.dark,
    textTheme: TextTheme(headline6: TextStyle(color: Colors.white), subtitle1: TextStyle(color: Colors.white)),
    primaryColorLight: Colors.grey[400],
    primaryColorDark: Colors.black,
    selectedRowColor: Colors.grey[850],
  );

  static ThemeData getThemeFromKey(ThemeKeys themeKey) {
    switch (themeKey) {
      case ThemeKeys.LIGHT:
        return lightTheme;
      case ThemeKeys.DARK:
        return darkTheme;
      case ThemeKeys.DARKER:
        return darkerTheme;
      default:
        return lightTheme;
    }
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final ThemeKeys initialThemeKey;

  const CustomTheme({Key key, this.initialThemeKey, @required this.child}) : super(key: key);

  @override
  CustomThemeState createState() => CustomThemeState();

  static ThemeData of(BuildContext context) {
    _CustomTheme inherited = (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited.data.theme;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    _CustomTheme inherited = (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited.data;
  }
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData _theme;

  ThemeData get theme => _theme;

  ThemeKeys _themeKey;

  ThemeKeys get themeKey => _themeKey;

  bool get isDart => _themeKey == ThemeKeys.DARK || _themeKey == ThemeKeys.DARKER;

  @override
  void initState() {
    _theme = Themes.getThemeFromKey(widget.initialThemeKey);
    _themeKey = widget.initialThemeKey;
    super.initState();
  }

  void changeTheme(ThemeKeys themeKey) {
    setState(() {
      _theme = Themes.getThemeFromKey(themeKey);
      _themeKey = themeKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _CustomTheme(
      data: this,
      child: widget.child,
    );
  }
}

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({this.data, Key key, @required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}