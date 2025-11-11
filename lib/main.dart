import 'package:flutter/material.dart';

void main() => runApp(const MealMakerApp());

class MealMakerApp extends StatelessWidget {
  const MealMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF1E533A);
    const beige = Color(0xFFF0E6C8);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meal Maker',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: beige,
        colorScheme: ColorScheme.fromSeed(
          seedColor: darkGreen,
          primary: darkGreen,
          onPrimary: Colors.white,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      home: const HomeWireframePage(),
    );
  }
}

// ==================== HOME ====================

class HomeWireframePage extends StatefulWidget {
  const HomeWireframePage({super.key});
  @override
  State<HomeWireframePage> createState() => _HomeWireframePageState();
}

class _HomeWireframePageState extends State<HomeWireframePage> {
  final TextEditingController _search = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String query = '';

  // Demo recipe catalog (title + tags)
  final List<Recipe> recipes = const [
    Recipe(
      title: 'Grilled Chicken Salad',
      minutes: 25,
      calories: 320,
      rating: 4.5,
      tags: ['low carb', 'high protein', 'chicken', 'salad', 'gluten-free'],
    ),
    Recipe(
      title: 'Oats & Berries',
      minutes: 10,
      calories: 280,
      rating: 4.7,
      tags: ['breakfast', 'vegetarian', 'low calorie', 'oats'],
    ),
    Recipe(
      title: 'Tofu Stir-Fry',
      minutes: 20,
      calories: 350,
      rating: 4.3,
      tags: ['vegan', 'high protein', 'tofu', 'dinner'],
    ),
    Recipe(
      title: 'Greek Yogurt Bowl',
      minutes: 8,
      calories: 240,
      rating: 4.4,
      tags: ['vegetarian', 'breakfast', 'low calorie', 'no sugar'],
    ),
    Recipe(
      title: 'Keto Zoodle Alfredo',
      minutes: 22,
      calories: 390,
      rating: 4.6,
      tags: ['keto', 'low carb', 'zucchini', 'dinner'],
    ),
    Recipe(
      title: 'Baked Salmon & Asparagus',
      minutes: 18,
      calories: 330,
      rating: 4.8,
      tags: ['salmon', 'high protein', 'gluten-free', 'dinner'],
    ),
  ];

  List<Recipe> get filtered {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return recipes.where((r) =>
        r.title.toLowerCase().contains(q) ||
        r.tags.any((t) => t.toLowerCase().contains(q))).toList();
  }

  void _clearSearch() {
    _search.clear();
    setState(() => query = '');
  }

