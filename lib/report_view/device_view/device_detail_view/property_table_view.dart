import 'package:flutter/material.dart';
import 'package:bluetooth_detector/report/device.dart';

class PropertyTable extends StatelessWidget {
  final Device device;
  late List<DataRow> rows;

  PropertyTable(this.device, {super.key}) {
    rows.add(Row("UUID", device.id.toString()));
    if (!device.name.isEmpty) {
      rows.add(Row("Name", device.name));
    }
    if (!device.platformName.isEmpty) {
      Row("Platform", device.platformName);
    }
    if (!device.manufacturer.isEmpty) {
      Row("Manufacturer", device.manufacturers().join(", "));
    }
  }

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
      rows: rows,
    );
  }
}
