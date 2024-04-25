import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
      label: "Sandbox",
      value:
          "https://open-sandbox.klavi.ai/data/v1/basic-links/ofpfdemo?redirect_url=klavilinkdemoflutter://redirect",
      key: '1',
    ),
    ListItemType(
      label: "Testing",
      value:
          "https://open-testing.klavi.ai/data/v1/basic-links/ofpfdemo?redirect_url=klavilinkdemoflutter://redirect",
      key: '2',
    ),
    ListItemType(
      label: "ofpf-multi-insti（A）",
      value:
          "https://open-testing.klavi.ai/data/v1/basic-links/ofpf-multi-insti?personal_tax_id=22697459812&email=jmlee26@gmail.com&redirect_url=klavilinkdemoflutter://redirect",
      key: '3',
    ),
    ListItemType(
      label: "ofpf-singl-insti（B）",
      value:
          "https://open-testing.klavi.ai/data/v1/basic-links/ofpf-singl-insti?personal_tax_id=22697459812&email=jmlee26@gmail.com&redirect_url=klavilinkdemoflutter://redirect",
      key: '4',
    ),
    ListItemType(
        label: "Custom",
        value:
            "https://open.klavi.tech/data/v1/basic-links/ofpfdemo?redirect_url=klavilinkdemoflutter://redirect",
        key: "custom"),
  ];

  var selectIndex = 0;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController(text: items.first.value);
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
                  initialSelection: _textEditingController.text,
                  dropdownMenuEntries:
                      items.map<DropdownMenuEntry<String>>((item) {
                    return DropdownMenuEntry<String>(
                        value: item.value, label: item.label);
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      _textEditingController.text = value!;
                      selectIndex =
                          items.indexWhere((element) => element.value == value);
                    });
                  }),
              TextField(
                enabled: items[selectIndex].key == 'custom',
                controller: _textEditingController,
                minLines: 1,
                maxLines: 5,
              ),
              SizedBox.fromSize(
                size: const Size(0, 10),
              ),
              ElevatedButton(
                  onPressed: () {
                    context.go('/web', extra: _textEditingController.text);
                  },
                  child: const Text('Open in Webview')),
              SizedBox.fromSize(
                size: const Size(0, 10),
              ),
              ElevatedButton(
                  onPressed: () {
                    launchUrl(Uri.parse(_textEditingController.text),
                        mode: LaunchMode.externalApplication);
                  },
                  child: const Text('Open in browser'))
            ],
          ),
        ));
  }
}
