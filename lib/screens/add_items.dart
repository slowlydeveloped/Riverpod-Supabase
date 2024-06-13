import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task1/utils/common_textfied.dart';
import '/models/items_model.dart';
import '/providers/admin_providers.dart';
import '/utils/common_button.dart';

import '../utils/global_methods.dart';

class AddItems extends ConsumerStatefulWidget {
  // Define a route for navigating to this screen
  static route() => MaterialPageRoute(builder: (context) => const AddItems());

  const AddItems({super.key});

  @override
  AddItemsState createState() => AddItemsState();
}

class AddItemsState extends ConsumerState<AddItems> {
  final itemNameController = TextEditingController();
  final itemQuantityController = TextEditingController();
  final itemPriceController = TextEditingController();
  final vendorIdController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose text editing controllers when the widget is disposed
    itemNameController.dispose();
    itemQuantityController.dispose();
    itemPriceController.dispose();
    vendorIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Items"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormField(
                    hintText: "Items Name", controller: itemNameController),
                const SizedBox(height: 12),
                CustomTextFormField(
                  hintText: "Items Quantity (in Kgs)",
                  controller: itemQuantityController,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  hintText: "Items Price",
                  controller: itemPriceController,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  hintText: "Id of the vendor",
                  controller: vendorIdController,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                CommonButton(
                  title: "Add Items",
                  onPressed: () {
                    try {
                      // Create an ItemModel object with the provided data
                      final items = ItemModel(
                        items_name: itemNameController.text,
                        items_price: double.parse(itemPriceController.text),
                        items_quantity:
                            double.parse(itemQuantityController.text),
                        vendor_id: int.parse(vendorIdController.text),
                      );

                      // Call the addItems method from the provider
                      ref.read(adminFunctionsProvider.notifier).addItems(items);

                      // Refresh the items list
                      ref.refresh(fetchItemsProvider);

                      // Clear the input fields
                      itemNameController.clear();
                      itemPriceController.clear();
                      itemQuantityController.clear();
                      vendorIdController.clear();
                    } catch (e) {
                      // Show a snackbar with the error message if an error occurs
                      showSnackBar(context, e.toString());
                    }
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final itemsFuture = ref.watch(fetchItemsProvider);
                      return itemsFuture.when(
                        data: (items) => ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.items_name),
                                    Text(
                                        'Quantity: ${item.items_quantity} Kgs'),
                                    Text('Price: ₹ ${item.items_price}'),
                                    Text("Vendor's Name: ${item.vendorname}")
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) => Text('Error: $error'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
