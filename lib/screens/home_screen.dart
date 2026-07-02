import 'package:flutter/material.dart';
import 'form_screen.dart';
import 'records_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        title: const Text('EQ Request', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Card with App Icon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  // Text ki jagah App Icon add kiya hai
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset('assets/images/app_icon.png', height: 75, width: 75),
                  ),
                  const SizedBox(height: 12),
                  const Text('Electric Loco Shed, Ghaziabad', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // New Request Button
            _buildMenuButton(
              context,
              title: 'New EQ Request',
              subtitle: 'Generate a new Emergency Quota letter',
              icon: Icons.add_circle_outline,
              color: const Color(0xFF1A237E),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormScreen())),
            ),
            const SizedBox(height: 16),

            // Old Records Button
            _buildMenuButton(
              context,
              title: 'Old Records',
              subtitle: 'View previously generated requests',
              icon: Icons.history,
              color: const Color(0xFF1E7031), // Green color matching your screenshot
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecordsScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
