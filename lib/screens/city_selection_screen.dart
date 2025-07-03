import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/city_list.dart';
import 'weather_screen.dart';

class CitySelectionScreen extends StatefulWidget {
  final void Function(String) onCitySelected;

  CitySelectionScreen({required this.onCitySelected});

  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  String? selectedCity;
  List<String> cities = [];
  List<String> favoriteCities = [];

  @override
  void initState() {
    super.initState();
    selectedCity = "Denizli";
    cities = turkishCities;
    _loadFavoriteCities();
  }

  Future<List<String>> _loadCities(String filter) async {
    await Future.delayed(Duration(milliseconds: 5));
    return cities
        .where((city) => city.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  _loadFavoriteCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteCities = prefs.getStringList('favoriteCities') ?? [];
    });
  }

  _addFavoriteCity(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!favoriteCities.contains(city)) {
      favoriteCities.add(city);
      await prefs.setStringList('favoriteCities', favoriteCities);
      setState(() {});
    }
  }

  _removeFavoriteCity(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    favoriteCities.remove(city);
    await prefs.setStringList('favoriteCities', favoriteCities);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFc3e4f3),
      appBar: AppBar(
        backgroundColor: Color(0xFF253949),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Hava Durumu Uygulaması"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assests/images/header.png', fit: BoxFit.contain),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Şehir Seçin",
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            SizedBox(height: 10),
            DropdownSearch<String>(
              asyncItems: _loadCities,
              onChanged: (newValue) {
                setState(() {
                  selectedCity = newValue;
                });
              },
              selectedItem: selectedCity,
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(hintText: 'Şehir ara...'),
                ),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Şehir Seçin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // Kenarlık yok
                  ),
                ),
              ),
              dropdownBuilder: (context, selectedItem) {
                return Text(selectedItem ?? 'Şehir Seçin');
              },
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF259ed9),
                    foregroundColor: Colors.white,
                    minimumSize: Size(150, 40),
                  ),
                  onPressed:
                      selectedCity != null
                          ? () {
                            widget.onCitySelected(selectedCity!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        WeatherScreen(cityName: selectedCity!),
                              ),
                            );
                          }
                          : null,
                  child: Text("Devam Et"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF259ed9),
                    foregroundColor: Colors.white,
                  ),
                  onPressed:
                      selectedCity != null
                          ? () {
                            _addFavoriteCity(selectedCity!); // Favoriye ekle
                          }
                          : null,
                  child: Text("Favorilere Kaydet"),
                ),
              ],
            ),
            SizedBox(height: 50),
            Text(
              "Favori Şehirler",
              style: TextStyle(fontSize: 22, color: Colors.black),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: favoriteCities.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  String city = favoriteCities[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeatherScreen(cityName: city),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm Deletion"),
                            content: Text(
                              'Are you sure you want to delete the city "$city"?',
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  _removeFavoriteCity(city);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          city,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
