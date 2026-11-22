# mental-math-drill

Practice your mental drill: percentages, metric prefixes and running pace conversions.

Live: https://acormer.github.io/mental-math-drill/

## Voice mode

The **Voice** switch reads each question aloud, and **Hide text** turns the drill into a
listening exercise (the text comes back once you answer). The timer starts when the
question has been spoken. **Replay** says it again.

Speech is generated in the browser by [Gradium Phonon](https://gradium.ai/phonon), an
open on-device text-to-speech model: no server, no API key, and the text never leaves
the device.

- The `phonon-tts` npm package (0.7.0) is copied as-is into `vendor/phonon-tts/`, so the
  site keeps working without a build step. It runs the model in a Web Worker with
  WebAssembly.
- **English** uses Phonon 31m (Apache 2.0). Its 8-bit quantized weights (about 64 MB) are
  downloaded from the Hugging Face Hub on first use and kept in the browser cache.
- **French** uses Phonon 40m by [Gradium](https://gradium.ai), under CC BY-NC 4.0
  (non-commercial). The original repo,
  [gradium/phonon-40m-fr](https://huggingface.co/gradium/phonon-40m-fr), is gated, and a
  browser has no token to download it. The page therefore loads an unchanged public copy,
  [cormer/phonon-40m-fr](https://huggingface.co/cormer/phonon-40m-fr), about 75 MB, pinned
  to a commit in `index.html`.
- Models load from the Hub on first use and are then kept in the browser cache.
- GitHub Pages cannot send the headers needed for multi-threaded WebAssembly
  (cross-origin isolation), so generation runs on one CPU thread. Measured in Chromium on
  a laptop: 70 to 180 ms to the first audio, and 1.4 to 2.3 times faster than real time.
  The next question's audio is generated while you answer the current one.

Spoken questions were checked by transcribing the generated audio with Whisper: 10 of 10
French and 9 of 10 English test phrases came back as written ("picofarads" was heard as
"picker farads").

### Updating the French model copy

The files live in `models/phonon-40m-fr/` (git-ignored), with the copy's model card as
`README.md`. After accepting the terms on the original repo:

```
hf download gradium/phonon-40m-fr config.json tokenizer.json model.q8.gguf default-voice.safetensors --local-dir models/phonon-40m-fr
hf upload cormer/phonon-40m-fr models/phonon-40m-fr .
```

Then update the commit hash in `MODELS.fr` in `index.html`.

## Run locally

```
make serve
```

Then open <http://127.0.0.1:8000/>. Voice mode does not work from a `file://` URL.
