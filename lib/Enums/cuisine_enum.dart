class Cuisine {
  final String name;
  final String value;

  const Cuisine._(this.name, this.value);

  static const Cuisine selectCuisine =
      Cuisine._('Select Cuisine', 'selectCuisine');
  static const Cuisine italian = Cuisine._('Italian', 'italian');
  static const Cuisine mexican = Cuisine._('Mexican', 'mexican');
  static const Cuisine chinese = Cuisine._('Chinese', 'chinese');
  static const Cuisine indian = Cuisine._('Indian', 'indian');
  static const Cuisine japanese = Cuisine._('Japanese', 'japanese');
  static const Cuisine french = Cuisine._('French', 'french');
  static const Cuisine greek = Cuisine._('Greek', 'greek');
  static const Cuisine spanish = Cuisine._('Spanish', 'spanish');
  static const Cuisine american = Cuisine._('American', 'american');
  static const Cuisine fastFood = Cuisine._('Fast Food', 'fastFood');
  static const Cuisine traditional = Cuisine._('Traditional', 'traditional');

  static const List<Cuisine> values = [
    selectCuisine,
    italian,
    mexican,
    chinese,
    indian,
    japanese,
    french,
    greek,
    spanish,
    american,
    fastFood,
    traditional,
  ];
}
