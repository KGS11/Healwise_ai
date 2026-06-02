import '../domain/pose_model.dart';

class YogaPosesData {
  static const List<PoseModel> poses = [
    PoseModel(
      id: 'mountain',
      displayName: 'Mountain Pose',
      sanskritName: 'Tadasana',
      description:
          'Foundation of all standing poses. Stand tall, grounded and centered.',
      difficulty: 'Beginner',
      duration: '30 seconds',
      emoji: 'mountain',
      benefits: ['Improves posture', 'Builds focus', 'Strengthens legs'],
    ),
    PoseModel(
      id: 'warrior1',
      displayName: 'Warrior I',
      sanskritName: 'Virabhadrasana I',
      description: 'Powerful standing pose that builds strength and stamina.',
      difficulty: 'Beginner',
      duration: '30 seconds each side',
      emoji: 'warrior',
      benefits: ['Strengthens legs', 'Opens chest', 'Builds confidence'],
    ),
    PoseModel(
      id: 'warrior2',
      displayName: 'Warrior II',
      sanskritName: 'Virabhadrasana II',
      description: 'Wide-legged stance building endurance and focus.',
      difficulty: 'Beginner',
      duration: '30 seconds each side',
      emoji: 'shield',
      benefits: ['Tones legs', 'Improves balance', 'Builds stamina'],
    ),
    PoseModel(
      id: 'tree',
      displayName: 'Tree Pose',
      sanskritName: 'Vrksasana',
      description: 'Balance on one leg to build focus and inner stability.',
      difficulty: 'Beginner',
      duration: '30 seconds each side',
      emoji: 'tree',
      benefits: ['Improves balance', 'Strengthens ankles', 'Builds focus'],
    ),
    PoseModel(
      id: 'child',
      displayName: "Child's Pose",
      sanskritName: 'Balasana',
      description: 'Resting pose for stress relief and gentle back stretch.',
      difficulty: 'Beginner',
      duration: '1-3 minutes',
      emoji: 'leaf',
      benefits: ['Relieves stress', 'Stretches back', 'Calms mind'],
    ),
    PoseModel(
      id: 'cobra',
      displayName: 'Cobra Pose',
      sanskritName: 'Bhujangasana',
      description: 'Backbend opening the chest and strengthening the spine.',
      difficulty: 'Beginner',
      duration: '15-30 seconds',
      emoji: 'cobra',
      benefits: ['Strengthens spine', 'Opens chest', 'Relieves back pain'],
    ),
    PoseModel(
      id: 'downdog',
      displayName: 'Downward Dog',
      sanskritName: 'Adho Mukha Svanasana',
      description:
          'Full body stretch and mild inversion for energy and flexibility.',
      difficulty: 'Beginner',
      duration: '30-60 seconds',
      emoji: 'dog',
      benefits: ['Full body stretch', 'Energizes body', 'Calms nervous system'],
    ),
    PoseModel(
      id: 'shavasana',
      displayName: 'Corpse Pose',
      sanskritName: 'Shavasana',
      description:
          'Complete relaxation for integrating the benefits of practice.',
      difficulty: 'Beginner',
      duration: '5-10 minutes',
      emoji: 'rest',
      benefits: ['Deep relaxation', 'Reduces anxiety', 'Integrates practice'],
    ),
  ];
}
