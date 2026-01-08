import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PostProjectPage extends StatefulWidget {
  const PostProjectPage({Key? key}) : super(key: key);

  @override
  State<PostProjectPage> createState() => _PostProjectPageState();
}

class _PostProjectPageState extends State<PostProjectPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Project> _projects = mockProjects;

  void _toggleLike(String id) {
    setState(() {
      _projects = _projects.map((project) {
        if (project.id == id) {
          return project.copyWith(
            liked: !project.liked,
            likes: project.liked ? project.likes - 1 : project.likes + 1,
          );
        }
        return project;
      }).toList();
    });
  }

  void _showPostProjectModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PostProjectModal(
        onSubmit: (projectData) {
          setState(() {
            final newProject = Project(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: projectData['title'],
              author: 'You',
              authorAvatar:
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&q=80',
              description: projectData['description'],
              technologies: projectData['technologies'],
              githubUrl: projectData['githubUrl'],
              liveUrl: projectData['liveUrl'],
              imageUrl: projectData['imageUrl'],
              likes: 0,
              comments: 0,
              liked: false,
              postedDate: DateTime.now(),
            );
            _projects = [newProject, ..._projects];
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  List<Project> get _filteredProjects {
    if (_searchQuery.isEmpty) return _projects;

    return _projects.where((project) {
      final query = _searchQuery.toLowerCase();
      return project.title.toLowerCase().contains(query) ||
          project.description.toLowerCase().contains(query) ||
          project.technologies.any(
            (tech) => tech.toLowerCase().contains(query),
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Student Projects',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Showcase your work and discover amazing projects',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _showPostProjectModal,
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Post Project'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText:
                          'Search projects by title, description, or technology...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF9CA3AF),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF3B82F6),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Projects Grid
            Expanded(
              child: _filteredProjects.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 0.85,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: _filteredProjects.length,
                      itemBuilder: (context, index) {
                        return _buildProjectCard(_filteredProjects[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              project.imageUrl,
              height: 192,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 192,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 48),
                );
              },
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(project.authorAvatar),
                        onBackgroundImageError: (_, __) {},
                        child: const Icon(Icons.person, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.author,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            Text(
                              _formatDate(project.postedDate),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    project.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Technologies
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.technologies.take(3).map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.tag,
                              size: 12,
                              color: Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tech,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const Spacer(),

                  // Actions
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => _toggleLike(project.id),
                              child: Row(
                                children: [
                                  Icon(
                                    project.liked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 20,
                                    color: project.liked
                                        ? Colors.red
                                        : const Color(0xFF6B7280),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${project.likes}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                const Icon(
                                  Icons.comment_outlined,
                                  size: 20,
                                  color: Color(0xFF6B7280),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${project.comments}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.code, size: 20),
                              color: const Color(0xFF6B7280),
                              onPressed: () => _launchUrl(project.githubUrl),
                              tooltip: 'View on GitHub',
                            ),
                            if (project.liveUrl != null)
                              IconButton(
                                icon: const Icon(Icons.open_in_new, size: 20),
                                color: const Color(0xFF6B7280),
                                onPressed: () => _launchUrl(project.liveUrl!),
                                tooltip: 'View Live Demo',
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.code_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No projects found matching your search',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Post Project Modal
class PostProjectModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const PostProjectModal({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<PostProjectModal> createState() => _PostProjectModalState();
}

class _PostProjectModalState extends State<PostProjectModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _technologiesController = TextEditingController();
  final _githubController = TextEditingController();
  final _liveUrlController = TextEditingController();
  final _imageUrlController = TextEditingController(
    text:
        'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80',
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: 700,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Post Your Project',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: const Color(0xFF9CA3AF),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Title
                      const Text(
                        'Project Title *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Enter your project title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),

                      // Description
                      const Text(
                        'Description *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText:
                              'Describe what your project does and what makes it unique...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        maxLines: 4,
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),

                      // Technologies
                      const Text(
                        'Technologies Used *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _technologiesController,
                        decoration: InputDecoration(
                          hintText:
                              'e.g. React, Node.js, MongoDB (comma-separated)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Separate multiple technologies with commas',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // GitHub URL
                      const Text(
                        'GitHub Repository URL *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _githubController,
                        decoration: InputDecoration(
                          hintText: 'https://github.com/username/repository',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),

                      // Live URL (Optional)
                      const Text(
                        'Live Demo URL (Optional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _liveUrlController,
                        decoration: InputDecoration(
                          hintText: 'https://your-project.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Image URL (Optional)
                      const Text(
                        'Project Image URL (Optional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: InputDecoration(
                          hintText: 'https://example.com/image.jpg',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        onChanged: (value) {
                          setState(() {}); // Rebuild to show preview
                        },
                      ),
                      if (_imageUrlController.text.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _imageUrlController.text,
                            height: 192,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 192,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final technologies = _technologiesController
                                      .text
                                      .split(',')
                                      .map((tech) => tech.trim())
                                      .where((tech) => tech.isNotEmpty)
                                      .toList();

                                  widget.onSubmit({
                                    'title': _titleController.text,
                                    'description': _descriptionController.text,
                                    'technologies': technologies,
                                    'githubUrl': _githubController.text,
                                    'liveUrl': _liveUrlController.text.isEmpty
                                        ? null
                                        : _liveUrlController.text,
                                    'imageUrl': _imageUrlController.text,
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Post Project',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    _githubController.dispose();
    _liveUrlController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}

// Project Model
class Project {
  final String id;
  final String title;
  final String author;
  final String authorAvatar;
  final String description;
  final List<String> technologies;
  final String githubUrl;
  final String? liveUrl;
  final String imageUrl;
  final int likes;
  final int comments;
  final bool liked;
  final DateTime postedDate;

  Project({
    required this.id,
    required this.title,
    required this.author,
    required this.authorAvatar,
    required this.description,
    required this.technologies,
    required this.githubUrl,
    this.liveUrl,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.liked,
    required this.postedDate,
  });

  Project copyWith({
    String? id,
    String? title,
    String? author,
    String? authorAvatar,
    String? description,
    List<String>? technologies,
    String? githubUrl,
    String? liveUrl,
    String? imageUrl,
    int? likes,
    int? comments,
    bool? liked,
    DateTime? postedDate,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      githubUrl: githubUrl ?? this.githubUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      liked: liked ?? this.liked,
      postedDate: postedDate ?? this.postedDate,
    );
  }
}

// Mock Data
final mockProjects = [
  Project(
    id: '1',
    title: 'Real-time Chat Application',
    author: 'Sarah Chen',
    authorAvatar:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80',
    description:
        'A fully functional chat app built with WebSocket for real-time messaging, file sharing, and group conversations.',
    technologies: ['React', 'Node.js', 'Socket.io', 'MongoDB'],
    githubUrl: 'https://github.com',
    liveUrl: 'https://example.com',
    imageUrl:
        'https://images.unsplash.com/photo-1611606063065-ee7946f0787a?w=800&q=80',
    likes: 42,
    comments: 8,
    liked: false,
    postedDate: DateTime(2025, 1, 8),
  ),
  Project(
    id: '2',
    title: 'AI Code Assistant',
    author: 'Mike Rodriguez',
    authorAvatar:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
    description:
        'VS Code extension that uses machine learning to provide intelligent code completions and suggestions.',
    technologies: ['Python', 'TensorFlow', 'TypeScript', 'VS Code API'],
    githubUrl: 'https://github.com',
    imageUrl:
        'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&q=80',
    likes: 67,
    comments: 15,
    liked: true,
    postedDate: DateTime(2025, 1, 5),
  ),
  Project(
    id: '3',
    title: 'E-commerce Platform',
    author: 'Emily Johnson',
    authorAvatar:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80',
    description:
        'Full-stack e-commerce solution with payment integration, inventory management, and admin dashboard.',
    technologies: ['Next.js', 'Stripe', 'PostgreSQL', 'Prisma'],
    githubUrl: 'https://github.com',
    liveUrl: 'https://example.com',
    imageUrl:
        'https://images.unsplash.com/photo-1557821552-17105176677c?w=800&q=80',
    likes: 89,
    comments: 22,
    liked: false,
    postedDate: DateTime(2025, 1, 3),
  ),
];
