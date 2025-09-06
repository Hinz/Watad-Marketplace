import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/listing.dart';

class CartItemWidget extends StatelessWidget {
  final Listing listing;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.listing,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: listing.imageUrls.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: listing.imageUrls.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getCategoryText(listing.category),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Condition: ${_getConditionText(listing.condition)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.currency(symbol: 'JD ').format(listing.price),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: onRemove,
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryText(ListingCategory category) {
    switch (category) {
      case ListingCategory.uniforms:
        return 'Uniforms';
      case ListingCategory.books:
        return 'Books';
      case ListingCategory.presentations:
        return 'Presentations';
      case ListingCategory.stationery:
        return 'Stationery';
      case ListingCategory.electronics:
        return 'Electronics';
      case ListingCategory.sports:
        return 'Sports';
      case ListingCategory.art:
        return 'Art';
      case ListingCategory.music:
        return 'Music';
      case ListingCategory.other:
        return 'Other';
    }
  }

  String _getConditionText(ListingCondition condition) {
    switch (condition) {
      case ListingCondition.new_:
        return 'New';
      case ListingCondition.excellent:
        return 'Excellent';
      case ListingCondition.good:
        return 'Good';
      case ListingCondition.fair:
        return 'Fair';
      case ListingCondition.poor:
        return 'Poor';
    }
  }
}
