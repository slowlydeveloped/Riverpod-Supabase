import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task1/models/recipe_creation.dart';
import 'package:task1/providers/admin_providers.dart';
import 'package:task1/utils/common_button.dart';
import '../utils/common_textfied.dart';

class CreateRecipe extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateRecipe());
  const CreateRecipe({super.key});

  @override
  CreateRecipeState createState() => CreateRecipeState();
}

class CreateRecipeState extends ConsumerState<CreateRecipe> {
  final recipeNameController = TextEditingController();
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final List<RecipeCreationModel> addedItems = [];
  String selectedItem = "";

  @override
  void dispose() {
    recipeNameController.dispose();
    itemNameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsyncValue = ref.watch(fetchItemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Recipe"),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CustomTextFormField(
                      controller: recipeNameController,
                      hintText: "Recipe's Name",
                    ),
                    const SizedBox(height: 12),
                    itemsAsyncValue.when(
                      data: (items) {
                        return DropdownButton<String>(
                          isExpanded: true,
                          underline: const SizedBox(),
                          value: selectedItem.isNotEmpty ? selectedItem : null,
                          hint: const Text("Select Item"),
                          onChanged: (value) {
                            setState(() {
                              selectedItem = value!;
                              itemNameController.text = selectedItem;
                            });
                          },
                          items: items.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.items_name, 
                              child: Text(item.items_name),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stackTrace) => Text('Error: $error'),
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      controller: quantityController,
                      hintText: "Item's Quantity",
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CommonButton(
                      title: "Add More Items",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final recipeCreation = RecipeCreationModel(
                            recipeName: recipeNameController.text,
                            itemName: itemNameController.text,
                            itemQuantity: double.parse(quantityController.text),
                          );
                          setState(() {
                            addedItems.add(recipeCreation);
                          });
                          itemNameController.clear();
                          quantityController.clear();
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    CommonButton(
                      title: "Save Recipe",
                      onPressed: () async {
                        for (var item in addedItems) {
                          try {
                            await ref.read(recipeCreationProvider.notifier).createRecipe(item);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Error: $e'),
                            ));
                          }
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: addedItems.length,
                    itemBuilder: (context, index) {
                      final item = addedItems[index];
                      return Card(
                        color: Colors.deepPurple.withOpacity(0.1),
                        child: ListTile(
                          title: Text(item.itemName, style: const TextStyle(color: Colors.deepPurple)),
                          subtitle: Text("Quantity: ${item.itemQuantity}", style: const TextStyle(color: Colors.deepPurple)),
                        ),
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
