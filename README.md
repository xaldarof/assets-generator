Run in terminal :

`flutter pub run simple_assets_generator:generate -i assets/path/files -o lib -n Images -ext jpeg,png -fn assets_file`


`flutter pub run simple_assets_generator:grouped_generate -i assets/path/files -o lib -n Images -fn assets_file`

[required] `-i` assets directory, in my case assets/path/files

[required] `-o` generated file output path, lib/assets_names in my case

[optional] `-n` generated class name

[optional] `-fn` generated file name

[optional] `-ext` generate only files with given extensions (not supported for grouped generation)


[Open pub.dev](https://pub.dev/packages/simple_assets_generator)

```dart
class TxtFiles {
  static String fileTxt = 'assets/path/files/text1.txt';
}
```

```dart
class Images {
  static String logoPng = 'assets/path/files/logo.png';
}
```
