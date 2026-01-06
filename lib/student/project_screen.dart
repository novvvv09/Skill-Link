import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final TextEditingController _searchController = TextEditingController();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  String _searchQuery = '';
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() => _isLoading = true);

    try {
      // Fetch all projects ordered by creation date
      final projectsSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .orderBy('createdAt', descending: true)
          .get();

      final projects = projectsSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? 'Untitled Project',
          'description': data['description'] ?? '',
          'studentId': data['studentId'] ?? '',
          'studentName': data['studentName'] ?? 'Unknown',
          'studentEmail': data['studentEmail'] ?? '',
          'eventId': data['eventId'] ?? '',
          'eventTitle': data['eventTitle'] ?? 'No event',
          'technologies': List<String>.from(data['technologies'] ?? []),
          'githubUrl': data['githubUrl'] ?? '',
          'liveUrl': data['liveUrl'],
          'imageUrl': data['imageUrl'] ?? '',
          'likes': data['likes'] ?? 0,
          'comments': data['comments'] ?? 0,
          'liked': false, // Check if current user liked this
          'createdAt': data['createdAt'] as Timestamp?,
        };
      }).toList();

      setState(() {
        _projects = projects;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading projects: $e');
      setState(() => _isLoading = false);
    }
  }

  void _toggleLike(
    String projectId,
    bool currentlyLiked,
    int currentLikes,
  ) async {
    if (_currentUser == null) return;

    try {
      final newLiked = !currentlyLiked;
      final newLikes = newLiked ? currentLikes + 1 : currentLikes - 1;

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .update({'likes': newLikes});

      // Update local state
      setState(() {
        _projects = _projects.map((project) {
          if (project['id'] == projectId) {
            return {...project, 'liked': newLiked, 'likes': newLikes};
          }
          return project;
        }).toList();
      });
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  void _showPostProjectModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PostProjectModal(
        onSubmit: () {
          _loadProjects(); // Reload projects after posting
        },
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredProjects {
    if (_searchQuery.isEmpty) return _projects;

    return _projects.where((project) {
      final query = _searchQuery.toLowerCase();
      return project['title'].toLowerCase().contains(query) ||
          project['description'].toLowerCase().contains(query) ||
          (project['technologies'] as List<String>).any(
            (tech) => tech.toLowerCase().contains(query),
          ) ||
          project['eventTitle'].toLowerCase().contains(query);
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
                          'Search by title, description, event, or technology...',
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProjects.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadProjects,
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: _filteredProjects.length,
                        itemBuilder: (context, index) {
                          return _buildProjectCard(_filteredProjects[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    final timestamp = project['createdAt'] as Timestamp?;
    final postedDate = timestamp?.toDate() ?? DateTime.now();

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
            child: project['imageUrl'].isNotEmpty
                ? Image.network(
                    project['imageUrl'],
                    height: 192,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage();
                    },
                  )
                : _buildPlaceholderImage(),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Info & Event Badge
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project['studentName'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            Text(
                              _formatDate(postedDate),
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

                  // Event Label
                  if (project['eventTitle'].isNotEmpty &&
                      project['eventTitle'] != 'No event')
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.event,
                              size: 12,
                              color: Color(0xFFA855F7),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                project['eventTitle'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFA855F7),
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    project['title'],
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
                    project['description'],
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
                    children: (project['technologies'] as List<String>)
                        .take(3)
                        .map((tech) {
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
                        })
                        .toList(),
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
                              onTap: () => _toggleLike(
                                project['id'],
                                project['liked'],
                                project['likes'],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    project['liked']
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 20,
                                    color: project['liked']
                                        ? Colors.red
                                        : const Color(0xFF6B7280),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${project['likes']}',
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
                                  '${project['comments']}',
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
                            if (project['githubUrl'].isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.code, size: 20),
                                color: const Color(0xFF6B7280),
                                onPressed: () =>
                                    _launchUrl(project['githubUrl']),
                                tooltip: 'View on GitHub',
                              ),
                            if (project['liveUrl'] != null &&
                                project['liveUrl'].isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.open_in_new, size: 20),
                                color: const Color(0xFF6B7280),
                                onPressed: () => _launchUrl(project['liveUrl']),
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

  Widget _buildPlaceholderImage() {
    return Container(
      height: 192,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.code, size: 64, color: Colors.white),
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
            _searchQuery.isEmpty
                ? 'No projects yet'
                : 'No projects found matching your search',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Be the first to post a project!',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
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
    if (urlString.isEmpty) return;
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
  final VoidCallback onSubmit;

  const PostProjectModal({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<PostProjectModal> createState() => _PostProjectModalState();
}

class _PostProjectModalState extends State<PostProjectModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _githubController = TextEditingController();
  final _liveUrlController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _techController = TextEditingController();
  final List<String> _technologies = [];
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  List<Map<String, String>> _registeredEvents = [];
  String? _selectedEventId;
  bool _isLoadingEvents = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadRegisteredEvents();
  }

  Future<void> _loadRegisteredEvents() async {
    if (_currentUser == null) {
      setState(() => _isLoadingEvents = false);
      return;
    }

    try {
      // Get all events the student is registered for
      final eventsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .get();

      List<Map<String, String>> events = [];

      for (var eventDoc in eventsSnapshot.docs) {
        // Check if student is registered for this event
        final registrationDoc = await FirebaseFirestore.instance
            .collection('events')
            .doc(eventDoc.id)
            .collection('registrations')
            .doc(_currentUser!.uid)
            .get();

        if (registrationDoc.exists) {
          final eventData = eventDoc.data();
          events.add({
            'id': eventDoc.id,
            'title': eventData['title'] ?? 'Untitled Event',
          });
        }
      }

      setState(() {
        _registeredEvents = events;
        _isLoadingEvents = false;
      });
    } catch (e) {
      print('Error loading registered events: $e');
      setState(() => _isLoadingEvents = false);
    }
  }

  Future<void> _submitProject() async {
    print('=== SUBMIT PROJECT CALLED ===');

    if (!_formKey.currentState!.validate() || _technologies.isEmpty) {
      print('Validation failed or no technologies');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields and add at least one technology',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedEventId == null) {
      print('No event selected');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an event for this project'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print('Current user: ${_currentUser?.uid}');
    print('Selected event: $_selectedEventId');

    setState(() => _isSubmitting = true);

    try {
      print('Fetching user data...');
      // Get current user data
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      final userData = userDoc.data();
      print('User data: $userData');

      final selectedEvent = _registeredEvents.firstWhere(
        (event) => event['id'] == _selectedEventId,
      );
      print('Selected event title: ${selectedEvent['title']}');

      final projectData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'studentId': _currentUser!.uid,
        'studentName': userData?['fullName'] ?? 'Unknown',
        'studentEmail': userData?['email'] ?? '',
        'eventId': _selectedEventId,
        'eventTitle': selectedEvent['title'],
        'technologies': _technologies,
        'githubUrl': _githubController.text.trim(),
        'liveUrl': _liveUrlController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
        'likes': 0,
        'comments': 0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      };

      print('Project data to save: $projectData');
      print('Saving to Firestore...');

      // Save project to Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('projects')
          .add(projectData);

      print('Project saved successfully! Doc ID: ${docRef.id}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project posted successfully!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onSubmit();
        Navigator.pop(context);
      }
    } catch (e, stackTrace) {
      print('ERROR submitting project: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error posting project: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Post New Project',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(),

          // Form
          Expanded(
            child: _isLoadingEvents
                ? const Center(child: CircularProgressIndicator())
                : _registeredEvents.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Registered Events',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You need to register for an event before posting a project',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Selection
                          const Text(
                            'Select Event',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedEventId,
                            decoration: InputDecoration(
                              hintText: 'Choose an event for this project',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            items: _registeredEvents.map((event) {
                              return DropdownMenuItem(
                                value: event['id'],
                                child: Text(
                                  event['title']!,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedEventId = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'Please select an event' : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Project Title *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description *',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _githubController,
                            decoration: const InputDecoration(
                              labelText: 'GitHub URL *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _liveUrlController,
                            decoration: const InputDecoration(
                              labelText: 'Live URL (Optional)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _imageUrlController,
                            decoration: const InputDecoration(
                              labelText: 'Image URL *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _techController,
                                  decoration: const InputDecoration(
                                    labelText: 'Add Technology',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  if (_techController.text.isNotEmpty) {
                                    setState(() {
                                      _technologies.add(_techController.text);
                                      _techController.clear();
                                    });
                                  }
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: _technologies.map((tech) {
                              return Chip(
                                label: Text(tech),
                                onDeleted: () {
                                  setState(() {
                                    _technologies.remove(tech);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submitProject,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text('Post Project'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _githubController.dispose();
    _liveUrlController.dispose();
    _imageUrlController.dispose();
    _techController.dispose();
    super.dispose();
  }
}
