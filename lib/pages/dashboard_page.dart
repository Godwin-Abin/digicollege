import 'package:flutter/material.dart';
import 'package:digicollege/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg if needed later
import 'package:http/http.dart' as http; // For HTTP requests
import 'dart:convert'; // For JSON decoding

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /// Fetches news from the API.
  Future<List<NewsItem>> fetchNews() async {
    // Replace YOUR_API_KEY with your actual API key.
    final response = await http.get(
      Uri.parse(
        'https://newsdata.io/api/1/news?apikey=pub_720180e89a6ff88e93a0e18eeee4b25d1400f&q=technology&language=en&category=technology',
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List results = jsonResponse['results'];

      // Filter results to include only items with a description and limit to top 5 or 6
      final filteredResults =
          results
              .where(
                (data) =>
                    data['description'] != null &&
                    data['description'].isNotEmpty,
              )
              .take(6) // Limit to top 6 items
              .toList();

      return filteredResults.map((data) => NewsItem.fromJson(data)).toList();
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
    return Scaffold(
      // Light purple background, similar to the design screenshot
      backgroundColor: const Color(0xFFF8F5FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top greeting text with a round icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_getGreeting()}, Abin",
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
                      // Navigate to the login page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Text('G Abin Roy'),
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

            // Main row containing the schedule (left) and news (right)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side: Class Schedule
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Class Schedule",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        // Individual class items with their respective download actions
                        _buildClassItem(
                          title: "Algorithm Analysis & Design",
                          duration: "60 mins",
                          teacher: "Mr. Immanual Thomas",
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
                        const SizedBox(height: 12),
                        _buildClassItem(
                          title: "Programming in Python",
                          duration: "50 mins",
                          teacher: "Mr. Anwar Abraham",
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
                        const SizedBox(height: 12),
                        _buildClassItem(
                          title: "Compiler Design",
                          duration: "50 mins",
                          teacher: "Dr. Jasmine Paul",
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
                        const SizedBox(height: 12),
                        _buildClassItem(
                          title: "Computer Graphics & Image Processing",
                          duration: "45 mins",
                          teacher: "Mrs. Bindhya P S",
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
                  ),
                ),

                // Right Side: Latest News
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Latest News",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder<List<NewsItem>>(
                          future: fetchNews(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text('No news available');
                            } else {
                              return Column(
                                children:
                                    snapshot.data!
                                        .map(
                                          (newsItem) => _buildNewsItem(
                                            title: newsItem.title,
                                            description: newsItem.description,
                                          ),
                                        )
                                        .toList(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single class schedule row with title, duration, teacher, and a Download button.
  Widget _buildClassItem({
    required String title,
    required String duration,
    required String teacher,
    VoidCallback? onDownload, // Optional callback parameter
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Class information
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
        // Download button
        ElevatedButton(
          onPressed:
              onDownload ??
              () {
                // Default action if no callback is provided.
              },
          child: const Text("Download"),
        ),
      ],
    );
  }

  /// Builds a single news item with title and description.
  Widget _buildNewsItem({required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(description, style: TextStyle(color: Colors.grey[700])),
        const SizedBox(height: 12),
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
      // Using null-aware operators to ensure the app doesn't crash if a field is missing.
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
    );
  }
}
