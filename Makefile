# Corrector ortográfico
install-spell:
	sudo apt-get install aspell aspell-es aspell-en

workflow-spell: install-spell spell

spell:
	./scripts/spell_check.sh

