import 'dart:developer';
import 'dart:io';

import 'package:simple_assets_generator/args_parser.dart';

void main(List<String> args) async {
  if (args.isNotEmpty) {
    var parser = ArgsParser();
    var parsedArgs = parser.parse(args);
    if (parsedArgs.length == 2) {
      var assetsPath =
          Directory("${Directory.current.path}/${parsedArgs['i']}");
      var classBuilder = StringBuffer();
      classBuilder.writeln("class Assets {");
      assetsPath.listSync().forEach((element) {
        print("found: ${element.path.split("\\").last}");
        var fieldName =
            "${element.path.split("\\").last.split(".").first}_${element.path.split("\\").last.split(".")[1]}";
        classBuilder.writeln(
            "  static String ${toCamelCase(fieldName)} = '${parsedArgs['i']}/${element.path.split("\\").last}';");
      });
      classBuilder.writeln("}");
      var file = File(
          "${Directory.current.path}${Platform.pathSeparator}${parsedArgs['o']}/assets_names.dart");
      file.createSync(recursive: true);
      file.writeAsString(classBuilder.toString());
    }
  }
}

String toCamelCase(String str, {String? splitter}) {
  var value = str.split("");
  var valueStr = "";
  for (int i = 0; i < value.length; i++) {
    if (value[i] == (splitter ?? "_")) {
      if (i < value.length) {
        value[i + 1] = value[i + 1].toUpperCase();
        value.removeAt(i);
      }
    }
  }
  for (var element in value) {
    valueStr += element;
  }
  return valueStr;
}

void printInfo(String info) {
  log('\u001b[32measy localization: $info\u001b[0m');
}

void printError(String error) {
  log('\u001b[31m[ERROR] easy localization: $error\u001b[0m');
}
