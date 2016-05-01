Unlambda Interpreter on Rhino
====

## Description

Unlambda言語をRhino上で走らせる簡易インタプリタです。

関数は k, s, i, v, c, d, .x, e, @, ?x, | に対応しています。

機能として、

- コンソール上で実行する(一行スクリプト)
- ファイルを読み込んで実行(複数行可)
- 標準入力受け付け

に対応しています。

また、このツールはCoffeeScript上で記述しており、一度javascriptに変換してRhino上で実行します。

## Requirement

- CoffeeScript: http://coffeescript.org/

- Rhino: https://developer.mozilla.org/ja/docs/Rhino

"coffee"と"rhino"のパスが通るように設定してください。

## Usage

- compile tool
```bash
$ make all
```

- run interpreter
```bash
$ sh unlambda.sh
> `.a.b
a
$ sh unlambda.sh sample/hello.unl
hello, world!
```

## Other

何か問題や要望があれば、Issueや[Twitter](https://twitter.com/jken_ull)などにお願いします。

## License

このツールはMITライセンスに従います。詳細はLICENSE.txtをご覧ください。
