import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index].data() as Map<String, dynamic>;
            final userName = user['name'] ?? 'No name provided';
            final userEmail = user['email'] ?? 'No email provided';
            final userPhone = user['phone'] ?? 'No phone number provided';

            return ListTile(
              title: Text(userName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: $userEmail'),
                  Text('Phone: $userPhone'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('users').doc(users[index].id).delete();
                },
              ),
              onTap: () {
                // Navigate to the user details screen for updates (if needed)
              },
            );
          },
        );
      },
    );
  }
}
