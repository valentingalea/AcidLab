# Status

Progress tracker for Acid Lab. See `AGENTS.md` for the concept & full curriculum.

**Last updated:** 2026-07-05

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
| 04 | Under the hood — real hardware | ✅ done | (was optional; built as a hardware deep-dive on request) real analog VCO (capacitor-ramp sawtooth animation + exp converter / 1V-oct / temp-drift), the 303's actual circuits (single VCO, diode-ladder VCF = transistors-as-diodes, ~18 dB, interacting poles, tuned NOT to self-oscillate, Devil Fish), then the real ladder as an **AudioWorklet** (inline Blob URL, 4× TPT one-pole cascade + tanh feedback + noise seed) that **self-oscillates** (biquad A/B, "🎵 filter sings a tune" via cutoff). Web-checked facts |
| 05 | The 303 voice | ✅ done | first assembly: osc(saw/sq) → 24 dB filter → VCA amp env, monophonic (held-note stack, last-note priority), playable keyboard (mouse + A..K, Z/X octave), cutoff/reso/amp-decay/vol, live filter curve, signal-chain diagram. Filter env deferred to 06 |
| ♬ | Interlude · Mono vs poly | ✅ done | voice-allocation demo built on request (follow-up to polyphony chat): pool of 6 persistent voices, VOICES knob (1=mono), chord buttons, live voice-rack showing each note grab a free voice or steal the oldest (red flash); readout narrates "N notes → V voices → S stolen"; ties back to shared-patch/global-tone point |
| ♪ | Interlude · Notes vs tone | ✅ done | conceptual bridge built on request (Valentin: "how do notes affect the sound? 16 A's and a G in the middle — what is that?"). A note = an oscillator frequency; a bassline = a list of them fed to osc.frequency per step. Big live Hz readout, tappable 16-step note lane w/ "16 A's" / "put a G" presets, separate TONE(cutoff) knob to show tune vs tone are independent axes |
| 303 | Interlude · The TB-303 story | ✅ done | history (Roland's failed bass machine → DJ Pierre/Phuture discovery → Acid Tracks 1987) + how the real 303 is programmed; same bassline "tame vs live acid morph" demo, 16-step sequencer grid w/ playhead, panel-map of every knob→lesson. Reuses 00–06 voice, web-searched facts, sits after 06 |
| 06 | Filter env: Env Mod + Decay | ✅ done | per-note envelope on both biquads' cutoff (floor→peak→floor, exp decay); Env Mod (0..4 oct) + Decay hero knobs; live env-shape graph + moving cutoff marker; hands-free "acid line" riff (lookahead scheduler); reuses lesson-03 resonance make-up. 2026-07-03 fix: riff sounded monotone/no-squelch — amp died to silence before the filter swept; now the note rings to ~0.28·L across the step so the sweep is audible, + baked-in accent groove (louder+brighter notes, preview of 07), punchier defaults (reso 14, floor 220, EnvMod 80) |
| 07 | Accent | ✅ done | ACCENT amount knob + clickable 16-step accent grid; accented steps scale 3 things by amount (amp ×(1+0.9a) louder, filter-env peak ×(1+a) brighter, filter decay ×(1−0.45a) snappier); playhead, live spectrum. Reuses 06 voice |
| 08 | Slide / glide | ✅ done | per-step slide flag → osc.frequency exp-ramp (portamento) into next note + legato tie (slid-into note skips amp attack & filter-env retrigger; note before a slide holds gate open); SLIDE TIME knob; pitch-over-time graph (diagonal=glide, vertical=jump) w/ gliding playhead; completes the 303 voice |
| 09 | Drive / saturation | ✅ done | (was optional; built on request) WaveShaperNode drive stage after the voice: DRIVE pre-gain + clean/soft(tanh)/hard(clamp)/fold(sin) curves, 4× oversample; live transfer-curve viz w/ signal dots + output scope; drive×resonance = the hard-acid scream (Hardfloor/Josh Wink framing) |
| 10 | The clock problem (scheduler) | ✅ done | CS centrepiece: A/B 16th-note metronome — naïve recursive setTimeout (plays on callback, drifts/jitters) vs lookahead scheduler (queues onto ctx.currentTime ~100ms ahead); 💣 main-thread busy-loop stressor exposes the difference; live beat-spacing-error bar viz + worst-jitter readout; "two clocks" framing |
| 11 | Synthesizing drums | ✅ done | 808/909 kit from scratch: kick (sine + pitch-drop env), snare (2 triangles body + HP noise snap), closed/open hat (HP noise, short/long decay), clap (4 stutter noise bursts + tail via bandpass). Playable pads (+A S D F G keys), scope, tune/decay/snap/brightness knobs, demo beat on the lesson-10 scheduler |
| 12 | The drum machine | ✅ done | 16-step × 5-drum grid (pattern = {drum:bool[16]}) firing lesson-11 voices on the lesson-10 scheduler; playhead via scheduled-time queue, tempo + swing (odd-step delay), house/techno/breaks/clear presets, tap-name row mute. Completes the rhythm half |
| 13 | 303 step sequencer | ✅ done | working TB-303: lesson-08 voice (slide/legato + accent) driven by an editable per-step grid on the lesson-10 scheduler; full 303 panel + presets + 🎲 random-walk generator, playhead. 2026-07-03: added OCT row (per-step octave switch ±12, the real 303 control) + a scale selector (min pent / nat minor / phrygian / phryg dom / harm minor / chromatic) — Phryg dom/harm minor = eastern/"Arabic" acid (P2 maqam-Hijaz); pitch now scale-index + 12·oct |
| 14 | Scales & melody | ✅ folded | not a standalone page — content lives in P2 (scales/modes/maqam), lesson 13's scale selector + octave row, and lesson 17's scale-locked random-walk generator |
| 15 | Pattern chaining | ⏭️ optional | not built — song-mode / chaining patterns into an arrangement, an optional future extension |
| 16 | Groovebox (capstone) | ✅ done | the 303 acid sequencer (13) + drum machine (12) on ONE shared lesson-10 scheduler (shared swing); master glue = tempo-synced dub delay (DelayNode+feedback, dotted-8th) + synthesised convolver reverb (procedural noise IR); acidBus/drumBus → dry + sends → master; 🎲 new jam, drum presets, full 303 panel. Loads a groove by default — press play = a track. 2026-07-03: acid grid gained the OCT row + scale selector (same as 13) — can do Arabic-flavoured acid over the beat |
| 17 | Generative acid | ✅ done | the two algorithms: Euclidean drums (per-drum pulses slider → `(i·k)%n<k` even spread, Bjorklund-equivalent) + scale-constrained random-walk melody (bounded degree walk on the scale mask, density/wander/octave/accent/slide knobs, scale selector). Reuses 303 voice + kit + clock + baked dub delay; generated patterns render on editable grids; framing = seed→loop for scoring the game |
| 18 | Shipping it | ✅ done | **course finale.** one buildEngine() used for both the live ctx and an OfflineAudioContext render; ⏺ render 2 bars offline (reports ms + N× realtime + KB), ▶ play baked buffer (loop), ⬇ download .wav (44-byte header + int16 PCM, no lib); live audio-unlock badge (suspended→running via onstatechange); live-vs-baked / latency / memory / into-the-game framing + a full-course TOC |

### Bonus chapter — The Korg DS-10 (`lessons/ds10-*`)
Meet the machine the course was aimed at. Interlude-style named slugs (no
renumbering). Spec agreed with Valentin 2026-07-04: a chapter of a few lessons —
(1) history + Kaoss X/Y, (2) DS-10 vs 303, (3) the rest of its features.

**Images (2026-07-04, Valentin's ask):** real DS-10 screenshots + hardware photos
sprinkled in at the point being explained, sourced into `assets/` (local copies,
not hotlinks). Hardware = free-licensed Wikimedia Commons (MS-10 public-domain,
MS-20 CC0, Nintendo DS Lite CC BY-SA 3.0 — attributed in captions/footers); DS-10
UI shots = fair-use "review" per Valentin (© Korg/AQ Interactive, from the Wikipedia
box art + the tinyloops walkthrough). Every image was eyeballed via the Read tool
before captioning so nothing is mislabeled (e.g. the file named `ds-song.jpg` is
actually a step-grid, captioned as such; the Kaoss button-1/button-3 shots map onto
lesson 1's play/ride modes). Verified: all decode in-browser, 0 × 404, 0 JS errors,
functional suites still green.

| # | Lesson | State | Notes |
|---|--------|-------|-------|
| DS-1 | The DS-10 story + Kaoss pad | ✅ done | web-checked history (Korg MS-10 1978: 1 VCO, 12 dB filter, MS-20 patch cords; Nobuyoshi Sano — Ridge Racer/Tekken composer, first synth an MS-10 — sees the Nintendo DS as an MS synth; Cavia builds, AQ Interactive ships KORG DS-10 in 2008; 2 synths + drums + seq + **8-player wireless jam**; team → Detune). New interactive: the **Kaoss X/Y pad** on the reused 05–08 voice — **ride** mode (X=cutoff log-mapped, Y=reso Q, over a looping acid line) + **play** mode (X=scale-quantised pitch that glides via lesson-08 portamento, Y=brightness); canvas pad w/ fading trail + crosshair, pointer-capture, `touch-action:none`. Panel-map DS-10 feature→lesson. Headless-verified: osc starts, loop scheduler drives freq/gain, ride readout (cutoff+Q), play plays notes (E4), play-btn disabled in play mode, 0 JS errors |
| DS-2 | DS-10 vs the TB-303 | ✅ done | one looping acid line (reused 05–08 voice) with a **filter-slope A/B** — 303 = 2 cascaded biquads (4-pole/24 dB, reso on f2) vs DS-10 = 1 biquad (2-pole/12 dB, reso on f1, f2 pinned open) — over a live product-of-active-biquads response curve + spectrum, so you *see* the skirt double. Plus the **LFO patch cord** (`lfo→gain→ACTIVE[0].frequency`, ±320 Hz wobble) the 303 has no socket for; disconnect/reconnects correctly across slope flips. cutoff/reso sliders retarget the right stage. Same/different comparison table + "make acid on a DS-10" recipe. Headless-verified: osc+lfo start, slope var 24↔12 + ACTIVE len 2↔1, LFO patch schedules gain, back-to-303 while patched OK, sliders live, 0 JS errors |
| DS-3 | The rest of the DS-10 | ✅ done | feature tour, anchored by the one unbuilt DS-10 concept: an interactive **patch panel** — a 2×3 matrix cabling two sources (**LFO** / **EG**) into three dests (**pitch** / **cutoff** / **amp**) over a repeating note + time-domain scope. LFO cords = real graph wires (`lfo→gain→param`, toggled by depth 0↔[45¢/360Hz/0.11]); EG cords = per-note scheduled ramps (EG→Cutoff = the lesson-06 acid pluck, EG→Pitch = blip, EG→Amp = snappy stab). Narrative panels for the rest, each linking where it was already built: 2 synths (05/mono-vs-poly, +VCO2 ring-mod), drums-are-synths (11), 6-track/16-step seq + song-mode-is-a-playlist (10/12/13/16), fx/8-player-jam/DS-10 PLUS. Finale → AcidBox = your DS-10. Headless-verified: osc+lfo start, LFO cord schedules gain + caption, EG cord arms, run schedules notes, unplug-all clears, 0 JS errors |

The chapter is a self-contained set of named-slug lessons after 00–18; the hub
gets a "Bonus chapter · The Korg DS-10" section. No renumbering of the course.

## Now / Next
- **THE COURSE IS COMPLETE — every lesson built, headless-verified, and live.**
  Prologue (P1–P3) → 303 voice (00–09, incl. the 04 hardware / ladder-worklet
  deep-dive) → interludes (303 story · notes-vs-tone · mono-vs-poly) →
  rhythm/clock/drums (10–12) → sequencer (13) → groovebox capstone (16) →
  generative (17) → shipping/WAV export (18). ~24 self-contained pages.
  Old `prologue-theory/` URL redirects to P1.
- **Not built, by design:** 14 (scales & melody) is folded into P2 + lesson 13's
  scale selector/octave row + lesson 17's generator; 15 (pattern chaining /
  song mode) is left as an optional future extension.
- **If extending:** song-mode (15), a shared `lib/` if duplication starts to
  hurt, and wiring the engine into the actual arcade game.

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

---

## Standalone app — AcidBox (`acidbox/`)

The lesson-16 groovebox, lifted out of the course into a self-contained mini
app at repo root (`acidbox/index.html`) — a phone-first acid instrument with
save/load, WAV export, and shareable-link patterns. The course/lessons are
untouched; lesson 16 stays as the teaching capstone and cross-links to the app.
Will later get its own DNS/host (M7). Spec agreed with Valentin 2026-07-03.

### Milestones
| # | Milestone | State | Notes |
|---|-----------|-------|-------|
| M1 | Foundation | ✅ done | New self-contained `acidbox/` dir; lesson-16 instrument ported verbatim (303 voice + drum kit + one shared scheduler + dub delay/reverb); lesson chrome (idea panels, next/back nav) stripped; app header/footer; lesson 16 ↔ app + hub cross-links; iOS touch hardening kept |
| M2 | UX overhaul | ✅ done | **(pulled earlier — Valentin's priority)** **card-grid** layout (chosen from 3 on-device mocks — tabbed / scroll / cards): 6 cards — `303 · filter · drums · space · transport · generate` — stack in portrait, reflow 2-up at ≥640px so **303 + its filter pair on the top row** (Valentin's ask), drums+space / transport+generate below. Full-length **"DJ" faders** (chunky long-throw, big tabular readouts) on cutoff/reso/env/decay/accent · delay/fb/reverb/**volume (new)** · tempo/swing. Sticky transport bar: power/play/🎲 jam + 💾🔗⬇ placeholders tagged M3/M4; generate card dimmed/disabled til M5. Engine unchanged from M1. Headless-verified: grids fire, faders drive params live, 303+filter same row in landscape, 0 JS errors. Decision mocks (`acidbox/mocks/`) removed after the pick. Cards = seed for M6 |
| M3 | Persistence & sharing | ✅ done | one bit-packed state token (~38 bytes → **51 url-safe chars**, version-tagged) drives BOTH transports: **localStorage autosave** (debounced; restores on reload) + **named slots** (💾 modal — name/save/load/🗑) and **`#s=` share links** (🔗 copies to clipboard; opening a link applies it then strips the hash so autosave takes over = "import once"). Stores raw slider values so restore = set+dispatch (re-derives internal state, audio, readouts); power-on now reads the fx/vol sliders too (restore-safe, also fixes a latent M2 gap). Headless-verified: 40/40 codec round-trips, apply-fidelity, reload-restore, share-restore + hash-strip, slots CRUD, 0 JS errors |
| M4 | WAV export | ✅ done | refactored the live engine into a shared `buildGraph(ctx,out)` + engine-param voice/drum functions, used by BOTH the live AudioContext and an `OfflineAudioContext` — so export is **byte-faithful to what you hear** (drums + dub delay + reverb, all current knob/slider values; swing included). ⬇ renders 2 bars offline → dependency-free WAV (44-byte header + int16 PCM) → downloads `acidbox-loop.wav`; works even before power-on. Headless-verified: non-silent stereo render (peak 0.6), valid RIFF/WAVE, real ~900 KB file download, **live playback + full M2/M3 suites still green** (0 regressions from the refactor) |
| M5 | Generators & clear | ✅ done | Generate card wired to the two lesson-17 algorithms. **303 · scale random-walk** — density/wander/octaves/accents/slides knobs + 🎲 generate 303 (also the app-bar 🎲 jam); knobs set the walk's params, the roll is stochastic. **drums · Euclidean** — per-drum pulse sliders (kick/snare/cl hat/op hat/clap) spread N hits evenly (`(i·k)%16<k`) and regenerate live as you drag (deterministic → no button needed). Clears stay per-instrument (303-card `clear` · drums `clear` preset). Generator params are session-only (deliberately NOT in the save/share token — the *resulting pattern* already is). Headless-verified: card enabled, gen303 = 16 in-scale notes at density 100, euclid kick4=`[0,4,8,12]` / chat7=7 hits, jam re-rolls, full M2–M4 suites still green |
| M6 | Draggable panels + maximize | ✅ done | **drag-to-reorder** (grab a card by its whole title bar — the ⠿ is just the cue — and slide it; live reorder via `elementFromPoint`, monotonic insert, handle/title-only so grids & faders are safe) + a **maximize** ⤢ button on the 303 & drums cards that spans the full deck width and grows the grid cells in both axes (bigger tap targets; also eases the Pencil misses). Layout (order + maximize) persists to its OWN `localStorage` key — NOT the save/share token — with a footer "reset layout". Chosen over free-floating panels (Valentin, 2026-07-05: "on the grid" + "both axis"). See the dated entry below |
| M7 | Deploy | 🟨 partial | **Live now** at `https://acidlab.duckdns.org/acidbox/` — whitelisted in the live Caddyfile's `acidlab` block (`redir /acidbox` + `/acidbox/*` on `@allowed`, same `:8083` origin, cf. puckline's `/legacy`); ufw unchanged (no new port); runbook synced in `DEPLOY.md`. **TODO:** its own DNS/subdomain (Valentin will add) + matching Caddy vhost |

### Bug fixes
- 2026-07-04: **Apple Pencil missed sequencer taps** (iPad; finger fine, pen
  dropped ~every 3rd tap on notes/accents/slides/octaves/drums; sliders fine).
  Cause: the tap cells inherited `touch-action:pan-x pan-y` from the `*` rule, so
  iPadOS Safari buffered each `pointerdown` to disambiguate tap-vs-pan — a buffer
  the Pencil's pointer stream (hover/pressure transitions) confuses, dropping taps
  in bursts. Sliders were immune because they already override to
  `touch-action:none`. Fix: same override on `.pcol,.tog,.dcell,.lbl.mut` — tap
  targets, not scroll surfaces (you pan from the gaps/labels/chrome). Mechanics
  green headless on Chromium+WebKit (cells compute `none`, chrome stays pannable,
  taps still toggle, 0 errors); the *pen* cure isn't headless-reproducible.
  **UPDATE 2026-07-04: `touch-action:none` did NOT fix it** — Valentin retested,
  same drop. So the pointerdown is being swallowed/canceled at the event layer,
  not lost to pan disambiguation. Added a `#debug` **pointer tracer** (append
  `#debug` to the URL): a fixed panel logging the raw pointer/touch/gesture stream
  at document-capture + a HIT line from the cell handler, with live counters
  (`down/up/CANCEL/hit/drag/click/tcxl/gest`) + copy button — so a missed pen tap
  is unambiguous (no `down`=OS swallowed · `CANCEL`>0=gesture-canceled · `down` w/o
  `hit`=didn't reach cell · `down`>taps=double-fire). Panel is absent without
  `#debug` (public app untouched; verified headless).
  **VERDICT 2026-07-05 (3 device traces in):** the drop is at the OS/WebKit input
  layer, NOT the app. On a missed tap there is no `pointerdown`/`touchstart`/`click`
  AND no `buttons:1` move — the pen stays a *hovering* pointer (`pen #1, buttons:0`)
  and the physical contact is never promoted to a `pointerdown`. So it's a
  WebKit/Apple-Pencil hover-vs-contact miss (a real tap read as continued hover),
  categorically uncatchable from JS. Corroborated every time: the missed tap always
  lands in an oversized inter-tap gap (+900–2300ms vs ~400 normal) that contains
  only `hover #1` lines — pen seen, contact dropped. Rate ~1–3 of 12. `touch-action`
  and touch/click fallbacks are dead ends (nothing to catch). **Fix direction =
  drag-to-paint** (additive): once a contact IS registered its `buttons:1`
  move-stream is rock-solid, so painting cells along a drag lets ONE good contact
  enter many steps — slashing how many drop-prone discrete contacts a pattern needs.
  Tap-to-toggle stays unchanged. `#debug` tracer kept in-tree (gated) for future.
  **Pressure trace (4th round) closed it:** on the dropped taps `PRESS-HOV` stayed
  0 — every hover event is `pr0.00`, no pressure, so the contact truly never
  enters the web layer (registered taps ramp `pr0.08→0.28`). Uncatchable, final.
  **FIX SHIPPED 2026-07-05 — drag-to-paint:** after a tap, dragging (>10px, so tap
  jitter can't trigger it) across cells of the SAME row paints them to the tapped
  value; one good contact fills a run of steps, so a dropped tap-down no longer
  blocks entry. Unified over all rows (note=pitch+oct, acc/sld/oct, drums) via
  `locateCell`/`readCell`/`applyCell` + a bubble-phase `paintDown` (reads the
  post-toggle value) and a document `pointermove` painter using `elementFromPoint`
  (capture-proof for touch). Additive — tap-to-toggle untouched. Verified headless
  Chromium+WebKit 10/10 (paints runs per row, stops at edges, no jitter-bleed, no
  cross-row bleed, tap still toggles, 0 errors); on-device pen retest still wanted.

### Requests → milestones (from Valentin's spec, 2026-07-03)
1 self-contained root dir → M1 · 2 localStorage save/load → M3 · 3 WAV download → M4 ·
4 URL-encoded share links → M3 · 5 separate clear+gen per instrument → M5 ·
6 generate via the lesson-17 algos + own controls → M5 · 7 UX (groups + full-length
DJ sliders + float/reposition, phone-first) → M2 (+ M6).

### Decisions (AcidBox)
- 2026-07-03: dir = `acidbox/`; lesson 16 left intact + cross-linked (not
  replaced/redirected); UX (M2) pulled ahead of the feature milestones per
  Valentin; deploy split out as its own milestone (M7).
- 2026-07-03: **layout = card grid** (M2). Picked from 3 side-by-side mocks
  Valentin tested on-device (tabbed console / single scroll / card grid).
  Portrait stack order `303 · filter · drums · space · transport · generate`
  chosen so a 2-col reflow pairs 303 with its filter. Added a **volume** fader
  (wired to `master.gain`) that M1/lesson-16 lacked. Generate + save/share/export
  kept as visible-but-disabled placeholders so the layout is final now.
- 2026-07-03: **persistence codec** (M3) = one bit-packed token for both
  localStorage and the `#s=` share link (not two codecs), version byte first so
  old links can be rejected/migrated. Share links are **import-once**: applied
  then the hash is stripped so local autosave owns the session afterwards (the
  🔗 button always mints a fresh link from current state).
- 2026-07-03: **unified power + play** into one button. Browsers require a user
  gesture to start audio (an `AudioContext` is born suspended; `resume()` needs a
  real tap) — so the first tap of ▶ play now creates+resumes the context AND
  starts the transport, then toggles play/stop after. Removes the separate ⏻
  power button and makes a shared-link recipient's single tap do everything.
  wave / jam / clear are now always enabled (they edit the pattern/params, which
  `buildGraph()` reads at power-on). NB: headless Chromium does NOT enforce the
  autoplay policy (context is born `running` even without the bypass flag), so
  this gating isn't visible in the Playwright suite — verified by reasoning +
  the documented policy, not a headless test.
- 2026-07-03: **WAV export = shared graph** (M4). Instead of duplicating the DSP
  (drift risk) or shipping lesson-18's slim 303-only render, one `buildGraph()`
  + engine-param voice/drum fns run on both the live ctx and an
  `OfflineAudioContext` (engine passed as arg; live nodes still destructured to
  globals for the control handlers). Export is therefore always exactly the live
  sound. Renders 2 bars + 1.3 s tail — a clip, not a seamless loop (tail bleed);
  fine for a game clip, revisit if gapless looping is wanted.
- 2026-07-04: **background / interruption hardening** (Safari flakiness; a friend
  hit "no sound" that survived a refresh). Three coordinated changes: (1) a
  `panicStop()` on `visibilitychange`+`pagehide` — when the tab hides / phone
  locks / another app grabs the audio session, kill the scheduler, fade the
  voice, reset ■→▶, and `suspend()`; user re-taps ▶ to resume inside a fresh
  gesture (iOS-safe). (2) `ctx.onstatechange` flips the button back to ▶ if the
  OS parks the context with no visibility event (call/Siri/BT). (3) fixed a
  latent resume bug: the play tap resumed only `if(state==="suspended")`, but iOS
  parks a backgrounded context in the **non-standard `"interrupted"` state** — so
  it now resumes on any non-`running` state. Verified on BOTH Chromium and
  **WebKit** (Safari's engine) headless — 14/14 checks green each (play→hide→
  scheduler-stops→button-resets→resume, + direct-suspend safety net, 0 JS errors).
  **Follow-up shipped 2026-07-04:** the refresh-persistent silence was likely a
  *leaked* AudioContext (iOS caps ~4 concurrent; a suspended one kept alive in
  bfcache still holds a slot → new contexts born silent). So `pagehide` now runs
  `teardown()` = `close()` + **null** the ctx (not just suspend); the next ▶
  rebuilds via `if(!ctx) powerOn()`, and `pageshow` (persisted/bfcache) forces the
  button back to ▶. Nulling is load-bearing (a closed-but-not-nulled ctx would let
  play() drive dead nodes = silent + stuck ■); `onstatechange` gained an
  `ev.target===ctx` guard so a late "closed" from the torn-down context can't stop
  the fresh one. **Mechanics** verified headless on Chromium + WebKit (pagehide→
  close+null→scheduler-dead→button ▶→rebuild=exactly-one-live-ctx→no misfire, 0 JS
  errors); the *leak cure itself* (iOS ~4-cap + bfcache eviction) is NOT
  reproducible headless — needs real-device confirmation, same caveat class as the
  autoplay-policy note above.
- 2026-07-05: **scale picker → dropdown** (small UX). The 303 card's scale
  control was a button that *cycled* through the 6 scales (one hidden option per
  tap, no overview); it's now a native `<select>` — styled to match the buttons
  (▾ caret, `scale` hint label like the drums card's `kit:`), so every scale is
  visible at once and iOS gets its native wheel picker (fits the phone-first
  design). Options are built from the `SCALES` array (no drift) with index 0
  (**Min pent**) labelled "Min pent · default" so the default is marked. Rewired
  `setScale()` + the `applyState()` restore to set `scaleSel.value` instead of
  button text; the save/share token/codec is unchanged (scale was already a
  field). Also removed dead M2 leftovers: the `.soon` CSS + `[data-soon]` click
  handler (nothing carries those attributes anymore) and refreshed the stale
  "placeholder buttons" comment over `toast`. Verified 11/11 headless on the live
  page (Chromium): SELECT has 6 options, only the default is marked, change
  re-masks the grid, switching to a smaller scale clamps out-of-range pitch,
  save/restore round-trips the scale through the select, sibling controls (wave /
  grid tap) intact, 0 JS errors.
- 2026-07-05: **undo (per-instrument, single-level)**. A `↶ undo` button on the
  303 card and the drums card, each with ONE snapshot that reverts the *last*
  action on that instrument, then disables. `mark303()`/`markDrums()` snapshot
  the pattern BEFORE each mutation; the button restores it. Covered: 303 = note
  cycle / acc / sld / oct tap, a whole drag-stroke (one action, mark fires once
  on the stroke's pointerdown, not per painted cell), 🎲 jam/generate, clear;
  drums = cell tap, drag-stroke, preset (house/techno/breaks/clear), mute, and
  euclidean pulse-slider drags (one snapshot per drag via a `pulseArmed` flag,
  not per input tick). The two undo slots are independent. **Clear survives a
  reload** (Valentin's ask): a clear also stashes its pre-clear snapshot in
  `localStorage` (`acidbox:undo303` / `acidbox:undodrums`); `loadPersistedUndo()`
  re-arms the button on startup, so a wipe stays undoable across a reload. Any
  newer non-clear action drops that stash (mark removes the key) so undo always
  means the *latest* action, never a stale clear; loading a slot / share link
  `resetUndo()`s. Scope: pattern-only — undo ignores voice/FX faders, wave and
  the scale selector (not "pattern actions"); only clear persists across reload
  (jam/preset/taps are in-memory). Applying an undo clamps notes to the current
  scale (guards a scale change in between). Undo button `.und` lights acid-green
  only when armed (`:not(:disabled)`), dim otherwise. Verified 25/25 headless on
  the live page (Chromium): every action type reverts, single-level (two toggles
  → one undo reverts only the last), drag = one undoable stroke, clear→persist→
  **reload**→undo restores the exact pre-clear pattern, staleness drop, 0 JS
  errors; the scale-dropdown suite stayed 11/11 green.
- 2026-07-05: **M6 — draggable panels + maximize.** Two parts, both additive on
  M2's card grid. **(A) Maximize:** a corner ⤢ button on the 303 & drums cards
  toggles `.card.max` → `grid-column:1/-1` (full deck width, both columns in
  landscape) AND grows the grid cells in both axes (`.pcol` 70→120, `.tog`
  21→34, `.dcell` 24→40) for big tap targets — also eases the Apple-Pencil
  dropped-tap problem. Each card maximizes independently; the button flips glyph
  (⤢↔⤡) + colour when active. **(B) Drag-to-reorder:** pointer-based sortable
  from scratch (dependency-free, ~25 lines) — reorders live via
  `document.elementFromPoint` with a monotonic insert (move toward the pointer →
  no thrash) and a light lift (opacity + acid outline). Grab from the WHOLE
  title bar, not just the ⠿ glyph (Valentin: the glyph alone was "very
  hard/fiddly"); `.ctitle,.ctitle *` are `touch-action:none` (it doesn't
  inherit, so the sub-text had been falling back to pan-x/pan-y scroll-
  disambiguation) + a 5px engage threshold + grab/grabbing cursor. **Persistence:**
  layout (order + maximize) on its OWN `localStorage` key `acidbox:layout`, NOT
  in the save/share token (a shared link carries the sound, not your ergonomics);
  a footer "reset layout" restores default order, un-maximizes, and clears the
  key. `data-card` ids on all six cards; `applyLayout()` on load, `resetUndo`-
  style guards so a slot/share load doesn't inherit a stale layout. Model =
  drag-to-reorder (not free-floating panels — phone-first, no overlap/off-screen);
  maximize = both axes; both per Valentin's plan sign-off. Verified 17/17 headless
  on the live page (Chromium): maximize spans full width (876 vs 432px) + grows
  cells + persists across reload + independent per card; drag from the title TEXT
  (not the glyph) reorders, a fader gesture does NOT, order persists across reload;
  reset restores/un-maxes/clears; grid+undo regression intact; 0 JS errors. Undo
  (25/25) and scale (11/11) suites stayed green.
