import 'package:auto_size_text/auto_size_text.dart';
import 'package:weather_flutter_project/models/current_weather.dart';
import 'package:weather_flutter_project/utils/constants.dart';
import 'package:weather_flutter_project/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CurrentSection extends StatelessWidget {
  final CurrentWeather currentWeather;
  final String unitSymbol;

  const CurrentSection({
    super.key,
    required this.currentWeather,
    required this.unitSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date: ${getFormattedDateTime(currentWeather.dt!, pattern: 'EEE MMM dd, yyyy')}",
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            'Area Name: ${currentWeather.name!}-${currentWeather.sys!.country}',
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currentWeather.main!.temp!.toStringAsFixed(0)}$degree$unitSymbol',
                style: const TextStyle(
                  fontSize: 100,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                    imageUrl: '$prefixWeatherIconUrl${currentWeather.weather![0].icon}$suffixWeatherIconUrl',
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  // Image.network(
                  //   '$prefixWeatherIconUrl${currentWeather.weather![0].icon}$suffixWeatherIconUrl',
                  //   errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  //     return const Icon(
                  //       Icons.image_not_supported,
                  //       size: 30,
                  //       color: Colors.grey,
                  //     );
                  //   },
                  // ),
                  AutoSizeText(
                    currentWeather.weather![0].description!,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
