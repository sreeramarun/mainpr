import 'package:event/adminPage/AdminPage.dart';
import 'package:event/loginPage/LoginPage.dart';
import 'package:event/signupPage/SignupPage.dart';
import 'package:event/userHomePage/UserHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Authpage extends StatefulWidget {
  const Authpage({super.key});

  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<String?> getUserRole(String uid) async {
  try {
    DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(uid).get();
    
    if (userDoc.exists) {
      var roleData = userDoc.get('role');  // Get role data
      
      // Ensure it's a String, otherwise convert or return an error
      if (roleData is String) {
        return roleData;  // Return if it's a String
      } else {
        print("Error: role is not a String. Found type: ${roleData.runtimeType}");
        return null;  // Handle error if it's not a String
      }
    } else {
      return null;
    }
  } catch (e) {
    print("Error fetching user role: $e");
    return null;
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String? userId = snapshot.data?.uid;
            if (userId != null) {
              return FutureBuilder<String?>(
                future: getUserRole(userId),
                builder: (context, roleSnapshot) {
                  if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (roleSnapshot.hasError) {
                    return Center(child: Text('Error: ${roleSnapshot.error}'));
                  } else if (roleSnapshot.hasData &&
                      roleSnapshot.data != null) {
                    String? role = roleSnapshot.data;
                    if (role == 'admin') {
                      return const Adminpage();
                    } else if (role == "user") {
                      return const UserHomepage();
                    }
                  }
                  return const Center(child: Text('User role not found.'));
                },
              );
            } else {
              return const Center(child: Text('User ID not available.'));
            }
          } else {
            return const Loginpage();
          }
        },
      ),
    );
  }
}
