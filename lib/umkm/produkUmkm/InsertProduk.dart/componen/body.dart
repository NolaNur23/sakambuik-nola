import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sakambuik/componen/InputDeco_design.dart';
import 'package:sakambuik/componen/background.dart';
import 'package:sakambuik/componen/rounded_input_field.dart';
import 'package:sakambuik/componen/text_field_container.dart';
import 'package:sakambuik/constant.dart';
import 'package:sakambuik/model/InsertProduk.dart';
import 'package:sakambuik/model/insert_foto.dart';

class BodyTambahProduk extends StatefulWidget {
  final String id;
  const BodyTambahProduk({Key key, this.id}) : super(key: key);

  @override
  _BodyTambahProdukState createState() => _BodyTambahProdukState();
}

class _BodyTambahProdukState extends State<BodyTambahProduk> {
  InsertProduk insertproduk = null;
  InsertFoto insertfoto = null;
  // InsertProduk insertprdk = null;
  File uploadimage;
  final TextEditingController _namaproduk = TextEditingController();
  final TextEditingController _deskripsi = TextEditingController();
  final TextEditingController _komposisi = TextEditingController();
  final TextEditingController _satuan = TextEditingController();
  final TextEditingController _stok = TextEditingController();
  final TextEditingController _kemampuanmembuat = TextEditingController();
  final TextEditingController _waktupembuatan = TextEditingController();
  // final TextEditingController _kemampuanmembuat = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String id_kategori,
      produk,
      komposisi,
      satuan,
      deskripsi,
      tgl_stok,
      id_umkm,
      id_produk;
  String _valuekategoriPrd, kategoriPrd;
  String kemampuan, stok, daya_buat, waktu_buat;
  int _valkategoriPrdint;

