import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tadzhuit/screens/student_detail_screen.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  List<Map<String, String>> _allUsers = [];
  List<Map<String, String>> _filteredUsers = [];
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _allUsers = [
        {'name': 'Асылым Сатиева', 'city': 'Астана', 'status': 'Учится'},
        {'name': 'Жадыра Айбеккызы', 'city': 'Алматы', 'status': 'Закончили'},
        {'name': 'Шалқарбек Абдурахман', 'city': 'Шымкент', 'status': 'Учится'},
        {'name': 'Айгерім Нурлан', 'city': 'Караганда', 'status': 'Закончили'},
      ];
      _filteredUsers = List.from(_allUsers);
      _isLoading = false;
    });
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = List.from(_allUsers);
      } else {
        _filteredUsers = _allUsers
            .where((user) =>
                user['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filterUsers('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3CC18E), Color(0xFF1C5B43)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.06),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _isSearching
                            ? MediaQuery.of(context).size.width * 0.75
                            : 0,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: _isSearching
                            ? TextField(
                          controller: _searchController,
                          onChanged: _filterUsers,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Поиск студента...',
                            hintStyle:
                            GoogleFonts.roboto(fontSize: 16),
                            border: InputBorder.none,
                            contentPadding:
                            const EdgeInsets.all(10),
                          ),
                        )
                            : null,
                      ),
                      IconButton(
                        icon: Icon(
                            _isSearching ? Icons.close : Icons.search,
                            color: Colors.white),
                        onPressed: _toggleSearch,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      _buildTab(Icons.school, 'Учится'),
                      _buildTab(Icons.done, 'Закончили'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF1C5B43),))
                : _filteredUsers.isEmpty
                    ? const Center(child: Text('Пользователи не найдены.'))
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          UserList(
                              users: _filteredUsers
                                  .where((user) => user['status'] == 'Учится')
                                  .toList()),
                          UserList(
                              users: _filteredUsers
                                  .where(
                                      (user) => user['status'] == 'Закончили')
                                  .toList()),
                        ],
                      ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: (){},
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Color(0xFF3CC18E), Color(0xFF1C5B43)],

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String text) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.roboto(fontSize: 16)),
        ],
      ),
    );
  }
}

class UserList extends StatelessWidget {
  final List<Map<String, String>> users;

  const UserList({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return users.isEmpty
        ? const Center(child: Text('Нет данных'))
        : ListView.builder(
            itemCount: users.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final user = users[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentDetailPage(student: user),
                    ),
                  );
                },
                child: Card(
                  elevation: 10,
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        user['name']![0].toUpperCase(),
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF50E3C2),
                        ),
                      ),
                    ),
                    title: Text(user['name'] ?? 'Без имени',
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('Номер: ${user['number']}',
                        style: GoogleFonts.roboto(fontSize: 16)),
                  ),
                ),
              );
            },
          );
  }
}
