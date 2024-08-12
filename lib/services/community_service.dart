import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:towner/models/project_model.dart';

class CommunityService {
  final CollectionReference _projectsCollection = FirebaseFirestore.instance.collection('projects');

  Future<void> createProject(ProjectModel project) async {
    await _projectsCollection.add(project.toMap());
  }

  Future<List<ProjectModel>> getProjects() async {
    QuerySnapshot querySnapshot = await _projectsCollection.get();
    return querySnapshot.docs.map((doc) => ProjectModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> updateProject(ProjectModel project) async {
    await _projectsCollection.doc(project.id).update(project.toMap());
  }

  Future<void> deleteProject(String id) async {
    await _projectsCollection.doc(id).delete();
  }
}