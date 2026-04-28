import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/aura_bloc.dart';
import '../engine/passive_detection.dart';
import 'aura_gradient.dart';

class CheckInScreen extends StatefulWidget {
  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final TextEditingController _textController = TextEditingController();
  final PassiveDetectionEngine _passiveEngine = PassiveDetectionEngine();
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    // In a real app, this would be tied to individual raw key events to track backspaces accurately.
    // For demo purposes, we simulate keystroke registration here.
    _passiveEngine.registerKeystroke('char');
  }

  void _submitCheckIn() {
    double loadScore = _passiveEngine.calculateCognitiveLoad();
    _passiveEngine.reset();
    
    // Simulate sending data to backend and receiving an AI Stress Index and Nudge
    // In a real implementation, this would use http package to call the Node.js API
    double simulatedStressIndex = 0.3 + (loadScore * 0.7); // High load -> High stress
    String? recommendedNudge;
    
    if (simulatedStressIndex > 0.8) {
      recommendedNudge = "Time for a break! Consider reaching out to your respite care network.";
    } else if (simulatedStressIndex > 0.5) {
      recommendedNudge = "Take a deep breath. Try the 4-7-8 breathing exercise.";
    }
    
    context.read<AuraBloc>().add(CheckInUpdated(simulatedStressIndex, recommendedNudge));
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuraBloc, AuraState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Background fluid gradient bound to stress index
            Positioned.fill(
              child: AuraGradient(stressIndex: state.stressIndex),
            ),
            
            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Aura",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Text("Demo Mode", style: TextStyle(color: Colors.white)),
                            Switch(
                              value: state.isDemoMode,
                              onChanged: (val) {
                                context.read<AuraBloc>().add(ToggleDemoMode(val));
                              },
                              activeColor: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 40),
                    
                    if (state.isDemoMode) ...[
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sarah's Journey - Friday", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                            SizedBox(height: 8),
                            Text("Stress Index: 0.85 (Critical)", style: TextStyle(color: Colors.redAccent)),
                            Text("Nudge Triggered: Respite Care", style: TextStyle(color: Colors.orangeAccent)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],

                    Text(
                      "How are you feeling today?",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    TextField(
                      controller: _textController,
                      onChanged: _onTextChanged,
                      maxLines: 5,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.3),
                        hintText: "Type your thoughts here...",
                        hintStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    ElevatedButton(
                      onPressed: _submitCheckIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text("Submit Check-in", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    if (state.activeNudge != null) ...[
                      AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                            ]
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.self_improvement, color: Colors.teal, size: 30),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  state.activeNudge!,
                                  style: TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
