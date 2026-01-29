class WorkerModel {
  final int id;
  final String name;
  final String city;
  final int experienceYears;
  final bool hasBrigade;
  final int? brigadeSize;
  final List<String> specs;
  final List<String> categories; // IDs
  final double rating;
  final int completedJobs;
  final int minPrice;
  final int maxPrice;
  final String avatarUrl; // For now using Icon
  final String bio;

  const WorkerModel({
    required this.id,
    required this.name,
    required this.city,
    required this.experienceYears,
    required this.hasBrigade,
    this.brigadeSize,
    required this.specs,
    required this.categories,
    this.rating = 5.0,
    this.completedJobs = 0,
    this.minPrice = 5000,
    this.maxPrice = 15000,
    this.avatarUrl = '',
    this.bio = '',
  });
}

// Mock Data
final List<WorkerModel> mockWorkers = [
  const WorkerModel(
    id: 1,
    name: 'Бекзат Тургинбай',
    city: 'Алматы',
    experienceYears: 5,
    hasBrigade: true,
    brigadeSize: 4,
    specs: ['Крыша', 'Фасад'],
    categories: ['roof', 'facade'],
    rating: 4.9,
    completedJobs: 124,
    bio: 'Ішпеймін, шекпеймін, жұмысты уақытында тапсырамын.',
  ),
  const WorkerModel(
    id: 2,
    name: 'Айдос Ержанов',
    city: 'Шымкент',
    experienceYears: 8,
    hasBrigade: false,
    specs: ['Бетон', 'Стяжка'],
    categories: ['concrete'],
    rating: 4.7,
    completedJobs: 45,
    bio: 'Сапалы бетон құю. Гарантия.',
  ),
];