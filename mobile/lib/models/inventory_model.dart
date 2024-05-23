class InventoryModel {
  String icon;
  String name;

  InventoryModel({
    required this.icon,
    required this.name,
  });

  static List<InventoryModel> getInventory() {
    List<InventoryModel> inventory = [];

    inventory.add(
      InventoryModel(
        icon: 'assets/bread.png',
        name: 'Bread'
      )
    );

    inventory.add(
      InventoryModel(
        icon: 'assets/bread.png',
        name: 'Bread'
      )
    );

    inventory.add(
      InventoryModel(
        icon: 'assets/bread.png',
        name: 'Bread'
      )
    );

    inventory.add(
      InventoryModel(
        icon: 'assets/bread.png',
        name: 'Bread'
      )
    );

    return inventory;
  }
}
