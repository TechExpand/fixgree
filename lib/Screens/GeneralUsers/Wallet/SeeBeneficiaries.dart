import 'package:fixme/Model/Beneficiary.dart';
import 'package:fixme/Screens/GeneralUsers/Wallet/Providers/BankProvider.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:fixme/Model/BankInfo.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:provider/provider.dart';

class SeeBeneficiaries extends StatefulWidget {
  final BankProvider model;
  final bool isWalletTransfer;
  SeeBeneficiaries({Key key, this.model, this.isWalletTransfer = false})
      : super(key: key);

  @override
  _SeeBeneficiariesState createState() => _SeeBeneficiariesState();
}

class _SeeBeneficiariesState extends State<SeeBeneficiaries> {
  TextEditingController searchController = TextEditingController();

  List<Beneficary> userItems = [];
  List<Beneficary> filteredItems = [];

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Select beneficiary',
            style: GoogleFonts.openSans(
                color: Color(0xFF333333),
                fontSize: 21,
                height: 1.4,
                fontWeight: FontWeight.w500)),
        elevation: 0,
        leadingWidth: 10,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(FeatherIcons.x, color: Color(0xFF777777)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 12),
            margin:
                const EdgeInsets.only(bottom: 15, left: 12, right: 12, top: 15),
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                border: Border.all(color: Color(0xFFF1F1FD)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFFF1F1FD),
                      blurRadius: 15.0,
                      offset: Offset(0.3, 4.0))
                ],
                borderRadius: BorderRadius.all(Radius.circular(35))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    FeatherIcons.search,
                    color: Color(0xFF555555),
                    size: 20,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF270F33),
                        fontWeight: FontWeight.w600),
                    controller: searchController,
                    onChanged: (value) {
                      print('Tapped!');
                      filterSearchResults(value);
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Search beneficiaries',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      focusColor: Color(0xFF2B1137),
                      fillColor: Color(0xFF2B1137),
                      hoverColor: Color(0xFF2B1137),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: FutureBuilder<List>(
                  future: network.getBeneficiaries(),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    Widget mainWidget;
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == null) {
                        mainWidget = Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Theme(
                                  data: Theme.of(context)
                                      .copyWith(accentColor: Color(0xFF9B049B)),
                                  child: CircularProgressIndicator()),
                              SizedBox(
                                height: 10,
                              ),
                              Text('No Network',
                                  style: TextStyle(
                                      // letterSpacing: 4,
                                      color: Color(0xFF333333),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        );
                      } else {
                        userItems = List<Beneficary>.generate(
                            snapshot.data.length,
                            (index) =>
                                Beneficary.fromJson(snapshot.data[index]));
                        mainWidget = filteredItems.length != 0 ||
                                searchController.text.isNotEmpty
                            ? ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: filteredItems.length,
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                itemBuilder: (BuildContext context, int index) {
                                  filteredItems.sort((a, b) {
                                    var ad = a.accountName;
                                    var bd = b.accountName;
                                    var s = ad.compareTo(bd);
                                    return s;
                                  });

                                  return Container(
                                    alignment: Alignment.center,
                                    height: 75,
                                    margin: const EdgeInsets.only(
                                        bottom: 5, top: 15),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        border: Border.all(
                                            color: Color(0xFFF1F1FD)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13))),
                                    child: ListTile(
                                      onTap: () {
                                        widget.model.bankName.text =
                                            filteredItems[index].accountName;
                                        widget.model.setAccountNumber =
                                            filteredItems[index].accountNumber;
                                        widget.model.setBankNameStatus = false;
                                        Navigator.pop(context);
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            Color(0xFF270F33).withOpacity(0.6),
                                        child: Text(
                                            filteredItems[index]
                                                .accountName
                                                .substring(0, 1),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      isThreeLine: true,
                                      title: Text(userItems[index].accountName,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF333333),
                                          )),
                                      subtitle: Text(userItems[index].bankName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF333333),
                                          )),
                                    ),
                                  );
                                })
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: userItems.length,
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                itemBuilder: (BuildContext context, int index) {
                                  userItems.sort((a, b) {
                                    var ad = a.accountName;
                                    var bd = b.accountName;
                                    var s = ad.compareTo(bd);
                                    return s;
                                  });

                                  return Container(
                                    alignment: Alignment.center,
                                    height: 75,
                                    margin: const EdgeInsets.only(
                                        bottom: 5, top: 15),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        border: Border.all(
                                            color: Color(0xFFF1F1FD)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13))),
                                    child: ListTile(
                                      onTap: () {
                                        BankInfo bankInfo = BankInfo(
                                            code: userItems[index].bankCode,
                                            name: userItems[index].bankName);
                                        widget.model.bankName.text =
                                            userItems[index].bankName;
                                        widget.model.accountNumber.text =
                                            userItems[index].accountNumber;
                                        widget.model.setAccountNumber =
                                            userItems[index].accountNumber;
                                        widget.model.setUserBankInfo = bankInfo;
                                        widget.model.setBankNameStatus = false;
                                        Navigator.pop(context);
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            Color(0xFF270F33).withOpacity(0.6),
                                        child: Text(
                                            userItems[index]
                                                .accountName
                                                .substring(0, 1),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      isThreeLine: true,
                                      title: Text(userItems[index].accountName,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF333333),
                                          )),
                                      subtitle: Text(userItems[index].bankName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF333333),
                                          )),
                                    ),
                                  );
                                });
                      }
                    } else {
                      mainWidget = Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Theme(
                                data: Theme.of(context)
                                    .copyWith(accentColor: Color(0xFF9B049B)),
                                child: CircularProgressIndicator()),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Loading',
                                style: TextStyle(
                                    // letterSpacing: 4,
                                    color: Color(0xFF333333),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    }

                    return mainWidget;
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void filterSearchResults(String query) {
    filteredItems.clear();
    if (query.isEmpty) {
      setState(() {});

      return;
    } else {
      userItems.forEach((item) {
        if (item.accountName.toLowerCase().contains(query.toLowerCase())) {
          filteredItems.add(item);
        }
      });
      setState(() {});
    }
  }
}
