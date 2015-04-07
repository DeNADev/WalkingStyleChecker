WalkingStyleChecker  
==================
Mobage Developers Blog （ http://developers.mobage.jp/blog ）で紹介した『歩き方判定アプリ』のソースコードです。

- あなたの歩き方は大丈夫？歩き方判定アプリを作ってみた【その１】
  - http://developers.mobage.jp/blog/2015/using-the-accelerometer
- あなたの歩き方は大丈夫？歩き方判定アプリを作ってみた【その２】
  - http://developers.mobage.jp/blog/2015/using-the-accelerometer02

=================================================================================
構成  
=================================================================================
- WalkingStyleChecker
  - 『歩き方判定アプリ』本体です。iOS で動作します。
- WalkingParamAnalyzer
  - Mac OSX で動作するアプリです。
  - 『歩き方判定アプリ』で出力された加速度の値を一括でパラメータ化します。
- param.arff
  - Weka 用のファイルです。
  - 執筆時に使用したラベルとパラメータのセットになったものです。

