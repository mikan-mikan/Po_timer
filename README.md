# Po timer

## はじめに
```
fvm install
```

## バージョンなど
グローバルから、fvmでバージョン管理に変更した
`.vscode/settings.json`でSDKのバージョンを指定

コマンドに`fvm`を付与すること

`fvm flutter --version`で確認
```sh
Flutter 2.10.4 • channel stable • https://github.com/flutter/flutter.git
Framework • revision c860cba910 (8 days ago) • 2022-03-25 00:23:12 -0500
Engine • revision 57d3bac3dd
Tools • Dart 2.16.2 • DevTools 2.9.2
```

# memo
## Flutter pod install エラーが出た
1. `ios/Pods/` と `ios/Podfile` `ios/Podfile.lock`手動で削除
2. `flutter run`
3. (sudo arch -x86_64 gem install ffi), arch -x86_64 pod install --repo-update # M1 mac
4. `flutter clean`
5. `flutter run`
