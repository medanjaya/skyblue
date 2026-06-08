import 'package:flutter/material.dart';

class Pain extends StatelessWidget {
  const Pain({super.key});

  static const _accentColor = Color(0xFF1F7CFF);
  static const _borderColor = Color(0xFFD8D8D8);
  static const _textColor = Color(0xFF3A3A3A);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        const Text(
          'Tambah Barang',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF007BFF),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 36.0,
            children: [
              Expanded(
                child: _CardShell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Product Information',
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 18.0,
                            children: [
                              _labeledField(
                                label: 'Nama Barang',
                                hint: 'Masukkan Nama Barang',
                              ),
                              Row(
                                spacing: 16.0,
                                children: [
                                  Expanded(
                                    child: _labeledField(
                                      label: 'Ukuran',
                                      hint: 'Masukkan Ukuran',
                                    ),
                                  ),
                                  Expanded(
                                    child: _labeledField(
                                      label: 'Warna',
                                      hint: 'Warna',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 16.0,
                                children: [
                                  Expanded(
                                    child: _labeledField(
                                      label: 'Kategori',
                                      hint: 'pilih category barang',
                                      suffixIcon: Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ),
                                  Expanded(
                                    child: _labeledField(
                                      label: 'Brand',
                                      hint: 'pilih brand',
                                      suffixIcon: Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ),
                                ],
                              ),
                              _labeledField(
                                label: 'Minimum Stok',
                                hint: 'Masukkan minimum stok',
                              ),
                              _labeledField(
                                label: 'Harga',
                                hint: 'Masukkan Harga',
                              ),
                              _labeledField(
                                label: 'Status Product',
                                hint: 'Select status product',
                                suffixIcon: Icons.keyboard_arrow_down_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 22.0,
                  children: [
                    Expanded(
                      child: _CardShell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Deskripsi Barang',
                              style: TextStyle(
                                color: _textColor,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            const Text(
                              'Deskripsi Produk',
                              style: TextStyle(
                                color: _accentColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 18.0),
                            Expanded(
                              child: TextField(
                                expands: true,
                                maxLines: null,
                                minLines: null,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(14.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.black54,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: _accentColor,
                                      width: 1.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _CardShell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Image Product',
                            style: TextStyle(
                              color: _textColor,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Note : ',
                                  style: TextStyle(
                                    color: _accentColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Format photos SVG, PNG, or JPG (Max size 4mb)',
                                  style: TextStyle(
                                    color: _textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            style: TextStyle(fontSize: 13.0),
                          ),
                          const SizedBox(height: 18.0),
                          Row(
                            spacing: 16.0,
                            children: List.generate(
                              5,
                              (i) {
                                return Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 1.18,
                                    child: _PhotoBox(index: i + 1),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 148.0,
                        height: 48.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Save Product'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _labeledField({
    required String label,
    required String hint,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.0,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _textColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(
          height: 52.0,
          child: TextField(
            readOnly: suffixIcon != null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF878787),
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: suffixIcon == null
              ? null
              : Icon(
                suffixIcon,
                color: const Color(0xFFA7A7A7),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: _borderColor,
                  width: 1.4,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: _accentColor,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFE4E4E4),
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: child,
    );
  }
}

class _PhotoBox extends StatelessWidget {
  const _PhotoBox({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _DashedBorderPainter(
        color: Pain._accentColor,
        radius: 8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10.0,
        children: [
          const Icon(
            Icons.image_outlined,
            color: Pain._accentColor,
            size: 28.0,
          ),
          Text(
            'Photo $index',
            style: const TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 13.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 4.0;
    const dashSpace = 3.5;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
