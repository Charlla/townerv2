import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towner/providers/community_provider.dart';
import 'package:towner/models/project_model.dart';
import 'package:towner/services/ai_service.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final AIService _aiService = AIService();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CommunityProvider>().fetchProjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Projects'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showCreateProjectDialog(context),
          ),
        ],
      ),
      body: Consumer<CommunityProvider>(
        builder: (context, communityProvider, child) {
          if (communityProvider.projects.isEmpty) {
            return Center(child: Text('No projects available'));
          }
          return ListView.builder(
            itemCount: communityProvider.projects.length,
            itemBuilder: (context, index) {
              final project = communityProvider.projects[index];
              return ListTile(
                title: Text(project.title),
                subtitle: Text('Volunteers: ${project.volunteerIds.length}/${project.volunteersNeeded}'),
                trailing: Chip(label: Text(project.status)),
                onTap: () => _showProjectDetails(context, project),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String initialDescription = '';
        return AlertDialog(
          title: Text('Create New Project'),
          content: TextField(
            decoration: InputDecoration(hintText: "Describe your project idea"),
            onChanged: (value) {
              initialDescription = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () async {
                Navigator.of(context).pop();
                final enhancedProject = await _aiService.enhanceProjectDescription(initialDescription);
                _createProject(context, enhancedProject);
              },
            ),
          ],
        );
      },
    );
  }

  void _createProject(BuildContext context, Map<String, dynamic> projectData) {
    final project = ProjectModel(
      title: projectData['title'],
      description: projectData['description'],
      creatorId: 'current_user_id', // Replace with actual user ID
      skillsNeeded: List<String>.from(projectData['skillsNeeded']),
      createdAt: DateTime.now(),
      deadline: DateTime.parse(projectData['deadline']),
      volunteersNeeded: projectData['volunteersNeeded'],
      volunteerIds: [],
      status: 'Active',
    );

    context.read<CommunityProvider>().createProject(project);
  }

  void _showProjectDetails(BuildContext context, ProjectModel project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(project.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(project.description),
                SizedBox(height: 10),
                Text('Skills Needed: ${project.skillsNeeded.join(", ")}'),
                Text('Deadline: ${project.deadline.toString().split(' ')[0]}'),
                Text('Volunteers: ${project.volunteerIds.length}/${project.volunteersNeeded}'),
                Text('Status: ${project.status}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Volunteer'),
              onPressed: () {
                // Implement volunteer functionality
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}