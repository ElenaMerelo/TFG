#!/bin/bash

# Script basado en el de https://github.com/BlancaCC/TFG-Estudio-de-las-redes-neuronales 
# MIT license 

SpellingError () {
    error=0;
    echo "";
    echo "Analizando si hay fallos en fichero" $1":";
    n_line=1;
    while IFS= read -r line
    do
        resultado=$(echo $line | aspell --mode=tex  --lang=en --list | aspell --mode=tex  --lang=es --list --home-dir=. --personal=.github/workflows/personal-dictionary.txt);
        if [[ ! -z "$resultado" ]]
        then
         echo "Spelling error in line $n_line : $resultado"
         let "error = 1";
        fi
        let "n_line += 1"
    done < $1
    return $error;
}

export -f SpellingError;
exitValue=0

# Comprobamos el readme
SpellingError README.md
let "exitValue += $?"
# Comprobamos ficheros .tex
for file in "doc/secciones/*.tex"
do
    SpellingError $file;
    let "exitValue += $?"
done

for file in "doc/*.tex"
do
    SpellingError $file;
    let "exitValue += $?"
done

exit $exitValue;
