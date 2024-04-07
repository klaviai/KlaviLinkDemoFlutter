import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:klavi_link_demo_flutter/pages/web.dart';

class ListItemType {
  final String label;
  final String value;
  final String? key;

  ListItemType({required this.label, required this.value, this.key});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _textEditingController;
  static List<ListItemType> items = [
    ListItemType(
      label: "Klavi Link, redirectUrl is a URL Scheme",
      value:
          "https://open-sandbox.klavi.ai/data/v1/basic-links/ofpfdemo?redirectURL=klavilinkdemoflutter://redirect",
      key: '1',
    ),
    ListItemType(
        label: "Custom Klavi Link",
        value: "https://open-testing.klavi.ai/data/v1/basic-links/ofpfdemo?redirectURL=klavilinkdemoflutter://redirect",
        key: "custom"),
  ];
  var selectValue = items.first.value;
  var selectIndex = 0;
  var textValue = items.first.value;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController(text: textValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Klavi Link Demo'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownMenu<String>(
                  expandedInsets: EdgeInsets.zero,
                  initialSelection: textValue,
                  dropdownMenuEntries:
                      items.map<DropdownMenuEntry<String>>((item) {
                    return DropdownMenuEntry<String>(
                        value: item.value, label: item.label);
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      textValue = value!;
                      selectIndex =
                          items.indexWhere((element) => element.value == value);
                    });
                  }),
              TextField(
                enabled: items[selectIndex].key == 'custom',
                controller: _textEditingController,
                maxLines: 3,
              ),
              SizedBox.fromSize(
                size: const Size(0, 10),
              ),
              ElevatedButton(
                  onPressed: () {
                    context.go('/web', extra: textValue);
                  },
                  child: const Text('GO'))
            ],
          ),
        ));
  }
}
