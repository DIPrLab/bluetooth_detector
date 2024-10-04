import "dart:math";

extension IterableStats on Iterable<num> {
  num average() => this.fold(0.0, (a, b) => a + b) / this.length;

  double standardDeviation() => sqrt(this.fold(0.0, (a, b) => a + pow(b - average(), 2)) / this.length);
}

extension ListStats on List<num> {
  num median() => this.length.isEven
      ? this.getRange((this.length ~/ 2) - 1, (this.length ~/ 2) + 1).average()
      : this[this.length ~/ 2];

  (List<num>, List<num>) split() =>
      (this.getRange(0, this.length ~/ 2).toList(), this.getRange((this.length / 2).ceil(), this.length).toList());

  num q3() => this.split().$2.median();
  num q1() => this.split().$1.median();

  num iqr() => q3() - q1();

  (Iterable<num>, Iterable<num>) iqrOutliers() {
    Iterable<num> lowOutliers = this.where((element) => element < (q1() - (iqr() * 1.5)));
    Iterable<num> highOutliers = this.where((element) => element > (q3() * (iqr() * 1.5)));
    return (lowOutliers, highOutliers);
  }

  (Iterable<num>, Iterable<num>, Iterable<num>, Iterable<num>) tukeyOutliers() {
    Iterable<num> extremeLowOutliers = this.where((element) => element < (q1() - (iqr() * 3)));
    Iterable<num> mildLowOutliers = this.where((element) => element < (q1() - (iqr() * 1.5)));
    Iterable<num> mildHighOutliers = this.where((element) => element > (q3() + (iqr() * 1.5)));
    Iterable<num> extremeHighOutliers = this.where((element) => element > (q3() + (iqr() * 3)));
    return (extremeLowOutliers, mildLowOutliers, mildHighOutliers, extremeHighOutliers);
  }
}
