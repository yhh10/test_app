import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:http/http.dart' as http; 


class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwCheckController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handleSignin() async {
    setState(() {
      _errorMessage = '';
    });
  
    if (_idController.text.isEmpty || _pwController.text.isEmpty || _pwCheckController.text.isEmpty) {
      setState(() {
        _errorMessage = '아이디와 비밀번호를 모두 입력하세요.';
      });
      return;
    }
    if (_pwController.text != _pwCheckController.text) {
      setState(() {
        _errorMessage = '입력한 비밀번호가 일치하지 않습니다.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://134.185.114.3:8000/api/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username' : _idController.text,
          'password' : _pwController.text,
        }),
      ).timeout(const Duration(seconds: 5));

      if (!mounted) return;

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? '회원가입이 완료되었습니다.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } else {
        final errorMsg = data['detail'] ?? '회원가입에 실패했습니다.';
        setState(() {
          _errorMessage = errorMsg;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '서버와 연결할 수 없습니다. 다시 시도해주세요.';
        });
      }
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
        title: Text("회원가입"),
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
                "회원가입",
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
              TextField(
                controller: _pwCheckController,
                obscureText: true,
                decoration: InputDecoration(labelText: "비밀번호 확인"),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20,),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSignin,
                child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white,)
                  : const Text("회원가입하기")
              ),
            ],
          ),
        ),
      ),
    );
  }
}