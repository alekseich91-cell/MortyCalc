func calculateDelayAndPolarity(slot: SpeakerSlot, allSlots: [SpeakerSlot]) -> (delay: Double, polarity: String, warning: String) {
    let allPresets = allSlots.map { $0.preset }.sorted()
    let key = allPresets.joined(separator: " + ")

    if allPresets.count >= 2 && allPresets.count <= 3 {
        switch key {
        // K1 связки
        case "K1 + SB28_60": if slot.preset == "K1" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "K1 + SB28_60_C": if slot.preset == "K1" { return (6.0, "+", "") } else { return (0.0, "-", "") }
        case "K1 + SB28_60_Cx": if slot.preset == "K1" { return (4.0, "+", "") } else { return (0.0, "-", "") }
        case "K1 + KS28_60": if slot.preset == "K1" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "K1 + KS28_60_C": if slot.preset == "K1" { return (6.0, "+", "") } else { return (0.0, "-", "") }
        case "K1 + KS28_60_Cx": if slot.preset == "K1" { return (4.0, "+", "") } else { return (0.0, "-", "") }
        case "K1 + K1SB_X + SB28_60": if slot.preset == "K1" { return (0.0, "+", "") } else if slot.preset == "K1SB_X" { return (0.0, "+", "") } else { return (0.0, "-", "") }
        case "K1 + K1SB_X + SB28_60_C": if slot.preset == "K1" { return (5.5, "+", "") } else if slot.preset == "K1SB_X" { return (5.5, "+", "") } else { return (0.0, "-", "") }
        case "K1 + K1SB_X + SB28_60_Cx": if slot.preset == "K1" { return (3.5, "+", "") } else if slot.preset == "K1SB_X" { return (3.5, "+", "") } else { return (0.0, "-", "") }
        case "K1 + K1SB_60 + SB28_60": if slot.preset == "K1" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (6.0, "-", "") }
        case "K1 + K1SB_60 + SB28_60_C": if slot.preset == "K1" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (0.5, "-", "") }
        case "K1 + K1SB_60 + SB28_60_Cx": if slot.preset == "K1" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (4.0, "-", "") }
        case "K1 + K1SB_X + KS28_60": if slot.preset == "K1" { return (0.0, "+", "") } else if slot.preset == "K1SB_X" { return (0.0, "+", "") } else { return (0.0, "-", "") }
        case "K1 + K1SB_X + KS28_60_C": if slot.preset == "K1" { return (5.5, "+", "") } else if slot.preset == "K1SB_X" { return (5.5, "+", "") } else { return (0.0, "-", "") }
        case "K1 + K1SB_X + KS28_60_Cx": if slot.preset == "K1" { return (3.5, "+", "") } else if slot.preset == "K1SB_X" { return (3.5, "+", "") } else { return (0.0, "-", "") }
        case "K1 + K1SB_60 + KS28_60": if slot.preset == "K1" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (6.0, "-", "") }
        case "K1 + K1SB_60 + KS28_60_C": if slot.preset == "K1" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (0.5, "-", "") }
        case "K1 + K1SB_60 + KS28_60_Cx": if slot.preset == "K1" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (4.0, "-", "") }
        // K2 связки
        case "K2 + K1SB_X K2": if slot.preset == "K2" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "K2 + K1SB_60": if slot.preset == "K2" { return (6.0, "+", "") } else { return (0.0, "+", "") }
        case "K2 + SB28_60": if slot.preset == "K2" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "K2 + SB28_60_C": if slot.preset == "K2" { return (6.0, "+", "") } else { return (0.0, "-", "") }
        case "K2 + SB28_60_Cx": if slot.preset == "K2" { return (4.0, "+", "") } else { return (0.0, "-", "") }
        case "K2 + KS28_60": if slot.preset == "K2" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "K2 + KS28_60_C": if slot.preset == "K2" { return (6.0, "+", "") } else { return (0.0, "-", "") }
        case "K2 + KS28_60_Cx": if slot.preset == "K2" { return (4.0, "+", "") } else { return (0.0, "-", "") }
        case "K2 + K1SB_X K2 + SB28_60": if slot.preset == "K2" { return (0.0, "+", "") } else if slot.preset == "K1SB_X K2" { return (0.0, "+", "") } else { return (0.0, "-", "") }
        case "K2 + K1SB_X K2 + SB28_60_C": if slot.preset == "K2" { return (5.5, "+", "") } else if slot.preset == "K1SB_X K2" { return (5.5, "+", "") } else { return (0.0, "-", "") }
        case "K2 + K1SB_X K2 + SB28_60_Cx": if slot.preset == "K2" { return (3.5, "+", "") } else if slot.preset == "K1SB_X K2" { return (3.5, "+", "") } else { return (0.0, "-", "") }
        case "K2 + K1SB_60 + SB28_60": if slot.preset == "K2" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (6.0, "-", "") }
        case "K2 + K1SB_60 + SB28_60_C": if slot.preset == "K2" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (0.5, "-", "") }
        case "K2 + K1SB_60 + SB28_60_Cx": if slot.preset == "K2" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (4.0, "-", "") }
        case "K2 + K1SB_X K2 + KS28_60": if slot.preset == "K2" { return (0.0, "+", "") } else if slot.preset == "K1SB_X K2" { return (0.0, "+", "") } else { return (0.0, "-", "") }
        case "K2 + K1SB_X K2 + KS28_60_C": if slot.preset == "K2" { return (5.5, "+", "") } else if slot.preset == "K1SB_X K2" { return (5.5, "+", "") } else { return (0.0, "-", "") }
        case "K2 + K1SB_X K2 + KS28_60_Cx": if slot.preset == "K2" { return (3.5, "+", "") } else if slot.preset == "K1SB_X K2" { return (3.5, "+", "") } else { return (0.0, "-", "") }
        case "K2 + K1SB_60 + KS28_60": if slot.preset == "K2" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (6.0, "-", "") }
        case "K2 + K1SB_60 + KS28_60_C": if slot.preset == "K2" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (0.5, "-", "") }
        case "K2 + K1SB_60 + KS28_60_Cx": if slot.preset == "K2" { return (6.0, "+", "") } else if slot.preset == "K1SB_60" { return (0.0, "+", "") } else { return (4.0, "-", "") }
        // K3 связки
        case "K3 + KS28_60": if slot.preset == "K3" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "K3 + KS28_60_C": if slot.preset == "K3" { return (6.0, "+", "") } else { return (0.0, "-", "") }
        case "K3 + KS28_60_Cx": if slot.preset == "K3" { return (4.0, "+", "") } else { return (0.0, "-", "") }
        case "K3 + KS21_60": if slot.preset == "K3" { return (0.0, "+", "") } else { return (0.0, "-", "") }
        case "K3 + KS21_60_C": if slot.preset == "K3" { return (5.5, "+", "") } else { return (0.0, "-", "") }
        case "K3 + KS21_60_Cx": if slot.preset == "K3" { return (5.0, "+", "") } else { return (0.0, "+", "") }
        // Kudo связки
        case "KUDOxx_60 + SB118_60": if slot.preset == "KUDOxx_60" { return (0.0, "+", "") } else { return (3.5, "+", "") }
        case "KUDOxx_60 + SB118_60_C": if slot.preset == "KUDOxx_60" { return (2.0, "+", "") } else { return (0.0, "+", "") }
        case "KUDOxx_60 + SB18_60": if slot.preset == "KUDOxx_60" { return (0.0, "+", "") } else { return (3.9, "+", "") }
        case "KUDOxx_60 + SB18_60_C": if slot.preset == "KUDOxx_60" { return (1.6, "+", "") } else { return (0.0, "+", "") }
        case "KUDOxx_60 + SB218_60": if slot.preset == "KUDOxx_60" { return (0.0, "+", "") } else { return (5.0, "+", "") }
        case "KUDOxx_60 + SB28_60": if slot.preset == "KUDOxx_60" { return (0.0, "+", "") } else { return (5.0, "+", "") }
        case "KUDOxx_60 + SB28_60_C": if slot.preset == "KUDOxx_60" { return (0.5, "+", "") } else { return (0.0, "+", "") }
        case "KUDOxx_60 + KS28_60": if slot.preset == "KUDOxx_60" { return (0.0, "+", "") } else { return (5.0, "+", "") }
        case "KUDOxx_60 + KS28_60_C": if slot.preset == "KUDOxx_60" { return (0.5, "+", "") } else { return (0.0, "+", "") }
        // Kara связки
        case "KARA II + SB18_100": if slot.preset == "KARA II" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA_II_FI + SB18_100": if slot.preset == "KARA_II_FI" { return (3.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA II_MO + SB18_100": if slot.preset == "KARA II_MO" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + SB18_100_C": if slot.preset == "KARA II" { return (5.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + SB18_100_Cx": if slot.preset == "KARA II" { return (4.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA_II_FI + SB18_100_C": if slot.preset == "KARA_II_FI" { return (8.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA_II_FI + SB18_100_Cx": if slot.preset == "KARA_II_FI" { return (7.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA II + SB18_60": if slot.preset == "KARA II" { return (2.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA II_MO + SB18_60": if slot.preset == "KARA II_MO" { return (2.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + SB18_60_C": if slot.preset == "KARA II" { return (8.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + SB18_60_Cx": if slot.preset == "KARA II" { return (6.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA + SB18_100": if slot.preset == "KARA" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA_FI + SB18_100": if slot.preset == "KARA_FI" { return (3.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA + SB18_100_C": if slot.preset == "KARA" { return (5.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA + SB18_100_Cx": if slot.preset == "KARA" { return (4.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA_FI + SB18_100_C": if slot.preset == "KARA_FI" { return (8.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA_FI + SB18_100_Cx": if slot.preset == "KARA_FI" { return (7.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA + SB18_60": if slot.preset == "KARA" { return (2.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA + SB18_60_C": if slot.preset == "KARA" { return (8.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA + SB18_60_Cx": if slot.preset == "KARA" { return (6.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA + KS21_60": if slot.preset == "KARA" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA + KS21_60_C": if slot.preset == "KARA" { return (6.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA + KS21_60_Cx": if slot.preset == "KARA" { return (5.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA + KS21_100": if slot.preset == "KARA" { return (0.0, "+", "") } else { return (0.5, "+", "") }
        case "KARA + KS21_100_C": if slot.preset == "KARA" { return (5.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA + KS21_100_Cx": if slot.preset == "KARA" { return (4.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA_FI + KS21_100": if slot.preset == "KARA_FI" { return (0.0, "+", "") } else { return (2.5, "-", "") }
        case "KARA_FI + KS21_100_C": if slot.preset == "KARA_FI" { return (3.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA_FI + KS21_100_Cx": if slot.preset == "KARA_FI" { return (2.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA + SB28_100": if slot.preset == "KARA" { return (0.0, "+", "") } else { return (1.0, "+", "") }
        case "KARA + SB28_100_C": if slot.preset == "KARA" { return (4.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA + SB28_100_Cx": if slot.preset == "KARA" { return (7.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA + SB28_60": if slot.preset == "KARA" { return (0.0, "+", "") } else { return (5.0, "-", "") }
        case "KARA + SB28_60_C": if slot.preset == "KARA" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA + SB28_60_Cx": if slot.preset == "KARA" { return (4.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA + KS28_100": if slot.preset == "KARA" { return (0.0, "+", "") } else { return (1.0, "+", "") }
        case "KARA + KS28_100_C": if slot.preset == "KARA" { return (4.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA + KS28_100_Cx": if slot.preset == "KARA" { return (7.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA + KS28_60": if slot.preset == "KARA" { return (0.0, "+", "") } else { return (5.0, "-", "") }
        case "KARA + KS28_60_C": if slot.preset == "KARA" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA + KS28_60_Cx": if slot.preset == "KARA" { return (4.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA + SB18_100 + SB28_60": if slot.preset == "KARA" { return (0.0, "+", "") } else if slot.preset == "SB18_100" { return (0.0, "+", "") } else { return (5.5, "-", "") }
        case "KARA + SB18_100 + SB28_60_C": if slot.preset == "KARA" { return (0.0, "+", "") } else if slot.preset == "SB18_100" { return (0.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA + SB18_100 + SB28_60_Cx": if slot.preset == "KARA" { return (5.5, "+", "") } else if slot.preset == "SB18_100" { return (5.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA + SB18_100 + KS28_60": if slot.preset == "KARA" { return (0.0, "+", "") } else if slot.preset == "SB18_100" { return (0.0, "+", "") } else { return (5.5, "-", "") }
        case "KARA + SB18_100 + KS28_60_C": if slot.preset == "KARA" { return (0.0, "+", "") } else if slot.preset == "SB18_100" { return (0.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA + SB18_100 + KS28_60_Cx": if slot.preset == "KARA" { return (5.5, "+", "") } else if slot.preset == "SB18_100" { return (5.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA + KS21_100 + SB28_60": if slot.preset == "KARA" { return (0.0, "+", "") } else if slot.preset == "KS21_100" { return (0.5, "+", "") } else { return (5.5, "-", "") }
        case "KARA + KS21_100 + SB28_60_C": if slot.preset == "KARA" { return (0.0, "+", "") } else if slot.preset == "KS21_100" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA + KS21_100 + SB28_60_Cx": if slot.preset == "KARA" { return (5.5, "+", "") } else if slot.preset == "KS21_100" { return (6.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA + KS21_100 + KS28_60": if slot.preset == "KARA" { return (0.0, "+", "") } else if slot.preset == "KS21_100" { return (0.0, "+", "") } else { return (5.5, "-", "") }
        case "KARA + KS21_100 + KS28_60_C": if slot.preset == "KARA" { return (0.0, "+", "") } else if slot.preset == "KS21_100" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA + KS21_100 + KS28_60_Cx": if slot.preset == "KARA" { return (5.5, "+", "") } else if slot.preset == "KS21_100" { return (6.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + KS21_60": if slot.preset == "KARA II" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA II + KS21_60_C": if slot.preset == "KARA II" { return (6.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA II + KS21_60_Cx": if slot.preset == "KARA II" { return (5.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA II_MO + KS21_60": if slot.preset == "KARA II_MO" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + KS21_100": if slot.preset == "KARA II" { return (0.0, "+", "") } else { return (0.5, "+", "") }
        case "KARA II + KS21_100_C": if slot.preset == "KARA II" { return (5.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + KS21_100_Cx": if slot.preset == "KARA II" { return (4.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA_II_FI + KS21_100": if slot.preset == "KARA_II_FI" { return (0.0, "+", "") } else { return (2.5, "-", "") }
        case "KARA_II_FI + KS21_100_C": if slot.preset == "KARA_II_FI" { return (3.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA_II_FI + KS21_100_Cx": if slot.preset == "KARA_II_FI" { return (2.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + SB28_100": if slot.preset == "KARA II" { return (0.0, "+", "") } else { return (1.0, "+", "") }
        case "KARA II + SB28_100_C": if slot.preset == "KARA II" { return (4.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + SB28_100_Cx": if slot.preset == "KARA II" { return (7.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA II + SB28_60": if slot.preset == "KARA II" { return (0.0, "+", "") } else { return (5.0, "-", "") }
        case "KARA II + SB28_60_C": if slot.preset == "KARA II" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA II + SB28_60_Cx": if slot.preset == "KARA II" { return (4.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + KS28_100": if slot.preset == "KARA II" { return (0.0, "+", "") } else { return (1.0, "+", "") }
        case "KARA II + KS28_100_C": if slot.preset == "KARA II" { return (4.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + KS28_100_Cx": if slot.preset == "KARA II" { return (7.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA II + KS28_60": if slot.preset == "KARA II" { return (0.0, "+", "") } else { return (5.0, "-", "") }
        case "KARA II + KS28_60_C": if slot.preset == "KARA II" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA II + KS28_60_Cx": if slot.preset == "KARA II" { return (4.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + SB18_100 + SB28_60": if slot.preset == "KARA II" { return (0.0, "+", "") } else if slot.preset == "SB18_100" { return (0.0, "+", "") } else { return (5.5, "-", "") }
        case "KARA II + SB18_100 + SB28_60_C": if slot.preset == "KARA II" { return (0.0, "+", "") } else if slot.preset == "SB18_100" { return (0.0, "+", "") } else { return (0.0, "-", "") }
        case "KARA II + SB18_100 + SB28_60_Cx": if slot.preset == "KARA II" { return (5.5, "+", "") } else if slot.preset == "SB18_100" { return (5.5, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + KS21_100 + SB28_60": if slot.preset == "KARA II" { return (0.0, "+", "") } else if slot.preset == "KS21_100" { return (0.5, "+", "") } else { return (5.5, "-", "") }
        case "KARA II + KS21_100 + SB28_60_C": if slot.preset == "KARA II" { return (0.0, "+", "") } else if slot.preset == "KS21_100" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA II + KS21_100 + SB28_60_Cx": if slot.preset == "KARA II" { return (5.5, "+", "") } else if slot.preset == "KS21_100" { return (6.0, "+", "") } else { return (0.0, "+", "") }
        case "KARA II + KS21_100 + KS28_60": if slot.preset == "KARA II" { return (0.0, "+", "") } else if slot.preset == "KS21_100" { return (0.0, "+", "") } else { return (5.5, "-", "") }
        case "KARA II + KS21_100 + KS28_60_C": if slot.preset == "KARA II" { return (0.0, "+", "") } else if slot.preset == "KS21_100" { return (0.5, "+", "") } else { return (0.0, "-", "") }
        case "KARA II + KS21_100 + KS28_60_Cx": if slot.preset == "KARA II" { return (5.5, "+", "") } else if slot.preset == "KS21_100" { return (6.0, "+", "") } else { return (0.0, "+", "") }
        // Kiva связки
        case "KIVA + KILO": if slot.preset == "KIVA" { return (0.0, "+", "") } else { return (1.5, "+", "") }
        case "KIVA_KILO + SB118_60": if slot.preset == "KIVA_KILO" { return (0.0, "+", "") } else { return (5.9, "+", "") }
        case "KIVA_KILO + SB118_60_C": if slot.preset == "KIVA_KILO" { return (0.0, "+", "") } else { return (0.4, "+", "") }
        case "KIVA_KILO + SB18_60": if slot.preset == "KIVA_KILO" { return (0.0, "+", "") } else { return (6.3, "+", "") }
        case "KIVA_KILO + SB18_60_C": if slot.preset == "KIVA_KILO" { return (0.0, "+", "") } else { return (0.8, "+", "") }
        case "KIVA + SB15_100": if slot.preset == "KIVA" { return (0.0, "+", "") } else { return (1.4, "+", "") }
        case "KIVA + SB15_100_C": if slot.preset == "KIVA" { return (2.4, "+", "") } else { return (0.0, "+", "") }
        case "KIVA_FI + SB15_100": if slot.preset == "KIVA_FI" { return (0.0, "+", "") } else { return (0.6, "+", "") }
        case "KIVA_SB15 + SB18_60": if slot.preset == "KIVA_SB15" { return (0.0, "+", "") } else { return (8.5, "+", "") }
        case "KIVA_SB15 + SB18_60_C": if slot.preset == "KIVA_SB15" { return (0.0, "+", "") } else { return (3.0, "+", "") }
        case "KIVA II + SB15_100": if slot.preset == "KIVA II" { return (0.0, "+", "") } else { return (1.0, "+", "") }
        case "KIVA II + SB15_100_C": if slot.preset == "KIVA II" { return (2.5, "+", "") } else { return (0.0, "+", "") }
        case "KIVA II + SB15_100_Cx": if slot.preset == "KIVA II" { return (4.5, "+", "") } else { return (0.0, "-", "") }
        case "KIVA II_FI + SB15_100": if slot.preset == "KIVA II_FI" { return (0.0, "+", "") } else { return (1.0, "+", "") }
        case "KIVA II_FI + SB15_100_C": if slot.preset == "KIVA II_FI" { return (2.5, "+", "") } else { return (0.0, "+", "") }
        case "KIVA II_FI + SB15_100_Cx": if slot.preset == "KIVA II_FI" { return (5.0, "+", "") } else { return (0.0, "-", "") }
        case "KIVA II + SB15_100 + SB18_60": if slot.preset == "KIVA II" { return (0.0, "+", "") } else if slot.preset == "SB15_100" { return (1.0, "+", "") } else { return (1.0, "-", "") }
        case "KIVA II + SB15_100 + SB18_60_C": if slot.preset == "KIVA II" { return (4.5, "+", "") } else if slot.preset == "SB15_100" { return (5.5, "+", "") } else { return (0.0, "-", "") }
        case "KIVA II + SB15_100 + SB18_60_Cx": if slot.preset == "KIVA II" { return (1.0, "+", "") } else if slot.preset == "SB15_100" { return (2.0, "+", "") } else { return (0.0, "+", "") }
        case "KIVA II + SB15_100_C + SB18_60": if slot.preset == "KIVA II" { return (2.5, "+", "") } else if slot.preset == "SB15_100_C" { return (0.0, "+", "") } else { return (3.5, "-", "") }
        case "KIVA II + SB15_100_C + SB18_60_C": if slot.preset == "KIVA II" { return (4.5, "+", "") } else if slot.preset == "SB15_100_C" { return (2.0, "+", "") } else { return (0.0, "-", "") }
        case "KIVA II + SB15_100_C + SB18_60_Cx": if slot.preset == "KIVA II" { return (3.0, "+", "") } else if slot.preset == "SB15_100_C" { return (0.5, "+", "") } else { return (0.0, "+", "") }
        // V-DOSC связки
        case "V-DOSC_xx_X + SB218_X": if slot.preset == "V-DOSC_xx_X" { return (1.8, "+", "") } else { return (0.0, "+", "") }
        case "V-DOSC_xx_60 + SB218_60": if slot.preset == "V-DOSC_xx_60" { return (0.0, "+", "") } else { return (3.8, "+", "") }
        case "V-DOSC_xx_60 + SB28_60": if slot.preset == "V-DOSC_xx_60" { return (0.0, "+", "") } else { return (3.8, "+", "") }
        case "V-DOSC_xx_60 + SB28_60_C": if slot.preset == "V-DOSC_xx_60" { return (1.7, "+", "") } else { return (0.0, "+", "") }
        case "V-DOSC_xx_60 + KS28_60": if slot.preset == "V-DOSC_xx_60" { return (0.0, "+", "") } else { return (3.8, "+", "") }
        case "V-DOSC_xx_60 + KS28_60_C": if slot.preset == "V-DOSC_xx_60" { return (1.7, "+", "") } else { return (0.0, "+", "") }
        case "V-DOSC_xx_X + dV-S_X": if slot.preset == "V-DOSC_xx_X" { return (0.0, "+", "") } else { return (0.2, "+", "") }
        case "V-DOSC_xx_60 + dV-S_60_ X + SB218_60": if slot.preset == "V-DOSC_xx_60" { return (0.0, "+", "") } else if slot.preset == "dV-S_60_ X" { return (0.2, "+", "") } else { return (3.7, "+", "") }
        case "V-DOSC_xx_60 + dV-S_60_ X + SB28_60": if slot.preset == "V-DOSC_xx_60" { return (0.0, "+", "") } else if slot.preset == "dV-S_60_ X" { return (0.2, "+", "") } else { return (3.7, "+", "") }
        case "V-DOSC_xx_60 + dV-S_60_ X + SB28_60_C": if slot.preset == "V-DOSC_xx_60" { return (1.9, "+", "") } else if slot.preset == "dV-S_60_ X" { return (2.0, "+", "") } else { return (0.0, "+", "") }
        case "V-DOSC_xx_60 + dV-S_60_ X + KS28_60": if slot.preset == "V-DOSC_xx_60" { return (0.0, "+", "") } else if slot.preset == "dV-S_60_ X" { return (0.2, "+", "") } else { return (3.7, "+", "") }
        case "V-DOSC_xx_60 + dV-S_60_ X + KS28_60_C": if slot.preset == "V-DOSC_xx_60" { return (1.9, "+", "") } else if slot.preset == "dV-S_60_ X" { return (2.0, "+", "") } else { return (0.0, "+", "") }
        case "V-DOSC_xx_60 + dV_xx_100": if slot.preset == "V-DOSC_xx_60" { return (0.0, "+", "") } else { return (0.04, "+", "") }
        // dV связки
        case "dV_xx_100 + SB118_100": if slot.preset == "dV_xx_100" { return (2.7, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + SB118_100_C": if slot.preset == "dV_xx_100" { return (8.3, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + SB218_100": if slot.preset == "dV_xx_100" { return (0.8, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + SB18_100": if slot.preset == "dV_xx_100" { return (2.4, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + SB18_100_C": if slot.preset == "dV_xx_100" { return (8.0, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + SB28_100": if slot.preset == "dV_xx_100" { return (0.8, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + SB28_100_C": if slot.preset == "dV_xx_100" { return (6.3, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + KS28_100": if slot.preset == "dV_xx_100" { return (0.8, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + KS28_100_C": if slot.preset == "dV_xx_100" { return (6.3, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + dV-S_100": if slot.preset == "dV_xx_100" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + dV-S_60_100 + SB118_60": if slot.preset == "dV_xx_100" { return (0.0, "+", "") } else if slot.preset == "dV-S_60_100" { return (0.75, "+", "") } else { return (4.0, "+", "") }
        case "dV_xx_100 + dV-S_60_100 + SB118_60_C": if slot.preset == "dV_xx_100" { return (1.5, "+", "") } else if slot.preset == "dV-S_60_100" { return (2.25, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + dV-S_60_100 + SB218_60": if slot.preset == "dV_xx_100" { return (0.0, "+", "") } else if slot.preset == "dV-S_60_100" { return (0.75, "+", "") } else { return (4.5, "+", "") }
        case "dV_xx_100 + dV-S_60_100 + SB18_60": if slot.preset == "dV_xx_100" { return (0.0, "+", "") } else if slot.preset == "dV-S_60_100" { return (0.75, "+", "") } else { return (4.4, "+", "") }
        case "dV_xx_100 + dV-S_60_100 + SB18_60_C": if slot.preset == "dV_xx_100" { return (1.1, "+", "") } else if slot.preset == "dV-S_60_100" { return (1.85, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + dV-S_60_100 + SB28_60": if slot.preset == "dV_xx_100" { return (0.0, "+", "") } else if slot.preset == "dV-S_60_100" { return (0.75, "+", "") } else { return (4.5, "+", "") }
        case "dV_xx_100 + dV-S_60_100 + SB28_60_C": if slot.preset == "dV_xx_100" { return (1.0, "+", "") } else if slot.preset == "dV-S_60_100" { return (1.75, "+", "") } else { return (0.0, "+", "") }
        case "dV_xx_100 + dV-S_60_100 + KS28_60": if slot.preset == "dV_xx_100" { return (0.0, "+", "") } else if slot.preset == "dV-S_60_100" { return (0.75, "+", "") } else { return (4.5, "+", "") }
        case "dV_xx_100 + dV-S_60_100 + KS28_60_C": if slot.preset == "dV_xx_100" { return (1.0, "+", "") } else if slot.preset == "dV-S_60_100" { return (1.75, "+", "") } else { return (0.0, "+", "") }
        // ARCS связки
        case "ARCS_xx_60 + SB118_60": if slot.preset == "ARCS_xx_60" { return (0.8, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_xx_60 + SB118_60_C": if slot.preset == "ARCS_xx_60" { return (6.3, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_xx_100 + SB118_100": if slot.preset == "ARCS_xx_100" { return (1.4, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_xx_100 + SB118_100_C": if slot.preset == "ARCS_xx_100" { return (6.9, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_xx_60 + SB18_60": if slot.preset == "ARCS_xx_60" { return (0.4, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_xx_60 + SB18_60_C": if slot.preset == "ARCS_xx_60" { return (5.9, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_xx_100 + SB18_100": if slot.preset == "ARCS_xx_100" { return (1.1, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_xx_100 + SB18_100_C": if slot.preset == "ARCS_xx_100" { return (6.6, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_xx_60 + SB218_60": if slot.preset == "ARCS_xx_60" { return (0.0, "+", "") } else { return (0.9, "+", "") }
        case "ARCS_xx_100 + SB218_100": if slot.preset == "ARCS_xx_100" { return (0.0, "+", "") } else { return (0.3, "+", "") }
        case "ARCS_xx_60 + SB28_60": if slot.preset == "ARCS_xx_60" { return (0.0, "+", "") } else { return (0.6, "+", "") }
        case "ARCS_xx_60 + SB28_60_C": if slot.preset == "ARCS_xx_60" { return (4.9, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_xx_100 + SB28_100": if slot.preset == "ARCS_xx_100" { return (0.0, "+", "") } else { return (0.5, "+", "") }
        case "ARCS_xx_100 + SB28_100_C": if slot.preset == "ARCS_xx_100" { return (5.0, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_xx_60 + KS28_60": if slot.preset == "ARCS_xx_60" { return (0.0, "+", "") } else { return (0.6, "+", "") }
        case "ARCS_xx_60 + KS28_60_C": if slot.preset == "ARCS_xx_60" { return (4.9, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_xx_100 + KS28_100": if slot.preset == "ARCS_xx_100" { return (0.0, "+", "") } else { return (0.5, "+", "") }
        case "ARCS_xx_100 + KS28_100_C": if slot.preset == "ARCS_xx_100" { return (5.0, "+", "") } else { return (0.0, "+", "") }
        case "ARCS II + SB28_60": if slot.preset == "ARCS II" { return (0.0, "+", "") } else { return (2.0, "+", "") }
        case "ARCS II + SB28_60_C": if slot.preset == "ARCS II" { return (3.5, "+", "") } else { return (0.0, "+", "") }
        case "ARCS II + SB28_60_Cx": if slot.preset == "ARCS II" { return (7.5, "+", "") } else { return (0.0, "-", "") }
        case "ARCS II + KS28_60": if slot.preset == "ARCS II" { return (0.0, "+", "") } else { return (2.0, "+", "") }
        case "ARCS II + KS28_60_C": if slot.preset == "ARCS II" { return (3.5, "+", "") } else { return (0.0, "+", "") }
        case "ARCS II + KS28_60_Cx": if slot.preset == "ARCS II" { return (7.5, "+", "") } else { return (0.0, "-", "") }
        case "ARCS_WIFO + SB18_60": if slot.preset == "ARCS_WIFO" { return (1.5, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_WIFO + SB18_60_C": if slot.preset == "ARCS_WIFO" { return (7.0, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_WIFO + SB18_60_Cx": if slot.preset == "ARCS_WIFO" { return (6.0, "+", "") } else { return (0.0, "-", "") }
        case "ARCS_WIFO_FI + SB18_60": if slot.preset == "ARCS_WIFO_FI" { return (1.5, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_WIFO_FI + SB18_60_C": if slot.preset == "ARCS_WIFO_FI" { return (7.0, "+", "") } else { return (0.0, "+", "") }
        case "ARCS_WIFO_FI + SB18_60_Cx": if slot.preset == "ARCS_WIFO_FI" { return (6.0, "+", "") } else { return (0.0, "-", "") }
        // A15 связки
        case "A15 + KS21_60": if slot.preset == "A15" { return (0.0, "+", "") } else { return (2.3, "+", "") }
        case "A15 + KS21_60_C": if slot.preset == "A15" { return (9.0, "+", "") } else { return (0.0, "-", "") }
        case "A15 + KS21_60_Cx": if slot.preset == "A15" { return (8.0, "+", "") } else { return (0.0, "-", "") }
        case "A15_FI + KS21_60": if slot.preset == "A15_FI" { return (0.0, "+", "") } else { return (2.3, "+", "") }
        case "A15_FI + KS21_60_C": if slot.preset == "A15_FI" { return (9.0, "+", "") } else { return (0.0, "-", "") }
        case "A15_FI + KS21_60_Cx": if slot.preset == "A15_FI" { return (8.0, "+", "") } else { return (0.0, "-", "") }
        case "A15_MO + KS21_60": if slot.preset == "A15_MO" { return (0.0, "+", "") } else { return (2.3, "+", "") }
        // A10 связки
        case "A10 + KS21_100": if slot.preset == "A10" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "A10 + KS21_100_C": if slot.preset == "A10" { return (5.5, "+", "") } else { return (0.0, "+", "") }
        case "A10 + KS21_100_Cx": if slot.preset == "A10" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "A10_FI + KS21_100": if slot.preset == "A10_FI" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "A10_FI + KS21_100_C": if slot.preset == "A10_FI" { return (5.5, "+", "") } else { return (0.0, "+", "") }
        case "A10_FI + KS21_100_Cx": if slot.preset == "A10_FI" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "A10_MO + KS21_100": if slot.preset == "A10_MO" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        // Syva связки
        case "SYVA + SYVA SUB_100": if slot.preset == "SYVA" { return (0.0, "+", "") } else { return (2.6, "+", "") }
        case "SYVA + SYVA LOW_100 + SYVA SUB_100": if slot.preset == "SYVA" { return (0.0, "+", "") } else if slot.preset == "SYVA LOW_100" { return (0.0, "+", "") } else { return (3.8, "+", "") }
        case "SYVA + SYVA LOW_100 + SB18_100": if slot.preset == "SYVA" { return (0.0, "+", "") } else if slot.preset == "SYVA LOW_100" { return (0.0, "+", "") } else { return (0.0, "-", "") }
        // Soka связки
        case "SOKA + SB6_100": if slot.preset == "SOKA" { return (1.4, "+", "") } else { return (0.0, "+", "") }
        case "SOKA_200 + SB6_200": if slot.preset == "SOKA_200" { return (1.9, "+", "") } else { return (0.0, "+", "") }
        case "SOKA_60 + SB6_60": if slot.preset == "SOKA_60" { return (3.6, "+", "") } else { return (0.0, "-", "") }
        case "SOKA + SB10_100": if slot.preset == "SOKA" { return (2.6, "+", "") } else { return (0.0, "+", "") }
        case "SOKA_200 + SB10_200": if slot.preset == "SOKA_200" { return (3.2, "+", "") } else { return (0.0, "+", "") }
        case "SOKA_60 + SB10_60": if slot.preset == "SOKA_60" { return (9.0, "+", "") } else { return (0.0, "-", "") }
        case "SOKA_60 + SYVA SUB_60": if slot.preset == "SOKA_60" { return (5.6, "+", "") } else { return (0.0, "+", "") }
        // X15 связки
        case "X15 + SB18_100": if slot.preset == "X15" { return (4.0, "+", "") } else { return (0.0, "-", "") }
        case "X15_MO + SB18_100": if slot.preset == "X15_MO" { return (0.0, "+", "") } else { return (1.0, "+", "") }
        case "X15 + SB18_100_C": if slot.preset == "X15" { return (9.7, "+", "") } else { return (0.0, "-", "") }
        case "X15 + SB18_100_Cx": if slot.preset == "X15" { return (8.25, "+", "") } else { return (0.0, "+", "") }
        case "X15 + KS21_100": if slot.preset == "X15" { return (0.0, "+", "") } else { return (1.5, "+", "") }
        case "X15_MO + KS21_100": if slot.preset == "X15_MO" { return (0.0, "+", "") } else { return (1.5, "+", "") }
        case "X15 + KS21_100_C": if slot.preset == "X15" { return (3.9, "+", "") } else { return (0.0, "+", "") }
        case "X15 + KS21_100_Cx": if slot.preset == "X15" { return (2.6, "+", "") } else { return (0.0, "-", "") }
        // X12 связки
        case "X12 + SB15_100": if slot.preset == "X12" { return (1.5, "+", "") } else { return (0.0, "-", "") }
        case "X12_MO + SB15_100": if slot.preset == "X12_MO" { return (0.0, "+", "") } else { return (2.85, "+", "") }
        case "X12 + SB15_100_C": if slot.preset == "X12" { return (5.1, "+", "") } else { return (0.0, "-", "") }
        case "X12 + SB15_100_Cx": if slot.preset == "X12" { return (3.0, "+", "") } else { return (0.0, "-", "") }
        case "X12 + SB18_100": if slot.preset == "X12" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "X12_MO + SB18_100": if slot.preset == "X12_MO" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "X12 + SB18_100_C": if slot.preset == "X12" { return (5.7, "+", "") } else { return (0.0, "+", "") }
        case "X12 + SB18_100_Cx": if slot.preset == "X12" { return (4.0, "+", "") } else { return (0.0, "-", "") }
        case "X12 + KS21_100": if slot.preset == "X12" { return (0.0, "+", "") } else { return (1.0, "+", "") }
        case "X12_MO + KS21_100": if slot.preset == "X12_MO" { return (0.0, "+", "") } else { return (0.4, "+", "") }
        case "X12 + KS21_100_C": if slot.preset == "X12" { return (4.8, "+", "") } else { return (0.0, "+", "") }
        case "X12 + KS21_100_Cx": if slot.preset == "X12" { return (3.4, "+", "") } else { return (0.0, "-", "") }
        // X8 связки
        case "X8 + SB10_100": if slot.preset == "X8" { return (0.0, "+", "") } else { return (3.2, "+", "") }
        case "X8 + SB15_100": if slot.preset == "X8" { return (2.0, "+", "") } else { return (0.0, "-", "") }
        case "X8_MO + SB15_100": if slot.preset == "X8_MO" { return (0.0, "+", "") } else { return (3.0, "+", "") }
        case "X8 + SB15_100_C": if slot.preset == "X8" { return (5.7, "+", "") } else { return (0.0, "-", "") }
        case "X8 + SB15_100_Cx": if slot.preset == "X8" { return (3.8, "+", "") } else { return (0.0, "-", "") }
        case "X8 + SYVA SUB_100": if slot.preset == "X8" { return (0.0, "+", "") } else { return (0.7, "+", "") }
        case "X8i + SB10_100": if slot.preset == "X8i" { return (0.0, "+", "") } else { return (0.5, "+", "") }
        case "X8i_40 + SB10_60": if slot.preset == "X8i_40" { return (0.0, "+", "") } else { return (3.0, "+", "") }
        case "X8i + SYVA SUB_100": if slot.preset == "X8i" { return (0.0, "+", "") } else { return (0.0, "-", "") }
        case "X8i_40 + SYVA SUB_60": if slot.preset == "X8i_40" { return (3.5, "+", "") } else { return (0.0, "-", "") }
        case "X8i + KS21_100": if slot.preset == "X8i" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "X8i_40 + KS21_60": if slot.preset == "X8i_40" { return (4.8, "+", "") } else { return (0.0, "+", "") }
        // X6i связки
        case "X6i + SB6_200": if slot.preset == "X6i" { return (0.0, "+", "") } else { return (0.0, "-", "") }
        case "X6i + SB6_100": if slot.preset == "X6i" { return (0.0, "+", "") } else { return (1.2, "+", "") }
        case "X6i_50 + SB6_60": if slot.preset == "X6i_50" { return (0.0, "+", "") } else { return (2.0, "+", "") }
        case "X6i + SB10_200": if slot.preset == "X6i" { return (1.4, "+", "") } else { return (0.0, "-", "") }
        case "X6i + SB10_100": if slot.preset == "X6i" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "X6i_50 + SB10_60": if slot.preset == "X6i_50" { return (0.0, "+", "") } else { return (6.8, "-", "") }
        case "X6i_50 + SYVA SUB_60": if slot.preset == "X6i_50" { return (0.0, "+", "") } else { return (0.4, "+", "") }
        // 5XT связки
        case "5XT + SB15_100": if slot.preset == "5XT" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        case "5XT_MO + SB15_100": if slot.preset == "5XT_MO" { return (0.2, "+", "") } else { return (0.0, "+", "") }
        case "5XT + SB10_100": if slot.preset == "5XT" { return (0.0, "+", "") } else { return (1.6, "-", "") }
        case "5XT_MO + SB10_100": if slot.preset == "5XT_MO" { return (0.0, "+", "") } else { return (1.6, "-", "") }
        // X4 связки
        case "X4 + SYVA SUB_200": if slot.preset == "X4" { return (0.0, "+", "") } else { return (0.5, "+", "") }
        case "X4_MO + SYVA SUB_200": if slot.preset == "X4_MO" { return (0.0, "+", "") } else { return (0.5, "+", "") }
        case "X4_60 + SB6_60": if slot.preset == "X4_60" { return (1.8, "+", "") } else { return (0.0, "-", "") }
        case "X4 + SB6_100": if slot.preset == "X4" { return (0.0, "+", "") } else { return (0.4, "+", "") }
        case "X4_MO + SB6_100": if slot.preset == "X4_MO" { return (0.0, "+", "") } else { return (0.4, "+", "") }
        case "X4 + SB6_200": if slot.preset == "X4" { return (0.6, "+", "") } else { return (0.0, "+", "") }
        case "X4_MO + SB6_200": if slot.preset == "X4_MO" { return (0.6, "+", "") } else { return (0.0, "+", "") }
        case "X4_60 + SB10_60": if slot.preset == "X4_60" { return (7.2, "+", "") } else { return (0.0, "-", "") }
        case "X4 + SB10_100": if slot.preset == "X4" { return (0.8, "+", "") } else { return (0.0, "+", "") }
        case "X4_MO + SB10_100": if slot.preset == "X4_MO" { return (0.8, "+", "") } else { return (0.0, "+", "") }
        case "X4 + SB10_200": if slot.preset == "X4" { return (1.9, "+", "") } else { return (0.0, "-", "") }
        case "X4_MO + SB10_200": if slot.preset == "X4_MO" { return (0.0, "+", "") } else { return (0.0, "+", "") }
        // HiQ связки
        case "HIQ_FI_100 + SB118_100": if slot.preset == "HIQ_FI_100" { return (2.6, "+", "") } else { return (0.0, "+", "") }
        case "HIQ_FR_100 + SB118_100": if slot.preset == "HIQ_FR_100" { return (2.6, "+", "") } else { return (0.0, "+", "") }
        case "HIQ_MO_100 + SB118_100": if slot.preset == "HIQ_MO_100" { return (2.5, "+", "") } else { return (0.0, "+", "") }
        case "HIQ_FI_100 + SB18_100": if slot.preset == "HIQ_FI_100" { return (2.3, "+", "") } else { return (0.0, "+", "") }
        case "HIQ_FR_100 + SB18_100": if slot.preset == "HIQ_FR_100" { return (2.3, "+", "") } else { return (0.0, "+", "") }
        case "HIQ_MO_100 + SB18_100": if slot.preset == "HIQ_MO_100" { return (2.2, "+", "") } else { return (0.0, "+", "") }
        case "HIQ_FI_100 + dV-S_100": if slot.preset == "HIQ_FI_100" { return (0.6, "+", "") } else { return (0.0, "+", "") }
        case "HIQ_FR_100 + dV-S_100": if slot.preset == "HIQ_FR_100" { return (0.6, "+", "") } else { return (0.0, "+", "") }
        case "HIQ_MO_100 + dV-S_100": if slot.preset == "HIQ_MO_100" { return (0.5, "+", "") } else { return (0.0, "+", "") }
        // 12XTA связки
        case "12XTA_FI_100 + SB118_100": if slot.preset == "12XTA_FI_100" { return (2.6, "+", "") } else { return (0.0, "+", "") }
        case "12XTA_FR_100 + SB118_100": if slot.preset == "12XTA_FR_100" { return (2.6, "+", "") } else { return (0.0, "+", "") }
        case "12XTA_MO_100 + SB118_100": if slot.preset == "12XTA_MO_100" { return (2.5, "+", "") } else { return (0.0, "+", "") }
        case "12XTA_FI_100 + SB18_100": if slot.preset == "12XTA_FI_100" { return (2.3, "+", "") } else { return (0.0, "+", "") }
        case "12XTA_FR_100 + SB18_100": if slot.preset == "12XTA_FR_100" { return (2.3, "+", "") } else { return (0.0, "+", "") }
        case "12XTA_MO_100 + SB18_100": if slot.preset == "12XTA_MO_100" { return (2.2, "+", "") } else { return (0.0, "+", "") }
        // 12XTP связки
        case "12XTP_FI_100 + SB118_100": if slot.preset == "12XTP_FI_100" { return (2.4, "+", "") } else { return (0.0, "+", "") }
        case "12XTP_FR_100 + SB118_100": if slot.preset == "12XTP_FR_100" { return (2.4, "+", "") } else { return (0.0, "+", "") }
        case "12XTP_MO_100 + SB118_100": if slot.preset == "12XTP_MO_100" { return (2.4, "+", "") } else { return (0.0, "+", "") }
        case "12XTP_FI_100 + SB18_100": if slot.preset == "12XTP_FI_100" { return (2.1, "+", "") } else { return (0.0, "+", "") }
        case "12XTP_FR_100 + SB18_100": if slot.preset == "12XTP_FR_100" { return (2.1, "+", "") } else { return (0.0, "+", "") }
        case "12XTP_MO_100 + SB18_100": if slot.preset == "12XTP_MO_100" { return (2.1, "+", "") } else { return (0.0, "+", "") }
        // 8XT связки
        case "8XT_FI_100 + SB118_100": if slot.preset == "8XT_FI_100" { return (3.1, "+", "") } else { return (0.0, "+", "") }
        case "8XT_FR_100 + SB118_100": if slot.preset == "8XT_FR_100" { return (3.2, "+", "") } else { return (0.0, "+", "") }
        case "8XT_MO_100 + SB118_100": if slot.preset == "8XT_MO_100" { return (3.0, "+", "") } else { return (0.0, "+", "") }
        case "8XT_FI_100 + SB18_100": if slot.preset == "8XT_FI_100" { return (2.8, "+", "") } else { return (0.0, "+", "") }
        case "8XT_FR_100 + SB18_100": if slot.preset == "8XT_FR_100" { return (2.9, "+", "") } else { return (0.0, "+", "") }
        case "8XT_MO_100 + SB18_100": if slot.preset == "8XT_MO_100" { return (2.7, "+", "") } else { return (0.0, "+", "") }
        // 115XT связки
        case "115XT_FI_100 + SB118_100": if slot.preset == "115XT_FI_100" { return (2.6, "+", "") } else { return (0.0, "+", "") }
        case "115XT_FR_100 + SB118_100": if slot.preset == "115XT_FR_100" { return (2.5, "+", "") } else { return (0.0, "+", "") }
        case "115XT_MO_100 + SB118_100": if slot.preset == "115XT_MO_100" { return (2.9, "+", "") } else { return (0.0, "+", "") }
        case "115XT_FI_100 + SB18_100": if slot.preset == "115XT_FI_100" { return (2.3, "+", "") } else { return (0.0, "+", "") }
        case "115XT_FR_100 + SB18_100": if slot.preset == "115XT_FR_100" { return (2.2, "+", "") } else { return (0.0, "+", "") }
        case "115XT_MO_100 + SB18_100": if slot.preset == "115XT_MO_100" { return (2.6, "+", "") } else { return (0.0, "+", "") }
        // 115bA связки
        case "115bA_FI_100 + SB118_100": if slot.preset == "115bA_FI_100" { return (2.4, "+", "") } else { return (0.0, "+", "") }
        case "115bA_FR_100 + SB118_100": if slot.preset == "115bA_FR_100" { return (2.5, "+", "") } else { return (0.0, "+", "") }
        case "115bA_MO_100 + SB118_100": if slot.preset == "115bA_MO_100" { return (2.7, "+", "") } else { return (0.0, "+", "") }
        case "115bA_FI_100 + SB18_100": if slot.preset == "115bA_FI_100" { return (2.1, "+", "") } else { return (0.0, "+", "") }
        case "115bA_FR_100 + SB18_100": if slot.preset == "115bA_FR_100" { return (2.0, "+", "") } else { return (0.0, "+", "") }
        case "115bA_MO_100 + SB18_100": if slot.preset == "115bA_MO_100" { return (2.4, "+", "") } else { return (0.0, "+", "") }
        // 115bP связки
        case "115bP_FI_100 + SB118_100": if slot.preset == "115bP_FI_100" { return (2.1, "+", "") } else { return (0.0, "+", "") }
        case "115bP_FR_100 + SB118_100": if slot.preset == "115bP_FR_100" { return (2.2, "+", "") } else { return (0.0, "+", "") }
        case "115bP_MO_100 + SB118_100": if slot.preset == "115bP_MO_100" { return (2.8, "+", "") } else { return (0.0, "+", "") }
        case "115bP_FI_100 + SB18_100": if slot.preset == "115bP_FI_100" { return (1.8, "+", "") } else { return (0.0, "+", "") }
        case "115bP_FR_100 + SB18_100": if slot.preset == "115bP_FR_100" { return (1.9, "+", "") } else { return (0.0, "+", "") }
        case "115bP_MO_100 + SB18_100": if slot.preset == "115bP_MO_100" { return (2.5, "+", "") } else { return (0.0, "+", "") }
        // 112XT связки
        case "112XT_FI_100 + SB118_100": if slot.preset == "112XT_FI_100" { return (2.3, "+", "") } else { return (0.0, "+", "") }
        case "112XT_FR_100 + SB118_100": if slot.preset == "112XT_FR_100" { return (2.3, "+", "") } else { return (0.0, "+", "") }
        case "112XT_MO_100 + SB118_100": if slot.preset == "112XT_MO_100" { return (2.6, "+", "") } else { return (0.0, "+", "") }
        case "112XT_FI_100 + SB18_100": if slot.preset == "112XT_FI_100" { return (2.0, "+", "") } else { return (0.0, "+", "") }
        case "112XT_FR_100 + SB18_100": if slot.preset == "112XT_FR_100" { return (2.0, "+", "") } else { return (0.0, "+", "") }
        case "112XT_MO_100 + SB18_100": if slot.preset == "112XT_MO_100" { return (2.3, "+", "") } else { return (0.0, "+", "") }
        // 112b связки
        case "112b_FI_100 + SB118_100": if slot.preset == "112b_FI_100" { return (2.4, "+", "") } else { return (0.0, "+", "") }
        case "112b_FR_100 + SB118_100": if slot.preset == "112b_FR_100" { return (2.5, "+", "") } else { return (0.0, "+", "") }
        case "112b_MO_100 + SB118_100": if slot.preset == "112b_MO_100" { return (3.0, "+", "") } else { return (0.0, "+", "") }
        case "112b_FI_100 + SB18_100": if slot.preset == "112b_FI_100" { return (2.1, "+", "") } else { return (0.0, "+", "") }
        case "112b_FR_100 + SB18_100": if slot.preset == "112b_FR_100" { return (2.2, "+", "") } else { return (0.0, "+", "") }
        case "112b_MO_100 + SB18_100": if slot.preset == "112b_MO_100" { return (2.7, "+", "") } else { return (0.0, "+", "") }
        // 108a связки
        case "108a_FI_100 + SB118_100": if slot.preset == "108a_FI_100" { return (3.5, "+", "") } else { return (0.0, "+", "") }
        case "108a_FR_100 + SB118_100": if slot.preset == "108a_FR_100" { return (3.6, "+", "") } else { return (0.0, "+", "") }
        case "108a_MO_100 + SB118_100": if slot.preset == "108a_MO_100" { return (4.0, "+", "") } else { return (0.0, "+", "") }
        case "108a_FI_100 + SB18_100": if slot.preset == "108a_FI_100" { return (3.2, "+", "") } else { return (0.0, "+", "") }
        case "108a_FR_100 + SB18_100": if slot.preset == "108a_FR_100" { return (3.3, "+", "") } else { return (0.0, "+", "") }
        case "108a_MO_100 + SB18_100": if slot.preset == "108a_MO_100" { return (3.7, "+", "") } else { return (0.0, "+", "") }
        default: return (0.0, "+", "Unknown preset combination: \(key)")
        }
    }
    return (0.0, "+", "Invalid number of slots: \(allPresets.count)")
}
