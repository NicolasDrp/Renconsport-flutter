import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CityInput extends StatefulWidget {
  const CityInput({super.key, required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  State<CityInput> createState() => _CityInputState();
}

class _CityInputState extends State<CityInput> {
  List _townQueryResults = [];
  bool showTowns = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      (showTowns == true)
          ? SizedBox(
              height: 160,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ListView(
                  shrinkWrap: true,
                  children: (_townQueryResults.isNotEmpty
                      ? _townQueryResults.map((town) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Card(
                              child: ListTile(
                                title: Text(town),
                                onTap: () {
                                  setState(() {
                                    widget.controller.text = town;
                                    showTowns = false;
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList()
                      : [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              title: Text("Aucun résultat"),
                            ),
                          )
                        ]),
                ),
              ),
            )
          : const SizedBox(
              height: 0,
            ),
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextField(
          onChanged: (value) {
            http
                .get(Uri.parse(
                    "https://api-adresse.data.gouv.fr/search/?q=$value&type=municipality"))
                .then((response) {
              setState(() {
                if (response.statusCode == 200) {
                  setState(() {
                    showTowns = true;
                  });
                  _townQueryResults = [];
                  var townsJson = jsonDecode(response.body);
                  for (var town in townsJson['features']) {
                    _townQueryResults.add(town['properties']['name']);
                  }
                } else {
                  _townQueryResults = [];
                  setState(() {
                    showTowns = false;
                  });
                }
              });
            });
          },
          controller: widget.controller,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange)),
            labelText: widget.label,
          ),
        ),
      )
    ]);
  }
}
