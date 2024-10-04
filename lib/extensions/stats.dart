import 'package:bluetooth_detector/extensions/collections.dart';

class Stats {
  final List<num> input;

  late num average = input.average();
  late num median = input.median();
  late num stdDev = input.stdDev();
  late num iqr = input.iqr();

  late Iterable<num> lowOutliers = input.iqrOutliers().$1;
  late Iterable<num> highOutliers = input.iqrOutliers().$2;
  late Iterable<num> extremeLowOutliers = input.tukeyOutliers().$1;
  late Iterable<num> mildLowOutliers = input.tukeyOutliers().$2;
  late Iterable<num> mildHighOutliers = input.tukeyOutliers().$3;
  late Iterable<num> extremeHighOutliers = input.tukeyOutliers().$4;

  double zScore(num x) => stdDev == 0 ? 0 : (x - average) / stdDev;

  factory Stats.init(Iterable<num> input) => Stats(input.toList()..sort());
  Stats(this.input);
}
