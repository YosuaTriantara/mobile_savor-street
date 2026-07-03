import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/qr/data/qr_token_parser.dart';

void main() {
  group('extractQrToken', () {
    test('mengambil token dari URL produksi dengan ?table=', () {
      expect(
        extractQrToken(
            'http://localhost:8000?table=bran9FoHykTngrx1o6hecOxs_ZJe_aJq0z8fksC-8Sk'),
        'bran9FoHykTngrx1o6hecOxs_ZJe_aJq0z8fksC-8Sk',
      );
    });

    test('mengambil token dari URL dengan ?token= (format lama docs)', () {
      expect(
        extractQrToken('https://savorstreet.app/table?token=QR-TABLE-001-A9F2K1'),
        'QR-TABLE-001-A9F2K1',
      );
    });

    test('mengambil token dari deep link scheme kustom', () {
      expect(
        extractQrToken('savorstreet://table?token=abc123'),
        'abc123',
      );
    });

    test('menerima raw token langsung', () {
      expect(extractQrToken('tbl_a01_f8s91x'), 'tbl_a01_f8s91x');
    });

    test('trim whitespace pada raw token', () {
      expect(extractQrToken('  abc-DEF_123  '), 'abc-DEF_123');
    });

    test('return null untuk string kosong', () {
      expect(extractQrToken(''), null);
      expect(extractQrToken('   '), null);
    });

    test('return null untuk URL tanpa param table/token', () {
      expect(extractQrToken('https://example.com/promo'), null);
    });

    test('return null untuk URL dengan param table kosong', () {
      expect(extractQrToken('http://localhost:8000?table='), null);
    });

    test('return null untuk teks acak yang bukan token', () {
      expect(extractQrToken('halo dunia ini bukan token'), null);
    });
  });
}
