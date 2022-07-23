# Corrector ortográfico
spell:
	chmod u+x ./scripts/spell_check.sh
	./scripts/spell-check.sh

install-spell:
	sudo apt-get install aspell aspell-es aspell-en

workflow-spell: install-spell spell
