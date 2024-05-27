import 'package:flutter/material.dart';
import 'package:restobook_web/view/restaurant_screen.dart';

import '../model/entities/restaurant.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        title: Text(restaurant.name),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RestaurantScreen(restaurant: restaurant,)));
        },
      ),
    );
  }
}