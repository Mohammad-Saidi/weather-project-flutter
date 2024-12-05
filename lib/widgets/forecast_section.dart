import 'package:auto_size_text/auto_size_text.dart';
import 'package:weather_flutter_project/utils/constants.dart';
import 'package:weather_flutter_project/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/forecast_weather.dart';

class ForecastSection extends StatelessWidget {
  final List<ForecastItem> items;
  final String unitSymbol;

  const ForecastSection({
    super.key,
    required this.items,
    required this.unitSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return AspectRatio(
            aspectRatio: 0.8,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Card(
                color: cardBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(getFormattedDateTime(
                        item.dt!,
                        pattern: 'EEE HH:mm',
                      )),

                      AutoSizeText(
                        'Max Temp: ${item.main!.tempMax!.round()}$degree$unitSymbol'
                      ),
                      AutoSizeText(
                          'Min Temp: ${item.main!.tempMin!.round()}$degree$unitSymbol'
                      ),
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: '$prefixWeatherIconUrl${item.weather![0].icon}$suffixWeatherIconUrl',
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        // child: Image.network(
                        //   '$prefixWeatherIconUrl${item.weather![0].icon}$suffixWeatherIconUrl',
                        //   width: 50,
                        //   height: 50,
                        //   errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        //     return const Icon(
                        //       Icons.image_not_supported,
                        //       size: 30,
                        //       color: Colors.grey,
                        //     );
                        //   },
                        // ),

                      ),
                      Text(
                        item.weather![0].description!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
