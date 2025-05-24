import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String role = 'user';
  String errorMessage = '';

  Future<void> _signup() async {
    try {
      final String prefix = role == 'guardian' ? 'g_' : 'u_';
      final String email = prefix + emailController.text.trim();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: passwordController.text.trim(),
      );

      setState(() {
        errorMessage = '회원가입 성공!';
      });
    } catch (e) {
      setState(() {
        errorMessage = '회원가입 실패: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: 'user', child: Text('사용자')),
                DropdownMenuItem(value: 'guardian', child: Text('보호자')),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: const Text('회원가입'),
            ),
            const SizedBox(height: 12),
            Text(errorMessage, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
