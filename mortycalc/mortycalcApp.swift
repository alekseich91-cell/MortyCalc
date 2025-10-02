import SwiftUI

@main

struct CalculatorLunaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var speakerSlots: [SpeakerSlot] = [SpeakerSlot()]
    @State private var showResults: Bool = false
    @State private var distanceA: String = ""
    @State private var distanceB: String = ""
    @State private var geoDelay: String = ""
    @State private var geoAdvice: String = ""
    @State private var applyGeoToPresets: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Lacoustics vs Луня")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.purple, .black]), startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(15)
                    .shadow(color: .yellow, radius: 10, x: 0, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.green, lineWidth: 2)
                    )

                Text("Миксуй колонки, как Рик миксует портальный сок, мать его!")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)

                ScrollView {
                    VStack(spacing: 15) {
                        ForEach($speakerSlots) { $slot in
                            SpeakerSlotView(slot: $slot, allSlots: $speakerSlots, slotCount: speakerSlots.count, onDelete: {
                                if let index = speakerSlots.firstIndex(where: { $0.id == slot.id }) {
                                    if speakerSlots.count > 1 {
                                        speakerSlots.remove(at: index)
                                    }
                                }
                            })
                            .transition(.opacity)
                        }
                    }
                    .padding(.horizontal)
                }

                HStack(spacing: 15) {
                    if speakerSlots.count < 3 {
                        Button(action: {
                            speakerSlots.append(SpeakerSlot())
                        }) {
                            Text("Добавь колонку, Морти!")
                                .font(.system(size: 18, weight: .bold))
                                .padding()
                                .background(Color.purple.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: .green, radius: 5)
                        }
                    }

                    Button(action: {
                        speakerSlots = [SpeakerSlot()]
                        showResults = false
                    }) {
                        Text("Сбросить всё!")
                            .font(.system(size: 18, weight: .bold))
                            .padding()
                            .background(Color.orange.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .red, radius: 5)
                    }
                }

                // Геометрическая задержка
                VStack(spacing: 10) {
                    Text("Геометрическая задержка (L-Acoustics)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.cyan)

                    HStack(spacing: 15) {
                        VStack {
                            Text("Расстояние до топов (A), м")
                                .foregroundColor(.white)
                            TextField("0", text: $distanceA)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                        }

                        VStack {
                            Text("Расстояние до субов (B), м")
                                .foregroundColor(.white)
                            TextField("0", text: $distanceB)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                        }

                        Button(action: {
                            calculateGeoDelay()
                        }) {
                            Text("Рассчитать")
                                .font(.system(size: 18, weight: .bold))
                                .padding()
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: .cyan, radius: 5)
                        }
                    }

                    Toggle("Применить геометрический делей к пресетам", isOn: $applyGeoToPresets)
                        .foregroundColor(.white)
                        .tint(.green)

                    if !geoDelay.isEmpty {
                        Text("Задержка: \(geoDelay) мс")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        Text(geoAdvice)
                            .font(.system(size: 16))
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                .shadow(color: .purple, radius: 5)

                Button(action: {
                    showResults = true
                }) {
                    Text("Считай задержки, межпространственный гений!")
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.red, .purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .green, radius: 8)
                }
                .disabled(speakerSlots.count < 2 || !isValidCombination(slots: speakerSlots))

                if showResults {
                    ResultsView(slots: speakerSlots, geoDelayValue: Double(geoDelay) ?? 0.0, applyGeoToPresets: applyGeoToPresets, geoAdvice: geoAdvice)
                        .padding()
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(color: .yellow, radius: 10)
                        .transition(.scale)
                }

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [.black, .purple, .indigo]), startPoint: .top, endPoint: .bottom)
            )
        }
    }

    private func calculateGeoDelay() {
        let filteredA = distanceA.filter { "0123456789.".contains($0) }
        let filteredB = distanceB.filter { "0123456789.".contains($0) }
        
        if let a = Double(filteredA), let b = Double(filteredB) {
            let delay = (b - a) * 2.9
            geoDelay = String(format: "%.2f", abs(delay))
            if delay > 0 {
                geoAdvice = "Задержать топы на \(geoDelay) мс"
            } else if delay < 0 {
                geoAdvice = "Задержать субы на \(geoDelay) мс"
            } else {
                geoAdvice = "Нет задержки"
            }
        } else {
            geoDelay = "0.00"
            geoAdvice = "Введите корректные значения (числа)"
        }
    }

    private func isValidCombination(slots: [SpeakerSlot]) -> Bool {
        let allPresets = slots.map { $0.preset }.filter { !$0.isEmpty }
        if allPresets.count != slots.count { return false }
        let key = allPresets.sorted().joined(separator: " + ")
        return delayData[key] != nil
    }
}

struct SpeakerSlot: Identifiable {
    let id = UUID()
    var speaker: String = ""
    var preset: String = ""
}

struct SpeakerSlotView: View {
    @Binding var slot: SpeakerSlot
    @Binding var allSlots: [SpeakerSlot]
    let slotCount: Int
    let onDelete: () -> Void

    @State private var localSpeaker: String
    @State private var localPreset: String

    init(slot: Binding<SpeakerSlot>, allSlots: Binding<[SpeakerSlot]>, slotCount: Int, onDelete: @escaping () -> Void) {
        self._slot = slot
        self._allSlots = allSlots
        self.slotCount = slotCount
        self.onDelete = onDelete
        self._localSpeaker = State(initialValue: slot.wrappedValue.speaker)
        self._localPreset = State(initialValue: slot.wrappedValue.preset)
    }

    var filteredSpeakers: [String] {
        guard let myIndex = allSlots.firstIndex(where: { $0.id == slot.id }) else { return [] }
        let baseList = myIndex == 0 ? tops : subs
        let otherPresets = allSlots.filter { $0.id != slot.id }.map { $0.preset }.filter { !$0.isEmpty }.sorted()
        if otherPresets.isEmpty {
            return baseList.filter { !(speakerPresets[$0]?.isEmpty ?? true) }.sorted()
        }
        var possible = Set<String>()
        for key in delayData.keys {
            let presetsInKey = key.split(separator: " + ").map(String.init).sorted()
            if presetsInKey.contains(subsequence: otherPresets) {
                let remaining = presetsInKey.filter { !otherPresets.contains($0) }
                for preset in remaining {
                    if let sp = baseList.first(where: { speakerPresets[$0]?.contains(preset) ?? false }) {
                        possible.insert(sp)
                    }
                }
            }
        }
        return Array(possible).sorted()
    }

    var filteredPresets: [String] {
        if localSpeaker.isEmpty { return [] }
        let otherPresets = allSlots.filter { $0.id != slot.id }.map { $0.preset }.filter { !$0.isEmpty }.sorted()
        var possible = speakerPresets[localSpeaker] ?? []
        if !otherPresets.isEmpty {
            possible = []
            for key in delayData.keys {
                let presetsInKey = key.split(separator: " + ").map(String.init).sorted()
                if presetsInKey.contains(subsequence: otherPresets) {
                    let remaining = presetsInKey.filter { !otherPresets.contains($0) }
                    possible.append(contentsOf: remaining.filter { speakerPresets[localSpeaker]?.contains($0) ?? false })
                }
            }
            possible = Array(Set(possible)).sorted()
        }
        return possible
    }

    var body: some View {
        HStack {
            Picker("Колонка", selection: $localSpeaker) {
                Text("Выбери колонку").tag("")
                ForEach(filteredSpeakers, id: \.self) { speaker in
                    Text(speaker).tag(speaker)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 200)

            Picker("Пресет", selection: $localPreset) {
                Text("Выбери пресет").tag("")
                ForEach(filteredPresets, id: \.self) { preset in
                    Text(preset).tag(preset)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 250)
            .disabled(filteredPresets.isEmpty)

            Button(action: onDelete) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
                    .scaleEffect(1.2)
            }
            .disabled(slotCount == 1)
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.5))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.green, lineWidth: 1)
        )
        .onChange(of: localSpeaker) { newValue in
            slot.speaker = newValue
            if !filteredPresets.contains(localPreset) {
                localPreset = ""
            }
        }
        .onChange(of: localPreset) { newValue in
            slot.preset = newValue
        }
        .onChange(of: slot.speaker) { newValue in
            localSpeaker = newValue
        }
        .onChange(of: slot.preset) { newValue in
            localPreset = newValue
        }
        .onChange(of: filteredSpeakers) { newValue in
            if !newValue.contains(localSpeaker) {
                localSpeaker = ""
            }
        }
        .onChange(of: filteredPresets) { newValue in
            if !newValue.contains(localPreset) {
                localPreset = ""
            }
        }
        .onAppear {
            if !filteredSpeakers.contains(localSpeaker) {
                localSpeaker = ""
            }
            if !filteredPresets.contains(localPreset) {
                localPreset = ""
            }
        }
    }
}

