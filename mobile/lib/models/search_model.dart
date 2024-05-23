class SearchModel {
  String icon;
  String name;

  SearchModel({
    required this.icon,
    required this.name,
  });

  static List<SearchModel> getSearch() {
    List<SearchModel> searches = [];

    searches.add(
      SearchModel(
        icon: 'assets/bread.png',
        name: 'Bread'
      )
    );

    searches.add(
      SearchModel(
        icon: 'assets/bread.png',
        name: 'Bread'
      )
    );

    searches.add(
      SearchModel(
        icon: 'assets/bread.png',
        name: 'Bread'
      )
    );

    searches.add(
      SearchModel(
        icon: 'assets/bread.png',
        name: 'Bread'
      )
    );

    return searches;
  }
}
