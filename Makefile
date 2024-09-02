
CC = emcc
CFLAGS = -g -Wall -s EXPORTED_RUNTIME_METHODS='["FS"]' -s EXPORTED_FUNCTIONS='["_csvmidi", "_midicsv"]'

#	You shouldn't need to change anything after this line

VERSION = 1.1
PROGRAMS = csvmidi.js
MANPAGES = $(PROGRAMS:%=%.1) midicsv.5
DOC = README log.txt
BUILD = Makefile
SOURCE = csv.c csvmidi.c midicsv.c midio.c
HEADERS = csv.h midifile.h midio.h types.h version.h
EXAMPLES = test.mid bad.csv ce3k.csv acomp.pl chorus.pl \
	count_events.pl drummer.pl exchannel.pl general_midi.pl \
	transpose.pl torture.pl

all:	$(PROGRAMS)

MIDICSV_OBJ = midicsv.o midio.o
CSVMIDI_OBJ = csvmidi.o midio.o csv.o

csvmidi.js:    $(CSVMIDI_OBJ) $(MIDICSV_OBJ)
	$(CC) $(CFLAGS) -o csvmidi.js csvmidi.o midicsv.o midio.o csv.o

check:	all
	@node ./midicsv_node_cli.js test.mid /tmp/test.csv
	@node ./midicsv_node_cli.js /tmp/test.csv /tmp/w.mid
	@node ./midicsv_node_cli.js /tmp/w.mid /tmp/w1.csv
	@-cmp -s test.mid /tmp/w.mid ; if test $$? -ne 0  ; then \
	    echo '** midicsv/csvmidi: MIDI file comparison failed. **' ; else \
	diff -q /tmp/test.csv /tmp/w1.csv ; if test $$? -ne 0  ; then \
	    echo '** midicsv/csvmidi: CSV file comparison failed. **' ; else \
	    echo 'All tests passed.' ; fi ; fi
	@rm -f /tmp/test.csv /tmp/w.mid /tmp/w1.csv
	
torture: all
	perl torture.pl > /tmp/torture.csv
	node ./midicsv_node_cli.js /tmp/torture.csv /tmp/w.mid
	node ./midicsv_node_cli.js /tmp/w.mid /tmp/torture1.csv
	node ./midicsv_node_cli.js /tmp/torture1.csv /tmp/w1.mid
	@cmp /tmp/w.mid /tmp/w1.mid ; if test $$? -ne 0  ; then \
	    echo '** midicsv/csvmidi: Torture test CSV file comparison failed. **' ; else \
	    echo 'Torture test passed.' ; fi
	@rm /tmp/w.mid /tmp/w1.mid /tmp/torture.csv /tmp/torture1.csv

clean:
	rm -f $(PROGRAMS) *.o *.bak core core.* *.out midicsv.zip *.wasm
