import 'dart:developer';
import 'dart:io';

import 'package:simple_assets_generator/args_parser.dart';
import 'package:path/path.dart' as p;
import 'package:simple_assets_generator/strings_ext.dart';

void main(List<String> args) async {
  if (args.isNotEmpty) {
    var parser = ArgsParser();
    var parsedArgs = parser.parse(args);
    var className = "Assets";
    var fileName = "assets";
    var extensions = {};
    if (parsedArgs.containsKey("n")) {
      className = parsedArgs['n'];
    }

    if (parsedArgs.containsKey("fn")) {
      fileName = parsedArgs['fn'];
    }

    if (parsedArgs.containsKey('ext')) {
      var ext = parsedArgs['ext'].toString().split(",");
      for (var element in ext) {
        extensions[element] = element;
      }
    }

    var assetsPath = Directory("${Directory.current.path}/${parsedArgs['i']}");
    var classBuilder = StringBuffer();
    classBuilder.writeln("abstract class $className {");
    assetsPath.listSync().forEach((element) {
      if (extensions.containsKey(element.path.split(".").last) ||
          extensions.isEmpty) {
        _writeToClass(element, classBuilder, parsedArgs['i']);
      }
    });
    classBuilder.writeln("}");
    _writeToFile(_createFile(fileName, parsedArgs['o']), classBuilder);
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
