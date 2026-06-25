import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
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
                  itemCount: 4,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final names = ['Ana', 'João', 'Maria', 'Artur'];
                    final cities = ['São Paulo', 'London', 'Florianópolis', 'Palhoça'];
                    final temps = ['22°C', '14°C', '20°C', '19°C'];
                    return Container(
                      width: 100,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.brancoPuro,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
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
                            backgroundColor: AppColors.azulSuave.withOpacity(0.2),
                            child: Text(names[index][0], style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            names[index],
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${cities[index]} • ${temps[index]}',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 8, color: AppColors.cinzaMorno),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Momentos Recentes',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.carvao,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final captions = [
                    'Um final de tarde maravilhoso na praia! 🌅',
                    'Almoço em família, que saudades de todos! ❤️'
                  ];
                  final times = ['há 2 horas', 'há 1 dia'];
                  final authors = ['Ana', 'Artur'];

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.brancoPuro,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.cinzaMorno.withOpacity(0.2),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            child: const Center(
                              child: Icon(Icons.image, size: 64, color: AppColors.cinzaMorno),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.coralSuave,
                                    child: Text(authors[index][0], style: const TextStyle(color: Colors.white, fontSize: 12)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    authors[index],
                                    style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    times[index],
                                    style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.cinzaMorno),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                captions[index],
                                style: const TextStyle(fontFamily: 'Inter', color: AppColors.carvao),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border, color: AppColors.coralSuave),
                                    onPressed: () {},
                                  ),
                                  const Text('3 reações', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.cinzaMorno)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
