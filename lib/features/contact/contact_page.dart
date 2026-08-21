import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/animated_reveal.dart';
import '../../shared/widgets/page_scroll_view.dart';
import '../../shared/widgets/tap_scale.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroSection(),
          _TwoColumnSection(),
          _ReassuranceStrip(),
        ],
      ),
    );
  }
}

// ===========================================================================
// HERO — compact, no full viewport
// ===========================================================================

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final headlineSize = (screenW * 0.075).clamp(48.0, 72.0);
    final isDesktop = screenW > Breakpoints.tablet;

    return ColoredBox(
      color: kaizenCream,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.s32,
          isDesktop ? 120 : 72,
          AppSpacing.s32,
          AppSpacing.s64,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpacing.maxReadingWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedReveal(
                  child: Text(
                    'Let\'s Talk',
                    style: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                      color: kaizenMuted,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                AnimatedReveal(
                  delay: const Duration(milliseconds: 80),
                  child: Text(
                    'Request a Proposal.',
                    style: GoogleFonts.fraunces(
                      fontSize: headlineSize,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                      color: kaizenInk,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                AnimatedReveal(
                  delay: const Duration(milliseconds: 160),
                  child: Text(
                    'Tell us about your school and what you\'re looking for. '
                    'We\'ll reply within two working days with a tailored proposal.',
                    style: AppTypography.bodyL.copyWith(color: kaizenMuted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// TWO-COLUMN SECTION — form left, contact panel right
// ===========================================================================

class _TwoColumnSection extends StatelessWidget {
  const _TwoColumnSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return ColoredBox(
      color: kaizenPaper,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s32,
          vertical: AppSpacing.s96,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(flex: 3, child: _EnquiryForm()),
                      SizedBox(width: AppSpacing.s64),
                      Expanded(flex: 2, child: _ContactPanel()),
                    ],
                  )
                : const Column(
                    children: [
                      _EnquiryForm(),
                      SizedBox(height: AppSpacing.s64),
                      _ContactPanel(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// ENQUIRY FORM
// TODO: swap mailto for a real backend (Formspree, Firebase, or custom API)
//       in production.
// ===========================================================================

class _EnquiryForm extends StatefulWidget {
  const _EnquiryForm();

  @override
  State<_EnquiryForm> createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<_EnquiryForm> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _nameCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _moreCtrl = TextEditingController();

  String _strength = 'Under 300';
  final _strengthOptions = ['Under 300', '300–800', '800–1500', '1500+'];

  final _classOptions = [
    'Pre-primary',
    'Classes 1–2',
    'Classes 3–5',
    'Classes 6–8',
    'Classes 9–10',
    'Classes 11–12',
  ];
  final _classSelected = <String>{};

  final _subjectOptions = [
    'English',
    'Hindi',
    'Mathematics',
    'Science',
    'Social Studies',
    'Other',
  ];
  final _subjectSelected = <String>{};

  bool _consent = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _schoolCtrl.dispose();
    _locationCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _moreCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final subject =
        Uri.encodeComponent('Proposal Request — ${_schoolCtrl.text.trim()}');
    final body = Uri.encodeComponent([
      'Name: ${_nameCtrl.text.trim()}',
      'Role: ${_roleCtrl.text.trim()}',
      'School: ${_schoolCtrl.text.trim()}',
      'Location: ${_locationCtrl.text.trim()}',
      'Email: ${_emailCtrl.text.trim()}',
      'Phone: ${_phoneCtrl.text.trim()}',
      'Approximate Student Strength: $_strength',
      'Classes: ${_classSelected.isEmpty ? "Not specified" : _classSelected.join(", ")}',
      'Subjects: ${_subjectSelected.isEmpty ? "Not specified" : _subjectSelected.join(", ")}',
      'Additional information:\n${_moreCtrl.text.trim()}',
      '',
      'Consent to contact: ${_consent ? "Yes" : "No"}',
    ].join('\n'));

    final uri = Uri.parse(
      'mailto:thekaizensolutions.hyd@gmail.com?subject=$subject&body=$body',
    );
    await launchUrl(uri);
    if (mounted) setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return const _SuccessCard();

    return AnimatedReveal(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s48),
        decoration: BoxDecoration(
          color: kaizenCream,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kaizenGold, width: 1),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KaizenTextField(
                controller: _nameCtrl,
                label: 'Your Name',
                required: true,
                validator: _requiredValidator,
              ),
              const SizedBox(height: AppSpacing.s24),
              KaizenTextField(
                controller: _roleCtrl,
                label: 'Role / Designation',
                hint: 'e.g. Principal, Administrator, Purchase Head',
                required: true,
                validator: _requiredValidator,
              ),
              const SizedBox(height: AppSpacing.s24),
              KaizenTextField(
                controller: _schoolCtrl,
                label: 'School Name',
                required: true,
                validator: _requiredValidator,
              ),
              const SizedBox(height: AppSpacing.s24),
              KaizenTextField(
                controller: _locationCtrl,
                label: 'School Location',
                hint: 'City, State',
                required: true,
                validator: _requiredValidator,
              ),
              const SizedBox(height: AppSpacing.s24),
              KaizenTextField(
                controller: _emailCtrl,
                label: 'Work Email',
                required: true,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final emailRe = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!emailRe.hasMatch(v.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.s24),
              KaizenTextField(
                controller: _phoneCtrl,
                label: 'Phone Number',
                required: true,
                keyboardType: TextInputType.phone,
                validator: _requiredValidator,
              ),
              const SizedBox(height: AppSpacing.s32),
              _FieldLabel('Approximate Student Strength', required: false),
              const SizedBox(height: AppSpacing.s8),
              _DropdownField(
                value: _strength,
                options: _strengthOptions,
                onChanged: (v) => setState(() => _strength = v!),
              ),
              const SizedBox(height: AppSpacing.s32),
              _FieldLabel('Which classes are you exploring notebooks for?',
                  required: false),
              const SizedBox(height: AppSpacing.s12),
              _ChipGroup(
                options: _classOptions,
                selected: _classSelected,
                onToggle: (v) => setState(() {
                  if (_classSelected.contains(v)) {
                    _classSelected.remove(v);
                  } else {
                    _classSelected.add(v);
                  }
                }),
              ),
              const SizedBox(height: AppSpacing.s32),
              _FieldLabel('Subjects of interest', required: false),
              const SizedBox(height: AppSpacing.s12),
              _ChipGroup(
                options: _subjectOptions,
                selected: _subjectSelected,
                onToggle: (v) => setState(() {
                  if (_subjectSelected.contains(v)) {
                    _subjectSelected.remove(v);
                  } else {
                    _subjectSelected.add(v);
                  }
                }),
              ),
              const SizedBox(height: AppSpacing.s32),
              KaizenTextField(
                controller: _moreCtrl,
                label: 'Tell us more',
                required: false,
                minLines: 4,
                maxLines: 8,
              ),
              const SizedBox(height: AppSpacing.s32),
              _ConsentRow(
                value: _consent,
                onChanged: (v) => setState(() => _consent = v ?? false),
              ),
              const SizedBox(height: AppSpacing.s40),
              _SubmitButton(onTap: _submit),
            ],
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;
}

// ---------------------------------------------------------------------------
// Reusable text field
// ---------------------------------------------------------------------------

class KaizenTextField extends StatefulWidget {
  const KaizenTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.required = true,
    this.validator,
    this.keyboardType,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool required;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int minLines;
  final int maxLines;

  @override
  State<KaizenTextField> createState() => _KaizenTextFieldState();
}

class _KaizenTextFieldState extends State<KaizenTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(widget.label, required: widget.required),
        const SizedBox(height: AppSpacing.s8),
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            validator: widget.required ? widget.validator : null,
            style: AppTypography.bodyM.copyWith(color: kaizenInk),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTypography.bodyM.copyWith(
                color: kaizenMuted.withValues(alpha: 0.6),
              ),
              filled: true,
              fillColor: kaizenCream,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: kaizenInk.withValues(alpha: 0.18),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: kaizenGold, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              errorStyle: AppTypography.caption.copyWith(color: Colors.red),
            ),
          ),
        ),
        if (_focused) const SizedBox.shrink(),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Field label
// ---------------------------------------------------------------------------

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {required this.required});
  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTypography.label.copyWith(color: kaizenInk),
        children: [
          TextSpan(text: text),
          if (required)
            TextSpan(
              text: ' *',
              style: AppTypography.label.copyWith(color: kaizenBlue),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dropdown
// ---------------------------------------------------------------------------

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      style: AppTypography.bodyM.copyWith(color: kaizenInk),
      decoration: InputDecoration(
        filled: true,
        fillColor: kaizenCream,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: kaizenInk.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: kaizenGold, width: 2),
        ),
      ),
      items: options
          .map(
            (o) => DropdownMenuItem(
              value: o,
              child: Text(o, style: AppTypography.bodyM.copyWith(color: kaizenInk)),
            ),
          )
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Chip group (multi-select)
// ---------------------------------------------------------------------------

class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: options.map((opt) {
        final isSelected = selected.contains(opt);
        return Semantics(
          label: '${isSelected ? "Selected" : "Unselected"}: $opt',
          button: true,
          child: GestureDetector(
            onTap: () => onToggle(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              constraints: const BoxConstraints(minHeight: 44),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? kaizenGold : kaizenCream,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isSelected ? kaizenGold : kaizenInk.withValues(alpha: 0.18),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Text(
                opt,
                style: AppTypography.bodyS.copyWith(
                  color: isSelected ? kaizenInk : kaizenMuted,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Consent checkbox
// ---------------------------------------------------------------------------

class _ConsentRow extends StatelessWidget {
  const _ConsentRow({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Consent checkbox: I\'d like Kaizen Solutions to contact me about this enquiry',
      checked: value,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: value ? kaizenGold : kaizenCream,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: value ? kaizenGold : kaizenInk.withValues(alpha: 0.25),
                      width: value ? 2 : 1,
                    ),
                  ),
                  child: value
                      ? const Icon(Icons.check, size: 14, color: kaizenInk)
                      : null,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'I\'d like Kaizen Solutions to contact me about this enquiry.',
                  style: AppTypography.bodyS.copyWith(color: kaizenInk),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Submit button
// ---------------------------------------------------------------------------

class _SubmitButton extends StatefulWidget {
  const _SubmitButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: Semantics(
      label: 'Send Enquiry',
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            constraints: const BoxConstraints(minHeight: 52, minWidth: 44),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s40,
              vertical: AppSpacing.s16,
            ),
            decoration: BoxDecoration(
              color: _hovered ? kaizenGoldDeep : kaizenGold,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: kaizenGold.withValues(alpha: _hovered ? 0.45 : 0.25),
                  blurRadius: _hovered ? 20 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              'Send Enquiry',
              style: AppTypography.label.copyWith(
                color: kaizenInk,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Success card
// ---------------------------------------------------------------------------

class _SuccessCard extends StatelessWidget {
  const _SuccessCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s48),
      decoration: BoxDecoration(
        color: kaizenCream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kaizenGold, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kaizenGold,
            ),
            child: const Icon(Icons.check, color: kaizenInk, size: 28),
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'Thanks — your email client should have opened.',
            style: AppTypography.headingM.copyWith(color: kaizenInk),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'If it didn\'t open, email us directly at thekaizensolutions.hyd@gmail.com.',
            style: AppTypography.bodyM.copyWith(color: kaizenMuted),
          ),
          const SizedBox(height: AppSpacing.s24),
          _TapLink(
            label: 'thekaizensolutions.hyd@gmail.com',
            uri: 'mailto:thekaizensolutions.hyd@gmail.com',
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// CONTACT PANEL — right column
// ===========================================================================

class _ContactPanel extends StatelessWidget {
  const _ContactPanel();

  @override
  Widget build(BuildContext context) {
    return AnimatedReveal(
      delay: const Duration(milliseconds: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prefer to reach out directly?',
            style: AppTypography.headingM.copyWith(color: kaizenInk),
          ),
          const SizedBox(height: AppSpacing.s40),
          _ContactCard(
            icon: Icons.mail_outline,
            label: 'Email',
            child: _TapLink(
              label: 'thekaizensolutions.hyd@gmail.com',
              uri: 'mailto:thekaizensolutions.hyd@gmail.com',
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          _ContactCard(
            icon: Icons.phone_outlined,
            label: 'Phone',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _TapLink(
                  label: '+91 9989828388',
                  uri: 'tel:+919989828388',
                ),
                SizedBox(height: AppSpacing.s4),
                _TapLink(
                  label: '+91 8686960105',
                  uri: 'tel:+918686960105',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          _ContactCard(
            icon: Icons.location_on_outlined,
            label: 'Address',
            child: Text(
              'KPHB Colony, Hyderabad, India – 500072',
              style: AppTypography.bodyM.copyWith(color: kaizenInk),
            ),
          ),
          const SizedBox(height: AppSpacing.s40),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s12,
            ),
            decoration: BoxDecoration(
              color: kaizenPaper,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kaizenInk.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule,
                  size: 18,
                  color: kaizenMuted,
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Text(
                    'Office Hours — Mon–Sat · 10:00 AM – 6:00 PM IST',
                    style: AppTypography.bodyS.copyWith(color: kaizenMuted),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: kaizenCream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kaizenInk.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kaizenGold,
            ),
            child: Icon(icon, size: 20, color: kaizenInk, semanticLabel: null),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: kaizenMuted,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TapLink extends StatefulWidget {
  const _TapLink({required this.label, required this.uri});
  final String label;
  final String uri;

  @override
  State<_TapLink> createState() => _TapLinkState();
}

class _TapLinkState extends State<_TapLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      link: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.uri)),
          child: Text(
            widget.label,
            style: AppTypography.bodyM.copyWith(
              color: _hovered ? kaizenBlueDeep : kaizenBlue,
              decoration: TextDecoration.underline,
              decorationColor: _hovered ? kaizenBlueDeep : kaizenBlue,
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// REASSURANCE STRIP — bottom three columns
// ===========================================================================

class _ReassuranceStrip extends StatelessWidget {
  const _ReassuranceStrip();

  static const _items = [
    (Icons.schedule_outlined, 'We reply within 2 working days.'),
    (Icons.description_outlined, 'Every proposal is tailored — no templates.'),
    (Icons.lock_outline, 'Your data is used only to respond to your enquiry.'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return ColoredBox(
      color: kaizenCream,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s32,
          vertical: AppSpacing.s64,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: AnimatedReveal(
              child: isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < _items.length; i++) ...[
                          Expanded(child: _ReassuranceItem(_items[i].$1, _items[i].$2)),
                          if (i < _items.length - 1)
                            Container(
                              width: 1,
                              height: 40,
                              color: kaizenInk.withValues(alpha: 0.1),
                              margin: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.s32,
                              ),
                            ),
                        ],
                      ],
                    )
                  : Column(
                      children: [
                        for (int i = 0; i < _items.length; i++) ...[
                          _ReassuranceItem(_items[i].$1, _items[i].$2),
                          if (i < _items.length - 1)
                            const SizedBox(height: AppSpacing.s32),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReassuranceItem extends StatelessWidget {
  const _ReassuranceItem(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: kaizenGold,
          ),
          child: Icon(icon, size: 22, color: kaizenInk, semanticLabel: null),
        ),
        const SizedBox(height: AppSpacing.s16),
        Text(
          text,
          style: AppTypography.bodyS.copyWith(color: kaizenMuted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
