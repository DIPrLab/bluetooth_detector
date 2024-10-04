import 'package:bluetooth_detector/extensions/collections.dart';

class Stats {
  final List<num> input;

  late num average = input.average();
  late num median = input.median();
  late num standardDeviation = input.standardDeviation();
  late num iqr = input.iqr();

  late Iterable<num> lowOutliers = input.iqrOutliers().$1;
  late Iterable<num> highOutliers = input.iqrOutliers().$2;
  late Iterable<num> extremeLowOutliers = input.tukeyOutliers().$1;
  late Iterable<num> mildLowOutliers = input.tukeyOutliers().$2;
  late Iterable<num> mildHighOutliers = input.tukeyOutliers().$3;
  late Iterable<num> extremeHighOutliers = input.tukeyOutliers().$4;

  double zScore(num x) => standardDeviation == 0 ? 0 : (x - average) / standardDeviation;

  factory Stats.fromData(Iterable<num> input) => Stats(input.toList()..sort());
  Stats(this.input);
}
