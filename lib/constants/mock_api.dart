import '../gen/assets.gen.dart';

final List<Category> categories = [
  Category('Breakfast', Assets.icons.breakfast.path),
  Category('Soup', Assets.icons.hotSoup.path),
  Category('Pastry and bakery', Assets.icons.bakery.path),
  Category('Pasta', Assets.icons.spaguetti.path),
  Category('Rice', Assets.icons.rice.path),
];

class Category {
  final String name;
  final String icon;

  Category(this.name, this.icon);
}
