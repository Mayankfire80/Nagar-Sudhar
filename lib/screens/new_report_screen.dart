import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fix_my_city/models/issue_data_model.dart';
import 'package:latlong2/latlong.dart';

class NewReportScreen extends StatefulWidget {
  final Function(IssueData) onReportSubmitted;

  const NewReportScreen({super.key, required this.onReportSubmitted});

  @override
  _NewReportScreenState createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  XFile? _imageFile;
  String? _selectedIssueType;
  String? _selectedSeverity;

  final List<String> _issueTypes = [
    'Pothole',
    'Litter/Garbage',
    'Damaged Sign',
    'Broken Streetlight',
    'Illegal Dumping',
    'Graffiti',
    'Water Leak',
    'Other',
  ];

  final List<String> _severityLevels = ['Low', 'Medium', 'High', 'Urgent'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _getCurrentLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fetching current location... (Dummy)')),
    );
    _locationController.text = "Current Location (Dummy)";
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      final newReport = IssueData(
        id: DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _imageFile != null ? _imageFile!.path : 'assets/default.png',
        location: const LatLng(23.7788, 86.4382),
        reportedOn: 'Just now',
        currentStatus: 'Pending',
      );
      widget.onReportSubmitted(newReport);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully!')),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report a New Problem',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Issue Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Issue Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _selectedIssueType,
                  hint: const Text('Choose a category'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedIssueType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an issue type';
                    }
                    return null;
                  },
                  items: _issueTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title of the issue (e.g., Pothole on Main St.)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Detailed description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                const Text(
                  'Location Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Address or landmark',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.my_location),
                      onPressed: _getCurrentLocation,
                      tooltip: 'Get current location',
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location or get current location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                const Text(
                  'Severity Level',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: _severityLevels.map((severity) {
                    return ChoiceChip(
                      label: Text(severity),
                      selected: _selectedSeverity == severity,
                      selectedColor: Colors.redAccent.withOpacity(0.2),
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedSeverity = selected ? severity : null;
                        });
                      },
                      labelStyle: TextStyle(
                        color: _selectedSeverity == severity
                            ? Colors.redAccent
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Upload Photo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      image: _imageFile != null
                          ? DecorationImage(
                              image: FileImage(File(_imageFile!.path)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _imageFile == null
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tap to add photo',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitReport,
        icon: const Icon(Icons.send),
        label: const Text('Submit Report'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}