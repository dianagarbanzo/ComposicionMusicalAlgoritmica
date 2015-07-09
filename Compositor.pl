% ------------------------------------------------------------------------------
%
% UCR - Facultad de Ingeniería - ECCI
% CI-1441 Paradigmas Computacionales
% I-2015, Prof. Dr. Alvaro de la Ossa
% Oscar Esquivel Oviedo, B22410
%
% Proyecto de composición musical algorítmica
%
% ------------------------------------------------------------------------------

%
% Funciones útiles
%

% tamano/2(+L,-T)
tamano([], 0).
tamano([_|R], N) :-
   tamano(R, M), N is M + 1.

% nesimo/3(+N,+L,-X)
nesimo(1,[X|_],X).
nesimo(N,[_|R],E) :-
   M is N - 1, nesimo(M,R,E).

% concatena/3(+L1,+L2,-L3)
concatena([],L,L).
concatena([X|Xr],Y,[X|Zr]) :-
   concatena(Xr,Y,Zr).

% posicion/3(+O,+L,-P)
posicion(O,[O|_],1).
posicion(O,[_|R],N) :-
    posicion(O,R,M), N is M + 1.

% Random
random(R) :-
	R is random_float.
%%	random_between(+L:int, +U:int, -R:int) is semidet.
%
%	Binds R to a random integer in [L,U] (i.e., including both L and
%	U).  Fails silently if U<L.
random_between(L, U, R) :-
	integer(L), integer(U), !,
	U >= L,
	R is L+random((U+1)-L).
random_between(L, U, _) :-
	must_be(integer, L),
	must_be(integer, U).

loop_through_list(_File, []) :- !.
loop_through_list(File, [Head|Tail]) :-
    write(File, Head),
    write(File, ' '),
    loop_through_list(File, Tail).

escribirLista(List) :-
    open('cancion.txt', write, File),
    loop_through_list(File, List),
    close(File).

% ------------------------------------------------------------------------------

%
% Rock
%

%
% cancionRock/3(+escala,+melodía,-canción)
% Crea una canción de rock a partir de una escala guía y una melodía base.
cancionRock([],[],C) :-       % En su forma más simple pide una canción, sin especificar escala ni melodía inicial
    random_between(2,4,R),    % Crea un número aleatorio para la duración total de la melodía (compases)
    D is R * 4,               % Convierte la duración de compases a tiempos
    escogerEscala(E),		  % Escoge una de las escalas que hay
	tamano(E,S),			  % Obtiene el tamaño de la escala de una vez para no tener que volver a calcularlo
    generarMelodia(E,S,D,M),  % Genera una melodía a partir de esa escala y esa duración
    cancionRock(E,S,M,C).     % En su forma más compleja pide una canción, especificando una escala y una melodía
	
cancionRock([],M,C) :-        % Forma intermedia en que se pide una canción especificando sólo una melodía
    cancionRock(M,M,C).       % aquí usa la melodía como escala

cancionRock(E,S,M,X) :-       % Donde se construye la canción realmente
    random_between(2,4,I),
    J is I * 4,
    % random_between(1,2,N),
    % O is N * 4,
	generarTransicion(E,S,T), % Genera una transición a partir de la melodía, la retorna en T
    generarVerso(E,S,J,V),    % Genera un verso a partir de la melodía, la duración J, lo retorna en V
	% generarCoro(M,O,K),	  % Genera un coro a partir de la melodía, la duración U, lo retorna en K
	% generarCoroElevado(K,L),% Genera el coro elevado a partir del coro normal, lo retorna en L
	concatena(M,T,A),		  % Une la melodía con la transición
	concatena(A,V,B),	  	  % Une lo anterior con el primer verso
	% concatena(B,K,C),		  % Une lo anterior con el primer coro
	% concatena(C,T,D),		  % Une lo anterior con la transición
	% concatena(D,V,E),		  % Une lo anterior con el segundo verso
	% concatena(E,L,F).		  % Une lo anterior con el coro elevado
	% concatena(F,M,X).		  % Une lo anterior con el coro elevado
	X = B,
    escribirLista(X).         % Imprime la canción en un archivo para que Java la lea

%
% escogerEscala/1(-escala)
% Escoge una escala a partir de un valor aleatorio.
escogerEscala(E) :-
    E = [0,2,4,5,7,9,11, 12,14,16,17,19,21,23, 24,26,28,29,31,33,35, 36,38,40,41,43,45,47, 48,50,52,53,55,57,59, 60,62,64,65,67,69,71, 72,74,76,77,79,81,83, 84,86,88].  % Escala C mayor
    % agregar más escalas usando un número aleatorio como parámetro

