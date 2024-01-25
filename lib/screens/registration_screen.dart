import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PetRegistrationScreen extends StatefulWidget {
  @override
  _PetRegistrationScreenState createState() => _PetRegistrationScreenState();
}

class _PetRegistrationScreenState extends State<PetRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _age = 0;
  final _descController = TextEditingController();
  File? _image;

  String _selectedType = 'Cat'; // Initialize with a default value from the list

  List<String> petTypes = ['Cat', 'Dog', 'Hamster', 'Rat', 'Turtle', 'Fish'];

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Upload image to Firebase Storage and get the download URL
      String imageUrl = await uploadImage();

      // Save data to Firebase Firestore
      try {
        await FirebaseFirestore.instance.collection('pets').add({
          'type': _selectedType,
          'name': _nameController.text,
          'age': _age,
          'desc': _descController.text,
          'image': imageUrl, // Store the image URL in the same document
        });

        // Clear form fields
        _selectedType = ''; // Clear selected type
        _nameController.clear();
        _descController.clear();
        _age = 0;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pet registration successful!'),
          ),
        );
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }

  Future<String> uploadImage() async {
    if (_image == null) {
      return '';
    }

    try {
      String imageName =
          '${DateTime.now().millisecondsSinceEpoch}.png'; // Use a unique name for the image
      Reference storageReference =
          FirebaseStorage.instance.ref().child(imageName);
      await storageReference.putFile(_image!);
      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              ElevatedButton(
                onPressed: _getImage,
                child: Text('Pick Image'),
              ),
              _image != null
                  ? Image.file(
                      _image!,
                      height: 100,
                      width: 100,
                    )
                  : SizedBox.shrink(),
              // Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
                items: petTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the type of pet';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of pet';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Text('Age: $_age'),
                  Slider(
                    value: _age.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _age = value.round();
                      });
                    },
                    min: 0,
                    max: getMaxAgeForType(_selectedType).toDouble(),
                  ),
                ],
              ),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double getMaxAgeForType(String type) {
    switch (type.toLowerCase()) {
      case 'cat':
        return 20; // Cats can live up to 20 years or more.
      case 'dog':
        return 15; // Dogs have a wide range of lifespans, but 15 is a common maximum.
      case 'hamster':
        return 3; // Hamsters typically live around 2 to 3 years.
      case 'rat':
        return 4; // Rats generally live 2 to 4 years.
      case 'turtle':
        return 100; // Turtles can have very long lifespans, some exceeding 100 years.
      case 'fish':
        return 30; // Some fish species, like Koi, can live for several decades.
      default:
        return 10; // Default maximum age for unknown types.
    }
  }
}
