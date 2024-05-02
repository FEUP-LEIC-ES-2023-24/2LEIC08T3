import 'package:flutter/material.dart';
import 'package:greenscan/pages/product-detail-page.dart';
import 'package:greenscan/models/history_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryPage extends StatefulWidget {
  User user;

  HistoryPage({super.key, 
    required this.user,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<HistoryModel>>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = HistoryModel.getHistory(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HistoryModel>>(
      future: _historyFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<HistoryModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor:
                  const Color(0xff4b986c), // Set the background color of the AppBar
              title: const Text(
                'History',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ),
            body: ListView.separated(
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                              productCode: snapshot.data![index].barcode,
                              user: widget.user,),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.history, size: 20),
                              const SizedBox(
                                  width: 20), // Add space between the widgets
                              Text(
                                snapshot.data![index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                snapshot.data![index].barcode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}