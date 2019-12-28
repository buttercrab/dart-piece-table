import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:piece_table/piece_table.dart';
import 'package:random_string/random_string.dart';

PieceTable table;

class PieceTableWriteBenchmark extends BenchmarkBase {
  const PieceTableWriteBenchmark() : super('Template');

  static void main() {
    PieceTableWriteBenchmark().report();
  }

  @override
  void run() {
    table.write('a');
    table.moveCursor(randomBetween(-table.length ~/ 2, table.length ~/ 2));
  }

  @override
  void setup() {
    table = PieceTable('a' * 1000);
  }

  @override
  void teardown() {
    table = null;
  }
}

void main() {
  for (var i = 1; i <= 5; i++) {
    print('Test $i');
    print('  Piece Table insert test:');
    PieceTableWriteBenchmark.main();
    print('');
  }
}
