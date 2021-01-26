# True Tweet

誤情報の拡散を防ぐことを目的としたスマートフォン向けのTwitterクライアント。

# 準備
twitterApiModel.dartの以下の部分にTwitterのAPIのコンシューマーキー（API key & secret）をセット。
``` Dart
class TwitterApi {
  static final String apiKey = 'API key';
  static final String apiSecret = 'API secret';
```

# 機能
誤情報である可能性があるツイートに対して以下のアクションを行う。

## 非表示
対象のツイートを非表示にする。
### 非表示にする対象のレベル（誤情報である可能性の高さ）を設定する

## 認識させにくくする
対象のツイートの文字色を薄くすることでユーザーに認識させにくくする。

## 警告
対象のツイートをリツイートまたはツイート時に警告する。

## 取消促し
対象のツイートをリツイートまたはツイート後に背景色を黄色にすることでユーザーに取り消しを促す。

# 情報提供元
[流言情報クラウド](http://mednlp.jp/~miyabe/rumorCloud/rumorlist.cgi)

# ライセンス
[MIT license](https://en.wikipedia.org/wiki/MIT_License).
