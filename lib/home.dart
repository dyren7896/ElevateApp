import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

// ---------- Palet warna (Light sebagai default & Dark) ----------

class AppPalette {
  const AppPalette({
    required this.bgTop,
    required this.bgBottom,
    required this.accent,
    required this.onAccent,
    required this.text,
    required this.surface,
    required this.surfacePressed,
    required this.border,
    required this.navBg,
    required this.drawerBg,
  });

  final Color bgTop;
  final Color bgBottom;
  final Color accent;
  final Color onAccent;
  final Color text;
  final Color surface;
  final Color surfacePressed;
  final Color border;
  final Color navBg;
  final Color drawerBg;

  Color get textSoft => text.withValues(alpha: 0.7);
  Color get textMuted => text.withValues(alpha: 0.55);

  static final dark = AppPalette(
    bgTop: Colors.black,
    bgBottom: Colors.black,
    accent: const Color.fromARGB(255, 223, 11, 212),
    onAccent: const Color(0xFF1B1F4B),
    text: Colors.white,
    surface: Colors.white.withValues(alpha: 0.07),
    surfacePressed: Colors.white.withValues(alpha: 0.12),
    border: Colors.white.withValues(alpha: 0.10),
    navBg: Colors.black,
    drawerBg: Colors.black,
  );

  static final light = AppPalette(
    bgTop: Colors.white,
    bgBottom: Colors.white,
    accent: Colors.black,
    onAccent: Colors.white,
    text: Colors.black,
    surface: Colors.grey.shade100,
    surfacePressed: Colors.grey.shade200,
    border: Colors.grey.shade300,
    navBg: Colors.white,
    drawerBg: Colors.white,
  );

  static AppPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

// ---------- App ----------

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static const appTitle = 'Rens Store';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Mode default disesuaikan ke Light Mode (Background Putih, Teks Hitam)
  ThemeMode _mode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    const seed = Colors.black;

