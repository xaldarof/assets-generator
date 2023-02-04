import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_assets_generator/args_parser.dart';
import 'package:simple_assets_generator/strings_ext.dart';

void main() {
  test('test args parser', () {
    var argsParer = ArgsParser();
    var args = argsParer.parse([
      "-i",
      "assets/path/files",
      "-o",
      "lib",
      "-n",
      "Images",
      "-ext",
      "dart",
      "-fn",
      "image_assets"
    ]);
    expect(args['i'], "assets/path/files");
    expect(args['o'], "lib");
    expect(args['n'], "Images");
    expect(args['ext'], "dart");
    expect(args['fn'], "image_assets");
  });

  test('camelCase converter test', () {
    var res1 = "example_string_abc".toCamelCase();
    var res2 = "example_string_abc_".toCamelCase();
    var res3 = "example_string_abc___".toCamelCase();
    expect(res1, "exampleStringAbc");
    expect(res2, "exampleStringAbc");
    expect(res3, "exampleStringAbc");
  });
}
