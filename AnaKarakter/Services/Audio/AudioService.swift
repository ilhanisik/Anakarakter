import AVFoundation

/// Hafif sentez sesler — varlık dosyası yok, tonlar çalışma anında üretilir
/// (docs/03 Faz 3: "hafif ses (sentez)").
///
/// - `.ambient` kategori: sessiz anahtarına ve diğer uygulamaların müziğine
///   saygı duyar (premium his ilkesi — asla bağırmayız).
/// - Tüm hatalar sessizce yutulur; ses, oyunun hiçbir işlevinin önkoşulu değildir.
@MainActor
final class AudioService {
    enum SoundEffect {
        /// Yıl geçişinde kısa, yumuşak tık.
        case yearTick
        /// Jenerik başlarken sıcak kapanış akoru.
        case creditsChord
    }

    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private var buffers: [SoundEffect: AVAudioPCMBuffer] = [:]
    private var isConfigured = false

    func play(_ effect: SoundEffect) {
        configureIfNeeded()
        guard let buffer = buffers[effect] else { return }
        if !engine.isRunning {
            try? engine.start()
        }
        guard engine.isRunning else { return }
        player.scheduleBuffer(buffer, at: nil)
        if !player.isPlaying {
            player.play()
        }
    }

    private func configureIfNeeded() {
        guard !isConfigured else { return }
        isConfigured = true

        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)

        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        engine.prepare()

        // La5 tabanlı kısa tık; jenerikte La minör yerine sıcak A majör akoru.
        buffers[.yearTick] = makeBuffer(frequencies: [880], duration: 0.07, gain: 0.10)
        buffers[.creditsChord] = makeBuffer(frequencies: [220, 277.18, 329.63], duration: 1.4, gain: 0.09)
    }

    /// Üstel sönümlü sinüs karışımı üretir.
    private func makeBuffer(frequencies: [Double], duration: Double, gain: Float) -> AVAudioPCMBuffer? {
        let sampleRate = 44_100.0
        let frameCount = AVAudioFrameCount(duration * sampleRate)
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
              let channel = buffer.floatChannelData?[0]
        else { return nil }

        buffer.frameLength = frameCount
        for frame in 0..<Int(frameCount) {
            let time = Double(frame) / sampleRate
            let envelope = exp(-5.0 * time / duration)
            let mixed = frequencies.reduce(0.0) { $0 + sin(2.0 * .pi * $1 * time) }
            channel[frame] = Float(mixed / Double(frequencies.count) * envelope) * gain
        }
        return buffer
    }
}
