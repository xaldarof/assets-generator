import 'dart:developer';
import 'dart:io';

import 'package:simple_assets_generator/args_parser.dart';
import 'package:path/path.dart' as p;
import 'package:simple_assets_generator/strings_ext.dart';
import 'package:simple_assets_generator/supported_files.dart';

void main(List<String> args) async {
  if (args.isNotEmpty) {
    var parser = ArgsParser();
    var parsedArgs = parser.parse(args);
    var className = "Asset";
    var fileName = "assets";

    if (parsedArgs.containsKey("n")) {
      className = parsedArgs['n'];
    }

    if (parsedArgs.containsKey("fn")) {
      fileName = parsedArgs['fn'];
    }

    final files = FileTypes.categories;

    var assetsPath = Directory("${Directory.current.path}/${parsedArgs['i']}");
    var classBuilder = StringBuffer();

    final file = _createFile(fileName, parsedArgs['o']);

    final groupedExtensions =
        assetsPath.listSync().groupBy((p0) => p0.path.split(".").last);

    groupedExtensions.forEach((key, value) {
      FileCategory foundEquality = FileTypes.categories.where((element) {
        return element.fileExtensions.contains(".$key");
      }).first;

      classBuilder
          .writeln("abstract class $className${foundEquality.categoryName} {");

      for (var element in value) {
        final nameAndExt = p.basename(element.path).split(".");
        final fieldName = "${nameAndExt[1]}_${nameAndExt[0]}".toCamelCase();
        classBuilder.writeln(
            """  static String $fieldName = "${(element.path).replaceAll("\\", "/")}"; """);
      }
      classBuilder.writeln("}\n\n");
    });

    _writeToFile(file, classBuilder);
  }
}

File _createFile(String fileName, String path) {
  var file = File(
      "${Directory.current.path}${Platform.pathSeparator}$path/$fileName.dart");
  file.createSync(recursive: true);
  return file;
}

void _writeToFile(File file, StringBuffer classBuilder) {
  file.writeAsString(classBuilder.toString());
}

void _writeToClass(
    FileSystemEntity element, StringBuffer classBuilder, String inputPath) {
  var fieldName =
      "${p.basename(element.path).split(".")[0]}_${p.basename(element.path).split(".")[1]}";
  classBuilder.writeln(
      "  static String ${fieldName.toCamelCase()} = '$inputPath${inputPath.endsWith("/") ? "" : "/"}${p.basename(element.path)}';");
}

void printInfo(String info) {
  log('\u001b[32measy localization: $info\u001b[0m');
}

void printError(String error) {
  log('\u001b[31m[ERROR] easy localization: $error\u001b[0m');
}

extension Iterables<E> on List<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
