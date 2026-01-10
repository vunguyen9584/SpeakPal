import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import '../providers/recording_provider.dart';

class VoiceRecorder extends ConsumerStatefulWidget {
  const VoiceRecorder({super.key});

  @override
  ConsumerState<VoiceRecorder> createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends ConsumerState<VoiceRecorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  RecorderController? _recorderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _recorderController = RecorderController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _recorderController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recordingState = ref.watch(recordingProvider);

    return Column(
      children: [
        // Recording button
        GestureDetector(
          onTap: _handleRecordingTap,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final isRecording = recordingState == RecordingState.recording;
              final scale = isRecording
                  ? 1.0 + (_animationController.value * 0.1)
                  : 1.0;

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getButtonColor(recordingState),
                    boxShadow: [
                      BoxShadow(
                        color: _getButtonColor(recordingState).withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    _getButtonIcon(recordingState),
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Waveform display (when recording)
        if (recordingState == RecordingState.recording && _recorderController != null)
          SizedBox(
            height: 60,
            child: AudioWaveforms(
              size: Size(MediaQuery.of(context).size.width - 32, 60),
              recorderController: _recorderController!,
              waveStyle: WaveStyle(
                waveColor: Theme.of(context).primaryColor,
                showDurationLabel: false,
                spacing: 8.0,
                showBottom: false,
                extendWaveform: true,
                showMiddleLine: false,
              ),
            ),
          ),
        
        // Status text
        const SizedBox(height: 8),
        Text(
          _getStatusText(recordingState),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  void _handleRecordingTap() async {
    final notifier = ref.read(recordingProvider.notifier);
    final state = ref.read(recordingProvider);

    if (state == RecordingState.idle) {
      await notifier.startRecording();
      await _recorderController?.record();
    } else if (state == RecordingState.recording) {
      await _recorderController?.stop();
      await notifier.stopRecording();
      // TODO: Submit answer
    }
  }

  Color _getButtonColor(RecordingState state) {
    switch (state) {
      case RecordingState.idle:
        return Colors.blue;
      case RecordingState.recording:
        return Colors.red;
      case RecordingState.processing:
        return Colors.orange;
      case RecordingState.permissionDenied:
        return Colors.grey;
    }
  }

  IconData _getButtonIcon(RecordingState state) {
    switch (state) {
      case RecordingState.idle:
        return Icons.mic;
      case RecordingState.recording:
        return Icons.stop;
      case RecordingState.processing:
        return Icons.hourglass_empty;
      case RecordingState.permissionDenied:
        return Icons.mic_off;
    }
  }

  String _getStatusText(RecordingState state) {
    switch (state) {
      case RecordingState.idle:
        return 'タップして録音開始';
      case RecordingState.recording:
        return '録音中... もう一度タップで停止';
      case RecordingState.processing:
        return '処理中...';
      case RecordingState.permissionDenied:
        return 'マイクの許可が必要です';
    }
  }
}
