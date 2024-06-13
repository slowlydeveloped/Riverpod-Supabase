import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task1/models/recipe_model.dart';
import 'package:task1/providers/admin_providers.dart';
import 'package:task1/screens/create_recipe.dart';
import 'package:task1/utils/common_button.dart';
import 'package:task1/utils/common_textfied.dart';

class AddRecipe extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const AddRecipe());

  const AddRecipe({super.key});

  @override
  AddRecipeState createState() => AddRecipeState();
}

class AddRecipeState extends ConsumerState<AddRecipe> {
  final recipeNameController = TextEditingController();
  final recipePriceController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    recipeNameController.dispose();
    recipePriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Recipe"),
      ),
      body: Center(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextFormField(
                    hintText: "Recipe's Name",
                    controller: recipeNameController),
                const SizedBox(height: 12),
                CustomTextFormField(
                    hintText: "Recipe's Price",
                    controller: recipePriceController),
                const SizedBox(height: 12),
                CommonButton(
                    title: "Create Recipe",
                    onPressed: () {
                      final recipes = RecipeModel(
                          recipeName: recipeNameController.text,
                          recipePrice: int.parse(recipePriceController.text));

                      ref.read(adminFunctionsProvider.notifier).addRecipe(recipes);
                      Navigator.push(context, CreateRecipe.route());
                      recipeNameController.clear();
                      recipePriceController.clear();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
