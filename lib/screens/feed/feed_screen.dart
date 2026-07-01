import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/hug_provider.dart';
import '../../widgets/post_card.dart';
import '../../widgets/member_row.dart';
import '../../widgets/hugs_section.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final group = context.read<GroupProvider>().currentGroup;
      final userId = context.read<AuthProvider>().currentUser?.uid;
      if (group != null) {
        context.read<FeedProvider>().loadPosts(group.id);
        if (userId != null) {
          context.read<HugProvider>().loadReceivedHugs(group.id, userId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final groupProvider = context.watch<GroupProvider>();
    final feedProvider = context.watch<FeedProvider>();
    final hugProvider = context.watch<HugProvider>();
    
    final currentUserId = authProvider.currentUser?.uid ?? '';
    final groupId = groupProvider.currentGroup?.id ?? '';
    final members = groupProvider.members;
    final receivedHugs = hugProvider.receivedHugs;

    return Scaffold(
      backgroundColor: AppColors.creme,
      appBar: AppBar(
        title: const Text(
          'Laço',
          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: AppColors.coralSuave),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.azulSuave),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.createPost),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (groupId.isNotEmpty) {
            feedProvider.loadPosts(groupId);
            if (currentUserId.isNotEmpty) {
              hugProvider.loadReceivedHugs(groupId, currentUserId);
            }
          }
        },
        color: AppColors.azulSuave,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppColors.paddingLateral),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                MemberRow(members: members),
                HugsSection(receivedHugs: receivedHugs),
                const Text(
                  'Momentos Recentes',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.carvao),
                ),
                const SizedBox(height: 12),
                if (feedProvider.isLoading && feedProvider.posts.isEmpty)
                  const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator(color: AppColors.azulSuave)))
                else if (feedProvider.posts.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(Icons.photo_library_outlined, size: 64, color: AppColors.cinzaMorno.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          const Text('Nenhum momento ainda.', style: TextStyle(fontFamily: 'Inter', color: AppColors.cinzaMorno, fontSize: 16)),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.createPost),
                            child: const Text('Seja o primeiro a postar!', style: TextStyle(color: AppColors.azulSuave)),
                          )
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: feedProvider.posts.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final post = feedProvider.posts[index];
                      final author = members.cast<dynamic>().firstWhere((m) => m.id == post.authorId, orElse: () => null);
                      return PostCard(
                        authorName: author?.name ?? 'Desconhecido',
                        authorPhotoUrl: author?.photoUrl ?? '',
                        imageUrl: post.imageUrl,
                        caption: post.caption,
                        timeAgo: DateFormatter.formatRelative(post.createdAt.toDate()),
                        reactions: post.reactions,
                        currentUserId: currentUserId,
                        onReact: (emoji) => feedProvider.reactToPost(post.id, currentUserId, emoji, groupId),
                      );
                    },
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
