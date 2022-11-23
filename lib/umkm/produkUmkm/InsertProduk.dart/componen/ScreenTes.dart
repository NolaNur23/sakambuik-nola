import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class Tess extends StatefulWidget {
  final String produk,
      komposisi,
      id_produk,
      satuan,
      waktu_buat,
      deskripsi,
      stok,
      tgl_stok,
      daya_buat,
      id_umkm;
  const Tess(
      {Key key,
      this.produk,
      this.komposisi,
      this.id_produk,
      this.satuan,
      this.waktu_buat,
      this.deskripsi,
      this.stok,
      this.tgl_stok,
      this.daya_buat,
      this.id_umkm})
      : super(key: key);

  @override
  _TessState createState() => _TessState();
}

class _TessState extends State<Tess> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Column(
        children: [
          Text(widget.waktu_buat),
          Text(widget.produk),
          Text(widget.id_produk),
          Text(widget.id_umkm),
          Text(widget.komposisi),
          Text(widget.deskripsi),
          Text(widget.stok),
          Text(widget.tgl_stok),
          Text(widget.daya_buat),
          Text(widget.satuan),
          // Text(widget.satuan),
        ],
      ),
    );
  }
}