  FToast fToast;
  Random random = Random();
  Future<void> uploadImage() async {
    String apiUrl = api + 'api/UMKM_Delete?';
    try {
      List<int> imageBytes = uploadimage.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      var response = await http.post(apiUrl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: {
        // 'name': name,
        'id_produk': "09876",
        'id_umkm': id_umkm,
        'foto_produk': baseimage,
      });
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body); //decode json data
        if (jsondata["pesan"]) {
          //check error sent from server
          print(jsondata["pesan"]);
          //if error return from server, show message from server
        } else {
          setState(() {
            print("Upload successful");
            InsertFoto.connectToApi(id_produk, widget.id, baseimage)
                .then((value) {
              insertfoto = value;
              if (insertfoto.Kode == 1) {
              } else {}
            });
          });
        }
      } else {
        print("Eror server");
      }
    } catch (e) {
      print("eror pas convert");
    }
  }

  Future<void> chooseImage() async {
    var choosedimage = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      // Do something with the file
      if (choosedimage == null) {
        // File is null, probably not found or incorrect path.
        return;
      }
      if (choosedimage.path == null) {}
      uploadimage = File(choosedimage.path);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();

    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    var tahun = DateFormat('yyMMddhhmmss').format(DateTime.now());
    int qr;
    qr = random.nextInt(999999999) + 10000;
    id_produk = "PRDK-" + tahun;
    List<String> spinJenisKategori = ['Handy Crafy', 'Kuliner', 'Perangkat'];

    Size size = MediaQuery.of(context).size;
    return Background(
      judul: "Insert Produk Baru",
      child: Container(
          // color: BlueSambuik,
          margin: EdgeInsets.only(
              left: size.width * 0.1,
              right: size.width * 0.1,
              top: size.height * 0.25,
              bottom: size.height * 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3))
              ]),
          height: size.height * 0.68,
          child: SingleChildScrollView(
              child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage("assets/user_pict.png"))),
                          child: Stack(
                            children: [
                              Center(
                                child: (uploadimage == null)
                                    ? SizedBox()
                                    : ClipOval(
                                        child: Container(
                                            width: 100,
                                            height: 100,
                                            child: Image.file(
                                              uploadimage,
                                              fit: BoxFit.cover,
                                            ))),
                              ),
                              GestureDetector(
                                onTap: () {
                                  chooseImage();
                                },
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                        height: 35,
                                        width: 35,
                                        child: Image(
                                            image: AssetImage((uploadimage ==
                                                    null)
                                                ? "assets/btn_add_photo.png"
                                                : "assets/btn_remove_photo.png")))),
                              )
                            ],
                          ),
                        ),
                      ),
                      Material(
                        child: RoundedInputField(
                          editInput: _namaproduk,
                          onChange: (value) {
                            _namaproduk.text = value;
                          },
                          cursorColor: BlueSambuik,
                          inDecoration:
                              buildInputDecoration(Icons.person, "Nama Produk"),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Masukkan Nama Produk';
                            }
                            return null;
                          },
                        ),
                      ),
                      Material(
                        // shape: BorderDirectional(),
                        child: TextFieldContainer(
                          child: Container(
                            child: DropdownButton(
                              value: _valuekategoriPrd,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: BlueSambuik,
                              ),
                              hint: const Text("pilih Ketegori"),
                              isExpanded: true,
                              items: spinJenisKategori.map((valuea) {
                                return DropdownMenuItem<String>(
                                  child: Text(valuea),
                                  value: valuea,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _valuekategoriPrd = value;
                                  _valkategoriPrdint =
                                      spinJenisKategori.indexOf(value);
                                  if (_valkategoriPrdint == 1) {
                                    id_kategori = "12321";
                                  } else if (_valkategoriPrdint == 1) {
                                    id_kategori = "124221";
                                  } else if (_valkategoriPrdint == 2) {
                                    id_kategori = "31234";
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Material(
                        child: RoundedInputField(
                          editInput: _komposisi,
                          onChange: (value) {
                            _komposisi.text = value;
                          },
                          cursorColor: BlueSambuik,
                          inDecoration: buildInputDecoration(
                              Icons.person, "Komposisi Produk"),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Masukkan Komposisi Produk';
                            }
                            return null;
                          },
                        ),
                      ),
                      Material(
                        child: RoundedInputField(
                          editInput: _deskripsi,
                          onChange: (value) {
                            _deskripsi.text = value;
                          },
                          cursorColor: BlueSambuik,
                          inDecoration: buildInputDecoration(
                              Icons.person, "Deskripsi Produk"),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Masukkan Deskripsi Produk';
                            }
                            return null;
                          },
                        ),
                      ),
                      Material(
                        child: RoundedInputField(
                          editInput: _kemampuanmembuat,
                          onChange: (value) {
                            _kemampuanmembuat.text = value;
                          },
                          cursorColor: BlueSambuik,
                          inDecoration: buildInputDecoration(
                              Icons.person, "Jumlah Buat Produk"),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Masukkan Jumlah Buat Produk';
                            }
                            return null;
                          },
                        ),
                      ),
                      Material(
                        child: RoundedInputField(
                          editInput: _satuan,
                          onChange: (value) {
                            _satuan.text = value;
                          },
                          cursorColor: BlueSambuik,
                          inDecoration: buildInputDecoration(
                              Icons.person, "Satuan Jumlah Buat Produk"),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Satuan Jumlah Buat Produk';
                            }
                            return null;
                          },
                        ),
                      ),
                      // Text(basei)
                      Material(
                        child: RoundedInputField(
                          editInput: _satuan,
                          onChange: (value) {
                            _waktupembuatan.text = value;
                          },
                          cursorColor: BlueSambuik,
                          inDecoration: buildInputDecoration(
                              Icons.person, "Waktu Buat Produk/hari"),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Masukkan Waktu Buat Produk/hari';
                            }
                            return null;
                          },
                        ),
                      ),
                      FlatButton(
                          child: Text("Simpan"),
                          // text: "Simpan",
                          onPressed: () {
                            if (_formkey.currentState.validate()) {
                              produk = _namaproduk.text;
                              komposisi = _komposisi.text;
                              satuan = _satuan.text;
                              waktu_buat = _waktupembuatan.text;
                              deskripsi = _deskripsi.text;
                              stok = "0";
                              tgl_stok = "0000-00-00";
                              daya_buat = _kemampuanmembuat.text;
                              uploadImage();

                              InsertProduk.connectToApi(
                                id_produk,
                                widget.id,
                                produk,
                                id_kategori,
                                komposisi,
                                int.parse(daya_buat),
                                satuan,
                                int.parse(waktu_buat),
                                stok,
                                tgl_stok,
                                "2021-12-01",
                                deskripsi,
                              ).then((value) {
                                insertproduk = value;
                                if (insertproduk != null) {
                                  if (insertproduk.Kode == 1) {}
                                }
                              });
                            }
                          })
                    ],
                  )))),
    );
  }
}
