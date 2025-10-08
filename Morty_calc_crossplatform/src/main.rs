//! MortyCalc Rust GUI application
//!
//! This program is a re‑implementation of the original Swift‑based
//! MortyCalc utility in Rust using the `eframe` crate for the
//! graphical user interface.  The goal is to replicate the core
//! functionality: selecting loudspeakers and presets, computing
//! appropriate delays and polarities based upon manufacturer data,
//! and optionally applying a geometric delay derived from two
//! distance measurements.  The application is designed to run on
//! both macOS and Windows without modification.
//!
//! ## Sections
//! 1. **Struct Definitions** – data structures used to represent the
//!    application state.
//! 2. **Helper Methods** – functions implementing the business
//!    logic: computing geometric delay, validating combinations and
//!    adjusting delays.
//! 3. **`eframe::App` Implementation** – rendering the GUI and
//!    responding to user input.
//! 4. **Main Entry Point** – sets up logging and launches the GUI.

use eframe::{egui, egui::ComboBox};
use log::{error, info, warn};
use simplelog::{Config as LogConfig, LevelFilter, WriteLogger};
use std::fs::File;

mod data;
use data::{canonical_key, RAW_DATA};

/// Represents a speaker slot in the UI.  Each slot holds the
/// currently selected speaker and preset and stores the resulting
/// delay and polarity once calculated.
#[derive(Debug, Clone)]
struct SpeakerSlot {
    id: usize,
    selected_speaker: Option<String>,
    selected_preset: Option<String>,
    delay_ms: Option<f32>,
    polarity: Option<String>,
}

impl SpeakerSlot {
    /// Creates a new empty slot with a unique identifier.
    fn new(id: usize) -> Self {
        Self {
            id,
            selected_speaker: None,
            selected_preset: None,
            delay_ms: None,
            polarity: None,
        }
    }
}

/// Application state for the MortyCalc GUI.  It holds the dynamic
/// list of speaker slots, user inputs for geometric calculations and
/// various UI flags.
#[derive(Debug, Default)]
struct MortyCalcApp {
    slots: Vec<SpeakerSlot>,
    distance_a: String,
    distance_b: String,
    geo_delay: Option<f32>,
    geo_advice: String,
    /// Indicates whether the geometric delay should be added to top
    /// speakers (when `Some(true)`) or to subwoofers (when
    /// `Some(false)`).  When `None` no geometric delay is applied.
    geo_delay_is_top: Option<bool>,
    apply_geo_to_presets: bool,
    warning: Option<String>,
}

impl MortyCalcApp {
    /// Initialise the application with a single empty slot and empty
    /// distance fields.
    fn new() -> Self {
        Self {
            slots: vec![SpeakerSlot::new(0)],
            distance_a: String::new(),
            distance_b: String::new(),
            geo_delay: None,
            geo_advice: String::new(),
            geo_delay_is_top: None,
            apply_geo_to_presets: false,
            warning: None,
        }
    }

    /// Parse the distance fields and compute the geometric delay.
    ///
    /// The formula from the original application is `(distance_b -
    /// distance_a) * 2.9` where the distances are entered in meters and
    /// the result is returned in milliseconds.  The advice string
    /// describes whether the delay should be added to the top or sub
    /// speaker.  On parsing failure an error is logged and the delay
    /// is cleared.
    fn calculate_geo_delay(&mut self) {
        let a: f32 = match self.distance_a.trim().replace(',', ".").parse() {
            Ok(v) => v,
            Err(e) => {
                warn!("Invalid distance A: {e}");
                self.geo_delay = None;
                self.geo_advice = String::from("Введите корректные дистанции.");
                return;
            }
        };
        let b: f32 = match self.distance_b.trim().replace(',', ".").parse() {
            Ok(v) => v,
            Err(e) => {
                warn!("Invalid distance B: {e}");
                self.geo_delay = None;
                self.geo_advice = String::from("Введите корректные дистанции.");
                return;
            }
        };
        let signed_delay = (b - a) * 2.9f32;
        let delay_abs = signed_delay.abs();
        // Round to one decimal place for display as in the Swift code
        let delay_rounded = (delay_abs * 10.0).round() / 10.0;
        self.geo_delay = Some(delay_rounded);
        // Determine where to apply the delay and update advice.
        // A positive signed delay means the sub distance (B) is greater
        // than the top distance (A), so the top is closer and must be
        // delayed to align with the later sub.  A negative signed delay
        // means the sub is closer, so the sub must be delayed.  This
        // mirrors the logic of the original Swift implementation.
        if signed_delay > 0.0 {
            // Sub is further (B > A); add delay to the top (closer) speaker.
            self.geo_delay_is_top = Some(true);
            self.geo_advice = String::from("Добавьте задержку в топ.");
        } else if signed_delay < 0.0 {
            // Sub is closer (B < A); add delay to the sub speaker.
            self.geo_delay_is_top = Some(false);
            self.geo_advice = String::from("Добавьте задержку в саб.");
        } else {
            // Distances equal; no delay needed
            self.geo_delay_is_top = None;
            self.geo_advice = String::from("Задержка не требуется.");
        }
        info!("Calculated geometric delay: {} ms", delay_rounded);
        // Automatically recompute results if necessary
        if self.apply_geo_to_presets {
            self.recompute_results();
        }
    }

