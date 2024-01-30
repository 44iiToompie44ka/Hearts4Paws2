import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartforpaw/cards/card_info.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseFirestore db;
  List<String> types = []; // List to store unique 'type' values
  String selectedType = 'All'; // Default filter value

  @override
  void initState() {
    db = FirebaseFirestore.instance;
    _loadTypesFromFirebase();
    super.initState();
  }

  // Fetch unique 'type' values from Firestore documents
  void _loadTypesFromFirebase() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("pets").get();

    List<String> uniqueTypes = [];

    querySnapshot.docs.forEach((doc) {
      String type = doc.get('type');
      if (!uniqueTypes.contains(type)) {
        uniqueTypes.add(type);
      }
    });

    setState(() {
      types = uniqueTypes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50.0), // Add space from the top
            child: _buildFilterButtons(), // Display filter buttons at the top
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: (selectedType == 'All')
                  ? db.collection("pets").snapshots()
                  : db
                      .collection("pets")
                      .where('type', isEqualTo: selectedType)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2 / 2.4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    return _buildPetCard(snapshot.data?.docs[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterButton('All'), // Add 'All' filter button
          ...types.map((type) => _buildFilterButton(type)).toList(),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    bool isActive = selectedType == filter;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedType = filter;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: isActive ? Theme.of(context).colorScheme.secondary : null,
        onPrimary: isActive ? Colors.white : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5.0,
      ),
      child: Text(
        filter,
        style: TextStyle(
          color: isActive ? Colors.white : null,
        ),
      ),
    );
  }

  Widget _buildPetCard(QueryDocumentSnapshot<Map<String, dynamic>>? doc) {
    String imageUrl = doc?.get('image') ?? '';

    if (imageUrl.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InfoPet(
                petId: '',
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // White background color
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.grey.withOpacity(0.3), // Slight gray shadow color
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: AutoSizeText(
                          doc?.get('name') ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                          maxLines:
                              1, // Set the maximum number of lines before text scaling occurs
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: AutoSizeText(
                          '${doc?.get('age')} лет',
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      doc?.get('desc') ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(); // You can return an empty container or some placeholder widget
    }
  }
}
