# Acid Lab — Concept & Curriculum

> A hands-on, first-principles course for building a **TB-303-style acid synth**, a
> drum machine, and a step sequencer — entirely in the browser with Web Audio.
> End state: a small "Korg DS-10"-like groovebox we can use to generate acid /
> chiptune-ish loops for a small arcade game.

This file is the **stable design doc**: the concept, the curriculum, the tech
choices, and the conventions. Day-to-day progress lives in `STATUS.md`.

---

## Who this is for

- Strong CS background, **little to no formal music knowledge**.
- Loves acid house / classic + progressive. Wants to *understand* the sound, not
  just use a plugin.
- Learning-first: correctness and clarity over production polish. Every lesson
  should be a small, self-contained, tweakable page that makes one idea click.

## Why acid is the perfect teacher

The Roland TB-303 (1981, a commercial flop resurrected by Chicago house — Phuture's
*Acid Tracks*, 1987) is almost the minimal synthesizer:

- **1 oscillator** — saw *or* square, that's it.
- **1 low-pass filter** — 4-pole (24 dB/oct) with resonance. This is the soul.
- **1 envelope** — short, plucky, modulating the filter.
- **accent** and **slide** — two per-step tricks that create the "squelch" and the
  liquid gliding pitch.
- a **16-step sequencer**.

Master those six things and you understand subtractive synthesis, filters,
envelopes, and sequencing — the foundation of *all* electronic music.

---

## The signal chain we are building toward

```
                 ┌──────────── the 303 voice ────────────┐
  sequencer ──►  OSC (saw/sq) ──► 4-pole LP FILTER ──► VCA ──►  ┐
   (pitch,        ▲   ▲              ▲     ▲            ▲        │
    gate,         │   │              │     │            │        ├─► drive ─► delay ─► reverb ─► OUT
    accent,      tune slide       cutoff  reso    amp env        │
    slide)                          ▲                            │
                            filter env (env mod + decay)         │
                                                                 │
  drum machine ──► [kick] [snare] [hats] [clap]  ──────────────►─┘
   (16 steps)
```

Everything upstream of "drive" is per-voice; drive/delay/reverb are the shared
"acid glue". Delay especially — dub delay is 50% of the acid vibe.

---

## Curriculum

Each lesson is a single folder under `lessons/NN-slug/` with an `index.html`.
Lessons build on each other but each one *runs on its own*. A lesson is "done"
when you can open it, hear the concept, and tweak it.

### Module 0 — Sound & Web Audio primitives
- **00 · Oscillator & the scope** — what sound *is*: frequency=pitch,
  amplitude=loudness, waveform=timbre. Sine/square/saw/triangle on an
  oscilloscope + spectrum. *Why saw is the acid oscillator* (rich harmonics to
  carve). `OscillatorNode`, `AnalyserNode`.  ✅ built
- **01 · Gain & envelopes (the VCA/ADSR)** — shaping loudness over time. Pluck vs
  pad. `GainNode`, `AudioParam` ramps (`setValueAtTime`,
  `linearRampToValueAtTime`, `setTargetAtTime`).

### Module 1 — The filter (the heart of acid)
- **02 · Low-pass filter & cutoff** — subtractive synthesis: start bright, carve.
  Sweep the cutoff, watch harmonics disappear on the spectrum. `BiquadFilterNode`.
- **03 · Resonance & the squelch** — Q, the whistle, self-oscillation. 12 vs
  24 dB/oct → why we chain two biquads for the 303's steeper slope.
- **04 · (optional) A real ladder filter** — `AudioWorkletNode` diode/transistor
  ladder for authentic self-oscillating acid. Custom DSP.

### Module 2 — Building the 303 voice
- **05 · The voice** — wire osc → 4-pole LP → VCA. One playable mono synth.
- **06 · Filter envelope: Env Mod + Decay** — the plucky filter movement. This is
  the moment it starts sounding *acid*.