    /// Determine if the currently selected combination of presets is
    /// valid, i.e. present in the `delay_data` table.  Returns
    /// `Some(canonical_key)` if valid, otherwise logs a warning and
    /// returns `None`.
    fn validate_combination(&mut self) -> Option<String> {
        // Collect selected presets
        let presets: Vec<String> = self
            .slots
            .iter()
            .filter_map(|slot| slot.selected_preset.clone())
            .collect();
        if presets.is_empty() {
            self.warning = Some(String::from(
                "Пожалуйста, выберите хотя бы один пресет для расчёта."
            ));
            return None;
        }
        // If all presets are identical there is nothing to calculate
        let all_same = presets.windows(2).all(|w| w[0] == w[1]);
        if all_same {
            self.warning = Some(String::from(
                "Все выбранные пресеты одинаковы, задержка 0 ms."
            ));
            // set results to zero and plus polarity
            for slot in &mut self.slots {
                slot.delay_ms = Some(0.0);
                slot.polarity = Some(String::from("+"));
            }
            return None;
        }
        // Maximum of 3 presets supported
        if presets.len() > 3 {
            self.warning = Some(String::from(
                "Превышено максимальное количество пресетов (3)."
            ));
            return None;
        }
        // Build canonical key
        let key = canonical_key(&presets);
        if !RAW_DATA.delay_data.contains_key(&key) {
            self.warning = Some(format!("Комбинация {key} не найдена."));
            return None;
        }
        self.warning = None;
        Some(key)
    }

    /// Compute base delays and polarities for each slot using the
    /// `delay_data` table.  Returns a vector of base delays and
    /// polarities in the same order as the slots.  If the lookup
    /// fails the result vector will be empty.
    fn compute_base_delays(&mut self, key: &str) -> Vec<(f32, String)> {
        let mut results = Vec::new();
        let entry = match RAW_DATA.delay_data.get(key) {
            Some(e) => e,
            None => {
                error!("Delay data missing for key {key}");
                return results;
            }
        };
        for slot in &self.slots {
            let preset = match &slot.selected_preset {
                Some(p) => p,
                None => {
                    results.push((0.0, String::from("+")));
                    continue;
                }
            };
            // Find the tuple whose preset matches
            let mut found = false;
            for (pr, delay, pol) in entry {
                if pr == preset {
                    results.push((*delay, pol.clone()));
                    found = true;
                    break;
                }
            }
            if !found {
                warn!("Preset {} not found in delay entry for key {key}", preset);
                results.push((0.0, String::from("+")));
            }
        }
        results
    }

