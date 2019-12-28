import 'package:piece_table/piece_table.dart';
import 'package:random_string/random_string.dart';
import 'package:test/test.dart';

void main() {
  test('write test', () {
    var table = PieceTable.empty();
    var s = '';

    for (var i = 0; i < 100; i++) {
      var t = randomString(10);
      s += t;
      table.write(t);
    }

    expect(s, equals(table.toString()));
  });
}
