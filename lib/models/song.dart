class Song {
  final String id;
  final String title;
  final String description;
  final String genre;
  final String imageUrl;
  final String audioUrl;
  final DateTime createdAt;
  final bool isFavorite;
  final bool isDownloaded;

  Song({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.imageUrl,
    required this.audioUrl,
    required this.createdAt,
    this.isFavorite = false,
    this.isDownloaded = false,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      genre: json['genre'] ?? '',
      imageUrl: json['image_url'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isFavorite: json['is_favorite'] ?? false,
      isDownloaded: json['is_downloaded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'genre': genre,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'created_at': createdAt.toIso8601String(),
      'is_favorite': isFavorite,
      'is_downloaded': isDownloaded,
    };
  }

  Song copyWith({
    String? id,
    String? title,
    String? description,
    String? genre,
    String? imageUrl,
    String? audioUrl,
    DateTime? createdAt,
    bool? isFavorite,
    bool? isDownloaded,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      genre: genre ?? this.genre,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
} 