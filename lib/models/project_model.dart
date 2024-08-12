import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String? id;
  final String title;
  final String description;
  final String creatorId;
  final List<String> skillsNeeded;
  final DateTime createdAt;
  final DateTime deadline;
  final int volunteersNeeded;
  final List<String> volunteerIds;
  final String status;

  ProjectModel({
    this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    required this.skillsNeeded,
    required this.createdAt,
    required this.deadline,
    required this.volunteersNeeded,
    required this.volunteerIds,
    required this.status,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> data, String id) {
    return ProjectModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      creatorId: data['creatorId'] ?? '',
      skillsNeeded: List<String>.from(data['skillsNeeded'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deadline: (data['deadline'] as Timestamp).toDate(),
      volunteersNeeded: data['volunteersNeeded'] ?? 0,
      volunteerIds: List<String>.from(data['volunteerIds'] ?? []),
      status: data['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'creatorId': creatorId,
      'skillsNeeded': skillsNeeded,
      'createdAt': Timestamp.fromDate(createdAt),
      'deadline': Timestamp.fromDate(deadline),
      'volunteersNeeded': volunteersNeeded,
      'volunteerIds': volunteerIds,
      'status': status,
    };
  }
}