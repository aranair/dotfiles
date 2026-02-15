.PHONY: all sync install sync-pi sync-claude install-pi install-claude

all: sync install

sync: sync-pi sync-claude

install: install-pi install-claude

sync-pi:
	./agent-stuff/pi/sync.sh

sync-claude:
	./agent-stuff/claude/sync.sh

install-pi:
	./agent-stuff/pi/install.sh

install-claude:
	./agent-stuff/claude/install.sh
