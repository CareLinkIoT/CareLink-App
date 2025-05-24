// role_select_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  void _navigateWithRole(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(selectedRole: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "역할을 선택하세요",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _navigateWithRole(context, 'user'),
                icon: Icon(Icons.person),
                label: Text("사용자 로그인"),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _navigateWithRole(context, 'guardian'),
                icon: Icon(Icons.shield),
                label: Text("보호자 로그인"),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50), backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}