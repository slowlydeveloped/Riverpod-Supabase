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

  @override
  void dispose() {
    recipeNameController.dispose();
    itemNameController.dispose();
    quantityController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
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
                CustomTextFormField(
                  controller: itemNameController,
                  hintText: "Item's Name",
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
                  children: [CommonButton(
                  title: "Add More Items",
                  onPressed: () {
                    final recipeCreation = RecipeCreationModel(
                      recipeName: recipeNameController.text,
                      itemName: itemNameController.text,
                      itemQuantity: double.parse(quantityController.text),
                    );
                    ref
                        .read(recipeCreationProvider.notifier)
                        .createRecipe(recipeCreation);
                    itemNameController.clear();
                    quantityController.clear();
                  },
                ),
                const SizedBox(width: 12),
                CommonButton(
                  title: "Save Recipe",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),],)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