    /// Adjust the base delays by applying the geometric delay to top
    /// speakers and normalising the minimum delay to zero when
    /// positive.  This mirrors the behaviour of the Swift
    /// implementation's `adjustDelay` function.
    fn apply_adjustments(&self, base_delays: Vec<(f32, String)>) -> Vec<(f32, String)> {
        let geo = self.geo_delay.unwrap_or(0.0);
        let mut adjusted: Vec<(f32, String)> = Vec::new();
        // Early exit if geometric delay should not be applied
        let mut delays: Vec<f32> = Vec::new();
        for (i, (delay, _pol)) in base_delays.iter().enumerate() {
            let mut d = *delay;
            if self.apply_geo_to_presets {
                if let Some(sign_top) = self.geo_delay_is_top {
                    let slot = &self.slots[i];
                    let is_top = slot
                        .selected_speaker
                        .as_ref()
                        .map(|s| RAW_DATA.tops.contains(s))
                        .unwrap_or(false);
                    // Apply geo delay either to tops or subs depending on sign_top
                    if (sign_top && is_top) || (!sign_top && !is_top) {
                        d += geo;
                    }
                }
            }
            delays.push(d);
        }
        // Normalise: subtract minimum if positive
        if let Some(min_d) = delays.iter().cloned().reduce(f32::min) {
            if min_d > 0.0 {
                for d in delays.iter_mut() {
                    *d -= min_d;
                }
            }
        }
        // Combine with polarities
        for ((_, pol), d) in base_delays.into_iter().zip(delays.into_iter()) {
            adjusted.push((d, pol));
        }
        adjusted
    }

    /// Determine whether `subseq` appears in order within `seq`.
    /// This helper is equivalent to the Swift extension `contains(subsequence:)`
    /// used in the original project.  Elements of `subseq` must appear in
    /// `seq` in the same order but not necessarily contiguously.
    fn contains_subsequence(seq: &[String], subseq: &[String]) -> bool {
        if subseq.is_empty() {
            return true;
        }
        let mut index = 0usize;
        for target in subseq {
            match seq[index..].iter().position(|x| x == target) {
                Some(pos) => {
                    index += pos + 1;
                }
                None => return false,
            }
        }
        true
    }

    /// Return the list of speakers available for the given slot based on
    /// other selected presets and the original categorisation (slot 0 =
    /// tops, slot > 0 = subs).  This replicates the logic of
    /// `filteredSpeakers` in the Swift UI.
    fn filtered_speakers(&self, slot_index: usize) -> Vec<String> {
        // Determine whether this slot should list tops or subs
        let base_list: Vec<String> = if slot_index == 0 {
            RAW_DATA.tops.iter().cloned().collect()
        } else {
            RAW_DATA.subs.iter().cloned().collect()
        };
        // Gather presets from other slots
        let mut other_presets: Vec<String> = self
            .slots
            .iter()
            .enumerate()
            .filter_map(|(i, s)| if i != slot_index { s.selected_preset.clone() } else { None })
            .filter(|p| !p.is_empty())
            .collect();
        other_presets.sort();
        if other_presets.is_empty() {
            // If no other presets, return speakers with at least one preset
            return base_list
                .into_iter()
                .filter(|sp| {
                    RAW_DATA
                        .speaker_presets
                        .get(sp)
                        .map(|v| !v.is_empty())
                        .unwrap_or(false)
                })
                .collect::<Vec<_>>();
        }
        use std::collections::HashSet;
        let mut possible: HashSet<String> = HashSet::new();
        for (key, _value) in RAW_DATA.delay_data.iter() {
            let mut presets_in_key: Vec<String> = key.split(" + ").map(|s| s.to_string()).collect();
            presets_in_key.sort();
            if Self::contains_subsequence(&presets_in_key, &other_presets) {
                let remaining: Vec<String> = presets_in_key
                    .into_iter()
                    .filter(|p| !other_presets.contains(p))
                    .collect();
                for preset in remaining {
                    // find a speaker in base_list whose presets contain this preset
                    for spk in &base_list {
                        if let Some(list) = RAW_DATA.speaker_presets.get(spk) {
                            if list.contains(&preset) {
                                possible.insert(spk.clone());
                                break;
                            }
                        }
                    }
                }
            }
        }
        let mut res: Vec<String> = possible.into_iter().collect();
        res.sort();
        res
    }

