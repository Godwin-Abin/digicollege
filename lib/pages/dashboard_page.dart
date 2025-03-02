import 'package:flutter/material.dart';
import 'package:digicollege/pages/login_page.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:http/http.dart' as http; // For HTTP requests
import 'dart:convert'; // For JSON decoding
import 'package:digicollege/pages/video_page.dart'; // Import VideoPage

class DashboardPage extends StatefulWidget {
  final String username; // Add a username parameter

  const DashboardPage({
    super.key,
    required this.username,
  });

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Set<String> _playedVideos = {}; // Track played videos
  List<NewsItem>? _cachedNews; // Cache for news items
  DateTime? _lastFetchTime; // Track last fetch time
  final Duration _fetchInterval = Duration(hours: 3); // Set fetch interval

  /// Fetches news from the API.
  Future<List<NewsItem>> fetchNews() async {
    if (_lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _fetchInterval) {
      return _cachedNews ?? [];
    }

    final response = await http.get(
      Uri.parse(
        'https://newsdata.io/api/1/news?apikey=pub_720180e89a6ff88e93a0e18eeee4b25d1400f&q=technology&language=en&category=technology',
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List results = jsonResponse['results'];

      final filteredResults = results
          .where(
            (data) =>
                data['description'] != null && data['description'].isNotEmpty,
          )
          .take(6)
          .toList();

      _cachedNews =
          filteredResults.map((data) => NewsItem.fromJson(data)).toList();
      _lastFetchTime = DateTime.now();
      return _cachedNews!;
    } else {
      throw Exception('Failed to load news');
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the class schedule widget with full-width dividers between sessions.
    Widget classScheduleWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Class Schedule",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildClassItem(
            title: "Algorithm Analysis & Design",
            duration: "80 mins",
            teacher: "Mr. Immanual Thomas",
            videoUrl:
                'https://seedxvj21.bitchute.com/Qa7hqB57hZTw/2X-qi3NXxHU.mp4',
            onDownload: () async {
              final url = Uri.parse(
                'https://drive.google.com/file/d/1gMOnOI40ArUIXezfnPAtrD1UUXE6COZa/view',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not launch URL'),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            child: const Divider(color: Color(0xFFF8F5FF), thickness: 3),
          ),
          const SizedBox(height: 8),
          _buildClassItem(
            title: "Programming in Python",
            duration: "50 mins",
            teacher: "Mr. Anup Mathew Abraham",
            videoUrl:
                'https://seed131.bitchute.com/cc1hXrEIScFC/GmJhqVgeg5dl.mp4',
            onDownload: () async {
              final url = Uri.parse(
                'https://drive.google.com/file/d/1Ipz2hXA_XaaPLqPMMyURmlqAUsnJlWLn/view',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not launch URL'),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            child: const Divider(color: Color(0xFFF8F5FF), thickness: 3),
          ),
          const SizedBox(height: 8),
          _buildClassItem(
            title: "Compiler Design",
            duration: "50 mins",
            teacher: "Dr. Jasmine Paul",
            videoUrl:
                'https://seed167.bitchute.com/FcRSDGCIUo0v/sKYHImvMXxLm.mp4',
            onDownload: () async {
              final url = Uri.parse(
                'https://drive.google.com/file/d/1948mmKDJEBEIwdc2apev7G19eoWl1V_q/view',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not launch URL'),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            child: const Divider(color: Color(0xFFF8F5FF), thickness: 3),
          ),
          const SizedBox(height: 8),
          _buildClassItem(
            title: "Computer Graphics & Image Processing",
            duration: "45 mins",
            teacher: "Mrs. Bindhya P S",
            videoUrl:
                'https://seed306.bitchute.com/FcRSDGCIUo0v/f2pAU5Jqo4C8.mp4',
            onDownload: () async {
              final url = Uri.parse(
                'https://drive.google.com/file/d/11fee1LiIvLKKM7sgWfoVuKHOdpdSRVES/view',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not launch URL'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );

    // Build the news widget with full-width dividers between news items.
    Widget newsWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Latest News",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<NewsItem>>(
            future: fetchNews(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No news available');
              } else {
                return Column(
                  children: snapshot.data!
                      .map(
                        (newsItem) => Column(
                          children: [
                            _buildNewsItem(
                              title: newsItem.title,
                              description: newsItem.description,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top greeting text with profile icon.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_getGreeting()}, ${widget.username}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                PopupMenuButton<int>(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  offset: const Offset(0, 50),
                  onSelected: (value) {
                    if (value == 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text(widget.username),
                    ),
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text('S6, CSE'),
                    ),
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text('2022-2026'),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Overall responsive layout.
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Class Schedule.
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: classScheduleWidget,
                        ),
                      ),
                      // Right: Latest News.
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: newsWidget,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      classScheduleWidget,
                      const SizedBox(height: 16),
                      newsWidget,
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a class schedule row with class info and responsive action buttons.
  /// In mobile view (width < 600), the buttons are arranged in a column.
  Widget _buildClassItem({
    required String title,
    required String duration,
    required String teacher,
    required String videoUrl,
    VoidCallback? onDownload,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Class information.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title ($duration)",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(teacher, style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ),
        // Responsive buttons.
        Builder(
          builder: (context) {
            final screenWidth = MediaQuery.of(context).size.width;
            if (screenWidth < 600) {
              // Mobile view: buttons arranged in a column.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _playedVideos.contains(videoUrl)
                        ? null
                        : () {
                            setState(() {
                              _playedVideos.add(videoUrl);
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoPage(videoUrl: videoUrl),
                              ),
                            );
                          },
                    child: const Text("Join Session"),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: onDownload,
                    child: const Text("Download"),
                  ),
                ],
              );
            } else {
              // Larger screens: buttons in a row.
              return Row(
                children: [
                  ElevatedButton(
                    onPressed: _playedVideos.contains(videoUrl)
                        ? null
                        : () {
                            setState(() {
                              _playedVideos.add(videoUrl);
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoPage(videoUrl: videoUrl),
                              ),
                            );
                          },
                    child: const Text("Join Session"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onDownload,
                    child: const Text("Download"),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  /// Builds a news item with title and description.
  Widget _buildNewsItem({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(description, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}

class NewsItem {
  final String title;
  final String description;

  NewsItem({required this.title, required this.description});

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
    );
  }
}
