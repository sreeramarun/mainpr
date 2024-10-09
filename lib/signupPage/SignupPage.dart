import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/data/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for user inputs
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _mentorNameController = TextEditingController();
  final TextEditingController _mentorPhoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _vtuNoController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _userPhoneController = TextEditingController();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create a new user with Firebase Auth
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Create UserModel object
        UserModel newUser = UserModel(
          attendedEvents: [],
          department: _departmentController.text.trim(),
          dob: _dobController.text.trim(),
          email: _emailController.text.trim(),
          mentorName: _mentorNameController.text.trim(),
          mentorPhone: _mentorPhoneController.text.trim(),
          userName: _userNameController.text.trim(),
          userPhone: _userPhoneController.text.trim(),
          role: 'USER', // Default role
          vtuNo: _vtuNoController.text.trim(),
          year: _yearController.text.trim(),
        );

        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid) // Using UID as document ID
            .set(newUser.toMap());

        // Notify user of successful registration
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User registered successfully!')),
        );

        // Optionally navigate to another page or clear fields
      } catch (e) {
        print("Error registering user: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Name
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'User Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your user name';
                  }
                  return null;
                },
              ),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              // Password
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              // Department
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'Department'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your department';
                  }
                  return null;
                },
              ),
              // Mentor Name
              TextFormField(
                controller: _mentorNameController,
                decoration: const InputDecoration(labelText: 'Mentor Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mentor name';
                  }
                  return null;
                },
              ),
              // Mentor Phone
              TextFormField(
                controller: _mentorPhoneController,
                decoration: const InputDecoration(labelText: 'Mentor Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mentor phone';
                  }
                  return null;
                },
              ),
              // Date of Birth
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),
              // VTU Number
              TextFormField(
                controller: _vtuNoController,
                decoration: const InputDecoration(labelText: 'VTU Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your VTU number';
                  }
                  return null;
                },
              ),
              // Year
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your year';
                  }
                  return null;
                },
              ),
              // User Phone
              TextFormField(
                controller: _userPhoneController,
                decoration: const InputDecoration(labelText: 'User Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your user phone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _departmentController.dispose();
    _mentorNameController.dispose();
    _mentorPhoneController.dispose();
    _dobController.dispose();
    _vtuNoController.dispose();
    _yearController.dispose();
    _userPhoneController.dispose();
    super.dispose();
  }
}
