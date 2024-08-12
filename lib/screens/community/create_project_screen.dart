import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towner/providers/community_provider.dart';
import 'package:towner/models/project_model.dart';
import 'package:towner/services/ai_service.dart';

class CreateProjectScreen extends StatefulWidget {
  @override
  _CreateProjectScreenState createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillsController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _volunteersNeededController = TextEditingController();
  
  final AIService _aiService = AIService();

  @override
  void initState() {
    super.initState();
    _processInitialDescription();
  }

  void _processInitialDescription() async {
    final communityProvider = Provider.of<CommunityProvider>(context, listen: false);
    final initialDescription = communityProvider.currentProjectDescription;
    if (initialDescription != null) {
      final enhancedProject = await _aiService.enhanceProjectDescription(initialDescription);
      setState(() {
        _titleController.text = enhancedProject['title'] ?? '';
        _descriptionController.text = enhancedProject['description'] ?? '';
        _skillsController.text = (enhancedProject['skillsNeeded'] as List<dynamic>).join(', ');
        _deadlineController.text = enhancedProject['deadline'] ?? '';
        _volunteersNeededController.text = enhancedProject['volunteersNeeded'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Project'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                controller: _skillsController,
                decoration: InputDecoration(labelText: 'Skills Needed (comma-separated)'),
                validator: (value) => value!.isEmpty ? 'Please enter skills needed' : null,
              ),
              TextFormField(
                controller: _deadlineController,
                decoration: InputDecoration(labelText: 'Deadline (YYYY-MM-DD)'),
                validator: (value) => value!.isEmpty ? 'Please enter a deadline' : null,
              ),
              TextFormField(
                controller: _volunteersNeededController,
                decoration: InputDecoration(labelText: 'Volunteers Needed'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the number of volunteers needed' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Create Project'),
                onPressed: _submitProject,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitProject() async {
    if (_formKey.currentState!.validate()) {
      final communityProvider = Provider.of<CommunityProvider>(context, listen: false);
      final newProject = ProjectModel(
        title: _titleController.text,
        description: _descriptionController.text,
        creatorId: 'current_user_id', // Replace with actual user ID
        skillsNeeded: _skillsController.text.split(',').map((e) => e.trim()).toList(),
        createdAt: DateTime.now(),
        deadline: DateTime.parse(_deadlineController.text),
        volunteersNeeded: int.parse(_volunteersNeededController.text),
        volunteerIds: [],
        status: 'Active',
      );

      try {
        await communityProvider.createProject(newProject);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Project created successfully')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create project: $e')));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    _deadlineController.dispose();
    _volunteersNeededController.dispose();
    super.dispose();
  }
}