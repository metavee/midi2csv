const fs = require('fs');
const path = require('path');

// Load the Emscripten-generated module
const Module = require('./dist/csvmidi.js');

// Function to convert MIDI to CSV
function convertMidiToCsv(inputPath, outputPath) {
    // Read the input file
    const inputFile = fs.readFileSync(inputPath);
    const byteArray = new Uint8Array(inputFile);

    // Write the file to MEMFS
    Module.FS.writeFile('/input.midi', byteArray);

    // Call the WebAssembly function
    Module._midicsv();

    // Read the output file from MEMFS
    const output = Module.FS.readFile('/output.csv');

    // Write the output to the filesystem
    fs.writeFileSync(outputPath, output);
    console.log(`Converted ${inputPath} to ${outputPath}`);
}

// Function to convert CSV to MIDI
function convertCsvToMidi(inputPath, outputPath) {
    // Read the input file
    const inputFile = fs.readFileSync(inputPath);
    const byteArray = new Uint8Array(inputFile);

    // Write the file to MEMFS
    Module.FS.writeFile('/input.csv', byteArray);

    // Call the WebAssembly function
    Module._csvmidi();

    // Read the output file from MEMFS
    const output = Module.FS.readFile('/output.midi');

    // Write the output to the filesystem
    fs.writeFileSync(outputPath, output);
    console.log(`Converted ${inputPath} to ${outputPath}`);
}

// Wait for the module to initialize
Module.onRuntimeInitialized = () => {
    console.log('WebAssembly module loaded');

    // Get command-line arguments
    const args = process.argv.slice(2);
    if (args.length < 2) {
        console.error('Usage: node midicsv_node_cli.js <input> <output>');
        process.exit(1);
    }

    const inputPath = path.resolve(args[0]);
    const outputPath = path.resolve(args[1]);

    if (outputPath.endsWith('.csv')) {
        convertMidiToCsv(inputPath, outputPath);
    } else {
        convertCsvToMidi(inputPath, outputPath);
    }
    
};