// Расширение для subsequence
extension Array where Element: Equatable {
    func contains(subsequence: [Element]) -> Bool {
        guard !subsequence.isEmpty else { return true }
        var index = startIndex
        for element in subsequence {
            if let newIndex = self[index..<endIndex].firstIndex(of: element) {
                index = newIndex + 1
            } else {
                return false
            }
        }
        return true
    }
}

struct ResultsView: View {
    let slots: [SpeakerSlot]
    let geoDelayValue: Double
    let applyGeoToPresets: Bool
    let geoAdvice: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Результаты, держись, Морти!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.green)
                .padding(.bottom, 5)

            ForEach(slots) { slot in
                let (delay, polarity, warning) = calculateDelayAndPolarity(slot: slot, allSlots: slots)
                let index = slots.firstIndex(where: { $0.id == slot.id }) ?? 0
                let adjustedDelay = adjustDelay(for: index, baseDelay: delay)
                VStack(alignment: .leading) {
                    Text("Колонка: \(slot.speaker) (\(slot.preset))")
                        .font(.system(size: 18))
                    if !warning.isEmpty {
                        Text(warning)
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                    } else {
                        Text("Задержка: \(String(format: "%.2f", adjustedDelay)) мс")
                        Text("Полярность: \(polarity)")
                    }
                }
                .padding(.vertical, 8)
                .background(Color.purple.opacity(0.3))
                .cornerRadius(8)
            }
        }
    }

    private func adjustDelay(for index: Int, baseDelay: Double) -> Double {
        if !applyGeoToPresets || geoDelayValue == 0 {
            return baseDelay
        }
        var allDelays = slots.map { calculateDelayAndPolarity(slot: $0, allSlots: slots).delay }
        let delayTops = geoAdvice.contains("топы")
        for j in 0..<allDelays.count {
            let currentIsTop = tops.contains(slots[j].speaker)
            if (delayTops && currentIsTop) || (!delayTops && !currentIsTop) {
                allDelays[j] += geoDelayValue
            }
        }
        if let minD = allDelays.min(), minD > 0 {
            for j in 0..<allDelays.count {
                allDelays[j] -= minD
            }
        }
        return allDelays[index]
    }
}

let tops = [
    "Kara", "Kara II", "K1", "K2", "K3", "Kudo", "Kiva", "Kiva II", "V-DOSC", "dV", "ARCS", "ARCS II", "ARCS_WIFO",
    "A15", "A10", "Syva", "Soka", "X15", "X12", "X8", "X8i", "X6i", "5XT", "X4", "HiQ", "12XTA", "12XTP",
    "8XT", "115XT", "115bA", "115bP", "112XT", "112b", "108a"
]

let subs = [
    "SB18", "SB28", "KS28", "KS21", "SB118", "SB218", "SB15m", "SB6i", "SB10i", "Syva Sub", "dV-SUB", "dV-DOSC"
]

let allSpeakers = tops + subs

let speakerPresets: [String: [String]] = [
    "Kara": ["KARA", "KARA_FI", "KARA_MO"],
    "Kara II": ["KARA II", "KARA II_FI", "KARA II_MO"],
    "K1": ["K1", "K1SB_X", "K1SB_60"],
    "K2": ["K2", "K1SB_X K2", "K1SB_60"],
    "K3": ["K3"],
    "Kudo": ["KUDOxx_60"],
    "Kiva": ["KIVA", "KIVA_KILO", "KIVA_SB15"],
    "Kiva II": ["KIVA II", "KIVA II_FI"],
    "V-DOSC": ["V-DOSC_xx_X", "V-DOSC_xx_60", "dV-S_60_X", "dV_xx_100"],
    "dV": ["dV_xx_100", "dV-S_60_100"],
    "ARCS": ["ARCS_xx_60", "ARCS_xx_100", "ARCS_WIFO", "ARCS_WIFO_FI"],
    "ARCS II": ["ARCS II"],
    "A15": ["A15", "A15_FI", "A15_MO"],
    "A10": ["A10", "A10_FI", "A10_MO"],
    "Syva": ["SYVA", "SYVA LOW_100", "SYVA SUB_100"],
    "Soka": ["SOKA", "SOKA_200", "SOKA_60"],
    "X15": ["X15", "X15_MO"],
    "X12": ["X12", "X12_MO"],
    "X8": ["X8", "X8_MO"],
    "X8i": ["X8i", "X8i_40"],
    "X6i": ["X6i", "X6i_50"],
    "5XT": ["5XT", "5XT_MO"],
    "X4": ["X4", "X4_MO", "X4_60"],
    "HiQ": ["HIQ_FI_100", "HIQ_FR_100", "HIQ_MO_100"],
    "12XTA": ["12XTA_FI_100", "12XTA_FR_100", "12XTA_MO_100"],
    "12XTP": ["12XTP_FI_100", "12XTP_FR_100", "12XTP_MO_100"],
    "8XT": ["8XT_FI_100", "8XT_FR_100", "8XT_MO_100"],
    "115XT": ["115XT_FI_100", "115XT_FR_100", "115XT_MO_100"],
    "115bA": ["115bA_FI_100", "115bA_FR_100", "115bA_MO_100"],
    "115bP": ["115bP_FI_100", "115bP_FR_100", "115bP_MO_100"],
    "112XT": ["112XT_FI_100", "112XT_FR_100", "112XT_MO_100"],
    "112b": ["112b_FI_100", "112b_FR_100", "112b_MO_100"],
    "108a": ["108a_FI_100", "108a_FR_100", "108a_MO_100"],
    "SB18": ["SB18_100", "SB18_60", "SB18_PL", "SB18_100_C", "SB18_60_C", "SB18_100_Cx", "SB18_60_Cx"],
    "SB28": ["SB28_100", "SB28_60", "SB28_PL", "SB28_100_C", "SB28_60_C", "SB28_100_Cx", "SB28_60_Cx"],
    "KS28": ["KS28_100", "KS28_60", "KS28_PL", "KS28_100_C", "KS28_60_C", "KS28_100_Cx", "KS28_60_Cx"],
    "KS21": ["KS21_100", "KS21_60", "KS21_PL", "KS21_100_C", "KS21_60_C", "KS21_100_Cx", "KS21_60_Cx"],
    "SB118": ["SB118_100", "SB118_60", "SB118_PL", "SB118_100_C", "SB118_60_C"],
    "SB218": ["SB218_100", "SB218_60", "SB218_PL"],
    "SB15m": ["SB15_100", "SB15_60", "SB15_100_C", "SB15_60_C", "SB15_100_Cx", "SB15_60_Cx"],
    "SB6i": ["SB6_100", "SB6_60", "SB6_200"],
    "SB10i": ["SB10_100", "SB10_60", "SB10_200"],
    "Syva Sub": ["SYVA_SUB_100", "SYVA_SUB_60", "SYVA_SUB_200"],
    "dV-SUB": ["dV-SUB_100", "dV-SUB_60"],
    "dV-DOSC": ["dV_xx_100", "dV-S_60_100"]
]