  void _goToAskAI() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ask AI will open (to be wired by team)')),
    );
  }

  void _openRecipe(Recipe r) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open: ${r.title} (to be wired)')),
    );
  }

  void _openGenre(String label, String tagQuery) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GenrePage(
          label: label,
          tagQuery: tagQuery,
          allRecipes: recipes,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF1E533A);
    const beige = Color(0xFFF0E6C8);

    final size = MediaQuery.of(context).size;

    // We keep compact, fixed heights for header & trending (stable look).
    const double headerH = 118;   // greeting + search
    const double trendingH = 120; // compact trending cards
    const double bottomNavH = 72;

    return Scaffold(
      backgroundColor: beige,

      bottomNavigationBar: const _BottomNav(),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAskAI,
        icon: const Icon(Icons.smart_toy),
        label: const Text('Ask AI'),
        backgroundColor: Colors.greenAccent,
        foregroundColor: darkGreen,
      ),

      body: Stack(
        children: [
          // MAIN LAYOUT (no scrolling needed for the top section)
          Column(
            children: [
              // Header: green band with greeting + rounded search
              Container(
                height: headerH,
                width: size.width,
                color: darkGreen,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hi, User. Let's find the best meal",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Material(
                        color: Colors.white,
                        child: TextField(
                          focusNode: _searchFocus,
                          controller: _search,
                          onChanged: (v) => setState(() => query = v),
                          decoration: InputDecoration(
                            hintText: 'Search recipes (e.g., chicken, low carb)…',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: query.isNotEmpty
                                ? IconButton(
                                    onPressed: _clearSearch,
                                    icon: const Icon(Icons.clear),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Trending Food Searches (compact)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                child: Row(
                  children: [
                    Text('Trending Food Searches',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              SizedBox(
                height: trendingH,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final data = [
                      ('Grilled Chicken Salad', 4.5),
                      ('Oats & Berries', 4.7),
                      ('Tofu Stir-Fry', 4.3),
                    ][i];
                    return _TrendingCard(title: data.$1, rating: data.$2);
                  },
                ),
              ),

              // Genres section — ALWAYS shows 2x2 tiles using dynamic sizing
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Two columns, one gutter between them
                    const double crossSpacing = 10;
                    const int columns = 2;

                    final double tileWidth =
                        (constraints.maxWidth - crossSpacing) / columns;

                    // Choose a compact tile height that fits on most phones.
                    // (Icon 22 + text + paddings) ~= 68–74; pick 74 for comfort.
                    const double tileHeight = 74;

                    // Child aspect ratio = width / height for GridView
                    final double aspect = tileWidth / tileHeight;

                    // Two rows + one mainSpacing between rows
                    const double mainSpacing = 10;
                    final double gridHeight = (tileHeight * 2) + mainSpacing;

                    return SizedBox(
                      height: gridHeight,
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: columns,
                        mainAxisSpacing: mainSpacing,
                        crossAxisSpacing: crossSpacing,
                        childAspectRatio: aspect,
                        children: [
                          _RoundCategory(
                            label: 'LOW\nCARB',
                            icon: Icons.download_done,
                            onTap: () => _openGenre('Low Carb', 'low carb'),
                          ),
                          _RoundCategory(
                            label: 'High\nProtein',
                            icon: Icons.fitness_center,
                            onTap: () => _openGenre('High Protein', 'high protein'),
                          ),
                          _RoundCategory(
                            label: 'LOW\nCALORIE',
                            icon: Icons.local_fire_department,
                            onTap: () => _openGenre('Low Calorie', 'low calorie'),
                          ),
                          _RoundCategory(
                            label: 'NO SUGAR',
                            icon: Icons.ac_unit,
                            onTap: () => _openGenre('No Sugar', 'no sugar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8), // small breathing room above bottom nav
            ],
          ),

          // SEARCH OVERLAY LIST (wireframe-style)
          if (filtered.isNotEmpty && (_searchFocus.hasFocus || query.isNotEmpty))
            Positioned(
              left: 16,
              right: 16,
              top: 90, // directly under the search field
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final r = filtered[i];
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.history),
                        title: Text(r.title),
                        subtitle: Text(
                          '${r.minutes} min · ${r.calories} cal · ★ ${r.rating}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.north_west_rounded),
                          onPressed: () => _openRecipe(r),
                          tooltip: 'Open',
                        ),
                        onTap: () => _openRecipe(r),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 72,
      child: Material(
        color: cs.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.favorite_border, color: Colors.white),
            Icon(Icons.lightbulb_outline, color: Colors.white),
            Icon(Icons.home_filled, color: Colors.white),
            Icon(Icons.person_outline, color: Colors.white),
            Icon(Icons.tune, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ==================== GENRE PAGE (placeholder) ====================

class GenrePage extends StatelessWidget {
  final String label;     // e.g., "Low Carb"
  final String tagQuery;  // e.g., "low carb"
  final List<Recipe> allRecipes;

  const GenrePage({
    super.key,
    required this.label,
    required this.tagQuery,
    required this.allRecipes,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final results = allRecipes
        .where((r) =>
            r.title.toLowerCase().contains(tagQuery.toLowerCase()) ||
            r.tags.any((t) => t.toLowerCase().contains(tagQuery.toLowerCase())))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        title: Text(label),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: results.isEmpty
            ? const Center(child: Text('No recipes yet — to be wired.'))
            : GridView.builder(
                itemCount: results.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final r = results[index];
                  return _MealTile(
                    title: r.title,
                    minutes: r.minutes,
                    calories: r.calories,
                    rating: r.rating,
                  );
                },
              ),
      ),
    );
  }
}

// ==================== DATA + WIDGETS ====================

class Recipe {
  final String title;
  final int minutes;
  final int calories;
  final double rating;
  final List<String> tags;
  const Recipe({
    required this.title,
    required this.minutes,
    required this.calories,
    required this.rating,
    required this.tags,
  });
}

class _TrendingCard extends StatelessWidget {
  final String title;
  final double rating;
  const _TrendingCard({required this.title, required this.rating});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image placeholder block
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Icon(Icons.restaurant, size: 36)),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Color(0xFFd4af37)),
              const Icon(Icons.star, size: 16, color: Color(0xFFd4af37)),
              const Icon(Icons.star, size: 16, color: Color(0xFFd4af37)),
              const Icon(Icons.star, size: 16, color: Color(0xFFd4af37)),
              Icon(rating >= 4.7 ? Icons.star : Icons.star_half,
                  size: 16, color: const Color(0xFFd4af37)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundCategory extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _RoundCategory({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8DCB7),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: cs.primary, width: 2.5),
              ),
              child: Icon(icon, color: cs.primary, size: 22),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                  fontSize: 13.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealTile extends StatelessWidget {
  final String title;
  final int minutes;
  final int calories;
  final double rating;
  const _MealTile({
    required this.title,
    required this.minutes,
    required this.calories,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8DCB7),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Icon(Icons.restaurant, size: 36)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(title,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Favorite',
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.timer, size: 16),
              const SizedBox(width: 4),
              Text('$minutes min'),
              const SizedBox(width: 10),
              const Icon(Icons.local_fire_department, size: 16),
              const SizedBox(width: 4),
              Text('$calories cal'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Color(0xFFd4af37)),
              const SizedBox(width: 4),
              Text('$rating'),
            ],
          ),
        ],
      ),
    );
  }
}
