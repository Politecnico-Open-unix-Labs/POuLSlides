\titlepage
\begin{flushleft}
\includegraphics[height=0.15\textwidth]{images/poul-logo}
\end{flushleft}
\begin{flushright}
\small Corso Linux Avanzato 2015
\end{flushright}

----------------------------------

\begin{center}
\Huge Processes?
\end{center}

Process
-------

\begin{center}
\Large attività controllata da un programma che si svolge su un processore in
genere sotto la gestione o supervisione del rispettivo sistema operativo
\end{center}

metadata
--------

Ogni processo ha dei metadata:

 * PID
 * PPID
 * UID/GID
 * EUID/EGID
 * Parent
 * Times
 * State
 * Priority
 * Resources

birth
-----

 * `fork()` or `clone()` system calls
    + ritorna `0` al figlio
    + ritorna il pid del figlio al padre
    + il figlio con un `exec()` esegue qualcosa di diverso da se stesso

death
-----

 * `exit()`
    + il padre raccoglie il codice d'uscita e si comporta di conseguenza
       - IFF il padre è ancora vivo...

something near to you...
------------------------

 * Ogni riga che si scrive al terminale causa un nuovo processo
 * la variabile `?` contiene il codice d'uscita dell'ultimo comando
    + `echo $?`
 * gli operatori booleani `||` e `&&` controllano proprio quel valore quando
   confrontano dei comandi
    + `apt-get update && apt-get upgrade`

init
----

\Large è il primo processo avviato dal sistema, padre di tutti gli altri processi

init
----

 * PID == **1**
 * adotta tutti i figli orfani
 * è l'unico processo orfano ammesso

states
------

 * **R** running/runnable
 * **D** uninterruptible sleep
 * **S** interruptible sleep
 * **T** stopped
 * **Z** zombie

backgrounds jobs
----------------

La maggior parte dei processi è eseguita in background, cioà senza che la shell
venga occupata da quel processo.

In una shell testuale:

 * `<command> &`: spawn del programma e passaggio in background
 * CTRL+Z per mandare un SIGTSTP\footnote{more on this later...} e tornare
   alla shell. `bg` per far continuare il programma in background
 * `jobs` per mostrare i processi in background
 * `fg` porta un processo in foreground

signals
-------

È un tipo di IPC usato per far modificare ai processi (più o meno forzatamente)
il loro stato.

 * identificati con un numero da 1 a 64
 * sono usati all'interno dei programmi per modificare lo stato dei propri
   thread
 * la maggior parte dei segnali vengono gestiti dal processo (se hanno una
   routine per farlo), alcuni vengono controllati esclusivamente dal kernel
   (e.g. SIGKILL)
 * sono usati dal kernel
 * possono essere usati dall'utente

signals
-------

\begin{center}
\begin{tabular}{ p{2cm} c l }
    \hline
    value & signal & description \\
    \hline
        1  &  \textbf{SIGHUP}  & Hangup detected \\
        2  &  \textbf{SIGINT} & C Interrupt from keyboard \\
        3  &  \textbf{SIGQUIT} & Quit from keyboard \\
        9  &  \textbf{SIGKILL} & Kill signal \\
        15 &  \textbf{SIGTERM} & Termination signal \\
        18 &  \textbf{SIGCONT} & Continue if stopped \\
        19 &  \textbf{SIGSTOP} & Stop process \\
        20 &  \textbf{SIGTSTP} & Z Stop typed at terminal \\
    \hline
\vspace{\fill}
Fonte: signals(7)
\end{tabular}
\end{center}

sending signals
---------------

via terminale:

 * `kill [-<signal>] <PID>`
 * `kill -9 12345`
 * `kill -SIGKILL 1234`
 * di default `kill` manda un SIGTERM

sending signals
---------------

via codice:

 * **C**: `int kill(pid_t pid, int sig);`
 * **python**: `os.kill(pid, sig)`


killall
-------

Comando che manda un segnale (SIGTERM di default) a tutti processi con un
dato nome.

nice
----

Modifica la priorità di un processo (quindi lo scheduling)

 * varia da -20 a +19
 * niceness alta == bassa priority
 * niceness bassa == alta priorità
 * viene ereditato dal processo padre
 * l'owner del processo può alzare il valore
 * solo root può abbassare il valore

