import 'package:flutter/material.dart';

void main() {
  runApp(const BondhuApp());
}

class BondhuApp extends StatelessWidget {
  const BondhuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bondhu',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    FriendsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Friends',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ================= HOME =================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> posts = [
    {
      'name': 'Bondhu User',
      'text': 'Bondhu-তে সবাইকে স্বাগতম! 👋',
      'likes': 12,
      'liked': false,
    },
  ];

  void createPost() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('নতুন পোস্ট'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'তুমি কী ভাবছো?',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বাতিল'),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;

                setState(() {
                  posts.insert(0, {
                    'name': 'তুমি',
                    'text': controller.text.trim(),
                    'likes': 0,
                    'liked': false,
                  });
                });

                Navigator.pop(context);
              },
              child: const Text('পোস্ট'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text(
              'Bondhu',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChatScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'স্বাগতম 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'বন্ধুদের সাথে যুক্ত হও, কথা বলো এবং পোস্ট শেয়ার করো।',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 18),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.person),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: createPost,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Text(
                                'তুমি কী ভাবছো?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                FilledButton.icon(
                  onPressed: createPost,
                  icon: const Icon(Icons.add),
                  label: const Text('পোস্ট তৈরি করো'),
                ),

                const SizedBox(height: 20),

                ...posts.map(
                  (post) => PostCard(
                    name: post['name'],
                    text: post['text'],
                    likes: post['likes'],
                    liked: post['liked'],
                    onLike: () {
                      setState(() {
                        if (post['liked']) {
                          post['likes']--;
                          post['liked'] = false;
                        } else {
                          post['likes']++;
                          post['liked'] = true;
                        }
                      });
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= POST CARD =================

class PostCard extends StatelessWidget {
  final String name;
  final String text;
  final int likes;
  final bool liked;
  final VoidCallback onLike;

  const PostCard({
    super.key,
    required this.name,
    required this.text,
    required this.likes,
    required this.liked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 15),

            Text(
              '$likes টি Like',
              style: const TextStyle(color: Colors.grey),
            ),

            const Divider(),

            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: onLike,
                    icon: Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      color: liked ? Colors.red : null,
                    ),
                    label: const Text('Like'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Comment'),
                          content: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Comment লিখুন...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('বন্ধ'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.comment_outlined),
                    label: const Text('Comment'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ================= FRIENDS =================

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friends = [
      'Rahim',
      'Karim',
      'Jannat',
      'Sadia',
      'Hasan',
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Friends',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(friends[index]),
                subtitle: const Text('Bondhu ব্যবহারকারী'),
                trailing: FilledButton(
                  onPressed: () {},
                  child: const Text('Add'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ================= PROFILE =================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const CircleAvatar(
              radius: 55,
              child: Icon(
                Icons.person,
                size: 55,
              ),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
                'Bondhu User',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Center(
              child: Text(
                'Bondhu-তে আমার প্রোফাইল',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 25),

            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text('বন্ধু'),
                trailing: const Text(
                  '0',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.post_add),
                title: const Text('আমার পোস্ট'),
                trailing: const Text(
                  '0',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('প্রোফাইল পরিবর্তন'),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= NOTIFICATION =================

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.favorite),
            ),
            title: Text('তোমার পোস্টে Like এসেছে'),
            subtitle: Text('কিছুক্ষণ আগে'),
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person_add),
            ),
            title: Text('নতুন Friend Request'),
            subtitle: Text('কিছুক্ষণ আগে'),
          ),
        ],
      ),
    );
  }
}

// ================= CHAT =================

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      'Rahim',
      'Karim',
      'Jannat',
      'Sadia',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(users[index]),
            subtitle: const Text('Message পাঠান...'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MessageScreen(
                    name: users[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ================= MESSAGE =================

class MessageScreen extends StatefulWidget {
  final String name;

  const MessageScreen({
    super.key,
    required this.name,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final controller = TextEditingController();
  final List<String> messages = [];

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      messages.add(controller.text.trim());
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text('এখনো কোনো Message নেই'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(messages[index]),
                        ),
                      );
                    },
                  ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Message লিখুন...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