let delayData: [String: [(preset: String, delay: Double, polarity: String)]] = [
    "K1 + SB28_60": [
        ("K1", 0.5, "+"),
        ("SB28_60", 0.0, "-")
    ],
    "K1 + SB28_60_C": [
        ("K1", 6.0, "+"),
        ("SB28_60_C", 0.0, "-")
    ],
    "K1 + SB28_60_Cx": [
        ("K1", 4.0, "+"),
        ("SB28_60_Cx", 0.0, "-")
    ],
    "K1 + KS28_60": [
        ("K1", 0.5, "+"),
        ("KS28_60", 0.0, "-")
    ],
    "K1 + KS28_60_C": [
        ("K1", 6.0, "+"),
        ("KS28_60_C", 0.0, "-")
    ],
    "K1 + KS28_60_Cx": [
        ("K1", 4.0, "+"),
        ("KS28_60_Cx", 0.0, "-")
    ],
    "K1 + K1SB_X + SB28_60": [
        ("K1", 0.0, "+"),
        ("K1SB_X", 0.0, "+"),
        ("SB28_60", 0.0, "-")
    ],
    "K1 + K1SB_X + SB28_60_C": [
        ("K1", 5.5, "+"),
        ("K1SB_X", 5.5, "+"),
        ("SB28_60_C", 0.0, "-")
    ],
    "K1 + K1SB_X + SB28_60_Cx": [
        ("K1", 3.5, "+"),
        ("K1SB_X", 3.5, "+"),
        ("SB28_60_Cx", 0.0, "-")
    ],
    "K1 + K1SB_60 + SB28_60": [
        ("K1", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("SB28_60", 6.0, "-")
    ],
    "K1 + K1SB_60 + SB28_60_C": [
        ("K1", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("SB28_60_C", 0.5, "-")
    ],
    "K1 + K1SB_60 + SB28_60_Cx": [
        ("K1", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("SB28_60_Cx", 4.0, "-")
    ],
    "K1 + K1SB_X + KS28_60": [
        ("K1", 0.0, "+"),
        ("K1SB_X", 0.0, "+"),
        ("KS28_60", 0.0, "-")
    ],
    "K1 + K1SB_X + KS28_60_C": [
        ("K1", 5.5, "+"),
        ("K1SB_X", 5.5, "+"),
        ("KS28_60_C", 0.0, "-")
    ],
    "K1 + K1SB_X + KS28_60_Cx": [
        ("K1", 3.5, "+"),
        ("K1SB_X", 3.5, "+"),
        ("KS28_60_Cx", 0.0, "-")
    ],
    "K1 + K1SB_60 + KS28_60": [
        ("K1", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("KS28_60", 6.0, "-")
    ],
    "K1 + K1SB_60 + KS28_60_C": [
        ("K1", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("KS28_60_C", 0.5, "-")
    ],
    "K1 + K1SB_60 + KS28_60_Cx": [
        ("K1", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("KS28_60_Cx", 4.0, "-")
    ],
    "K2 + K1SB_X K2": [
        ("K2", 0.0, "+"),
        ("K1SB_X K2", 0.0, "+")
    ],
    "K2 + K1SB_60": [
        ("K2", 6.0, "+"),
        ("K1SB_60", 0.0, "+")
    ],
    "K2 + SB28_60": [
        ("K2", 0.5, "+"),
        ("SB28_60", 0.0, "-")
    ],
    "K2 + SB28_60_C": [
        ("K2", 6.0, "+"),
        ("SB28_60_C", 0.0, "-")
    ],
    "K2 + SB28_60_Cx": [
        ("K2", 4.0, "+"),
        ("SB28_60_Cx", 0.0, "-")
    ],
    "K2 + KS28_60": [
        ("K2", 0.5, "+"),
        ("KS28_60", 0.0, "-")
    ],
    "K2 + KS28_60_C": [
        ("K2", 6.0, "+"),
        ("KS28_60_C", 0.0, "-")
    ],
    "K2 + KS28_60_Cx": [
        ("K2", 4.0, "+"),
        ("KS28_60_Cx", 0.0, "-")
    ],
    "K2 + K1SB_X K2 + SB28_60": [
        ("K2", 0.0, "+"),
        ("K1SB_X K2", 0.0, "+"),
        ("SB28_60", 0.0, "-")
    ],
    "K2 + K1SB_X K2 + SB28_60_C": [
        ("K2", 5.5, "+"),
        ("K1SB_X K2", 5.5, "+"),
        ("SB28_60_C", 0.0, "-")
    ],
    "K2 + K1SB_X K2 + SB28_60_Cx": [
        ("K2", 3.5, "+"),
        ("K1SB_X K2", 3.5, "+"),
        ("SB28_60_Cx", 0.0, "-")
    ],
    "K2 + K1SB_60 + SB28_60": [
        ("K2", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("SB28_60", 6.0, "-")
    ],
    "K2 + K1SB_60 + SB28_60_C": [
        ("K2", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("SB28_60_C", 0.5, "-")
    ],
    "K2 + K1SB_60 + SB28_60_Cx": [
        ("K2", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("SB28_60_Cx", 4.0, "-")
    ],
    "K2 + K1SB_X K2 + KS28_60": [
        ("K2", 0.0, "+"),
        ("K1SB_X K2", 0.0, "+"),
        ("KS28_60", 0.0, "-")
    ],
    "K2 + K1SB_X K2 + KS28_60_C": [
        ("K2", 5.5, "+"),
        ("K1SB_X K2", 5.5, "+"),
        ("KS28_60_C", 0.0, "-")
    ],
    "K2 + K1SB_X K2 + KS28_60_Cx": [
        ("K2", 3.5, "+"),
        ("K1SB_X K2", 3.5, "+"),
        ("KS28_60_Cx", 0.0, "-")
    ],
    "K2 + K1SB_60 + KS28_60": [
        ("K2", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("KS28_60", 6.0, "-")
    ],
    "K2 + K1SB_60 + KS28_60_C": [
        ("K2", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("KS28_60_C", 0.5, "-")
    ],
    "K2 + K1SB_60 + KS28_60_Cx": [
        ("K2", 6.0, "+"),
        ("K1SB_60", 0.0, "+"),
        ("KS28_60_Cx", 4.0, "-")
    ],
    "K3 + KS28_60": [
        ("K3", 0.5, "+"),
        ("KS28_60", 0.0, "-")
    ],
    "K3 + KS28_60_C": [
        ("K3", 6.0, "+"),
        ("KS28_60_C", 0.0, "-")
    ],
    "K3 + KS28_60_Cx": [
        ("K3", 4.0, "+"),
        ("KS28_60_Cx", 0.0, "-")
    ],
    "K3 + KS21_60": [
        ("K3", 0.0, "+"),
        ("KS21_60", 0.0, "-")
    ],
    "K3 + KS21_60_C": [
        ("K3", 5.5, "+"),
        ("KS21_60_C", 0.0, "-")
    ],
    "K3 + KS21_60_Cx": [
        ("K3", 5.0, "+"),
        ("KS21_60_Cx", 0.0, "+")
    ],
    "KUDOxx_60 + SB118_60": [
        ("KUDOxx_60", 0.0, "+"),
        ("SB118_60", 3.5, "+")
    ],
    "KUDOxx_60 + SB118_60_C": [
        ("KUDOxx_60", 2.0, "+"),
        ("SB118_60_C", 0.0, "+")
    ],
    "KUDOxx_60 + SB18_60": [
        ("KUDOxx_60", 0.0, "+"),
        ("SB18_60", 3.9, "+")
    ],
    "KUDOxx_60 + SB18_60_C": [
        ("KUDOxx_60", 1.6, "+"),
        ("SB18_60_C", 0.0, "+")
    ],
    "KUDOxx_60 + SB218_60": [
        ("KUDOxx_60", 0.0, "+"),
        ("SB218_60", 5.0, "+")
    ],
    "KUDOxx_60 + SB28_60": [
        ("KUDOxx_60", 0.0, "+"),
        ("SB28_60", 5.0, "+")
    ],
    "KUDOxx_60 + SB28_60_C": [
        ("KUDOxx_60", 0.5, "+"),
        ("SB28_60_C", 0.0, "+")
    ],
    "KUDOxx_60 + KS28_60": [
        ("KUDOxx_60", 0.0, "+"),
        ("KS28_60", 5.0, "+")
    ],
    "KUDOxx_60 + KS28_60_C": [
        ("KUDOxx_60", 0.5, "+"),
        ("KS28_60_C", 0.0, "+")
    ],
    "KARA + SB18_100": [
        ("KARA", 0.0, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "KARA_FI + SB18_100": [
        ("KARA_FI", 3.0, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "KARA + SB18_100_C": [
        ("KARA", 5.5, "+"),
        ("SB18_100_C", 0.0, "+")
    ],
    "KARA + SB18_100_Cx": [
        ("KARA", 4.0, "+"),
        ("SB18_100_Cx", 0.0, "-")
    ],
    "KARA_FI + SB18_100_C": [
        ("KARA_FI", 8.5, "+"),
        ("SB18_100_C", 0.0, "+")
    ],
    "KARA_FI + SB18_100_Cx": [
        ("KARA_FI", 7.0, "+"),
        ("SB18_100_Cx", 0.0, "-")
    ],
    "KARA + SB18_60": [
        ("KARA", 2.5, "+"),
        ("SB18_60", 0.0, "+")
    ],
    "KARA + SB18_60_C": [
        ("KARA", 8.0, "+"),
        ("SB18_60_C", 0.0, "+")
    ],
    "KARA + SB18_60_Cx": [
        ("KARA", 6.5, "+"),
        ("SB18_60_Cx", 0.0, "-")
    ],
    "KARA + KS21_60": [
        ("KARA", 0.5, "+"),
        ("KS21_60", 0.0, "-")
    ],
    "KARA + KS21_60_C": [
        ("KARA", 6.0, "+"),
        ("KS21_60_C", 0.0, "-")
    ],
    "KARA + KS21_60_Cx": [
        ("KARA", 5.5, "+"),
        ("KS21_60_Cx", 0.0, "-")
    ],
    "KARA + KS21_100": [
        ("KARA", 0.0, "+"),
        ("KS21_100", 0.5, "+")
    ],
    "KARA + KS21_100_C": [
        ("KARA", 5.0, "+"),
        ("KS21_100_C", 0.0, "+")
    ],
    "KARA + KS21_100_Cx": [
        ("KARA", 4.0, "+"),
        ("KS21_100_Cx", 0.0, "-")
    ],
    "KARA_FI + KS21_100": [
        ("KARA_FI", 0.0, "+"),
        ("KS21_100", 2.5, "-")
    ],
    "KARA_FI + KS21_100_C": [
        ("KARA_FI", 3.0, "+"),
        ("KS21_100_C", 0.0, "-")
    ],
    "KARA_FI + KS21_100_Cx": [
        ("KARA_FI", 2.0, "+"),
        ("KS21_100_Cx", 0.0, "+")
    ],
    "KARA + SB28_100": [
        ("KARA", 0.0, "+"),
        ("SB28_100", 1.0, "+")
    ],
    "KARA + SB28_100_C": [
        ("KARA", 4.5, "+"),
        ("SB28_100_C", 0.0, "+")
    ],
    "KARA + SB28_100_Cx": [
        ("KARA", 7.5, "+"),
        ("SB28_100_Cx", 0.0, "-")
    ],
    "KARA + SB28_60": [
        ("KARA", 0.0, "+"),
        ("SB28_60", 5.0, "-")
    ],
    "KARA + SB28_60_C": [
        ("KARA", 0.5, "+"),
        ("SB28_60_C", 0.0, "-")
    ],
    "KARA + SB28_60_Cx": [
        ("KARA", 4.5, "+"),
        ("SB28_60_Cx", 0.0, "+")
    ],
    "KARA + KS28_100": [
        ("KARA", 0.0, "+"),
        ("KS28_100", 1.0, "+")
    ],
    "KARA + KS28_100_C": [
        ("KARA", 4.5, "+"),
        ("KS28_100_C", 0.0, "+")
    ],
    "KARA + KS28_100_Cx": [
        ("KARA", 7.5, "+"),
        ("KS28_100_Cx", 0.0, "-")
    ],
    "KARA + KS28_60": [
        ("KARA", 0.0, "+"),
        ("KS28_60", 5.0, "-")
    ],
    "KARA + KS28_60_C": [
        ("KARA", 0.5, "+"),
        ("KS28_60_C", 0.0, "-")
    ],
    "KARA + KS28_60_Cx": [
        ("KARA", 4.5, "+"),
        ("KS28_60_Cx", 0.0, "+")
    ],
    "KARA + SB18_100 + SB28_60": [
        ("KARA", 0.0, "+"),
        ("SB18_100", 0.0, "+"),
        ("SB28_60", 5.5, "-")
    ],
    "KARA + SB18_100 + SB28_60_C": [
        ("KARA", 0.0, "+"),
        ("SB18_100", 0.0, "+"),
        ("SB28_60_C", 0.0, "-")
    ],
    "KARA + SB18_100 + SB28_60_Cx": [
        ("KARA", 5.5, "+"),
        ("SB18_100", 5.5, "+"),
        ("SB28_60_Cx", 0.0, "+")
    ],
    "KARA + SB18_100 + KS28_60": [
        ("KARA", 0.0, "+"),
        ("SB18_100", 0.0, "+"),
        ("KS28_60", 5.5, "-")
    ],
    "KARA + SB18_100 + KS28_60_C": [
        ("KARA", 0.0, "+"),
        ("SB18_100", 0.0, "+"),
        ("KS28_60_C", 0.0, "-")
    ],
    "KARA + SB18_100 + KS28_60_Cx": [
        ("KARA", 5.5, "+"),
        ("SB18_100", 5.5, "+"),
        ("KS28_60_Cx", 0.0, "+")
    ],
    "KARA + KS21_100 + SB28_60": [
        ("KARA", 0.0, "+"),
        ("KS21_100", 0.5, "+"),
        ("SB28_60", 5.5, "-")
    ],
    "KARA + KS21_100 + SB28_60_C": [
        ("KARA", 0.0, "+"),
        ("KS21_100", 0.5, "+"),
        ("SB28_60_C", 0.0, "-")
    ],
    "KARA + KS21_100 + SB28_60_Cx": [
        ("KARA", 5.5, "+"),
        ("KS21_100", 6.0, "+"),
        ("SB28_60_Cx", 0.0, "+")
    ],
    "KARA + KS21_100 + KS28_60": [
        ("KARA", 0.0, "+"),
        ("KS21_100", 0.0, "+"),
        ("KS28_60", 5.5, "-")
    ],
    "KARA + KS21_100 + KS28_60_C": [
        ("KARA", 0.0, "+"),
        ("KS21_100", 0.5, "+"),
        ("KS28_60_C", 0.0, "-")
    ],
    "KARA + KS21_100 + KS28_60_Cx": [
        ("KARA", 5.5, "+"),
        ("KS21_100", 6.0, "+"),
        ("KS28_60_Cx", 0.0, "+")
    ],
    "KARA II + SB18_100": [
        ("KARA II", 0.0, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "KARA II_FI + SB18_100": [
        ("KARA II_FI", 3.0, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "KARA II_MO + SB18_100": [
        ("KARA II_MO", 0.0, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "KARA II + SB18_100_C": [
        ("KARA II", 5.5, "+"),
        ("SB18_100_C", 0.0, "+")
    ],
    "KARA II + SB18_100_Cx": [
        ("KARA II", 4.0, "+"),
        ("SB18_100_Cx", 0.0, "-")
    ],
    "KARA II_FI + SB18_100_C": [
        ("KARA II_FI", 8.5, "+"),
        ("SB18_100_C", 0.0, "+")
    ],
    "KARA II_FI + SB18_100_Cx": [
        ("KARA II_FI", 7.0, "+"),
        ("SB18_100_Cx", 0.0, "-")
    ],
    "KARA II + SB18_60": [
        ("KARA II", 2.5, "+"),
        ("SB18_60", 0.0, "+")
    ],
    "KARA II_MO + SB18_60": [
        ("KARA II_MO", 2.5, "+"),
        ("SB18_60", 0.0, "+")
    ],
    "KARA II + SB18_60_C": [
        ("KARA II", 8.0, "+"),
        ("SB18_60_C", 0.0, "+")
    ],
    "KARA II + SB18_60_Cx": [
        ("KARA II", 6.5, "+"),
        ("SB18_60_Cx", 0.0, "-")
    ],
    "KARA II + KS21_60": [
        ("KARA II", 0.5, "+"),
        ("KS21_60", 0.0, "-")
    ],
    "KARA II + KS21_60_C": [
        ("KARA II", 6.0, "+"),
        ("KS21_60_C", 0.0, "-")
    ],
    "KARA II + KS21_60_Cx": [
        ("KARA II", 5.5, "+"),
        ("KS21_60_Cx", 0.0, "-")
    ],
    "KARA II_MO + KS21_60": [
        ("KARA II_MO", 0.0, "+"),
        ("KS21_60", 0.0, "+")
    ],
    "KARA II + KS21_100": [
        ("KARA II", 0.0, "+"),
        ("KS21_100", 0.5, "+")
    ],
    "KARA II + KS21_100_C": [
        ("KARA II", 5.0, "+"),
        ("KS21_100_C", 0.0, "+")
    ],
    "KARA II + KS21_100_Cx": [
        ("KARA II", 4.0, "+"),
        ("KS21_100_Cx", 0.0, "-")
    ],
    "KARA II_FI + KS21_100": [
        ("KARA II_FI", 0.0, "+"),
        ("KS21_100", 2.5, "-")
    ],
    "KARA II_FI + KS21_100_C": [
        ("KARA II_FI", 3.0, "+"),
        ("KS21_100_C", 0.0, "-")
    ],
    "KARA II_FI + KS21_100_Cx": [
        ("KARA II_FI", 2.0, "+"),
        ("KS21_100_Cx", 0.0, "+")
    ],
    "KARA II + SB28_100": [
        ("KARA II", 0.0, "+"),
        ("SB28_100", 1.0, "+")
    ],
    "KARA II + SB28_100_C": [
        ("KARA II", 4.5, "+"),
        ("SB28_100_C", 0.0, "+")
    ],
    "KARA II + SB28_100_Cx": [
        ("KARA II", 7.5, "+"),
        ("SB28_100_Cx", 0.0, "-")
    ],
    "KARA II + SB28_60": [
        ("KARA II", 0.0, "+"),
        ("SB28_60", 5.0, "-")
    ],
    "KARA II + SB28_60_C": [
        ("KARA II", 0.5, "+"),
        ("SB28_60_C", 0.0, "-")
    ],
    "KARA II + SB28_60_Cx": [
        ("KARA II", 4.5, "+"),
        ("SB28_60_Cx", 0.0, "+")
    ],
    "KARA II + KS28_100": [
        ("KARA II", 0.0, "+"),
        ("KS28_100", 1.0, "+")
    ],
    "KARA II + KS28_100_C": [
        ("KARA II", 4.5, "+"),
        ("KS28_100_C", 0.0, "+")
    ],
    "KARA II + KS28_100_Cx": [
        ("KARA II", 7.5, "+"),
        ("KS28_100_Cx", 0.0, "-")
    ],
    "KARA II + KS28_60": [
        ("KARA II", 0.0, "+"),
        ("KS28_60", 5.0, "-")
    ],
    "KARA II + KS28_60_C": [
        ("KARA II", 0.5, "+"),
        ("KS28_60_C", 0.0, "-")
    ],
    "KARA II + KS28_60_Cx": [
        ("KARA II", 4.5, "+"),
        ("KS28_60_Cx", 0.0, "+")
    ],
    "KARA II + SB18_100 + SB28_60": [
        ("KARA II", 0.0, "+"),
        ("SB18_100", 0.0, "+"),
        ("SB28_60", 5.5, "-")
    ],
    "KARA II + SB18_100 + SB28_60_C": [
        ("KARA II", 0.0, "+"),
        ("SB18_100", 0.0, "+"),
        ("SB28_60_C", 0.0, "-")
    ],
    "KARA II + SB18_100 + SB28_60_Cx": [
        ("KARA II", 5.5, "+"),
        ("SB18_100", 5.5, "+"),
        ("SB28_60_Cx", 0.0, "+")
    ],
    "KARA II + KS21_100 + SB28_60": [
        ("KARA II", 0.0, "+"),
        ("KS21_100", 0.5, "+"),
        ("SB28_60", 5.5, "-")
    ],
    "KARA II + KS21_100 + SB28_60_C": [
        ("KARA II", 0.0, "+"),
        ("KS21_100", 0.5, "+"),
        ("SB28_60_C", 0.0, "-")
    ],
    "KARA II + KS21_100 + SB28_60_Cx": [
        ("KARA II", 5.5, "+"),
        ("KS21_100", 6.0, "+"),
        ("SB28_60_Cx", 0.0, "+")
    ],
    "KARA II + KS21_100 + KS28_60": [
        ("KARA II", 0.0, "+"),
        ("KS21_100", 0.0, "+"),
        ("KS28_60", 5.5, "-")
    ],
    "KARA II + KS21_100 + KS28_60_C": [
        ("KARA II", 0.0, "+"),
        ("KS21_100", 0.5, "+"),
        ("KS28_60_C", 0.0, "-")
    ],
    "KARA II + KS21_100 + KS28_60_Cx": [
        ("KARA II", 5.5, "+"),
        ("KS21_100", 6.0, "+"),
        ("KS28_60_Cx", 0.0, "+")
    ],
    "KIVA + KILO": [
        ("KIVA", 0.0, "+"),
        ("KILO", 1.5, "+")
    ],
    "KIVA_KILO + SB118_60": [
        ("KIVA_KILO", 0.0, "+"),
        ("SB118_60", 5.9, "+")
    ],
    "KIVA_KILO + SB118_60_C": [
        ("KIVA_KILO", 0.0, "+"),
        ("SB118_60_C", 0.4, "+")
    ],
    "KIVA_KILO + SB18_60": [
        ("KIVA_KILO", 0.0, "+"),
        ("SB18_60", 6.3, "+")
    ],
    "KIVA_KILO + SB18_60_C": [
        ("KIVA_KILO", 0.0, "+"),
        ("SB18_60_C", 0.8, "+")
    ],
    "KIVA + SB15_100": [
        ("KIVA", 0.0, "+"),
        ("SB15_100", 1.4, "+")
    ],
    "KIVA + SB15_100_C": [
        ("KIVA", 2.4, "+"),
        ("SB15_100_C", 0.0, "+")
    ],
    "KIVA_FI + SB15_100": [
        ("KIVA_FI", 0.0, "+"),
        ("SB15_100", 0.6, "+")
    ],
    "KIVA_SB15 + SB18_60": [
        ("KIVA_SB15", 0.0, "+"),
        ("SB18_60", 8.5, "+")
    ],
    "KIVA_SB15 + SB18_60_C": [
        ("KIVA_SB15", 0.0, "+"),
        ("SB18_60_C", 3.0, "+")
    ],
    "KIVA II + SB15_100": [
        ("KIVA II", 0.0, "+"),
        ("SB15_100", 1.0, "+")
    ],
    "KIVA II + SB15_100_C": [
        ("KIVA II", 2.5, "+"),
        ("SB15_100_C", 0.0, "+")
    ],
    "KIVA II + SB15_100_Cx": [
        ("KIVA II", 4.5, "+"),
        ("SB15_100_Cx", 0.0, "-")
    ],
    "KIVA II_FI + SB15_100": [
        ("KIVA II_FI", 0.0, "+"),
        ("SB15_100", 1.0, "+")
    ],
    "KIVA II_FI + SB15_100_C": [
        ("KIVA II_FI", 2.5, "+"),
        ("SB15_100_C", 0.0, "+")
    ],
    "KIVA II_FI + SB15_100_Cx": [
        ("KIVA II_FI", 5.0, "+"),
        ("SB15_100_Cx", 0.0, "-")
    ],
    "KIVA II + SB15_100 + SB18_60": [
        ("KIVA II", 0.0, "+"),
        ("SB15_100", 1.0, "+"),
        ("SB18_60", 1.0, "-")
    ],
    "KIVA II + SB15_100 + SB18_60_C": [
        ("KIVA II", 4.5, "+"),
        ("SB15_100", 5.5, "+"),
        ("SB18_60_C", 0.0, "-")
    ],
    "KIVA II + SB15_100 + SB18_60_Cx": [
        ("KIVA II", 1.0, "+"),
        ("SB15_100", 2.0, "+"),
        ("SB18_60_Cx", 0.0, "+")
    ],
    "KIVA II + SB15_100_C + SB18_60": [
        ("KIVA II", 2.5, "+"),
        ("SB15_100_C", 0.0, "+"),
        ("SB18_60", 3.5, "-")
    ],
    "KIVA II + SB15_100_C + SB18_60_C": [
        ("KIVA II", 4.5, "+"),
        ("SB15_100_C", 2.0, "+"),
        ("SB18_60_C", 0.0, "-")
    ],
    "KIVA II + SB15_100_C + SB18_60_Cx": [
        ("KIVA II", 3.0, "+"),
        ("SB15_100_C", 0.5, "+"),
        ("SB18_60_Cx", 0.0, "+")
    ],
    "V-DOSC_xx_X + SB218_X": [
        ("V-DOSC_xx_X", 1.8, "+"),
        ("SB218_X", 0.0, "+")
    ],
    "V-DOSC_xx_60 + SB218_60": [
        ("V-DOSC_xx_60", 0.0, "+"),
        ("SB218_60", 3.8, "+")
    ],
    "V-DOSC_xx_60 + SB28_60": [
        ("V-DOSC_xx_60", 0.0, "+"),
        ("SB28_60", 3.8, "+")
    ],
    "V-DOSC_xx_60 + SB28_60_C": [
        ("V-DOSC_xx_60", 1.7, "+"),
        ("SB28_60_C", 0.0, "+")
    ],
    "V-DOSC_xx_60 + KS28_60": [
        ("V-DOSC_xx_60", 0.0, "+"),
        ("KS28_60", 3.8, "+")
    ],
    "V-DOSC_xx_60 + KS28_60_C": [
        ("V-DOSC_xx_60", 1.7, "+"),
        ("KS28_60_C", 0.0, "+")
    ],
    "V-DOSC_xx_X + dV-S_X": [
        ("V-DOSC_xx_X", 0.0, "+"),
        ("dV-S_X", 0.2, "+")
    ],
    "V-DOSC_xx_60 + dV-S_60_X + SB218_60": [
        ("V-DOSC_xx_60", 0.0, "+"),
        ("dV-S_60_X", 0.2, "+"),
        ("SB218_60", 3.7, "+")
    ],
    "V-DOSC_xx_60 + dV-S_60_X + SB28_60": [
        ("V-DOSC_xx_60", 0.0, "+"),
        ("dV-S_60_X", 0.2, "+"),
        ("SB28_60", 3.7, "+")
    ],
    "V-DOSC_xx_60 + dV-S_60_X + SB28_60_C": [
        ("V-DOSC_xx_60", 1.9, "+"),
        ("dV-S_60_X", 2.0, "+"),
        ("SB28_60_C", 0.0, "+")
    ],
    "V-DOSC_xx_60 + dV-S_60_X + KS28_60": [
        ("V-DOSC_xx_60", 0.0, "+"),
        ("dV-S_60_X", 0.2, "+"),
        ("KS28_60", 3.7, "+")
    ],
    "V-DOSC_xx_60 + dV-S_60_X + KS28_60_C": [
        ("V-DOSC_xx_60", 1.9, "+"),
        ("dV-S_60_X", 2.0, "+"),
        ("KS28_60_C", 0.0, "+")
    ],
    "V-DOSC_xx_60 + dV_xx_100": [
        ("V-DOSC_xx_60", 0.0, "+"),
        ("dV_xx_100", 0.04, "+")
    ],
    "dV_xx_100 + SB118_100": [
        ("dV_xx_100", 2.7, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "dV_xx_100 + SB118_100_C": [
        ("dV_xx_100", 8.3, "+"),
        ("SB118_100_C", 0.0, "+")
    ],
    "dV_xx_100 + SB218_100": [
        ("dV_xx_100", 0.8, "+"),
        ("SB218_100", 0.0, "+")
    ],
    "dV_xx_100 + SB18_100": [
        ("dV_xx_100", 2.4, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "dV_xx_100 + SB18_100_C": [
        ("dV_xx_100", 8.0, "+"),
        ("SB18_100_C", 0.0, "+")
    ],
    "dV_xx_100 + SB28_100": [
        ("dV_xx_100", 0.8, "+"),
        ("SB28_100", 0.0, "+")
    ],
    "dV_xx_100 + SB28_100_C": [
        ("dV_xx_100", 6.3, "+"),
        ("SB28_100_C", 0.0, "+")
    ],
    "dV_xx_100 + KS28_100": [
        ("dV_xx_100", 0.8, "+"),
        ("KS28_100", 0.0, "+")
    ],
    "dV_xx_100 + KS28_100_C": [
        ("dV_xx_100", 6.3, "+"),
        ("KS28_100_C", 0.0, "+")
    ],
    "dV_xx_100 + dV-S_100": [
        ("dV_xx_100", 0.0, "+"),
        ("dV-S_100", 0.0, "+")
    ],
    "dV_xx_100 + dV-S_60_100 + SB118_60": [
        ("dV_xx_100", 0.0, "+"),
        ("dV-S_60_100", 0.75, "+"),
        ("SB118_60", 4.0, "+")
    ],
    "dV_xx_100 + dV-S_60_100 + SB118_60_C": [
        ("dV_xx_100", 1.5, "+"),
        ("dV-S_60_100", 2.25, "+"),
        ("SB118_60_C", 0.0, "+")
    ],
    "dV_xx_100 + dV-S_60_100 + SB218_60": [
        ("dV_xx_100", 0.0, "+"),
        ("dV-S_60_100", 0.75, "+"),
        ("SB218_60", 4.5, "+")
    ],
    "dV_xx_100 + dV-S_60_100 + SB18_60": [
        ("dV_xx_100", 0.0, "+"),
        ("dV-S_60_100", 0.75, "+"),
        ("SB18_60", 4.4, "+")
    ],
    "dV_xx_100 + dV-S_60_100 + SB18_60_C": [
        ("dV_xx_100", 1.1, "+"),
        ("dV-S_60_100", 1.85, "+"),
        ("SB18_60_C", 0.0, "+")
    ],
    "dV_xx_100 + dV-S_60_100 + SB28_60": [
        ("dV_xx_100", 0.0, "+"),
        ("dV-S_60_100", 0.75, "+"),
        ("SB28_60", 4.5, "+")
    ],
    "dV_xx_100 + dV-S_60_100 + SB28_60_C": [
        ("dV_xx_100", 1.0, "+"),
        ("dV-S_60_100", 1.75, "+"),
        ("SB28_60_C", 0.0, "+")
    ],
    "dV_xx_100 + dV-S_60_100 + KS28_60": [
        ("dV_xx_100", 0.0, "+"),
        ("dV-S_60_100", 0.75, "+"),
        ("KS28_60", 4.5, "+")
    ],
    "dV_xx_100 + dV-S_60_100 + KS28_60_C": [
        ("dV_xx_100", 1.0, "+"),
        ("dV-S_60_100", 1.75, "+"),
        ("KS28_60_C", 0.0, "+")
    ],
    "ARCS_xx_60 + SB118_60": [
        ("ARCS_xx_60", 0.8, "+"),
        ("SB118_60", 0.0, "+")
    ],
    "ARCS_xx_60 + SB118_60_C": [
        ("ARCS_xx_60", 6.3, "+"),
        ("SB118_60_C", 0.0, "+")
    ],
    "ARCS_xx_100 + SB118_100": [
        ("ARCS_xx_100", 1.4, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "ARCS_xx_100 + SB118_100_C": [
        ("ARCS_xx_100", 6.9, "+"),
        ("SB118_100_C", 0.0, "+")
    ],
    "ARCS_xx_60 + SB18_60": [
        ("ARCS_xx_60", 0.4, "+"),
        ("SB18_60", 0.0, "+")
    ],
    "ARCS_xx_60 + SB18_60_C": [
        ("ARCS_xx_60", 5.9, "+"),
        ("SB18_60_C", 0.0, "+")
    ],
    "ARCS_xx_100 + SB18_100": [
        ("ARCS_xx_100", 1.1, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "ARCS_xx_100 + SB18_100_C": [
        ("ARCS_xx_100", 6.6, "+"),
        ("SB18_100_C", 0.0, "+")
    ],
    "ARCS_xx_60 + SB218_60": [
        ("ARCS_xx_60", 0.0, "+"),
        ("SB218_60", 0.9, "+")
    ],
    "ARCS_xx_100 + SB218_100": [
        ("ARCS_xx_100", 0.0, "+"),
        ("SB218_100", 0.3, "+")
    ],
    "ARCS_xx_60 + SB28_60": [
        ("ARCS_xx_60", 0.0, "+"),
        ("SB28_60", 0.6, "+")
    ],
    "ARCS_xx_60 + SB28_60_C": [
        ("ARCS_xx_60", 4.9, "+"),
        ("SB28_60_C", 0.0, "+")
    ],
    "ARCS_xx_100 + SB28_100": [
        ("ARCS_xx_100", 0.0, "+"),
        ("SB28_100", 0.5, "+")
    ],
    "ARCS_xx_100 + SB28_100_C": [
        ("ARCS_xx_100", 5.0, "+"),
        ("SB28_100_C", 0.0, "+")
    ],
    "ARCS_xx_60 + KS28_60": [
        ("ARCS_xx_60", 0.0, "+"),
        ("KS28_60", 0.6, "+")
    ],
    "ARCS_xx_60 + KS28_60_C": [
        ("ARCS_xx_60", 4.9, "+"),
        ("KS28_60_C", 0.0, "+")
    ],
    "ARCS_xx_100 + KS28_100": [
        ("ARCS_xx_100", 0.0, "+"),
        ("KS28_100", 0.5, "+")
    ],
    "ARCS_xx_100 + KS28_100_C": [
        ("ARCS_xx_100", 5.0, "+"),
        ("KS28_100_C", 0.0, "+")
    ],
    "ARCS II + SB28_60": [
        ("ARCS II", 0.0, "+"),
        ("SB28_60", 2.0, "+")
    ],
    "ARCS II + SB28_60_C": [
        ("ARCS II", 3.5, "+"),
        ("SB28_60_C", 0.0, "+")
    ],
    "ARCS II + SB28_60_Cx": [
        ("ARCS II", 7.5, "+"),
        ("SB28_60_Cx", 0.0, "-")
    ],
    "ARCS II + KS28_60": [
        ("ARCS II", 0.0, "+"),
        ("KS28_60", 2.0, "+")
    ],
    "ARCS II + KS28_60_C": [
        ("ARCS II", 3.5, "+"),
        ("KS28_60_C", 0.0, "+")
    ],
    "ARCS II + KS28_60_Cx": [
        ("ARCS II", 7.5, "+"),
        ("KS28_60_Cx", 0.0, "-")
    ],
    "ARCS_WIFO + SB18_60": [
        ("ARCS_WIFO", 1.5, "+"),
        ("SB18_60", 0.0, "+")
    ],
    "ARCS_WIFO + SB18_60_C": [
        ("ARCS_WIFO", 7.0, "+"),
        ("SB18_60_C", 0.0, "+")
    ],
    "ARCS_WIFO + SB18_60_Cx": [
        ("ARCS_WIFO", 6.0, "+"),
        ("SB18_60_Cx", 0.0, "-")
    ],
    "ARCS_WIFO_FI + SB18_60": [
        ("ARCS_WIFO_FI", 1.5, "+"),
        ("SB18_60", 0.0, "+")
    ],
    "ARCS_WIFO_FI + SB18_60_C": [
        ("ARCS_WIFO_FI", 7.0, "+"),
        ("SB18_60_C", 0.0, "+")
    ],
    "ARCS_WIFO_FI + SB18_60_Cx": [
        ("ARCS_WIFO_FI", 6.0, "+"),
        ("SB18_60_Cx", 0.0, "-")
    ],
    "A15 + KS21_60": [
        ("A15", 0.0, "+"),
        ("KS21_60", 2.3, "+")
    ],
    "A15 + KS21_60_C": [
        ("A15", 9.0, "+"),
        ("KS21_60_C", 0.0, "-")
    ],
    "A15 + KS21_60_Cx": [
        ("A15", 8.0, "+"),
        ("KS21_60_Cx", 0.0, "-")
    ],
    "A15_FI + KS21_60": [
        ("A15_FI", 0.0, "+"),
        ("KS21_60", 2.3, "+")
    ],
    "A15_FI + KS21_60_C": [
        ("A15_FI", 9.0, "+"),
        ("KS21_60_C", 0.0, "-")
    ],
    "A15_FI + KS21_60_Cx": [
        ("A15_FI", 8.0, "+"),
        ("KS21_60_Cx", 0.0, "-")
    ],
    "A15_MO + KS21_60": [
        ("A15_MO", 0.0, "+"),
        ("KS21_60", 2.3, "+")
    ],
    "A10 + KS21_100": [
        ("A10", 0.0, "+"),
        ("KS21_100", 0.0, "+")
    ],
    "A10 + KS21_100_C": [
        ("A10", 5.5, "+"),
        ("KS21_100_C", 0.0, "+")
    ],
    "A10 + KS21_100_Cx": [
        ("A10", 0.0, "+"),
        ("KS21_100_Cx", 0.0, "+")
    ],
    "A10_FI + KS21_100": [
        ("A10_FI", 0.0, "+"),
        ("KS21_100", 0.0, "+")
    ],
    "A10_FI + KS21_100_C": [
        ("A10_FI", 5.5, "+"),
        ("KS21_100_C", 0.0, "+")
    ],
    "A10_FI + KS21_100_Cx": [
        ("A10_FI", 0.0, "+"),
        ("KS21_100_Cx", 0.0, "+")
    ],
    "A10_MO + KS21_100": [
        ("A10_MO", 0.0, "+"),
        ("KS21_100", 0.0, "+")
    ],
    "SYVA + SYVA SUB_100": [
        ("SYVA", 0.0, "+"),
        ("SYVA SUB_100", 2.6, "+")
    ],
    "SYVA + SYVA LOW_100 + SYVA SUB_100": [
        ("SYVA", 0.0, "+"),
        ("SYVA LOW_100", 0.0, "+"),
        ("SYVA SUB_100", 3.8, "+")
    ],
    "SYVA + SYVA LOW_100 + SB18_100": [
        ("SYVA", 0.0, "+"),
        ("SYVA LOW_100", 0.0, "+"),
        ("SB18_100", 0.0, "-")
    ],
    "SOKA + SB6_100": [
        ("SOKA", 1.4, "+"),
        ("SB6_100", 0.0, "+")
    ],
    "SOKA_200 + SB6_200": [
        ("SOKA_200", 1.9, "+"),
        ("SB6_200", 0.0, "+")
    ],
    "SOKA_60 + SB6_60": [
        ("SOKA_60", 3.6, "+"),
        ("SB6_60", 0.0, "-")
    ],
    "SOKA + SB10_100": [
        ("SOKA", 2.6, "+"),
        ("SB10_100", 0.0, "+")
    ],
    "SOKA_200 + SB10_200": [
        ("SOKA_200", 3.2, "+"),
        ("SB10_200", 0.0, "+")
    ],
    "SOKA_60 + SB10_60": [
        ("SOKA_60", 9.0, "+"),
        ("SB10_60", 0.0, "-")
    ],
    "SOKA_60 + SYVA_SUB_60": [
        ("SOKA_60", 5.6, "+"),
        ("SYVA_SUB_60", 0.0, "+")
    ],
    "X15 + SB18_100": [
        ("X15", 4.0, "+"),
        ("SB18_100", 0.0, "-")
    ],
    "X15_MO + SB18_100": [
        ("X15_MO", 0.0, "+"),
        ("SB18_100", 1.0, "+")
    ],
    "X15 + SB18_100_C": [
        ("X15", 9.7, "+"),
        ("SB18_100_C", 0.0, "-")
    ],
    "X15 + SB18_100_Cx": [
        ("X15", 8.25, "+"),
        ("SB18_100_Cx", 0.0, "+")
    ],
    "X15 + KS21_100": [
        ("X15", 0.0, "+"),
        ("KS21_100", 1.5, "+")
    ],
    "X15_MO + KS21_100": [
        ("X15_MO", 0.0, "+"),
        ("KS21_100", 1.5, "+")
    ],
    "X15 + KS21_100_C": [
        ("X15", 3.9, "+"),
        ("KS21_100_C", 0.0, "+")
    ],
    "X15 + KS21_100_Cx": [
        ("X15", 2.6, "+"),
        ("KS21_100_Cx", 0.0, "-")
    ],
    "X12 + SB15_100": [
        ("X12", 1.5, "+"),
        ("SB15_100", 0.0, "-")
    ],
    "X12_MO + SB15_100": [
        ("X12_MO", 0.0, "+"),
        ("SB15_100", 2.85, "+")
    ],
    "X12 + SB15_100_C": [
        ("X12", 5.1, "+"),
        ("SB15_100_C", 0.0, "-")
    ],
    "X12 + SB15_100_Cx": [
        ("X12", 3.0, "+"),
        ("SB15_100_Cx", 0.0, "-")
    ],
    "X12 + SB18_100": [
        ("X12", 0.0, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "X12_MO + SB18_100": [
        ("X12_MO", 0.0, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "X12 + SB18_100_C": [
        ("X12", 5.7, "+"),
        ("SB18_100_C", 0.0, "+")
    ],
    "X12 + SB18_100_Cx": [
        ("X12", 4.0, "+"),
        ("SB18_100_Cx", 0.0, "-")
    ],
    "X12 + KS21_100": [
        ("X12", 0.0, "+"),
        ("KS21_100", 1.0, "+")
    ],
    "X12_MO + KS21_100": [
        ("X12_MO", 0.0, "+"),
        ("KS21_100", 0.4, "+")
    ],
    "X12 + KS21_100_C": [
        ("X12", 4.8, "+"),
        ("KS21_100_C", 0.0, "+")
    ],
    "X12 + KS21_100_Cx": [
        ("X12", 3.4, "+"),
        ("KS21_100_Cx", 0.0, "-")
    ],
    "X8 + SB10_100": [
        ("X8", 0.0, "+"),
        ("SB10_100", 3.2, "+")
    ],
    "X8 + SB15_100": [
        ("X8", 2.0, "+"),
        ("SB15_100", 0.0, "-")
    ],
    "X8_MO + SB15_100": [
        ("X8_MO", 0.0, "+"),
        ("SB15_100", 3.0, "+")
    ],
    "X8 + SB15_100_C": [
        ("X8", 5.7, "+"),
        ("SB15_100_C", 0.0, "-")
    ],
    "X8 + SB15_100_Cx": [
        ("X8", 3.8, "+"),
        ("SB15_100_Cx", 0.0, "-")
    ],
    "X8 + SYVA_SUB_100": [
        ("X8", 0.0, "+"),
        ("SYVA_SUB_100", 0.7, "+")
    ],
    "X8i + SB10_100": [
        ("X8i", 0.0, "+"),
        ("SB10_100", 0.5, "+")
    ],
    "X8i_40 + SB10_60": [
        ("X8i_40", 0.0, "+"),
        ("SB10_60", 3.0, "+")
    ],
    "X8i + SYVA_SUB_100": [
        ("X8i", 0.0, "+"),
        ("SYVA_SUB_100", 0.0, "-")
    ],
    "X8i_40 + SYVA_SUB_60": [
        ("X8i_40", 3.5, "+"),
        ("SYVA_SUB_60", 0.0, "-")
    ],
    "X8i + KS21_100": [
        ("X8i", 0.0, "+"),
        ("KS21_100", 0.0, "+")
    ],
    "X8i_40 + KS21_60": [
        ("X8i_40", 4.8, "+"),
        ("KS21_60", 0.0, "+")
    ],
    "X6i + SB6_100": [
        ("X6i", 0.0, "+"),
        ("SB6_100", 1.2, "+")
    ],
    "X6i + SB6_200": [
        ("X6i", 0.0, "+"),
        ("SB6_200", 0.0, "-")
    ],
    "X6i + SB10_100": [
        ("X6i", 0.0, "+"),
        ("SB10_100", 0.0, "+")
    ],
    "X6i + SB10_200": [
        ("X6i", 1.4, "+"),
        ("SB10_200", 0.0, "-")
    ],
    "X6i_50 + SB6_60": [
        ("X6i_50", 0.0, "+"),
        ("SB6_60", 2.0, "+")
    ],
    "X6i_50 + SB10_60": [
        ("X6i_50", 0.0, "+"),
        ("SB10_60", 6.8, "-")
    ],
    "X6i_50 + SYVA_SUB_60": [
        ("X6i_50", 0.0, "+"),
        ("SYVA_SUB_60", 0.4, "+")
    ],
    "5XT + SB10_100": [
        ("5XT", 0.0, "+"),
        ("SB10_100", 1.6, "-")
    ],
    "5XT_MO + SB10_100": [
        ("5XT_MO", 0.0, "+"),
        ("SB10_100", 1.6, "-")
    ],
    "X4 + SB4_60": [
        ("X4", 0.0, "+"),
        ("SB4_60", 0.4, "+")
    ],
    "X4 + SB6_200": [
        ("X4", 0.6, "+"),
        ("SB6_200", 0.0, "+")
    ],
    "X4_60 + SB6_60": [
        ("X4_60", 1.8, "+"),
        ("SB6_60", 0.0, "-")
    ],
    "X4 + SB10_100": [
        ("X4", 0.8, "+"),
        ("SB10_100", 0.0, "+")
    ],
    "X4_MO + SB10_100": [
        ("X4_MO", 0.8, "+"),
        ("SB10_100", 0.0, "+")
    ],
    "X4 + SB10_200": [
        ("X4", 1.9, "+"),
        ("SB10_200", 0.0, "-")
    ],
    "X4_MO + SB10_200": [
        ("X4_MO", 0.0, "+"),
        ("SB10_200", 0.0, "+")
    ],
    "HIQ_FI_100 + SB118_100": [
        ("HIQ_FI_100", 2.6, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "HIQ_FR_100 + SB118_100": [
        ("HIQ_FR_100", 2.6, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "HIQ_MO_100 + SB118_100": [
        ("HIQ_MO_100", 2.5, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "HIQ_FI_100 + SB18_100": [
        ("HIQ_FI_100", 2.3, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "HIQ_FR_100 + SB18_100": [
        ("HIQ_FR_100", 2.3, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "HIQ_MO_100 + SB18_100": [
        ("HIQ_MO_100", 2.2, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "HIQ_FI_100 + dV-S_100": [
        ("HIQ_FI_100", 0.6, "+"),
        ("dV-S_100", 0.0, "+")
    ],
    "HIQ_FR_100 + dV-S_100": [
        ("HIQ_FR_100", 0.6, "+"),
        ("dV-S_100", 0.0, "+")
    ],
    "HIQ_MO_100 + dV-S_100": [
        ("HIQ_MO_100", 0.5, "+"),
        ("dV-S_100", 0.0, "+")
    ],
    "12XTA_FI_100 + SB118_100": [
        ("12XTA_FI_100", 2.6, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "12XTA_FR_100 + SB118_100": [
        ("12XTA_FR_100", 2.6, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "12XTA_MO_100 + SB118_100": [
        ("12XTA_MO_100", 2.5, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "12XTA_FI_100 + SB18_100": [
        ("12XTA_FI_100", 2.3, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "12XTA_FR_100 + SB18_100": [
        ("12XTA_FR_100", 2.3, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "12XTA_MO_100 + SB18_100": [
        ("12XTA_MO_100", 2.2, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "12XTP_FI_100 + SB118_100": [
        ("12XTP_FI_100", 2.4, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "12XTP_FR_100 + SB118_100": [
        ("12XTP_FR_100", 2.4, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "12XTP_MO_100 + SB118_100": [
        ("12XTP_MO_100", 2.4, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "12XTP_FI_100 + SB18_100": [
        ("12XTP_FI_100", 2.1, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "12XTP_FR_100 + SB18_100": [
        ("12XTP_FR_100", 2.1, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "12XTP_MO_100 + SB18_100": [
        ("12XTP_MO_100", 2.1, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "8XT_FI_100 + SB118_100": [
        ("8XT_FI_100", 3.1, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "8XT_FR_100 + SB118_100": [
        ("8XT_FR_100", 3.2, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "8XT_MO_100 + SB118_100": [
        ("8XT_MO_100", 3.0, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "8XT_FI_100 + SB18_100": [
        ("8XT_FI_100", 2.8, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "8XT_FR_100 + SB18_100": [
        ("8XT_FR_100", 2.9, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "8XT_MO_100 + SB18_100": [
        ("8XT_MO_100", 2.7, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "115XT_FI_100 + SB118_100": [
        ("115XT_FI_100", 2.6, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "115XT_FR_100 + SB118_100": [
        ("115XT_FR_100", 2.5, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "115XT_MO_100 + SB118_100": [
        ("115XT_MO_100", 2.9, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "115XT_FI_100 + SB18_100": [
        ("115XT_FI_100", 2.3, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "115XT_FR_100 + SB18_100": [
        ("115XT_FR_100", 2.2, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "115XT_MO_100 + SB18_100": [
        ("115XT_MO_100", 2.6, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "115bA_FI_100 + SB118_100": [
        ("115bA_FI_100", 2.4, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "115bA_FR_100 + SB118_100": [
        ("115bA_FR_100", 2.5, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "115bA_MO_100 + SB118_100": [
        ("115bA_MO_100", 2.7, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "115bA_FI_100 + SB18_100": [
        ("115bA_FI_100", 2.1, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "115bA_FR_100 + SB18_100": [
        ("115bA_FR_100", 2.0, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "115bA_MO_100 + SB18_100": [
        ("115bA_MO_100", 2.4, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "115bP_FI_100 + SB118_100": [
        ("115bP_FI_100", 2.1, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "115bP_FR_100 + SB118_100": [
        ("115bP_FR_100", 2.2, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "115bP_MO_100 + SB118_100": [
        ("115bP_MO_100", 2.8, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "115bP_FI_100 + SB18_100": [
        ("115bP_FI_100", 1.8, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "115bP_FR_100 + SB18_100": [
        ("115bP_FR_100", 1.9, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "115bP_MO_100 + SB18_100": [
        ("115bP_MO_100", 2.5, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "112XT_FI_100 + SB118_100": [
        ("112XT_FI_100", 2.3, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "112XT_FR_100 + SB118_100": [
        ("112XT_FR_100", 2.3, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "112XT_MO_100 + SB118_100": [
        ("112XT_MO_100", 2.6, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "112XT_FI_100 + SB18_100": [
        ("112XT_FI_100", 2.0, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "112XT_FR_100 + SB18_100": [
        ("112XT_FR_100", 2.0, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "112XT_MO_100 + SB18_100": [
        ("112XT_MO_100", 2.3, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "112b_FI_100 + SB118_100": [
        ("112b_FI_100", 2.4, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "112b_FR_100 + SB118_100": [
        ("112b_FR_100", 2.5, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "112b_MO_100 + SB118_100": [
        ("112b_MO_100", 3.0, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "112b_FI_100 + SB18_100": [
        ("112b_FI_100", 2.1, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "112b_FR_100 + SB18_100": [
        ("112b_FR_100", 2.2, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "112b_MO_100 + SB18_100": [
        ("112b_MO_100", 2.7, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "108a_FI_100 + SB118_100": [
        ("108a_FI_100", 3.5, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "108a_FR_100 + SB118_100": [
        ("108a_FR_100", 3.6, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "108a_MO_100 + SB118_100": [
        ("108a_MO_100", 4.0, "+"),
        ("SB118_100", 0.0, "+")
    ],
    "108a_FI_100 + SB18_100": [
        ("108a_FI_100", 3.2, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "108a_FR_100 + SB18_100": [
        ("108a_FR_100", 3.3, "+"),
        ("SB18_100", 0.0, "+")
    ],
    "108a_MO_100 + SB18_100": [
        ("108a_MO_100", 3.7, "+"),
        ("SB18_100", 0.0, "+")
    ]
]

func calculateDelayAndPolarity(slot: SpeakerSlot, allSlots: [SpeakerSlot]) -> (delay: Double, polarity: String, warning: String) {
    let allPresets = allSlots.map { $0.preset }.filter { !$0.isEmpty }.sorted()
    let key = allPresets.joined(separator: " + ")

    if allPresets.allSatisfy({ $0 == allPresets.first }) {
        return (0.0, "+", "Все пресеты одинаковые — задержка не нужна, но проверь мануал!")
    }

    if allPresets.count >= 2 && allPresets.count <= 3 {
        if let entries = delayData[key] {
            for entry in entries {
                if entry.preset == slot.preset {
                    return (entry.delay, entry.polarity, "")
                }
            }
        }
        return (0.0, "+", "Такого сочетания нет в официальном мануале: \(key)")
    }
    return (0.0, "+", "Invalid number of slots: \(allPresets.count)")
}
