# midi2csv

Convert MIDI to CSV and back! Visualize the internals of the MIDI file format! Perform audio editing with surgical precision in your favourite ~~DAW~~ spreadsheet application!

This is a WebAssembly port of John Walker's [midicsv](https://www.fourmilab.ch/webtools/midicsv/) project.

Run it from your browser here: https://metavee.github.io/midi2csv/

## Building

To build from source, an environment with GNU Make (e.g. v3.81), Emscripten (e.g. v3.1.65), and Node (e.g. v20.15.1) are required.

- `make all`: build
- `make check`: run basic tests
- `make clean`: delete build artifacts

## License

The original midicsv code is in the public domain.

The embedded MIDI player includes code from https://github.com/fraigo/javascript-midi-player (license unknown) as well as https://github.com/surikov/webaudiofont (licensed under [GPL v3](LICENSE)).
