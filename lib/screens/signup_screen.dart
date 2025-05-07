// screens/signup_screen.dart
import 'package:eco_collect/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validators/validators.dart';

class SignupScreen extends StatefulWidget {
  final Function toggleAuthMode;
  const SignupScreen({super.key, required this.toggleAuthMode});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthBase auth = Auth();
  bool isLoading = false;

  Future<void> _Createaccount() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (formKey.currentState!.validate()) {
        final user = await auth.createUserWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );
          // Navigate to the login screen
          widget.toggleAuthMode();
        }
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'An error occurred')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
              const Text(
                "EcoCollect ♻️",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Create your account",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
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
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(
                              Icons.lock_reset,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          validator:
                              (val) =>
                                  val != passwordController.text
                                      ? 'Passwords do not match'
                                      : null,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      if (formKey.currentState!.validate()) {
                                        _Createaccount();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Creating account...',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                            child:
                                isLoading
                                    ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    )
                                    : const Text(
                                      'SIGN UP',
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
              TextButton(
                onPressed: () => widget.toggleAuthMode(),
                child: const Text(
                  "Already have an account? LOG IN",
                  style: TextStyle(color: Color(0xFF2E7D32)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
