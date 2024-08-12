import 'package:flutter/foundation.dart';
import 'package:towner/models/project_model.dart';
import 'package:towner/services/community_service.dart';

class CommunityProvider with ChangeNotifier {
  final CommunityService _communityService = CommunityService();
  List<ProjectModel> _projects = [];
  String? _currentProjectDescription;

  List<ProjectModel> get projects => _projects;
  String? get currentProjectDescription => _currentProjectDescription;

  void setCurrentProjectDescription(String description) {
    _currentProjectDescription = description;
    notifyListeners();
  }

  Future<void> fetchProjects() async {
    try {
      _projects = await _communityService.getProjects();
      notifyListeners();
    } catch (e) {
      print('Error fetching projects: $e');
      rethrow;
    }
  }

  Future<void> createProject(ProjectModel project) async {
    try {
      await _communityService.createProject(project);
      _projects.add(project);
      notifyListeners();
    } catch (e) {
      print('Error creating project: $e');
      rethrow;
    }
  }

  Future<void> updateProject(ProjectModel project) async {
    try {
      await _communityService.updateProject(project);
      int index = _projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        _projects[index] = project;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating project: $e');
      rethrow;
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await _communityService.deleteProject(id);
      _projects.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting project: $e');
      rethrow;
    }
  }
}