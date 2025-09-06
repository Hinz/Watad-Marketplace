import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.user == null) {
            return const Center(
              child: Text('No user data available'),
            );
          }

          final user = authProvider.user!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: user.profileImageUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    user.profileImageUrl!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text(
                                        user.name[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Text(
                                  user.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),
                        // Name and Type
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(
                            user.userType == UserType.student ? 'Student' : 'Parent',
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        const SizedBox(height: 16),
                        // Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('Listings', '${user.totalListings}'),
                            _buildStatItem('Sales', '${user.totalSales}'),
                            _buildStatItem('Rating', '${user.rating.toStringAsFixed(1)}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Profile Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profile Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Email', user.email),
                        _buildInfoRow('Phone', user.phone),
                        _buildInfoRow('Country', user.country),
                        _buildInfoRow('Province', user.province),
                        if (user.schoolName != null)
                          _buildInfoRow('School', user.schoolName!),
                        _buildInfoRow('Member Since', _formatDate(user.createdAt)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Quick Actions
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildActionTile(
                          context,
                          icon: Icons.edit,
                          title: 'Edit Profile',
                          subtitle: 'Update your personal information',
                          onTap: () {
                            _showEditProfileDialog(context, user);
                          },
                        ),
                        _buildActionTile(
                          context,
                          icon: Icons.inventory_2,
                          title: 'My Listings',
                          subtitle: 'View and manage your listings',
                          onTap: () {
                            // Navigate to user's listings
                          },
                        ),
                        _buildActionTile(
                          context,
                          icon: Icons.shopping_bag,
                          title: 'Purchase History',
                          subtitle: 'View your purchase history',
                          onTap: () {
                            // Navigate to purchase history
                          },
                        ),
                        _buildActionTile(
                          context,
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Get help and contact support',
                          onTap: () {
                            _showHelpDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // App Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'App Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Version', '1.0.0'),
                        _buildInfoRow('Build', '1'),
                        _buildActionTile(
                          context,
                          icon: Icons.info_outline,
                          title: 'About Watad Marketplace',
                          subtitle: 'Learn more about our platform',
                          onTap: () {
                            _showAboutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, User user) {
    // This would open an edit profile screen in a real app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile feature coming soon!'),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For support, please contact us at:'),
            SizedBox(height: 8),
            Text('Email: support@watadmarketplace.com'),
            Text('Phone: +962 6 123 4567'),
            SizedBox(height: 16),
            Text('Common Questions:'),
            SizedBox(height: 8),
            Text('• How do I create a listing?'),
            Text('• What is the listing fee?'),
            Text('• How do I contact a seller?'),
            Text('• How do I make a payment?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Watad Marketplace',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.school, size: 48),
      children: const [
        Text(
          'Watad Marketplace is a platform for parents and students to buy and sell educational items including uniforms, books, presentations, and more.',
        ),
        SizedBox(height: 16),
        Text(
          'Features:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('• Browse and search listings'),
        Text('• Filter by school, country, province'),
        Text('• Secure payment system'),
        Text('• User ratings and reviews'),
        Text('• Mobile-friendly interface'),
      ],
    );
  }
}