%
% generarMelodia/2(+escala,+duracionTotal,-melodia)
% Genera una melodía a partir de una escala.
% Debe escoger una nota aleatoria con una duración aleatoria.
% Por ahora siempre escoge la misma duración, 1.
generarMelodia(_,_,0,[]).
generarMelodia(E,S,D,M) :-
    random_between(1,S,R),      % Crea un número aleatorio para generar notas
    nesimo(R,E,I),              % Escoje una nota inicial
    K is 1,                     % Escoje una duración para esa nota inicial
    P is D - K,                 % Duración total - duración de nota inicial
    concatena([I],[K],A),       % Genera el par nota,duracion "A" para la nota inicial
    generarNotas(E,S,P,I,1,N),  % Genera una lista de notas consecuentes N
    concatena([A],N,M).         % Finalmente, concatena la nota inicial A con la lista de notas N, en M, la N NO va entre []

% generarNotas/4(+escala,+duracionRestante,+notaAnterior,+duracionAnterior,-listaNotas)
generarNotas(_,_,0,_,_,[]).     % Si la duración restante es 0, retorna la lista que ya trae
generarNotas(_,_,0.0,_,_,[]).   % Si la duración restante es 0, retorna la lista que ya trae
generarNotas(E,S,D,I,Q,X) :-
	print(D),
    random_between(1,5,R),      % Crea un desplazamiento aleatorio a partir de la nota actual para la siguiente, por ahora entre 1 y 5
	random_between(0,1,U),		% Crea un número aleatorio para escoger el signo del desplazamiento, 0 negativo, 1 positivo
    generarNotaSiguiente(E,S,I,R,U,N),
	generarDuracionSiguiente(Q,Z),% Escoje una duración para esta nueva nota
    redondearDuracion(D,Z,K),	% Se asegura de no sobrepasar el máximo del compás
	% K is 1,
    P is D - K,                 % Duración total - duración de nueva nota
    concatena([N],[K],B),       % Genera el par nota,duracion "B" para la siguiente nota
    generarNotas(E,S,P,N,K,M),  % Continúa generando notas
    concatena([B],M,X).         % Concatena la recién generada con las demás, la M NO va entre []

% generarNotaSiguiente/4(+escala,+notaAnterior,+desplazamiento,-notaSiguiente)
generarNotaSiguiente(E,S,I,R,U,N) :-
	U == 0,						% Si el desplazamiento es negativo
    posicion(I,E,P),            % Guarda la posición de I dentro de E, en P
    Q is P - R,                 % Resta la posición de la nota actual menos el desplazamiento
    Q > 0,                  	% Si el desplazamiento no nos saca de las posiciones de E
    nesimo(Q,E,N).              % La nota siguiente S será la que estaba en ese desplazamiento
generarNotaSiguiente(E,S,I,R,U,N) :-
	U == 0,						% Si el desplazamiento es negativo
    posicion(I,E,P),            % Guarda la posición de I dentro de E, en P
    Q is P + R,                 % Resta a la posición de la nota actual el desplazamiento
    Q < S + 1,                  % Si el desplazamiento SÍ nos saca de las posiciones de E, sumamos en vez de restar
    nesimo(Q,E,N).              % La nota siguiente S será la que estaba en ese desplazamiento
generarNotaSiguiente(E,S,I,R,U,N) :-
	U == 1,						% Si el desplazamiento es positivo
    posicion(I,E,P),            % Guarda la posición de I dentro de E, en P
    Q is P + R,                 % Suma la posición de la nota actual más el desplazamiento
    Q < S + 1,                  % Si el desplazamiento no nos saca de las posiciones de E
    nesimo(Q,E,N).              % La nota siguiente S será la que estaba en ese desplazamiento
generarNotaSiguiente(E,S,I,R,U,N) :-
	U == 1,						% Si el desplazamiento es positivo
    posicion(I,E,P),            % Guarda la posición de I dentro de E, en P
    Q is P - R,                 % Resta a la posición de la nota actual el desplazamiento
    Q > 0,                      % Si el desplazamiento SÍ nos saca de las posiciones de E, restamos en vez de sumar
    nesimo(Q,E,N).              % La nota siguiente S será la que estaba en ese desplazamiento
% Como el desplazamiento máximo es 5 por ahora, nunca ocurrirá que se genere un número que sobrepase ambos límites


% generarDuracionSiguiente/(+duracionAnterior,-duracionSiguiente)
generarDuracionSiguiente(V,N) :-
    random_between(1,3,R),      % Crea un desplazamiento aleatorio a partir de la nota actual para la siguiente, 1=mitad, 2=igual, 3=duplicar
	generarDuracion(V,R,N).
generarDuracion(V,D,N) :-
	D == 1,						% La nueva será la mitad de la anterior
	A is V/2,
	A > 1/8,					% Duración mínima: 1/4
	N is A.
generarDuracion(V,D,N) :-
	D == 1,						% La nueva será la mitad de la anterior
	% A is V/2,
	% A <= 1/8,					% Duración mínima: 1/4
	B is V*2,					% Si es menor a eso, se duplica en lugar de dividir
	N is B.
