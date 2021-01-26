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
<img src="https://user-images.githubusercontent.com/39755176/105844128-11dd5200-601c-11eb-91bf-e75b027d0659.png" width="320px">

## 認識させにくくする
対象のツイートの文字色を薄くすることでユーザーに認識させにくくする。

<img src="https://user-images.githubusercontent.com/39755176/105844161-1dc91400-601c-11eb-809a-73019abec2ae.png" width="320px">

## 警告
対象のツイートをリツイートまたはツイート時に警告する。

<img src="https://user-images.githubusercontent.com/39755176/105844173-27527c00-601c-11eb-83d3-8925d6860be4.png" width="320px">

<img src="https://user-images.githubusercontent.com/39755176/105844185-2cafc680-601c-11eb-91bf-dadbf62be069.png" width="320px">

## 取消促し
対象のツイートをリツイートまたはツイート後に背景色を黄色にすることでユーザーに取り消しを促す。

<img src="https://user-images.githubusercontent.com/39755176/105844207-36392e80-601c-11eb-892b-cd0e7720cae3.png" width="320px">

# 情報提供元
[流言情報クラウド](http://mednlp.jp/~miyabe/rumorCloud/rumorlist.cgi)

# ライセンス
[MIT license](https://en.wikipedia.org/wiki/MIT_License).
