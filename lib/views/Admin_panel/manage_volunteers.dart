import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageVolunteersScreen extends StatelessWidget {
  const ManageVolunteersScreen({Key? key}) : super(key: key);

  // Delete Volunteer
  Future<void> deleteVolunteer(String volunteerId) async {
    await FirebaseFirestore.instance.collection('volunteers').doc(volunteerId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('volunteers').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final volunteers = snapshot.data!.docs;

        return ListView.builder(
          itemCount: volunteers.length,
          itemBuilder: (context, index) {
            final volunteer = volunteers[index];
            return ListTile(
              title: Text(volunteer['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${volunteer['email']}'),
                  Text('Phone: ${volunteer['phone']}'),
                  Text('Created At: ${(volunteer['createdAt'] as Timestamp).toDate()}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await deleteVolunteer(volunteer.id);
                },
              ),
              onTap: () {
                // Implement view or update details
              },
            );
          },
        );
      },
    );
  }
}
