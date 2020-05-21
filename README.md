# Laboratoria z bootloadera:

Tomasz Praszkiewicz	

## Prezentacja wstępny plan:

Kompilacja systemu operacyjnego ładowanego przez GRUB i dodanie do niego funkcjonalności wykonanie obliczeń i prosta wizualizacja postępów.
Wymagane:qemu grub-iso-bin xorriso i686-elf-tools

a)kompilacja przykładowego startera asemblerowego i hello worda w c,linkowanie obiektów

b)stworzenie obrazu systemu przy użyciu GRUB

c)odpalenie systemu przy pomocy qemu

d)dodanie funkcjonalności do systemu (nowe linie)

e)dodanie programu wykonującego obliczenia do systemu

f)Prosta wizualna reprezentacja postępu obliczeń

g)dodawanie wielu wersji systemów do GRUB


## Opis zadań:

1. Setup środowiska:

   ubuntu:

   sudo apt install -y qemu xorriso grub-efi-amd64:i386

   debian:

   apt-get install -y git qemu-system-i386 grub-efi wget zip unzip mtools 
   
   
   
   potem download:
   https://github.com/lordmilko/i686-elf-tools/releases/download/7.1.0/i686-elf-tools-linux.zip
   paczkę wypakowujemy i folder podfolder bin dodajemy do zmiennej path lub w dowolny inny sposób korzystamy z cross kompilatora np export PATH="$HOME/Downloads/i686-elf-tools-linux/bin:$PATH"
   potrzebuje jeszcze pliki z tego repozytorium linker.ld bootstrap.s kernel.c




2. Po tym jak nasze środowisko jest gotowe  przystępujemy do kompilacji podstawowego systemu. aby to zrobić kompilujemy plik boot.asm który wystartuje nasz program następnie kompilujemy nasz program w z korzystając z cross kompilatora. gdy skompilowaliśmy oba pliki linkujemy je korzystając z pliku linker.ld który określa layoutu pamięci. kompilacja odbywa się przy użyciu odpowiedniego ściągniętego przez nas cross kompilatora który jest przystosowana do kompilacji na architekturę i686 odpowiednio as ,gcc,linkujemy korzystając z gcc
celem tego zadanie jest zapoznanie się z sposobem kompilacji prostego systemu.<details><summary>Pomoc:</summary>
kompilator nazywa się i686-elf-as dla asemblera i
i686-elf-gcc dla c przy kompilowaniu c trzeba pamiętać o fladze -c oraz o fladze -ffreestanding która mówi kompilatorowi że w środowisku w którym się znajdzie nie ma biblioteki standardowej.
Linkowanie można również przeprowadzić przy pomocy gcc. Obcja -T pozwala na podanie nazwy pliku w którym znajduje się skrypt linkera. informacje o braku standardowej biblioteki przekazujemy poprzez flagi -ffreestanding -nostdlib dodatkowo używamy flaki -lgcc
</details>


3. Gdy mamy skompilowany system zamieniamy go na obraz iso korzystając gruba. celem tego ćwiczenia jest zapoznanie z procesem zamiany jądra bootowalny obraz nie jest to konieczne w tym momencie ponieważ quemu może bootować bezpośrednio kernel ale posłuży jako wstęp do multibootingu korzystając z gruba oraz pozwala na testowania naszego systemu na realnym sprzęcie jeśli naprawdę byśmy tego chcieli.<details><summary>Pomoc:</summary>
tworzymy strukturę folderów folderNaszegoIso/boot/grub;
do folderu boot kopiujemy obraz naszego systemu a w katalogu grub tworzymy plik grub.cfg tym pliku dodajemy entry do ekranu startowego gruba struktura jest taka:
menuentry "Nazwa naszego systemu do wyświetlenia"{
   multiboot /path/do/systemu
}
np.:
menuentry "cw1"{
   multiboot /boot/cw1.bin
}
</details>

4. następnie używamy quemu do odpalenia naszego systemu operacyjnego celem tego kroku jest upewnienie się że wszystko do tego etapu zrobiliśmy dobrze i jesteśmy w stanie wystartować nasz prosty system<details><summary>Pomoc:</summary>
tworzymy strukturę folderów folderNaszegoIso/boot/grub;
do folderu boot kopiujemy obraz naszego systemu a w katalogu grub tworzymy plik grub.cfg tym pliku dodajemy entry do ekranu startowego gruba struktura jest taka:</br>
menuentry "Nazwa naszego systemu do wyświetlenia"{</br>
   multiboot /path/do/systemu</br>
}</br>
np.:</br>
menuentry "cw1"{</br>
   multiboot /boot/cw1.bin</br>
}</br>
Następnie możemy stworzyć obraz przy użyciu polecenia grub-mkrescue które jako argument przyjmuje nazwę folderu z którego zrobić ma obraz iso.
</details>

