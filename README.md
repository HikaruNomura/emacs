# emacs

個人用 GNU Emacs 設定（Emacs 30 系で動作確認）。

## 構成

```
.
├── early-init.el   パッケージ/GUI 初期化前に読まれる設定
├── init.el         エントリポイント。lisp/ のモジュールを読み込む
├── lisp/           モジュール群（init-*.el）
│   └── init-ui.el  基本 UI 設定
├── install.sh      ~/.emacs.d へシンボリックリンクを張る
└── .gitignore      custom.el / elpa/ など生成物を除外
```

`custom.el`（Customize の出力）や `elpa/`（インストール済みパッケージ）は
機械生成物のため Git 管理しない。

## インストール

```sh
git clone https://github.com/HikaruNomura/emacs.git ~/git/emacs
cd ~/git/emacs
./install.sh
```

`install.sh` は `early-init.el` / `init.el` / `lisp` を `~/.emacs.d` に
シンボリックリンクする。既存のファイルやリンクは
`~/.emacs.d/backup-YYYYMMDD-HHMMSS/` に退避してから張り直す（再実行可能）。

## モジュールの追加

1. `lisp/init-FOO.el` を作成し、末尾に `(provide 'init-FOO)` を置く
2. `init.el` に `(require 'init-FOO)` を追記する
