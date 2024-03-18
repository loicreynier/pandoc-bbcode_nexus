pandoc ?= pandoc
writer ?= ../bbcode_nexus.lua

sample.bbcode: sample.md $(writer)
	$(pandoc) --to $(writer) --output $@ $<

clean:
	@rm -v *.bbcode

.PHONY: all clean test