generarDuracion(V,D,N) :-
	D == 2,						% La nueva será igual a la anterior
	N is V.
generarDuracion(V,D,N) :-
	D == 3,						% La nueva será la mitad de la anterior
	A is V*2,
	A < 4,						% Duración máxima: 2
	N is A.
generarDuracion(V,D,N) :-
	D == 3,						% La nueva será la mitad de la anterior
	% A is V*2,
	% A >= 4,						% Duración máxima: 2
	B is V/2,					% Si es menor a eso, se duplica en lugar de dividir
	N is B.
% redondearDuracion(+maximo,+duracionMala,-redondeo)
redondearDuracion(M,D,R) :-
	D < M,						% Si se generó una duración que excede el máximo
	R is D.						% se le resta la diferencia a esa duración
redondearDuracion(M,D,R) :-		% En cualquier otro caso (>=)
	R is M.						% se le resta la diferencia a esa duración
	
%
% generarTransicion/3(+escala,+duracionTotal,-verso)
% Genera un verso a partir de una escala.
% Debe escoger una nota aleatoria con una duración aleatoria.
% Por ahora siempre escoge la misma duración, 4.
generarTransicion(E,S,T) :-
    random_between(1,S,R),      % Crea un número aleatorio para generar notas
    nesimo(R,E,I),              % Escoje una nota inicial
	generarNotas(E,S,4,I,1,T).	% Genera 2 compases de notas

%
% generarVerso/4(+escala,+tamaño,+duracionTotal,-verso)
% Genera un verso a partir de una escala.
% Debe escoger una nota aleatoria con una duración aleatoria.
% Por ahora siempre escoge la misma duración, 4.
generarVerso(_,_,0,[]).
generarVerso(M,S,D,V) :-
    random_between(1,S,R),      % Crea un número aleatorio para generar notas
    nesimo(R,M,I),              % Escoje una nota inicial
    K is 4,                     % Escoje una duración para esa nota inicial
    P is D - K,                 % Duración total - duración de nota inicial
    concatena([I],[K],A),       % Genera el par nota,duracion "A" para la nota
    generarVerso(M,S,P,N),      % Genera una lista de notas consecuentes S para el resto del verso
    concatena([A],N,V).         % Finalmente, concatena la nota inicial A con la lista de notas S, en V
	
%
% generarCoro/2(+escala,+duracionTotal,-verso)
% Genera un verso a partir de una escala.
% Debe escoger una nota aleatoria con una duración aleatoria.
% Por ahora siempre escoge la misma duración, 4.
generarCoro(M,D,V) :-
	tamano(M,Z),
    random_between(1,Z,R),      % Crea un número aleatorio para generar notas
    nesimo(R,M,I),              % Escoje una nota inicial
    K is 4,                     % Escoje una duración para esa nota inicial
    P is D - K,                 % Duración total - duración de nota inicial
    concatena([I],[K],A),       % Genera el par nota,duracion "A" para la nota
    generarCoro(M,P,S),         % Genera una lista de notas consecuentes S para el resto del verso
    concatena([A],S,V).         % Finalmente, concatena la nota inicial A con la lista de notas S, en V
	
%
% generarCoroElevado/2(+escala,+duracionTotal,-verso)
% Genera un verso a partir de una escala.
% Debe escoger una nota aleatoria con una duración aleatoria.
% Por ahora siempre escoge la misma duración, 4.
generarCoroElevado(M,D,V) :-
	tamano(M,Z),
    random_between(1,Z,R),      % Crea un número aleatorio para generar notas
    nesimo(R,M,I),              % Escoje una nota inicial
    K is 4,                     % Escoje una duración para esa nota inicial
    P is D - K,                 % Duración total - duración de nota inicial
    concatena([I],[K],A),       % Genera el par nota,duracion "A" para la nota
    generarCoroElevado(M,P,S),  % Genera una lista de notas consecuentes S para el resto del verso
    concatena([A],S,V).         % Finalmente, concatena la nota inicial A con la lista de notas S, en V


% Enumeración de las notas según las cuerdas:
% 6: 0, 1, 2, 3, 4
% 5: 5, 6, 7, 8, 9
% 4: 10, 11, 12, 13, 14
% 3: 15, 16, 17, 18,
% 2: 19, 20, 21, 22, 23,
% 1: 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45
% Identificación de las notas según la numeración:
% 6: E, F, F#, G, G#
% 5: A, A#, B, C, C#
% 4: D, D#, E, F, F#
% 3: G, G#, A, A#
% 2: B, C, C#, D, D#
% 1: E, F, F#, G, G#, A, A#, B, C, C#, D, D#, E, F, F#, G, G#, A, A#, B, C, C#, D, D#, E, F








