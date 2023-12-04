import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:worldflags/model/country_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<country> allCountries;
  late List<country> displayedCountries = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const Url = "https://countriesnow.space/api/v0.1/countries/flag/images";
    var response = await http.get(Uri.parse(Url));
    var jsondata = json.decode(response.body);
    var jsonarray = jsondata['data'];

    allCountries = jsonarray
        .map<country>(
          (jsonCountry) => country(
            name: jsonCountry['name'],
            flag: jsonCountry['flag'],
          ),
        )
        .toList();

    displayedCountries = List.from(allCountries);

    setState(() {});
  }

  void filterCountries(String query) {
    displayedCountries = allCountries
        .where((country) =>
            country.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "World",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            Text(
              "Flags🌎",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterCountries,
              decoration: InputDecoration(
                  labelText: 'Search Country',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          Expanded(
            child: displayedCountries.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.black,
                  ))
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: displayedCountries.length,
                    itemBuilder: (context, index) {
                      country Country = displayedCountries[index];
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Card(
                          elevation: 50,
                          shadowColor: Colors.black,
                          color: const Color.fromARGB(33, 0, 103, 92),
                          child: SizedBox(
                            height: 300,
                            width: 500,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text(
                                    '🌎 ${Country.name}',
                                    style: GoogleFonts.permanentMarker(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Expanded(
                                    child: SvgPicture.network(
                                      Country.flag,
                                      height: 200,
                                      width: 400,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
