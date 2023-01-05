# dotfiles
## 概要

Mac端末を新規購入やクリーンインストールした際の環境構築

## 前提環境

- [XCode CLI Tool](https://developer.apple.com/jp/xcode/)
- [Zinit](https://github.com/zdharma-continuum/zinit)

## インストール手順

1. XCode CLI Tool の インストール

    ```bash
    xcode-select --install
    ```

2. Zinit のインストール

    ```bash
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

    zinit self-update
    ```

3. Mac App Storeにログイン

4. Masでインストールするアプリが購入済みにしておく

5. dotfiles のインストール

    ```bash
    chmod 755 install.sh
    ./install.sh
    ```
