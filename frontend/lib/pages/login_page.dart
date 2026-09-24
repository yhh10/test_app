import 'dart:convert';
import 'package:flutter/material.dart'; // 필수
import 'package:frontend/pages/home_page.dart';
import 'package:http/http.dart' as http;



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  // final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handleLogin() async {
    if (_idController.text.isEmpty || _pwController.text.isEmpty) {
      setState(() {
        _errorMessage = '아이디와 비밀번호를 모두 입력하세요.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://134.185.114.3:8000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id' : _idController.text,
          'pw' : _pwController.text,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        } else {
          setState(() {
            _errorMessage = '아이디 또는 비밀번호가 일치하지 않습니다.';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = '서버와 연결할 수 없습니다. 다시 시도해주세요.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Login"),
      ),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "로그인",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              TextField(
                controller: _idController,
                decoration: InputDecoration(labelText: "아이디"),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _pwController,
                obscureText: true,
                decoration: InputDecoration(labelText: "비밀번호"),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20,),
              
              ElevatedButton(onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text("로그인하기")),
            ],
          ),
        ),
      ),
    );
  }
}
