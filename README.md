# Acid Lab 🧪🟢

Learn synthesis from first principles by building a **TB-303-style acid synth**, a
drum machine, and a sequencer in the browser — working toward a small
"Korg DS-10"-style groovebox for generating acid / chiptune loops.

- **Concept & curriculum:** [`AGENTS.md`](./AGENTS.md)
- **Progress:** [`STATUS.md`](./STATUS.md)
- **Start here:** open [`index.html`](./index.html) (the lesson hub)

## Running

Lesson 00 works by just double-clicking it (`file://`). Later lessons use ES
modules / AudioWorklet / fetch and need a static server:

```bash
python3 -m http.server 8000    # then open http://localhost:8000
# or
npx serve
```

> Audio only starts after a click — browsers block autoplay until a user gesture.
> Every lesson has a "power on" / start button that creates the `AudioContext`.

## Layout

```
lessons/NN-slug/index.html   one self-contained lesson each
lib/                         shared helpers (grows as needed)
index.html                   hub linking every lesson
```
