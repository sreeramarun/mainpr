import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/adminAddEventPage/AdminAddEventPage.dart';
import 'package:event/data/EventModel.dart';
import 'package:event/data/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserHomepage extends StatefulWidget {
  const UserHomepage({super.key});

  @override
  State<UserHomepage> createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  Future<List<EventModel>>? eventsFuture;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    eventsFuture = getAllEvents();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userModel =
                UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
            print("test hello --------- :${userModel?.toMap()}");
          });
        } else {
          print('User document does not exist.');
        }
      } else {
        print('No user is signed in.');
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<List<EventModel>> getAllEvents() async {
    List<EventModel> eventsList = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('events').get();

      for (var doc in querySnapshot.docs) {
        EventModel event =
            EventModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        eventsList.add(event);
      }
      print(eventsList.toString());
    } catch (e) {
      print("Error fetching events: $e");
    }
    return eventsList;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerStudent(
      {required String eventId, required String vtunumber}) async {
    try {
      DocumentReference eventRef = _firestore.collection('events').doc(eventId);
      DocumentSnapshot eventSnapshot = await eventRef.get();

      if (!eventSnapshot.exists) {
        print("Event does not exist");
        return;
      }

      List<String> registeredStudents =
          List<String>.from(eventSnapshot['registered'] ?? []);
      if (!registeredStudents.contains(vtunumber)) {
        registeredStudents.add(vtunumber);
        await eventRef.update({'registered': registeredStudents});
      }

      DocumentReference userRef = _firestore.collection('Users').doc(vtunumber);
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        UserModel user =
            UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
        if (!user.attendedEvents.contains(eventId)) {
          user.attendedEvents.add(eventId);
          await userRef.update({'attendedEvents': user.attendedEvents});
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registered successfully!')),
      );

      setState(() {
        eventsFuture = getAllEvents();
      });
    } catch (e) {
      print("Error registering for event: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering for event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProfileAvatar(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("userModel!.userName"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${FirebaseAuth.instance.currentUser?.email}'),
                ),
                const Divider(),
              ],
            ),
            ListTile(
              title: const Text('Attended Events'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Signout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<EventModel>>(
        future: eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          List<EventModel> events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return eventCard(
                eventName: event.eventName,
                startDate: event.startDate,
                endDate: event.endDate,
                startTime: event.startTime,
                endTime: event.endTime,
                isLimitedStudent: event.isLimitedStudent,
                studentLimit: event.studentLimit,
                resourcePerson: event.resourcePerson,
                venue: event.venue,
                registeredCount: event.registered.length,
                bannerImage: event.bannerImage,
                onRegisterPressed: () {
                  User? currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    registerStudent(
                        eventId: event.id, vtunumber: userModel!.vtuNo);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please log in to register.')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return CircleAvatar(
      radius: 30.0,
      backgroundColor: Colors.grey,
      foregroundImage:
          user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
    );
  }
}

Widget eventCard({
  required String eventName,
  required String startDate,
  required String endDate,
  required String startTime,
  required String endTime,
  required bool isLimitedStudent,
  required int studentLimit,
  required String resourcePerson,
  required String venue,
  required int registeredCount,
  required String bannerImage,
  required VoidCallback onRegisterPressed,
}) {
  return Card(
    margin: const EdgeInsets.all(10.0),
    child: TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        shape: BeveledRectangleBorder(),
      ),
      onPressed: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 20),
                  ),
                  Text('$startDate to $endDate'),
                ],
              ),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(bannerImage),
                    fit: BoxFit.fill,
                  ),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$startTime to $endTime"),
                Text("Registered: $registeredCount/$studentLimit"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onRegisterPressed,
                  child: const Text("Register"),
                ),
                if (isLimitedStudent) Text("Limited seats available"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
