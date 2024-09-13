import 'package:bluetooth_detector/assigned_numbers/company_identifiers.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_detector/report/device.dart';

class PropertyTable extends StatelessWidget {
  final Device device;

  const PropertyTable(this.device, {super.key});

  @override
  Widget build(context) {
    return DataTable(
      sortAscending: true,
      sortColumnIndex: 1,
      showBottomBorder: false,
      columns: const [
        DataColumn(
            label: Text(
          'Property',
        )),
        DataColumn(
            label: Text(
              'Value',
            ),
            numeric: true),
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(Text(
              "UUID",
            )),
            DataCell(Text(device.id.toString(), textAlign: TextAlign.right)),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text(
              "Name",
            )),
            DataCell(Text(device.name, textAlign: TextAlign.right)),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text(
              "Platform",
            )),
            DataCell(Text(device.platformName, textAlign: TextAlign.right)),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text(
              "Manufacturer",
            )),
            DataCell(Text(
                device.manufacturer
                    .map((e) =>
                        company_identifiers[e
                            .toRadixString(16)
                            .toUpperCase()
                            .padLeft(4, "0")] ??
                        "Unknown")
                    .join(", "),
                textAlign: TextAlign.right)),
          ],
        ),
      ],
    );
  }
}
