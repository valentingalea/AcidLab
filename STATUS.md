# Status

Progress tracker for Acid Lab. See `AGENTS.md` for the concept & full curriculum.

**Last updated:** 2026-07-02

## Legend
`⬜ planned` · `🟨 in progress` · `✅ done` · `⏭️ optional/skipped`

## Lessons

| # | Lesson | State | Notes |
|---|--------|-------|-------|
| 00 | Oscillator & the scope | ✅ done | vanilla Web Audio, scope + spectrum, 4 waveforms |
| 01 | Gain & envelopes (ADSR) | ⬜ planned | |
| 02 | Low-pass filter & cutoff | ⬜ planned | |
| 03 | Resonance & the squelch | ⬜ planned | |
| 04 | Ladder filter (AudioWorklet) | ⏭️ optional | |
| 05 | The 303 voice | ⬜ planned | |
| 06 | Filter env: Env Mod + Decay | ⬜ planned | |
| 07 | Accent | ⬜ planned | |
| 08 | Slide / glide | ⬜ planned | |
| 09 | Drive / saturation | ⏭️ optional | |
| 10 | The clock problem (scheduler) | ⬜ planned | CS centrepiece |
| 11 | Synthesizing drums | ⬜ planned | |
| 12 | The drum machine | ⬜ planned | |
| 13 | 303 step sequencer | ⬜ planned | |
| 14 | Scales & melody | ⬜ planned | |
| 15 | Pattern chaining | ⏭️ optional | |
| 16 | DS-10 groovebox (capstone) | ⬜ planned | |
| 17 | Generative acid | ⬜ planned | for the game |
| 18 | Shipping it | ⬜ planned | for the game |

## Now / Next
- **Now:** Module 0 started. Lesson 00 built and playable.
- **Next:** Lesson 01 (envelopes) → then Module 1 (the filter), where it starts
  to sound like acid.

## Open questions (to align with Valentin)
1. Build pace: lesson-by-lesson with a checkpoint each, or a few at a time?
2. Library taste for knobs/grids: NexusUI (clean, code-y) vs webaudio-controls
   (photoreal hardware knobs)?
3. Authenticity vs simplicity for the filter: chained biquads (easy, 90% there)
   or go all the way to an AudioWorklet ladder (authentic, more DSP)?
4. Game target: what engine/framework is the arcade game in? Affects Module 6.

## Decisions log
- 2026-07-02: Raw Web Audio first, Tone.js later (build the scheduler by hand in
  lesson 10 before using Tone). Lessons self-contained until reuse justifies a
  shared `lib/`.
