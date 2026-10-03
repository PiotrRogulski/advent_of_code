import 'package:leancode_lint/plugin.dart';

final plugin = LeanCodeLintPlugin(
  config: .new(
    applicationPrefix: 'Aoc',
    designSystemItemReplacements: {
      'AocScaffold': [..._material('Scaffold')],
      'AocText': [..._material('Text')],
      'AocBorderRadius': [..._material('BorderRadius')],
      'AocBorder': [..._material('RoundedRectangleBorder')],
      'AocIcon': [..._material('Icon')],
      'AocIconData': [..._material('IconData'), ..._material('Icons')],
      'AocIconButton': [..._material('IconButton')],
      'AocInkWell': [..._material('InkWell')],
      'AocCard': [..._material('Card')],
      'AocRadioListTile': [..._material('RadioListTile')],
      'AocSwitchListTile': [..._material('SwitchListTile')],
      'AocCheckboxListTile': [..._material('CheckboxListTile')],
      'AocListTile': [..._material('ListTile')],
      'AocEdgeInsets': [
        ..._material('EdgeInsets'),
        ..._material('EdgeInsetsDirectional'),
        ..._material('EdgeInsetsGeometry'),
      ],
      'AocPadding': [..._material('Padding')],
      'AocSliverPadding': [..._material('SliverPadding')],
    },
  ),
);

Iterable<DesignSystemForbiddenItem> _material(String name) => [
  .new(name: name, packageName: 'flutter'),
  .new(name: name, packageName: 'material_ui'),
];
