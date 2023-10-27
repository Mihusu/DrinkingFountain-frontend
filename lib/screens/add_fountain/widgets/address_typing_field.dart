import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Address Autocomplete')),
        body: AddressTypingField(),
      ),
    );
  }
}

class AddressTypingField extends StatefulWidget {
  @override
  _AddressTypingFieldState createState() => _AddressTypingFieldState();
}

class _AddressTypingFieldState extends State<AddressTypingField> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _suggestions = [
    'Strandvejen 1, 2900 Hellerup',
    'Vesterbrogade 2B, 1620 København',
    'Møllegade 3, 8000 Aarhus',
    'Algade 4, 9000 Aalborg',
  ];
  List<String> _filteredSuggestions = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Indtast adresse'),
            onChanged: (value) {
              setState(() {
                _filteredSuggestions = _suggestions
                    .where((suggestion) =>
                        suggestion.toLowerCase().contains(value.toLowerCase()))
                    .toList();
              });
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredSuggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_filteredSuggestions[index]),
                onTap: () {
                  _controller.text = _filteredSuggestions[index];
                  setState(() {
                    _filteredSuggestions = [];
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
