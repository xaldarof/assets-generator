import 'dart:developer';
import 'dart:io';

import 'package:simple_assets_generator/args_parser.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) async {
  if (args.isNotEmpty) {
    var parser = ArgsParser();
    var parsedArgs = parser.parse(args);
    var className = "Assets";
    var extensions = {};
    if(parsedArgs.containsKey("n")) {
      className = parsedArgs['n'];
    }

    if(parsedArgs.containsKey('ext')) {
      var ext = parsedArgs['ext'].toString().split(",");
      for (var element in ext) {
        extensions[element] = element;
      }
    }

    var assetsPath = Directory("${Directory.current.path}/${parsedArgs['i']}");
    var classBuilder = StringBuffer();
    classBuilder.writeln("class $className {");
    assetsPath.listSync().forEach((element) {
      if(extensions.containsKey(element.path.split(".").last) || extensions.isEmpty) {
        _writeToClass(element, classBuilder, parsedArgs['i']);
      }
    });
    classBuilder.writeln("}");
    _writeToFile(_createFile(parsedArgs['o']), classBuilder);
  }
}

File _createFile(String fileName) {
  var file = File(
      "${Directory.current.path}${Platform.pathSeparator}$fileName/assets_names.dart");
  file.createSync(recursive: true);
  return file;
}

void _writeToFile(File file,StringBuffer classBuilder) {
  file.writeAsString(classBuilder.toString());
}
void _writeToClass(FileSystemEntity element,StringBuffer classBuilder,String inputPath) {
  var fieldName =
      "${p.basename(element.path).split(".")[0]}_${p.basename(
      element.path).split(".")[1]}";
  classBuilder.writeln(
      "  static String ${_toCamelCase(fieldName)} = '$inputPath/${p
          .basename(element.path)}';");
}

String _toCamelCase(String str, {String? splitter}) {
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