    return MaterialApp(
      title: MyApp.appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      themeAnimationDuration: const Duration(milliseconds: 350),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
      ),
      home: MyHomePage(
        title: MyApp.appTitle,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onToggleTheme,
  });

  final String title;
  final VoidCallback onToggleTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const _HomeView(key: ValueKey(0));
      case 1:
        return const _InventoryView(key: ValueKey(1));
      case 2:
        return const _ProfileView(key: ValueKey(2));
      default:
        return const _WalletView(key: ValueKey(3));
    }
  }

  Widget _drawerItem(
    AppPalette p,
    int index,
    IconData icon,
    String label,
  ) {
    final selected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        selected: selected,
        selectedColor: p.accent,
        selectedTileColor: p.accent.withValues(alpha: 0.12),
        iconColor: p.textSoft,
        textColor: p.textSoft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        onTap: () {
          _onItemTapped(index);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p.bgTop, p.bgBottom],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: p.text,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          systemOverlayStyle:
              isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          actions: [
            IconButton(
              tooltip: isDark ? 'Mode terang' : 'Mode gelap',
              onPressed: widget.onToggleTheme,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: Tween<double>(begin: 0.75, end: 1).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey(isDark),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.03, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _buildPage(_selectedIndex),
        ),
        drawer: Drawer(
          backgroundColor: p.drawerBg,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                        child: Row(
                          children: [
                            const SizedBox(width: 4),
                            Text(
                              'Elevates App',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: p.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _drawerItem(p, 0, Icons.home_rounded, 'Home'),
                      _drawerItem(p, 1, Icons.inventory_2_rounded, 'Inventaris'),
                      _drawerItem(p, 2, Icons.person_rounded, 'Profile'),
                      _drawerItem(p, 3, Icons.wallet_rounded, 'wallet')
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

// ---------- Halaman ----------

class _HomeView extends StatelessWidget {
  const _HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      physics: const BouncingScrollPhysics(),
      children: const [
        _Reveal(
          index: 0,
          child: _PageHeader(
            label: 'HOME',
            title: 'Store Management',
            subtitle: 'Manage Your Store With ElevateApp',
          ),
        ),
        _Reveal(
          index: 1,
          child: _InfoCard(
            icon: Icons.currency_exchange,
            title: 'Total Assets',
            value:'Rp.37.894.200',
          ),
        ),
        _Reveal(
          index: 2, 
          child: _InfoCard(
            icon: Icons.card_membership, 
            title: 'ID Member', 
            value: '889012223',
          )
        ),
        _Reveal(
          index: 3,
          child: _InfoCard(
            icon: Icons.notifications_none_rounded,
            title: 'Pembaruan',
            value: 'Belum ada notifikasi baru.',
          ),
        ),
      ],
    );
  }
}

// Halaman Inventaris (Menggantikan Halaman Statistic)
class _InventoryView extends StatelessWidget {
  const _InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      physics: const BouncingScrollPhysics(),
      children: const [
        _Reveal(
          index: 0,
          child: _PageHeader(
            label: 'INVENTARIS',
            title: 'Stok Barang',
            subtitle: 'Ringkasan manajemen produk Rens Store.',
          ),
        ),
        _Reveal(
          index: 1,
          child: _InfoCard(
            icon: Icons.category_rounded,
            title: 'Total Produk Unique',
            value: '1.420 Item',
          ),
        ),
        _Reveal(
          index: 2,
          child: _InfoCard(
            icon: Icons.warning_amber_rounded,
            title: 'Stok Rendah',
            value: '12 Produk perlu re-stock',
          ),
        ),
        _Reveal(
          index: 3,
          child: _InfoCard(
            icon: Icons.unarchive_rounded,
            title: 'Barang Keluar (Hari ini)',
            value: '184 Unit',
          ),
        ),
        _Reveal(
          index: 4,
          child: _InfoCard(
            icon: Icons.local_shipping_rounded,
            title: 'Pemasok Terhubung',
            value: '8 Supplier Aktif',
          ),
        ),
      ],
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        _Reveal(
          index: 0,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: p.accent.withValues(alpha: 0.12),
                  border: Border.all(color: p.accent, width: 2),
                ),
                child: Text(
                  'R',
                  style: TextStyle(
                    color: p.accent,
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Rens Store Admin',
                style: TextStyle(
                  color: p.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'admin@rensstore.com',
                style: TextStyle(color: p.textMuted),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
        const _Reveal(
          index: 1,
          child: _InfoCard(
            icon: Icons.edit_outlined,
            title: 'Edit profil',
            value: 'Ubah nama dan toko.',
          ),
        ),
        const _Reveal(
          index: 2,
          child: _InfoCard(
            icon: Icons.lock_outline_rounded,
            title: 'Keamanan',
            value: 'Kata sandi dan sesi aktif.',
          ),
        ),
      ],
    );
  }
}

class _WalletView extends StatelessWidget {
  const _WalletView({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      physics: const BouncingScrollPhysics(), 
      children: const [
        _Reveal(
          index: 0, 
          child: _PageHeader(
            label: 'Wallet', 
            title: 'Rp. 28.900.000', 
            subtitle: 'Total Assets :Rp.37.894.200 '
          )
        ),
        _Reveal(
          index: 1, 
          child: _InfoCard(
            icon: Icons.send, 
            title: 'Tarik Tunai', 
            value: 'Tarik tunai dengan metode penarikan yang kamu mau. ',
          )
        ),
        _Reveal(
          index: 2, 
          child: _InfoCard(
            icon: Icons.receipt, 
            title: 'Terima Tunai', 
            value: 'Terima tunai saat ini hanya bisa melalui Qris dan Transfer.'
          ),
        ),
        _Reveal(
          index: 3, 
          child: _InfoCard(
            icon: Icons.history, 
            title: 'Riwayat Transaksi', 
            value: 'Lihat riwayat transaksi anda disini.',
          ),
        ),
      ],
    );
  }
}

// ---------- Komponen ----------

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.label,
    required this.title,
    required this.subtitle,
  });

  final String label;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 28, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: text.labelLarge?.copyWith(
              color: p.accent,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: text.displaySmall?.copyWith(
              color: p.text,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: text.bodyLarge?.copyWith(color: p.textSoft),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatefulWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _pressed ? p.surfacePressed : p.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: p.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(70, 223, 64, 251),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(widget.icon, color:Colors.purple),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: text.titleMedium?.copyWith(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.value,
                      style: text.bodyMedium?.copyWith(color: p.textSoft),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fade + slide masuk bertahap. Main lagi tiap halaman berganti.
class _Reveal extends StatelessWidget {
  const _Reveal({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450 + index * 120),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}