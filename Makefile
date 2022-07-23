# Corrector ortográfico
spell:
	./scripts/spell_check.sh

install-spell:
	sudo apt-get install aspell aspell-es aspell-en

workflow-spell: install-spell spell
