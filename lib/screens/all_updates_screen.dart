// lib/screens/all_updates_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../services/story_repository.dart';
import 'story_detail_screen.dart';
import '../widgets/common/app_background.dart';

class AllUpdatesScreen extends StatefulWidget {
  const AllUpdatesScreen({super.key});

  @override
  State<AllUpdatesScreen> createState() => _AllUpdatesScreenState();
}

class _AllUpdatesScreenState extends State<AllUpdatesScreen> {
  Future<List<LatestUpdate>>? _updatesFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the data when the screen loads
    _updatesFuture = context.read<StoryRepository>().getRecentUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Important for background
      // ✅ CORRECTLY STYLED APPBAR
      appBar: AppBar(
        title: Text('Recent Updates (48h)',
            style: GoogleFonts.orbitron(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // Let the background show through
        elevation: 0,
        // This ensures the title and back arrow match your app's theme
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: AppBackground(
        child: FutureBuilder<List<LatestUpdate>>(
          future: _updatesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Failed to load updates.'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No stories updated in the last 48 hours.'));
            }

            final updates = snapshot.data!;
            return ListView.builder(
              itemCount: updates.length,
              itemBuilder: (context, index) {
                final update = updates[index];
                return ListTile(
                  title: Text(update.title,
                      style: GoogleFonts.exo2(fontWeight: FontWeight.bold)),
                  subtitle: Text('${update.chapter} • ${update.time}',
                      style: GoogleFonts.exo2()),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryDetailScreen(
                              story: Story(
                                  id: update.id,
                                  title: update.title,
                                  imageUrl: update.coverImageUrl)),
                        ));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
