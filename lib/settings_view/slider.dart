part of "settings_view.dart";

extension SettingsSlider on SettingsViewState {
  void clampThresholdTime(double newValue) {
    widget.settings.scanTime = newValue;
    widget.settings.thresholdTime =
        max(widget.settings.scanTime, widget.settings.thresholdTime);
  }

  void clampScanTime(double newValue) {
    widget.settings.thresholdTime = newValue;
    widget.settings.scanTime = min(widget.settings.scanTime, newValue);
  }

  void clampThresholdDistance(double newValue) {
    widget.settings.scanDistance = newValue;
    widget.settings.thresholdDistance =
        max(widget.settings.scanDistance, widget.settings.thresholdDistance);
  }

  void clampScanDistance(double newValue) {
    widget.settings.thresholdDistance = newValue;
    widget.settings.scanDistance = min(widget.settings.scanDistance, newValue);
  }

  Column settingsSlider(String label, String valueLabel, double minValue,
      double maxValue, double value, void Function(double) onChange) {
    return Column(children: [
      Row(children: [
        Text(label),
        Spacer(),
        Text(valueLabel),
      ]),
      Slider(
        min: minValue,
        max: maxValue,
        value: value,
        onChanged: (newValue) => setState(() => onChange(newValue)),
        onChangeEnd: ((value) {
          save();
          print("Saved Settings");
        }),
      )
    ]);
  }
}
