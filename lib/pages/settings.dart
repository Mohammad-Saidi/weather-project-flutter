import 'package:weather_flutter_project/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/weather_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isOn = false;
  late WeatherProvider provider;

  @override
  void initState() {
    getTempStatus().then((value) {
      setState(() {
        isOn = value;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<WeatherProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            value: isOn,
            onChanged: (value) async {
              setState(() {
                isOn = value;
              });
              await setTempStatus(value);
              provider.setTempUnit(value);
              provider.getData();
            },
            title: const Text('Show temperature in Fahrenheit'),
            subtitle: const Text('By default is Celsius'),
          ),
        ],
      ),
    );
  }
}
