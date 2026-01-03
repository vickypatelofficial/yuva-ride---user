import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/customAppBar.dart';
import 'package:yuva_ride/view/custom_widgets/customTextField.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/status.dart';

class ChooseSavedContactScreen extends StatefulWidget {
  const ChooseSavedContactScreen({super.key});

  @override
  State<ChooseSavedContactScreen> createState() =>
      _ChooseSavedContactScreenState();
}

class _ChooseSavedContactScreenState extends State<ChooseSavedContactScreen> {
  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final uid = await LocalStorage.getUserId() ?? '';
    if (!mounted) return;
    context.read<BookRideProvider>().fetchContacts(uid);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomScaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Choose Contact",
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _openAddContactSheet(context),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // ---------------- CONTACT LIST ----------------
          Expanded(
            child: Consumer<BookRideProvider>(
              builder: (context, provider, _) {
                if (provider.contactState.status == ApiStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final list = provider.contactState.data ?? [];

                if (list.isEmpty) {
                  return const Center(
                    child: Text("No saved contacts"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    final contact = list[index];
                    return _contactTile(
                      context,
                      name: contact.name,
                      phone: "${contact.countryCode} ${contact.phone}",
                      isSelected: provider.selectedContact?.id == contact.id,
                      onTap: () {
                        provider.selectContact(
                            isSelf: false,
                            phone: contact.phone,
                            id: contact.id,
                            name: contact.name,
                            cId: contact.cId,
                            countryCode: contact.countryCode);
                        print(provider.selectedContact?.id);
                        print(contact.id);
                        print(provider.selectedContact?.id == contact.id);
                      },
                      onDelete: () async {
                        final uid = await LocalStorage.getUserId() ?? '';
                        provider.deleteContact(
                          uid: uid,
                          contactId: contact.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          // ---------------- CONFIRM BUTTON ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Confirm",
                    style: textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontFamily: AppFonts.medium,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // CONTACT TILE
  // ------------------------------------------------------------------
  Widget _contactTile(
    BuildContext context, {
    required String name,
    required String phone,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    final text = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style:
                        text.titleMedium!.copyWith(fontFamily: AppFonts.medium),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone,
                    style: text.bodySmall!.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // DELETE
            CustomInkWell(
              onTap: onDelete,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: AppColors.red),
                  shape: BoxShape.circle),
              child: const Padding(
                  padding: EdgeInsetsGeometry.all(5),
                  child: Icon(Icons.delete, color: AppColors.red)),
            ),

            // SELECT INDICATOR
            // Container(
            //   height: 26,
            //   width: 26,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     border: Border.all(
            //       color: isSelected
            //           ? AppColors.primaryColor
            //           : Colors.grey.shade400,
            //       width: 2,
            //     ),
            //     color: isSelected ? AppColors.primaryColor : Colors.white,
            //   ),
            //   child: isSelected
            //       ? const Icon(Icons.check, size: 16, color: Colors.white)
            //       : null,
            // ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // ADD CONTACT BOTTOM SHEET
  // ------------------------------------------------------------------
  void _openAddContactSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Contact",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              CustomTextField(controller: nameCtrl, hint: 'Name'),
              const SizedBox(height: 10),
              CustomTextField(
                controller: phoneCtrl,
                maxLength: 10,
                hint: 'Phone number',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Consumer<BookRideProvider>(
                builder: (_, provider, __) {
                  return InkWell(
                    onTap: () async {
                      final uid = await LocalStorage.getUserId() ?? '';
                      provider.addContact(
                        uid: uid,
                        name: nameCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        countryCode: "+91",
                      );
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