nice(1) e renice(1)
-------------------

Sono i due programmi che permettono di operarare sulla niceness di un processo:

 * nice 5 process-name
 * renice -10 another-process
 * renice 15 -u username

/proc
-----

File system virtuale con informazioni sui processi (e non solo)

C'è una directory per ogni processo, chiamata dopo il PID.

 * **cmdiline** comando con cui il processo è stato invocato
 * **cwd** symlink alla directory di lavoro del processo
 * **fd/** directory contente i file descriptor attualmente aperti
 * molto molto altro, vedi `man 5 proc`

ps
--

Mostra le informazioni sui processi, generalmente usato insieme a grep.

Stampa UID, PID, ora/data di avvio del processo, comando, stato, tempo di
esecuzione, e qualsiasi altra cosa gli si chieda.

Un uso comune consiste nel chiamarlo con le opzioni `aux` o `-ef` per avere
un output con qualche dato.

`man 1 ps`

top
---

 * monitori i processi in tempo reale con un'interfaccia ncurses
 * refresh ogni 3 secondi
 * si possono mandare segnali e modificare il nice
 * molto personalizzabile: `man 1 top`

top
---

\includegraphics[width=0.8\textwidth]{images/top}

\footnotesize Image by Ivan Voras - Licensed under Public Domain via Wikimedia
Commons - https://commons.wikimedia.org/wiki/File:BSD-unix-top-plain.png#/media/File:BSD-unix-top-plain.png

htop
----

 * versione figa e colorata di top
 * e più facile da usare, ovviamente

htop
----

\includegraphics[width=0.8\textwidth]{images/htop}

\footnotesize Image by Erik Strandberg - Licensed under CC BY-SA 3.0 via Wikimedia Commons - https://commons.wikimedia.org/wiki/File:Htop.png#/media/File:Htop.png

lsof
----

 * mostra i file aperti da un processo
    + `lsof -p <PID>`
 * mostra i processi che hanno file aperti in una directory
    + `lsof +D <directory>`

Processes
---------

\begin{center}
\Huge Questions?!?
\end{center}

Do you want more cookies?
-------------------------

~~RTFM and stop ranting~~

 1. Chiedi al tuo computer: `man chmod`, per esempio.
    + se non riesci a usare man: `man man`
 2. GIYF\footnote{Google Is Your Friend}
 3. wiki della tua distribuzione
    + Hint: anche se non è della distribuzione che stai usando va bene lo
    stesso.
 4. chiedi nei canali di supporto della tua distribuzione
 5. chiedi a noi ;)

Thanks
------

 * \href{https://poul.org}{POuL}, for the organization
 * **YOU**, for attending
 * \href{http://layer-acht.org/}{Holger Levsen}
   <\href{mailto:holger@debian.org}{holger@debian.org}> and Jérémy Bobbio
   <\href{mailto:lunar@debian.org}{lunar@debian.org}> for the template
   used for these slides
 * Slides degli anni precedenti. Thanks to:
    + Daniele Iamartino (2011)
    + Pietro Virgilio (2012)
    + Radu Andries (2013)
    + Stefano Bouchs (2014)
 * chiunque si sia sbattutto per scrivere le pagine di manuale!!!!
 * \href{https://kernel.org}{Linux} for being so funny

Bye o/
------

\vspace{\fill}
\begin{flushright}
\begin{columns}
    \column{50px}
        \href{http://creativecommons.org/licenses/by-sa/4.0/}{
        \includegraphics[width=50px]{images/cc-by-sa}
        }
    \column{.70\linewidth}
        \footnotesize This work is licensed under a
        \href{http://creativecommons.org/licenses/by-sa/4.0/}{
        Creative Commons Attribution-ShareAlike 4.0 International License
        }
\end{columns}
\end{flushright}

\vspace{\fill}
\centering
\begin{footnotesize}
\begin{tabular}{ l c }
    \hline
    email & \texttt{mattia@mapreri.org} \\
    GPG key & \texttt{66AE 2B4A FCCF 3F52 DA18  4D18 4B04 3FCD B944 4540} \\
    \hline
\end{tabular}
\end{footnotesize}