5. Teraz zaczniemy zadania bazujące na kodzie naszym zadaniem będzie implementacja nowej linii aby ułatwić nasze dalsze zadania i przetestować umiejętność zrozumienia esencji dostarczonego kodu<details><summary>Pomoc:</summary>
   Aktualny system obsługujący terminal nie obsługuje nowych linii. Czcionka trybu tekstowego VGA przechowuje inny znak w tym miejscu, ponieważ nowe linie nie są nigdy przeznaczone do rzeczywistego renderowania: są to logiczne encje. Należy w terminal_putchar sprawdzić czy c == '\n' i inkrementować terminal_row i zresetować terminal_column. 
</details>

6. Następnie implementujemy prosty algorytm obliczeniowy celem tego kroku jest pokazanie większej prostoty korzystania z C zamiast assemblera .Moją propozycją jest zaimplementowanie znajdowania liczb pierwszych z przedziału od 1 do 1000000 i wypisywanie ich ilości. Kluczowymi trudnościami które powinniśmy pokonać w tym etapie jest zamiana liczby na string bez bibliotek ponieważ nie jesteśmy w stanie ich użyć w naszym systemie oraz implementacja funkcji sqrt bez biblioteki. A ważną rzeczą do zastanowienia się jest jak  wyglądałby nasz program gdybyśmy pisali go w asemblerze czy było by to dla nas proste oraz jak porównuje się czytelność naszego programu z c to programu asemblerowego
<details><summary>     Pomoc:
</summary>
<p>

   szkic przykładowego algorytmu:

```c
    int counter = 1; //2 jest pierwsza
    for (int i = 3; i < 1000000; i += 2)
    {
        _Bool is_prime = 1;
        for (int j = 3; j <= sqrt(i); j++)
        {
            if (i % j == 0)
            {
                is_prime = 0;
                break;
            }
        }
        if (is_prime)
        {
            counter++;
        }
    }
    printf("%i",counter);
   
```



   liczb pierwszych z przedziału 1-500 jest 95
   Przykładowy algorytm: na sqrt to może być wyszukiwanie binarne. w algorytmie może być ważne żeby liczba była sqrt lub trochę większa ponieważ jeśli jest mniejsza to algorytm da niepoprawny wynik a jeśli jest większa to będzie dłużej się liczył.

</p>
</details>

7. Następnie dokonujemy prostej wizualizacji postępu podczas naszych obliczeń co pozwoli na obserwowanie postępu obliczeń celem tego zadania jest zwiększenie umiejętności adaptacji otrzymanego niskopoziomowego kodu do uzyskania pożądanego efektu. pasek postępu<details><summary>Pomoc:</summary>
    Najprostszym sposobem może być wykorzystanie jednego z wierszy jako 
    pasek postępu. możemy uzyskać wstawiając kolejno znaki na pusty wiersz na matrycy raz na pewną ilość operacji z odpowiednim przesunięciem.
    </details>

8. następnie dodajemy opcję multibooting i dodajemy do niej wszystkie stworzone przez nas systemy. celem tego zadania jest nabycie umiejętności tworzenia obrazu bootującego zawierającego wiele systemów.<details><summary>Pomoc:</summary>
    zobacz do pomocy z punktu 3. w configu można dodać więcej niż jedno menuentry 
    </details>

### Materiały dodatkowe:

video i artykuły opisujące proces tworzenia systemu operacyjnego nie jest niezbędne ale pozwala lepiej zrozumieć część dostarczonego kodu:

https://www.youtube.com/watch?v=4hJDOvwbTZs

https://www.c-sharpcorner.com/article/create-your-own-kernel/

https://www.codeproject.com/Articles/1225196/Create-Your-Own-Kernel-In-C-2



## Z seminarium:

https://youtu.be/ZCrOg3lVNpc?t=2040

## Zadania:

zadaniem jest: </br>
1.skąpilowanie i zlinkowanie oraz zamienienia na iso systemu hello world

2.dodanie funkcjonalności nowej linii do systemu

3.implementacja programu obliczeniowego.

4.implementacja wizualizacji postępów programu.

5.połączenie 1,2,3,4 w jeden obraz iso dający możliwość wyboru dowolnego z czterech systemów.(spakowany w zip powinien mieć około 3 Mb)

## Środowiskiem pracy:

linux z zainstalowanym grubem cross kompilatorem i qemu-system-i386 lista paczek podana w punkcie 1

## Skrypt:
Znajduje się w repozytorium aczkolwiek nie tworzy osobnego środowiska pracy mimo licznych prób środowisko nie działa wystarczająco aby wspierać laboratoria. 




## Bibliografia:

- https://wiki.osdev.org
- https://www.c-sharpcorner.com
- https://www.codeproject.com


