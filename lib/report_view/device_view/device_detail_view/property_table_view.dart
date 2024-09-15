import 'package:flutter/material.dart';
import 'package:bluetooth_detector/report/device.dart';

class PropertyTable extends StatelessWidget {
  final Device device;

  const PropertyTable(this.device, {super.key});

  DataRow Row(String label, String value) {
    return DataRow(
      cells: [
        DataCell(Text(label, softWrap: true)),
        DataCell(Text(value, softWrap: true, textAlign: TextAlign.right)),
      ],
    );
  }

  @override
  Widget build(context) {
    return DataTable(
      sortAscending: true,
      sortColumnIndex: 1,
      showBottomBorder: false,
      columns: const [
        DataColumn(label: Text("")),
        DataColumn(label: Text(""), numeric: true),
      ],
      rows: [
        Row("UUID", device.id.toString()),
        Row("Name", device.name),
        Row("Platform", device.platformName),
        Row("Manufacturer", device.manufacturers().join(", ")),
      ],
    );
  }
}
