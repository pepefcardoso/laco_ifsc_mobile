import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creme,
      body: Stack(
        children: [
          // Simulated map background
          Container(
            color: AppColors.azulSuave.withOpacity(0.1),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map_outlined, size: 80, color: AppColors.azulSuave),
                  const SizedBox(height: 16),
                  Text(
                    'Mapa dos Membros',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.carvao,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '(Visualização do mapa integrado em breve)',
                    style: TextStyle(fontFamily: 'Inter', color: AppColors.cinzaMorno),
                  ),
                ],
              ),
            ),
          ),
          // Floating weather information card
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.coralSuave),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Últimas localizações ativas',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Icon(Icons.info_outline, color: AppColors.cinzaMorno, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
