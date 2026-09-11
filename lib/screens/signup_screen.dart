import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim().toLowerCase();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      showMessage('সব তথ্য পূরণ করুন');
      return;
    }

    if (password.length < 6) {
      showMessage('Password কমপক্ষে ৬ অক্ষরের হতে হবে');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        showMessage('Account তৈরি করা যায়নি');
        return;
      }

      await user.updateDisplayName(name);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name,
        'username': username,
        'email': email,
        'phone': '',
        'photoUrl': '',
        'bio': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      showMessage('Bondhu Account তৈরি হয়েছে!');

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'Account তৈরি করা যায়নি';

      if (e.code == 'email-already-in-use') {
        message = 'এই Email দিয়ে Account আগে থেকেই আছে';
      } else if (e.code == 'invalid-email') {
        message = 'Email সঠিক নয়';
      } else if (e.code == 'weak-password') {
        message = 'Password আরও শক্তিশালী দিন';
      }

      showMessage(message);
    } catch (e) {
      showMessage('সমস্যা হয়েছে');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('নতুন Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              'Bondhu-তে যোগ দিন',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'আপনার নাম',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'যেমন: mojidul123',
                prefixIcon: Icon(Icons.alternate_email),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: loading ? null : createAccount,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Account তৈরি করুন',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
