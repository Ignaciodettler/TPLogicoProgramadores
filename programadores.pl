programador(juan,cobol).
programador(juan,visualBasic).
programador(juan,java).
programador(julieta,java).
programador(marcos,java).
programador(santiago,ecmaScript).
programador(santiago,java).


rol(carlos,gerenteDeVentas).
rol(fernando,analistaFuncional).
rol(ana,projectLeader).
rol(juan,programador).
rol(julieta,programador).
rol(marcos,programador).
rol(santiago,programador).

queLenguajesSabeProgramar(Alguien,Lenguajes):-
    programador(Alguien,Lenguajes).

queRolEs(Persona,Rol):-
    rol(Persona,Rol).

%%Punto 2.

proyectoLenguaje(sumatra,java).
proyectoLenguaje(sumatra,ecmaScript).
proyectoLenguaje(prometeus,cobol).

proyectoInicio(sumatra,2020).
proyectoInicio(prometeus,1999).

proyectoIntegrantes(sumatra,julieta).
proyectoIntegrantes(sumatra,marcos).
proyectoIntegrantes(sumatra,ana).
proyectoIntegrantes(prometeus,juan).
proyectoIntegrantes(prometeus,santiago).

personaDentroDeProyecto(Proyecto,Persona,Rol):-
    proyectoIntegrantes(Proyecto,Persona),
    queRolEs(Persona,Rol).


estaBienAsignado(Persona,Proyecto):-
    proyectoIntegrantes(Proyecto,Persona),
    queLenguajesSabeProgramar(Persona,Lenguaje),
    proyectoLenguaje(Proyecto,Lenguaje).

estaBienAsignado(Persona,Proyecto):-
    personaDentroDeProyecto(Proyecto,Persona,analistaFuncional).

estaBienAsignado(Persona,Proyecto):-
    personaDentroDeProyecto(Proyecto,Persona,projectLeader).


%% Punto3

lenguaje(assembler,1949).
lenguaje(cobol,1959).
lenguaje(visualBasic,1992).
lenguaje(java,1996).
lenguaje(go,2009).
lenguaje(ecmaScript,1997).

estaDentroDelProyecto(Persona,Rol,Proyecto):-
    proyectoIntegrantes(Proyecto,Persona),
    rol(Persona,Rol).

unSoloProjectLeader(Proyecto):-
    proyectoLenguaje(Proyecto,_),
    findall(Integrantes,estaDentroDelProyecto(Integrantes,projectLeader,Proyecto),Lista),
    length(Lista,Cantidad),
    Cantidad = 1.
    
proyectoConsistente(Proyecto):-
    proyectoLenguaje(Proyecto,_),
    unSoloProjectLeader(Proyecto),
    forall(proyectoIntegrantes(Proyecto,Integrantes),estaBienAsignado(Integrantes,Proyecto)).

proyectoInnovador(Proyecto):-
    proyectoConsistente(Proyecto),
    noTieneAnalistaFuncional(Proyecto),
    diferenciaProyectoYLenguaje(Proyecto,Resultado),
    Resultado < 10.

noTieneAnalistaFuncional(Proyecto):-
    proyectoLenguaje(Proyecto,_),
    forall(proyectoIntegrantes(Proyecto,Integrante),not(rol(Integrante,analistaFuncional))).

%%la dif entre año creacion lenguaje y proyecto no supera los 10 años
diferenciaProyectoYLenguaje(Proyecto,Resultado):-
    proyectoLenguaje(Proyecto,Lenguaje),
    lenguaje(Lenguaje,AnioLenguaje),
    proyectoInicio(Proyecto,AnioInicio), %% AnioInicio - AnioLenguaje < 10
    restaAnios(AnioInicio,AnioLenguaje,Resultado).
    
restaAnios(AnioInicio,AnioLenguaje,Resultado):-
    Resultado is AnioInicio- AnioLenguaje.

proyectoDesactualizado(Proyecto):-
    diferenciaProyectoYLenguaje(Proyecto,Resultado),
    Resultado > 15.

proyectoReciente(Proyecto):- %%de todos los proyectos es el ultimo que se desarrollo
    proyectoInicio(Proyecto,Inicio),
    anioMaximo(Maximo),
    Maximo = Inicio.

anioMaximo(Maximo):-
    findall(Anio,proyectoInicio(_,Anio),Lista),
    max_list(Lista, Maximo).

%% Punto4

tarea(fernando,evolutiva(compleja)).
tarea(fernando,correctiva(8,brainfuck)).
tarea(juan,correctiva(3,brainfuck)).
tarea(marcos,algoritmica(20)).
%% pongo ejemplo de supervisada.
tarea(marcos,supervisada(juan,correctiva(_,brainfuck))).

grado(evolutiva(compleja),5).
grado(evolutiva(simple),3).
grado(correctiva(_,brainfuck),4).

grado(correctiva(Linea,_),Grado):- 
    Linea > 50, 
    Grado is 4.

grado(algoritmica(Linea),Grado):-
    Grado is Linea / 10.

grado(supervisada(_,Tarea),Grado):-
    grado(Tarea,Grado2),
    Grado is Grado2 * 2.

gradoSeniority(Persona,Grado):-
    rol(Persona,_),
    findall(Grados,(tarea(Persona,Tarea),grado(Tarea,Grados)),Lista),
    sum_list(Lista, Grado).

%%Punto 5

esNinja(Persona):- 
    hizoTarea(Persona),
    soloHizoCorrectivas(Persona),
    not(fueronSupervisadasEnLenguajeQueConoce(Persona)).

soloHizoCorrectivas(Persona):-
    forall(tarea(Persona,Tarea),esCorrectiva(Tarea)).

hizoTarea(Persona):-
    tarea(Persona,_),
    programador(Persona,_).

esCorrectiva(correctiva(_,_)).

fueronSupervisadasEnLenguajeQueConoce(Persona):-
    hizoTarea(Persona),
    forall(tarea(_,supervisada(Persona,correctiva(_,Lenguaje))),programador(Persona,Lenguaje)).

%%%%PARTE 5B

porcentajePorNinja(Porcentaje):-
    puntosCorrectivas(Suma),
    puntosCorrectivasPorNinjas(Suma2),
    Porcentaje is (Suma2 * 100) / Suma.

puntosCorrectivas(Suma):- %% me tiene que dar 8 
    findall(Puntos,gradoDeTarea(correctiva(_,_),Puntos),Lista),
    sum_list(Lista,Suma).

gradoDeTarea(Tarea,Grado):- %% tarea(fernando,correctiva(8,brainfuck)).
    tarea(_,Tarea),
    grado(Tarea,Grado).

puntosCorrectivasPorNinjas(Suma2):-
    esNinja(Persona),
    tarea(Persona,Tarea),
    findall(Puntos,gradoDeTarea(Tarea,Puntos),Lista),
    sum_list(Lista,Suma2).