- **07 · Accent** — per-note emphasis: louder + brighter + snappier envelope.
- **08 · Slide / glide** — portamento between legato notes (the liquid pitch).
- **09 · (optional) Drive / saturation** — `WaveShaperNode` for the dirty edge.
- Outcome: a full "303 panel" — Tuning, Cutoff, Resonance, Env Mod, Decay, Accent.

### Module 3 — Rhythm & timing
- **10 · The clock problem** — why `setTimeout` can't keep musical time; the
  lookahead scheduler ("A Tale of Two Clocks"). BPM → 16th notes → transport.
  *This is the CS-flavoured centrepiece.*
- **11 · Synthesizing drums** — 808/909 from scratch: kick (sine + pitch env),
  snare (noise + tone), hats (filtered noise), clap.
- **12 · The drum machine** — a 16-step grid triggering the drum voices.

### Module 4 — The sequencer
- **13 · 303 step sequencer** — pitch per step, gate (note / rest / tie), accent,
  slide. Looping patterns wired into the module-2 voice.
- **14 · Scales & making it sound "right"** — *just enough theory*: semitones,
  octaves, a scale as a bit-mask. Minor / phrygian / pentatonic — why acid leans
  dark and chromatic.
- **15 · (optional) Pattern chaining / song mode.**

### Module 5 — The groovebox (capstone)
- **16 · DS-10 clone** — 2 synth tracks + drums + sequencer + master delay/reverb.
  Pattern save/load (localStorage + JSON export). Optional WAV render / recording.

### Module 6 — Applied: music for the game
- **17 · Generative acid** — Euclidean rhythms, scale-constrained random-walk
  melodies, probability-driven accents/slides → procedural loops for the arcade
  game. Very CS-friendly.
- **18 · Shipping it** — offline render vs live engine, mobile audio unlock,
  latency, memory. How the loops actually get into the game.

---

## Tech choices & libraries

Deliberately **layered** — raw Web Audio first so nothing is magic, then
libraries once the primitive is understood.

| Concern | Choice | When |
|---|---|---|
| Core audio | **Web Audio API** (raw) | everywhere; the whole point |
| Scheduling/transport | hand-rolled lookahead scheduler, then **Tone.js** | 10+ (build it, then use it) |
| Custom DSP | **AudioWorklet** | 04, advanced |
| Visualization | Canvas + `AnalyserNode` (scope/spectrum) | throughout |
| Knobs / grids / keys | **NexusUI** or **webaudio-controls** | 05+ |
| MIDI (optional) | **Web MIDI API** | late/optional |

Principle: **teach the primitive raw, then allow the library.** Lesson 10 builds
the scheduler by hand *specifically so* Tone.js isn't a black box afterward.

---

## Repo conventions

```
AGENTS.md              this file — concept + curriculum (stable)
STATUS.md              progress tracker (changes often)
README.md              how to run
index.html             hub linking every lesson
lessons/NN-slug/       one self-contained lesson per folder
lib/                   shared helpers (added when reuse appears, not before)
vendor/                pinned local copies of libs (if we stop using CDNs)
assets/                images, impulse responses, etc.
```

- **Self-contained first.** Early lessons are single HTML files that work from
  `file://`. We introduce a shared `lib/` only when duplication actually hurts.
- **Comment for a CS reader who doesn't know audio.** Explain the *audio* idea;
  assume the *programming* is understood.
- **Visual + audible.** If a lesson changes the sound, it should also change
  something on screen (scope, spectrum, meter).

## Running

Lesson 00 opens directly (`file://`). Later lessons that use ES modules,
`AudioWorklet`, or `fetch` need a static server:

```bash
python3 -m http.server 8000     # then open http://localhost:8000
# or:  npx serve
```

## Working agreement (for the AI assistant)

- Update `STATUS.md` as lessons are built; keep this file for the durable plan.
- Checkpoint-commit per lesson (or per meaningful chunk).
- Prefer clarity and small steps over big drops. Brainstorm before big changes.
