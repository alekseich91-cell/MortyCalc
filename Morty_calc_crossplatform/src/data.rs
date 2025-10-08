//! Data handling for MortyCalc.
//!
//! This module is responsible for loading the reference data used by
//! the calculator.  The upstream Swift project encoded its tables
//! directly in code; here we extract those tables into a JSON file
//! (`data.json`) that is included at compile time.  Using a
//! structured representation via `serde` makes it easy to access
//! tops, subs, presets and delay information without having to
//! maintain a massive Rust source file.
//!
//! The JSON file defines four top‑level keys:
//!
//! * `tops` — an array of strings representing full‑range loudspeakers.
//! * `subs` — an array of strings representing subwoofers.
//! * `speaker_presets` — a map from speaker name to an array of preset names.
//! * `delay_data` — a map whose key is a combination of preset names
//!   joined by ` + ` in lexicographical order.  Each value is an
//!   array of tuples `(preset, delay_ms, polarity)`.  The delay is
//!   measured in milliseconds and polarity is a string (`"+"` or
//!   `"-"`).  When calculating a delay for a given preset the
//!   application looks up the combination of all selected presets and
//!   finds the tuple whose first element matches the preset in
//!   question.

use once_cell::sync::Lazy;
use serde::Deserialize;
use std::collections::HashMap;

/// Rust representation of the JSON data file.
#[derive(Debug, Deserialize)]
pub struct RawData {
    /// Array of full‑range loudspeakers.
    pub tops: Vec<String>,
    /// Array of subwoofer models.
    pub subs: Vec<String>,
    /// Mapping from speaker names to available presets.
    pub speaker_presets: HashMap<String, Vec<String>>,
    /// Mapping from canonical preset combinations to delay/polarity data.
    pub delay_data: HashMap<String, Vec<(String, f32, String)>>,
}

/// Lazily parsed global instance of `RawData`.
///
/// The `include_str!` macro embeds the contents of `data.json` into the
/// binary at compile time.  When the `RAW_DATA` value is first
/// accessed the JSON is parsed using `serde_json`, ensuring that the
/// parsing overhead occurs only once.
pub static RAW_DATA: Lazy<RawData> = Lazy::new(|| {
    let json_str = include_str!("data.json");
    serde_json::from_str(json_str).expect("failed to parse data.json")
});

/// Helper to canonicalise a set of preset strings into a key used
/// within `delay_data`.  The presets are sorted lexicographically
/// (case sensitive) and concatenated with ` + ` separators.
pub fn canonical_key<I, S>(presets: I) -> String
where
    I: IntoIterator<Item = S>,
    S: AsRef<str>,
{
    let mut vec: Vec<String> = presets.into_iter().map(|s| s.as_ref().to_string()).collect();
    vec.sort_unstable();
    vec.join(" + ")
}