import 'package:weather_flutter_project/pages/settings.dart';
import 'package:weather_flutter_project/utils/helper.dart';
import 'package:weather_flutter_project/utils/location_service.dart';
import 'package:weather_flutter_project/widgets/current_section.dart';
import 'package:weather_flutter_project/widgets/forecast_section.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/weather_provider.dart';
import '../utils/constants.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  late WeatherProvider provider;

  @override
  void didChangeDependencies() {
    provider = Provider.of<WeatherProvider>(context, listen: false);
    getLocation();
    super.didChangeDependencies();
  }

  getLocation() async {
    final position = await determinePosition();
    provider.setNewLocation(position.latitude, position.longitude);
    provider.setTempUnit(await getTempStatus());
    provider.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: getLocation,
        child: const Icon(Icons.my_location),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Weather Information'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage()));
          },
          icon: const Icon(Icons.settings),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: _CitySearchDelegate(),
              ).then((value) {
                if (value != null && value.isNotEmpty) {
                  provider.convertCityToCoord(value).then((value) {
                    print(value);
                    showMsg(context, value);
                  });
                }
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) => provider.hasDataLoaded
            ? SingleChildScrollView(

                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CurrentSection(
                        currentWeather: provider.currentWeather!,
                        unitSymbol: provider.tempUnitSymbol,
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    ForecastSection(
                      items: provider.forecastWeather!.list!,
                      unitSymbol: provider.tempUnitSymbol,
                    ),
                  ],
                ),
              )
            : const Center(
                child: Text('Please wait'),
              ),
      ),
    );
  }
}

class _CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: () {
        close(context, query);
      },
      title: Text(query),
      leading: const Icon(Icons.search),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredList = query.isEmpty
        ? cities
        : cities.where((city) => city.toLowerCase().startsWith(query)).toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          close(context, filteredList[index]);
        },
        title: Text(filteredList[index]),
      ),
    );
  }
}
