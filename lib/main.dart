import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:freemium_novels_app/services/data_change_notifier.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

// Providers & Services
import 'providers/theme_provider.dart';
import 'providers/reader_settings_provider.dart';
import 'services/story_repository.dart';
import 'services/crypto_api_service.dart';
import 'services/firebase_article_repository.dart';
import 'services/firebase_story_service.dart';
import 'core/theme/app_theme.dart';
import 'models.dart';

// Debug utility for Firebase data
Future<void> printStoriesFromFirebase() async {
  try {
    print('=== FETCHING STORIES FROM FIREBASE ===');

    final storyService = StoryService();

    print('\n--- All Published Stories ---');
    List<FirebaseStory> publishedStories =
        await storyService.getPublishedStories();
    print('Total published stories: ${publishedStories.length}');
    for (int i = 0; i < publishedStories.length; i++) {
      final story = publishedStories[i];
      print('\nStory ${i + 1}:');
      print('  ID: ${story.id}');
      print('  Title: ${story.title}');
      print('  Description: ${story.description}');
      print('  Category: ${story.category}');
      print('  Status: ${story.status}');
      print('  Cover Image: ${story.coverImage}');
      print('  Chapter Count: ${story.chapterCount}');
      print('  Created: ${story.createdAt}');
      print('  Updated: ${story.updatedAt}');
      print('  Author ID: ${story.authorId}');
    }

    print('\n--- Newly Added Stories ---');
    List<FirebaseStory> newlyAdded =
        await storyService.getNewlyAddedStories(limit: 5);
    for (int i = 0; i < newlyAdded.length; i++) {
      print('  ${i + 1}. ${newlyAdded[i].title} (${newlyAdded[i].category})');
    }

    print('\n--- Trending Stories ---');
    List<FirebaseStory> trending =
        await storyService.getTrendingStories(limit: 3);
    for (int i = 0; i < trending.length; i++) {
      print('  ${i + 1}. ${trending[i].title} (${trending[i].category})');
    }

    print('\n--- Stories by Category ---');
    List<FirebaseStory> originals =
        await storyService.getStoriesByCategory('Originals');
    List<FirebaseStory> fanFiction =
        await storyService.getStoriesByCategory('Fan-Fiction');

    print('Originals: ${originals.length}');
    for (int i = 0; i < originals.length; i++) {
      print('  ${i + 1}. ${originals[i].title}');
    }

    print('Fan-Fiction: ${fanFiction.length}');
    for (int i = 0; i < fanFiction.length; i++) {
      print('  ${i + 1}. ${fanFiction[i].title}');
    }

    print('\n=== FIREBASE STORIES FETCH COMPLETE ===');
  } catch (e) {
    print('Error fetching stories from Firebase: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Optional: Call only during dev
  await printStoriesFromFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataChangeNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ReaderSettingsProvider()),
        Provider(create: (_) => StoryRepository()),
        Provider(create: (_) => CryptoApiService()),
        Provider(create: (_) => FirebaseArticleRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Freemium Novels',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _redirectUser();
  }

  // This function will handle the delay and navigation
  Future<void> _redirectUser() async {
    // Wait for at least 2 seconds to ensure the splash screen is visible
    await Future.delayed(const Duration(seconds: 2));

    // After the delay, check if the user is logged in
    final user = FirebaseAuth.instance.currentUser;

    // Ensure the widget is still mounted before navigating
    if (!mounted) return;

    if (user != null) {
      // If user is logged in, replace the splash screen with the main screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // If user is not logged in, replace with the login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This widget will now always show the SplashScreen initially.
    // The navigation logic is handled in initState.
    return const SplashScreen();
  }
}
