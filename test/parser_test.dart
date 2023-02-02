

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_assets_generator/args_parser.dart';

void main() {
  test('test args parser', () {
    var argsParer = ArgsParser();
    var args = argsParer.parse(["-i", "assets/path/files","-o", "lib", "-n", "Images", "-ext", "dart", "-fn", "image_assets"]);
    expect(args['i'], "assets/path/files");
    expect(args['o'], "lib");
    expect(args['n'], "Images");
    expect(args['ext'], "dart");
    expect(args['fn'], "image_assets");
  });
}