    /// Return the list of presets available for the given slot based on
    /// the selected speaker and other presets.  This mirrors the
    /// `filteredPresets` computed property from the Swift UI.
    fn filtered_presets(&self, slot_index: usize) -> Vec<String> {
        let slot = &self.slots[slot_index];
        let speaker = match &slot.selected_speaker {
            Some(s) => s,
            None => return vec![],
        };
        let base_presets: Vec<String> = RAW_DATA
            .speaker_presets
            .get(speaker)
            .cloned()
            .unwrap_or_default();
        // Collect other presets
        let mut other_presets: Vec<String> = self
            .slots
            .iter()
            .enumerate()
            .filter_map(|(i, s)| if i != slot_index { s.selected_preset.clone() } else { None })
            .filter(|p| !p.is_empty())
            .collect();
        other_presets.sort();
        if other_presets.is_empty() {
            return base_presets;
        }
        use std::collections::HashSet;
        let mut possible: HashSet<String> = HashSet::new();
        for (key, _value) in RAW_DATA.delay_data.iter() {
            let mut presets_in_key: Vec<String> = key.split(" + ").map(|s| s.to_string()).collect();
            presets_in_key.sort();
            if Self::contains_subsequence(&presets_in_key, &other_presets) {
                let remaining: Vec<String> = presets_in_key
                    .into_iter()
                    .filter(|p| !other_presets.contains(p))
                    .collect();
                for preset in remaining {
                    if base_presets.contains(&preset) {
                        possible.insert(preset.clone());
                    }
                }
            }
        }
        let mut res: Vec<String> = possible.into_iter().collect();
        res.sort();
        res
    }

    /// Recompute and apply delays and polarities if the current
    /// combination is valid.  This is used to automatically update
    /// results when geometric delay or its application toggles change.
    fn recompute_results(&mut self) {
        if let Some(key) = self.validate_combination() {
            let base = self.compute_base_delays(&key);
            let adjusted = self.apply_adjustments(base);
            for (slot, (delay, pol)) in self.slots.iter_mut().zip(adjusted.into_iter()) {
                slot.delay_ms = Some(delay);
                slot.polarity = Some(pol);
            }
        }
    }
}

