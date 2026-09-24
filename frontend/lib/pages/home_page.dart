import 'dart:convert';
import 'package:flutter/material.dart'; // 필수
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/signin_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  
  // final String title;

  @override
  State<MyHomePage> createState() => _HomePageSate();
}

class _HomePageSate extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('메인')
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "메인페이지에 오신걸 환영합니다.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                  onPressed: () {
                    Navigator.push( 
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    "로그인 하러가기",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SigninPage()),
                    );
                  },
                  child: const Text(
                    "회원가입 하러가기",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}