import 'package:flutter/material.dart';

class PassbookPage extends StatefulWidget {
  @override
  _PassbookPageState createState() => _PassbookPageState();
}

class _PassbookPageState extends State<PassbookPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Passbook "),
      ),
      body: Column(
        children: [
          // Top Earnings Card
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Earnings Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Aligns children to both ends
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Earnings',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12)),
                                SizedBox(height: 5),
                                Text('₹0',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Icon(Icons.wallet, color: Colors.black, size: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSummaryCard('My Bookings', '5', Icons.bookmark),
                      SizedBox(width: 16),
                      _buildSummaryCard(
                          'Total Released', '₹0', Icons.monetization_on),
                      SizedBox(width: 16),
                      _buildSummaryCard('Connect & Collect', '₹0',
                          Icons.connect_without_contact),
                      SizedBox(width: 16),
                      _buildSummaryCard('My Expenses', '₹0', Icons.money_off),
                    ],
                  ),
                ),
              ],
            ),
          ),

          TabBar(
            controller: _tabController,
            indicatorColor: Colors.orange,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Property Bookings'),
              Tab(text: 'Home Loan'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionsList(),
                Center(
                    child: Text('Home Loan',
                        style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.orange, size: 30),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Transaction List Widget
  Widget _buildTransactionsList() {
    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        _buildTransactionCard(
            'VJ Enchante Pune', '₹1,09,820', '2023-09-05', 'Approved'),
        _buildTransactionCard(
            'Sobha Nesara Pune', '₹1,43,109', '2023-05-17', 'Approved'),
        _buildTransactionCard(
            'VTP Euphoria Pune', '₹3,16,667', '2023-07-29', 'Approved'),
      ],
    );
  }

  // Transaction Card Widget
  Widget _buildTransactionCard(
      String projectName, String amount, String date, String status) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              projectName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Realised On:',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              status,
              style: TextStyle(color: Colors.green, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
