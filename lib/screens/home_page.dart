import 'package:flutter/material.dart';
import 'package:task1/screens/admin_page.dart';
import 'package:task1/screens/manager_page.dart';
import 'package:task1/utils/common_button.dart';

class HomePage extends StatefulWidget {
    static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonButton(
                title: "Admin",
                width: 200,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminPage()));
                }),
            const SizedBox(height: 18),
            CommonButton(
                title: "Manager",
                width: 200,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManagerPage()));
                })
          ],
        ),
      ),
    );
  }
}
