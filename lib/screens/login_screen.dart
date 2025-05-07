// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validators/validators.dart';
import 'package:eco_collect/auth/auth.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleAuthMode;
  const LoginScreen({super.key, required this.toggleAuthMode});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthBase auth = Auth();
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (formKey.currentState!.validate()) {
        final user = await auth.signInWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        if (user != null) {
          if (!mounted) return; // Check if the widget is still mounted
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful!')));
          // TODO: Navigate to the next screen after successful login
        }
      }
    } on PlatformException catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'An error occurred')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo/App Name
              const Text(
                "EcoCollect ♻️",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32), // Dark green
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Log in to manage waste efficiently",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              // Login Form
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          validator:
                              (val) =>
                                  !isEmail(val!) ? 'Enter a valid email' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          validator:
                              (val) =>
                                  val!.length < 6 ? 'Password too short' : null,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      login();
                                    },
                            child:
                                isLoading
                                    ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    )
                                    : const Text(
                                      'LOG IN',
                                      style: TextStyle(fontSize: 16),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Sign up toggle
              TextButton(
                onPressed: () => widget.toggleAuthMode(),
                child: const Text(
                  "Don’t have an account? SIGN UP",
                  style: TextStyle(color: Color(0xFF2E7D32)), // Dark green
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
