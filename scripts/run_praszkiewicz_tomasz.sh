#!/bin/bash

if [ $1 == "clone" ]; then
git clone https://github.com/T0Mage/tpBootloaderlab&&cd tpBootloaderlab&&echo -e "\e[31mZmiany w ściągniętym folderze z funkcji clone nie zostaną zachowane po clean"

elif [ $1 == "run" ]; then
echo "niestety niejestem wstanie zainicjalizować środowiska w sposób który może byc latwo odwrócony wymaganym środowiskiem jest debian based linux (może być vm), jeżeli ktoś chce spróbować zrozumień co poszło nietak dostępne są skrypty oraz dokerfile w którym istniejące pliki są nie widziane przez basha a widziane przez ls i inne programy"

elif [ $1 == "clean" ] ;then
rm -rf tpBootloaderlab&&echo "pobrany folder zostal usunienty"

fi
