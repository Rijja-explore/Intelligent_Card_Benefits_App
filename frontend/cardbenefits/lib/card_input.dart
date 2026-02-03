import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ai_result.dart';
import 'disclaimer.dart';
import 'api_config.dart';

class CardInputPage extends StatefulWidget {
  const CardInputPage({super.key});

  @override
  State<CardInputPage> createState() => _CardInputPageState();
}

class _CardInputPageState extends State<CardInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardController = TextEditingController();
  final _locationController = TextEditingController();

  String _userType = 'Student';
  String _language = 'English';
  bool _isLoading = false;

  final List<String> _userTypes = ['Student', 'Professional'];

  @override
  void dispose() {
    _cardController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _analyzeBenefits() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.genaiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'user_context': {
            'user_type': _userType,
            'location': _locationController.text.trim(),
          },
          'language': _language,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                aiResponse: data['response'] ?? 'No response received',
                language: _language,
              ),
            ),
          );
        }
      } else if (response.statusCode == 422) {
        _showError('Invalid input data. Please check your entries.');
      } else if (response.statusCode == 500) {
        _showError('Server error. Please try again later.');
      } else {
        _showError('Server error: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      _showError('Connection failed: ${e.message}');
    } on FormatException catch (e) {
      _showError('Invalid response format from server');
    } catch (e) {
      _showError('Network error: Please check your connection');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Card Benefit Assistant'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DisclaimerPage(),
                ),
              );
            },
            tooltip: 'About & Disclaimer',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),

                  // Welcome Section
                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: colorScheme.outline.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.credit_card_outlined,
                            size: 32,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Discover Your Benefits',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Get personalized card benefit recommendations',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Input Form Card
                  Card(
                    elevation: 0,
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: colorScheme.outline.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Number Field
                          TextFormField(
                            controller: _cardController,
                            decoration: InputDecoration(
                              labelText: 'Card Number',
                              hintText: 'XXXX XXXX XXXX 1234',
                              prefixIcon: Icon(
                                Icons.credit_card,
                                color: colorScheme.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest
                                  .withOpacity(0.3),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                              _CardNumberFormatter(),
                            ],
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter card number';
                              }
                              final digits = value.replaceAll(' ', '');
                              if (digits.length < 13) {
                                return 'Card number must be at least 13 digits';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // User Type Dropdown
                          DropdownButtonFormField<String>(
                            value: _userType,
                            decoration: InputDecoration(
                              labelText: 'User Type',
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: colorScheme.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest
                                  .withOpacity(0.3),
                            ),
                            items: _userTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _userType = value);
                              }
                            },
                          ),

                          const SizedBox(height: 24),

                          // Location Field
                          TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              labelText: 'Location',
                              hintText: 'e.g., Chennai',
                              prefixIcon: Icon(
                                Icons.location_on_outlined,
                                color: colorScheme.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest
                                  .withOpacity(0.3),
                            ),
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your location';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          // Language Selector
                          Text(
                            'Preferred Language',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'English',
                                label: Text('English'),
                                icon: Icon(Icons.language),
                              ),
                              ButtonSegment(
                                value: 'Tamil',
                                label: Text('தமிழ்'),
                                icon: Icon(Icons.translate),
                              ),
                            ],
                            selected: {_language},
                            onSelectionChanged: (Set<String> selection) {
                              setState(() => _language = selection.first);
                            },
                            style: SegmentedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Analyze Button
                          FilledButton(
                            onPressed: _isLoading ? null : _analyzeBenefits,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.onPrimary,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.analytics_outlined),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Analyze Benefits',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
