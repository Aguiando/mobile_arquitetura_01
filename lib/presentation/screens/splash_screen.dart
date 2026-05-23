import 'package:flutter/material.dart';
import '../../session/session_controller.dart';
import 'login_page.dart';
import 'product_list_screen.dart';
 
/// Tela inicial: verifica se há sessão ativa e redireciona corretamente.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
 
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
 
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }
 
  Future<void> _checkSession() async {
    await SessionController.instance.loadFromPrefs();
    if (!mounted) return;
 
    if (SessionController.instance.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductListScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}