import 'package:flutter/material.dart';
import 'package:digicollege/pages/login_page.dart'; // Replace 'your_project_name' with your actual project name

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

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

                        // Individual class items
                        _buildClassItem(
                          title: "Alorith Analysis & Design",
                          duration: "60 mins",
                          teacher: "Mr. Immanual Thomas",
                        ),
                        const SizedBox(height: 12),
                        _buildClassItem(
                          title: "Programming in Python",
                          duration: "50 mins",
                          teacher: "Mr. Anwar Abraham",
                        ),
                        const SizedBox(height: 12),
                        _buildClassItem(
                          title: "Compiler Design",
                          duration: "50 mins",
                          teacher: "Dr. Jasmine Paul",
                        ),
                        const SizedBox(height: 12),
                        _buildClassItem(
                          title: "Computer Graphics & Image Processing",
                          duration: "45 mins",
                          teacher: "Mrs. Bindhya P S",
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

                        // News items
                        _buildNewsItem(
                          title: "VirtualCollege Launches New Courses",
                          description:
                              "Stay ahead with our new range of courses designed to help you excel.",
                        ),
                        const SizedBox(height: 12),
                        _buildNewsItem(
                          title: "Upcoming Webinar: Future of Education",
                          description:
                              "Join our experts as they discuss the evolving landscape of education.",
                        ),
                        const SizedBox(height: 12),
                        _buildNewsItem(
                          title: "Scholarship Opportunities",
                          description:
                              "Additional savings opportunities available for deserving students.",
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
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Class info
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
          onPressed: () {
            // TODO: Handle download action
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
      ],
    );
  }
}
