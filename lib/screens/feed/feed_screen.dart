import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/group_provider.dart';
import '../../widgets/post_card.dart';

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
      if (group != null) {
        context.read<FeedProvider>().loadPosts(group.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final groupProvider = context.watch<GroupProvider>();
    final feedProvider = context.watch<FeedProvider>();
    
    final currentUserId = authProvider.currentUser?.uid ?? '';
    final groupId = groupProvider.currentGroup?.id ?? '';
    final members = groupProvider.members;

    return Scaffold(
      backgroundColor: AppColors.creme,
      appBar: AppBar(
        title: const Text(
          'Laço',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            color: AppColors.coralSuave,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.azulSuave),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createPost);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (groupId.isNotEmpty) {
            feedProvider.loadPosts(groupId);
          }
        },
        color: AppColors.azulSuave,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                if (members.isNotEmpty) ...[
                  const Text(
                    'Membros do Grupo',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.carvao,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: members.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return Container(
                          width: 100,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.brancoPuro,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.azulSuave.withValues(alpha: 0.2),
                                backgroundImage: member.photoUrl.isNotEmpty ? CachedNetworkImageProvider(member.photoUrl) : null,
                                child: member.photoUrl.isEmpty
                                    ? Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?', style: const TextStyle(fontWeight: FontWeight.bold))
                                    : null,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                member.name,
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              // TODO: Integrate actual weather later. For now placeholder if needed or blank.
                              const Text(
                                '-',
                                style: TextStyle(fontFamily: 'Inter', fontSize: 8, color: AppColors.cinzaMorno),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                const Text(
                  'Momentos Recentes',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.carvao,
                  ),
                ),
                const SizedBox(height: 12),
                if (feedProvider.isLoading && feedProvider.posts.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: AppColors.azulSuave),
                    ),
                  )
                else if (feedProvider.posts.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(Icons.photo_library_outlined, size: 64, color: AppColors.cinzaMorno.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhum momento ainda.',
                            style: TextStyle(fontFamily: 'Inter', color: AppColors.cinzaMorno, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.createPost);
                            },
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
                      final authorName = author?.name ?? 'Desconhecido';
                      final authorPhotoUrl = author?.photoUrl ?? '';
                      final timeAgo = DateFormatter.formatRelative(post.createdAt.toDate());

                      return PostCard(
                        authorName: authorName,
                        authorPhotoUrl: authorPhotoUrl,
                        imageUrl: post.imageUrl,
                        caption: post.caption,
                        timeAgo: timeAgo,
                        reactions: post.reactions,
                        currentUserId: currentUserId,
                        onReact: (emoji) {
                          feedProvider.reactToPost(post.id, currentUserId, emoji, groupId);
                        },
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
