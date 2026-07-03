# Status

Progress tracker for Acid Lab. See `AGENTS.md` for the concept & full curriculum.

**Last updated:** 2026-07-02

## Legend
`⬜ planned` · `🟨 in progress` · `✅ done` · `⏭️ optional/skipped`

## Lessons

| # | Lesson | State | Notes |
|---|--------|-------|-------|
| P1 | What is sound? (prologue) | ✅ done | ELI5 rewrite of the old one-page prologue: air wiggles → clicks-fuse-into-a-note morph, pitch/loudness sliders, octave ×2, 12 steps, keyboard+MIDI, harmonics stack |
| P2 | Scales & the acid mood (prologue) | ✅ done | intervals, interactive scale index (w/ 2026-07-02 playback fixes: correct root, per-scale chord, lands home, keys flash), modes, West vs East microtones, cheat-sheet |
| P3 | Sound as numbers (prologue) | ✅ done | NEW: CS side of audio — sampling canvas, Nyquist fold sweep you can hear, bitcrush demos, buffers/latency readout, synthesize sine/square/saw/noise from a for-loop |
| 00 | Oscillator & the scope | ✅ done | vanilla Web Audio, scope + spectrum, 4 waveforms |
| 01 | Gain & envelopes (ADSR) | ✅ done | VCA + ADSR, live envelope graph w/ playhead, presets |
| 02 | Low-pass filter & cutoff | ✅ done | single biquad lowpass (Q=0.707, reso saved for 03), live getFrequencyResponse curve + cutoff marker on log spectrum, bypass A/B, auto-sweep, saw/square/noise sources |
| 03 | Resonance & the squelch | ✅ done | reso knob (Q in dB on stage 2 only), 12/24 dB slope toggle (chained biquads), impulse "ping" that rings at cutoff, dB-scale response curve. 2026-07-03: reworked ★ squelch from a slow held sweep (clipped to 2.17, sounded like a pad) into a plucky repeating A-minor-pentatonic riff w/ per-note filter env (env-mod+decay preview) via mini lookahead scheduler; added resonance makeup-gain so high-Q no longer clips |
| 04 | Ladder filter (AudioWorklet) | ⏭️ optional | |
| 05 | The 303 voice | ✅ done | first assembly: osc(saw/sq) → 24 dB filter → VCA amp env, monophonic (held-note stack, last-note priority), playable keyboard (mouse + A..K, Z/X octave), cutoff/reso/amp-decay/vol, live filter curve, signal-chain diagram. Filter env deferred to 06 |
| 06 | Filter env: Env Mod + Decay | ✅ done | per-note envelope on both biquads' cutoff (floor→peak→floor, exp decay); Env Mod (0..4 oct) + Decay hero knobs; live env-shape graph + moving cutoff marker; hands-free "acid line" riff (lookahead scheduler); reuses lesson-03 resonance make-up |
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
- **Now:** Prologue (3 ELI5 parts), Module 0 (00 + 01), Module 1 (02 + 03 —
  the filter), and Module 2 up through the filter envelope (05 voice + 06 env)
  all live. The core 303 voice now sounds properly acid.
  Old `prologue-theory/` URL redirects to P1.
- **Next:** Lesson 07 (Accent) — per-note emphasis: louder + brighter + snappier
  envelope on accented steps. Then 08 (Slide/glide). Lesson 04 (AudioWorklet
  ladder) stays optional.

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
- 2026-07-02: **Pace = lesson-by-lesson** (build one, Valentin tries it, continue).
- 2026-07-02: **Filter = chained biquads first** (24 dB/oct), AudioWorklet ladder
  kept as the optional deep-dive (04).
- 2026-07-02: **Game target = web** (JS/Canvas/Phaser/Pixi). Big implication: the
  synth/sequencer engine we build can be embedded live in the game — Module 6
  favours a reusable JS engine over rendering loops to files.
- 2026-07-03: **iOS touch hardening** on all 8 widget pages (ported from
  Mudline's pattern): viewport `maximum-scale=1,user-scalable=no`,
  `-webkit-touch-callout/user-select/tap-highlight` off, `format-detection=no`,
  JS veto of `gesture*`/`contextmenu` — so the long-press loupe, tap flash and
  pinch/double-tap zoom stop fighting the sliders & keyboard. Deviation from
  Mudline: body is NOT pinned (`touch-action:pan-x pan-y`, no `overflow:hidden`)
  so the lesson text still scrolls. Side effect: lesson text is no longer
  selectable — revisit if copy/zoom accessibility is wanted on the reading pages.
  `touch-action:pan-x pan-y` lives on the `*` selector (touch-action doesn't
  inherit, so an `auto` `<p>` would still double-tap-zoom); sliders + `#kbwrap`
  override to `none`.
