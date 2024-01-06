class Cuisine {
  final String name;
  final String value;

  const Cuisine._(this.name, this.value);

  static const Cuisine selectCuisine =
      Cuisine._('Select Cuisine', 'selectCuisine');
  static const Cuisine italian = Cuisine._('Italian', 'italian');
  static const Cuisine chinese = Cuisine._('Chinese', 'chinese');
  static const Cuisine american = Cuisine._('American', 'american');
  static const Cuisine fastFood = Cuisine._('Fast Food', 'fastFood');
  static const Cuisine traditional = Cuisine._('Traditional', 'traditional');

  static const List<Cuisine> values = [
    selectCuisine,
    italian,
    chinese,
    american,
    fastFood,
    traditional,
  ];
}
