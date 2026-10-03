import 'package:clean_arch/features/user/domain/entities/user_entity.dart';
import 'package:clean_arch/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, this.cubit});
  final UserCubit? cubit;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late final UserCubit _cubit = widget.cubit ?? UserCubit();
  final _controller = TextEditingController(text: '1');
  final _form = GlobalKey<FormState>();
  int _lastId = 1;

  void _search() {
    if (_cubit.state is UserLoading || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    _lastId = int.parse(_controller.text.trim());
    _cubit.eitherFailureOrUser(_lastId);
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.cubit == null) _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: StreamBuilder<UserState>(
            stream: _cubit.stream,
            initialData: _cubit.state,
            builder: (context, snapshot) {
              final state = snapshot.data!;
              final loading = state is UserLoading;
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people_alt_outlined,
                        size: 36,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'People',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    'A little closer to everyone.',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find a profile and explore their contact details.',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  const SizedBox(height: 28),
                  Form(
                    key: _form,
                    child: TextFormField(
                      controller: _controller,
                      enabled: !loading,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.search,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onFieldSubmitted: (_) => _search(),
                      validator: (value) {
                        final id = int.tryParse(value?.trim() ?? '');
                        return id == null || id < 1 || id > 10
                            ? 'Enter a user ID from 1 to 10'
                            : null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'User ID',
                        helperText: 'Explore profiles 1–10',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: loading ? null : _search,
                    icon: const Icon(Icons.person_search_outlined),
                    label: Text(loading ? 'Finding profile…' : 'Find profile'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (state is UserLoaded)
                    _Profile(
                      user: state.userEntity,
                      onRefresh: () => _cubit.eitherFailureOrUser(_lastId),
                    )
                  else
                    _Panel(
                      child: Column(
                        children: [
                          if (loading)
                            const CircularProgressIndicator()
                          else
                            Icon(
                              state is UserError
                                  ? Icons.wifi_off_rounded
                                  : Icons.person_outline_rounded,
                              size: 52,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          const SizedBox(height: 20),
                          Text(
                            loading
                                ? 'Finding your person'
                                : state is UserError
                                ? 'Couldn’t load this profile'
                                : 'Meet someone new',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            loading
                                ? 'Loading profile details…'
                                : state is UserError
                                ? state.failure.errMessage
                                : 'Choose a user ID above to see their profile, contact information and address.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                          if (state is UserError) ...[
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () =>
                                  _cubit.eitherFailureOrUser(_lastId),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try again'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sample profiles provided by JSONPlaceholder',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}

class _Profile extends StatelessWidget {
  const _Profile({required this.user, required this.onRefresh});
  final UserEntity user;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final initials = user.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0])
        .join()
        .toUpperCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5365DF), Color(0xFF7C64D8)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white24,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.address.city,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contact details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              _Detail(
                icon: Icons.alternate_email,
                label: 'Email',
                value: user.email,
                copyable: true,
              ),
              _Detail(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: user.phone,
                copyable: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              _Detail(
                icon: Icons.location_on_outlined,
                label: 'Street & suite',
                value: '${user.address.street}, ${user.address.suite}',
              ),
              _Detail(
                icon: Icons.location_city_outlined,
                label: 'City',
                value: user.address.city,
              ),
              _Detail(
                icon: Icons.markunread_mailbox_outlined,
                label: 'ZIP code',
                value: user.address.zipcode,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh profile'),
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
    ),
    child: child,
  );
}

class _Detail extends StatelessWidget {
  const _Detail({
    required this.icon,
    required this.label,
    required this.value,
    this.copyable = false,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool copyable;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 4),
              SelectableText(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (copyable)
          IconButton(
            tooltip: 'Copy $label',
            icon: const Icon(Icons.copy_outlined, size: 20),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: value));
              if (context.mounted)
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('$label copied')));
            },
          ),
      ],
    ),
  );
}