impl eframe::App for MortyCalcApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        egui::CentralPanel::default().show(ctx, |ui| {
            ui.heading("MortyCalc (Rust edition)");
            ui.add_space(10.0);
            // Distance inputs for geometric delay
            ui.horizontal(|ui| {
                ui.label("Расстояние A (м):");
                ui.text_edit_singleline(&mut self.distance_a);
                ui.label("Расстояние B (м):");
                ui.text_edit_singleline(&mut self.distance_b);
                if ui.button("Рассчитать гео задержку").clicked() {
                    self.calculate_geo_delay();
                }
            });
            // Show computed geometric delay and advice
            if let Some(d) = self.geo_delay {
                ui.label(format!("Геометрическая задержка: {d:.1} ms"));
                ui.label(&self.geo_advice);
            }
            ui.add_space(10.0);
            // Toggle for applying geometric delay to presets and button to calculate
            ui.horizontal(|ui| {
                let resp = ui.checkbox(&mut self.apply_geo_to_presets, "Применить геометрический делей к пресетам");
                if resp.changed() {
                    // recompute results immediately when toggled
                    self.recompute_results();
                }
                if ui.button("Рассчитать гео задержку").clicked() {
                    self.calculate_geo_delay();
                }
            });
            ui.add_space(10.0);
            // Speaker slots UI
            // Because removing an element inside an iteration invalidates
            // indexes, we capture a removal index and delete after the
            // loop completes.
            let mut remove_idx: Option<usize> = None;
            // Iterate over slots by index rather than iterating directly over
            // mutable references.  This allows computing filtered lists
            // (immutable borrows) before taking a mutable reference to each slot.
            for i in 0..self.slots.len() {
                // Precompute available speakers and presets for this slot using
                // immutable borrows of `self`.  This avoids borrow conflicts
                // when later mutably accessing `self.slots[i]` in the UI.
                let available_speakers = self.filtered_speakers(i);
                let available_presets = self.filtered_presets(i);
                ui.group(|ui| {
                    let slot = &mut self.slots[i];
                    // If current speaker is no longer valid, reset it and its preset
                    if let Some(ref sp) = slot.selected_speaker {
                        if !available_speakers.contains(sp) {
                            slot.selected_speaker = None;
                            slot.selected_preset = None;
                        }
                    }
                    // If current preset is no longer valid, reset it
                    if let Some(ref pr) = slot.selected_preset {
                        if !available_presets.contains(pr) {
                            slot.selected_preset = None;
                        }
                    }
                    // Build horizontal layout for controls
                    ui.horizontal(|ui| {
                        ui.label(format!("Слот {}:", i + 1));
                        // Speaker selection filtered based on other presets and slot index
                        ComboBox::from_id_source(format!("speaker_{i}"))
                            .selected_text(slot.selected_speaker.as_deref().unwrap_or("Выберите колонку"))
                            .show_ui(ui, |ui| {
                                for spk in available_speakers.iter() {
                                    ui.selectable_value(&mut slot.selected_speaker, Some(spk.clone()), spk.as_str());
                                }
                            });
                        // Preset selection filtered based on speaker and other presets
                        ComboBox::from_id_source(format!("preset_{i}"))
                            .selected_text(slot.selected_preset.as_deref().unwrap_or("Выберите пресет"))
                            .show_ui(ui, |ui| {
                                for pr in available_presets.iter() {
                                    ui.selectable_value(&mut slot.selected_preset, Some(pr.clone()), pr.as_str());
                                }
                            });
                        // Remove slot button
                        if ui.button("Удалить").clicked() {
                            remove_idx = Some(i);
                        }
                    });
                    // Display result if available
                    if let (Some(delay), Some(pol)) = (slot.delay_ms, slot.polarity.as_ref()) {
                        ui.label(format!("Задержка: {delay:.1} ms, Полярность: {pol}"));
                    }
                });
                ui.add_space(5.0);
            }
            // Perform removal after iteration
            if let Some(idx) = remove_idx {
                self.slots.remove(idx);
                // Early return to avoid using stale indexes
                return;
            }
            // Add new slot button
            if self.slots.len() < 3 {
                if ui.button("Добавить слот").clicked() {
                    let new_id = self.slots.len();
                    self.slots.push(SpeakerSlot::new(new_id));
                }
            }
            ui.add_space(10.0);
            // Calculate button
            if ui.button("Вычислить задержки").clicked() {
                if let Some(key) = self.validate_combination() {
                    let base = self.compute_base_delays(&key);
                    let adjusted = self.apply_adjustments(base);
                    for (slot, (delay, pol)) in self.slots.iter_mut().zip(adjusted.into_iter()) {
                        slot.delay_ms = Some(delay);
                        slot.polarity = Some(pol);
                    }
                }
            }
            // Warning message
            if let Some(ref warning) = self.warning {
                ui.colored_label(egui::Color32::RED, warning);
            }
            // Reset button
            if ui.button("Сбросить").clicked() {
                *self = MortyCalcApp::new();
            }

            // Add author credit, contact link and disclaimer below the controls
            ui.add_space(10.0);
            ui.horizontal(|ui| {
                ui.label("Made by Lunia");
                // Add a hyperlink to the Telegram handle.  When clicked this
                // opens the specified URL in the user's browser.
                ui.hyperlink_to("@lunevilia", "https://t.me/lunevilia");
            });
            ui.label("Эту программу написал не программист, а энтузиаст с нейросетью. На основании мануала к Lacoustic и возможно, здравой логики. Если обнаружится баг, глюк или неточность - пишите в телегу поправим.");
        });
    }
}

/// Main entry point.  Sets up a simple file logger and launches the
/// GUI.  Errors during logger initialisation are ignored and will
/// result in logging to the standard error output.
fn main() {
    // Initialise logging to a file in the working directory.  If the
    // file cannot be created the logger falls back to standard error.
    let _ = WriteLogger::init(
        LevelFilter::Info,
        LogConfig::default(),
        File::create("mortycalc.log").unwrap_or_else(|_| File::create("/dev/null").unwrap()),
    );
    info!("Starting MortyCalc application");
    let native_options = eframe::NativeOptions::default();
    eframe::run_native(
        "MortyCalc", 
        native_options, 
        Box::new(|_cc| Box::new(MortyCalcApp::new())),
    ).expect("Failed to launch application");
}