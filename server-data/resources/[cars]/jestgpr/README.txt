JESTGPR - Cara pasang mod mobil (format dlc.rpf)

Kondisi kamu sekarang:
- Di folder ini cuma ada dlc.rpf

FiveM umumnya TIDAK memakai dlc.rpf mentah untuk add-on vehicle.
Yang dipakai adalah isi di dalamnya: folder stream + file meta (data).

Langkah:
1) Buka dlc.rpf pakai OpenIV.
2) Extract/copy bagian berikut:
   - /common/data/ (handling.meta, vehicles.meta, carcols.meta, carvariations.meta, dll)
   - /x64/**/vehicles.rpf/ (file model: *.yft, *.ytd, *.ycd, dll)
3) Buat folder:
   - stream/  -> taruh semua *.yft/*.ytd/*.ycd dkk dari vehicles.rpf
   - data/    -> taruh semua *.meta dari common/data
4) Pastikan fxmanifest.lua sudah ada (file ini sudah dibuat).
5) Di server.cfg pastikan ada:
   - ensure [cars]
   (atau ensure jestgpr)
6) Restart server.

Cara test:
- Spawn pakai nama model yang ada di vehicles.meta (contoh: <modelName>).

Catatan:
- Setelah sudah diextract ke stream/ dan data/, kamu boleh hapus dlc.rpf supaya hemat space.
