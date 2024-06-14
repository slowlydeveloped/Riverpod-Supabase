import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task1/models/orders_model.dart';
import 'package:task1/utils/common_button.dart';
import 'package:task1/utils/global_methods.dart';

import '../models/recipe_model.dart';
import '../providers/admin_providers.dart';

class ManagerPage extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ManagerPage());
  const ManagerPage({super.key});

  @override
  ConsumerState<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends ConsumerState<ManagerPage> {
  final Map<int, bool> _selectedItems = {};
  double _totalPrice = 0.0;
  List<RecipeModel> _items = [];

  void _toggleSelection(int index, int price) {
    setState(() {
      if (_selectedItems.containsKey(index) && _selectedItems[index] == true) {
        _selectedItems[index] = false;
        _totalPrice -= price;
      } else {
        _selectedItems[index] = true;
        _totalPrice += price;
      }
    });
  }

  void _makeOrder() async {
    final selectedItems = _items
        .asMap()
        .entries
        .where((entry) => _selectedItems[entry.key] == true)
        .map((entry) => entry.value)
        .toList();
    if (selectedItems.isEmpty) {
      showSnackBar(context, 'No items selected');
      return;
    }
    final order = OrderModel(totalPrice: _totalPrice);
    final orderItems = selectedItems
        .map((item) => OrderItemModel(
            recipeId: item.recipeId!, quantity: 1, price: item.recipePrice))
        .toList();

    final adminFunctions = ref.read(createOrderProvider.notifier);
    await adminFunctions.createOrder(order, orderItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Page"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final itemsFuture = ref.watch(fetchRecipesProvider);
                        return itemsFuture.when(
                          data: (items) {
                            _items =
                                items; // Update the state variable with fetched items
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CheckboxListTile(
                                          value: _selectedItems[index] ?? false,
                                          title: Text(item.recipeName),
                                          subtitle:
                                              Text('Price: ₹ ${item.recipePrice}'),
                                          onChanged: (bool? value) {
                                            _toggleSelection(index, item.recipePrice);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => Text('Error: $error'),
                        );
                      },
                    ),
                  ),
                  
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Total Price: ₹ $_totalPrice'),
              ),
              CommonButton(
                  title: "Make Order",
                  onPressed: () {
                    _makeOrder();
                  }),
            ],
          ),
          
        ),
      ),
    );
  }
}
