%
% Fonction langue
%
% Créateur: MEK, mars 2009
% Reanudado más en serio en abril de 2015.
%
% ESPAÑOL
%
function varargout =langue_es(varargin)
  if nargout | nargin

    %___________________________________________________________________________
  	% Variable repetitive
    %---------------------------------------------------------------------------
    auTravail='Vamos';

  	%___________________________________________________________________________
  	%POUR AFFICHER LA LANGUE DE TRAVAIL
  	S.langue ='Español';
    %---------------------------------------------------------------------------

  	%___________________________________________________________________________
  	% Variable mnuip
  	% MENÚ PRINCIPAL INTERFACE
    %---------------------------------------------------------------------------
    S.mnuip.file ='Archivo';
    S.mnuip.fileouvrir ='Abrir';
    S.mnuip.fileouvrirot ='Abrir otros';
    S.mnuip.fileouvrirottxt ='Texto delimitado';
    S.mnuip.fileouvrirotauto21 ='.&XML (Auto21)';
    S.mnuip.fileouvriroti2m ='.&H5 (I2M)';
    S.mnuip.fileouvrirotc3d ='.&C3D (Vicon)';
    S.mnuip.fileouvrirotemg ='.&MAT (Emg)';
    S.mnuip.fileouvrirotkeit ='.ADW (&Keitley)';
    S.mnuip.fileajout ='Añadir';
    S.mnuip.filebatch ='Procesamiento Por Lotes';
    S.mnuip.filefermer ='Cerrar';
    S.mnuip.filesave ='Guardar';
    S.mnuip.filesaveas ='Guardar como';
    S.mnuip.fileexport ='Exportación';
    S.mnuip.fileecritresult ='Escribir los resultados';
    S.mnuip.fileprint ='Imprimir';
    S.mnuip.fileprintcopiecoller ='Copiar-Pegar';
    S.mnuip.fileprintjpeg ='Archivo JPEG';
    S.mnuip.fileprintimprimer ='Imprimir';
    S.mnuip.filedernierouvert ='Recientemente inaugurado';
    S.mnuip.filepreferences ='Preferencias';
    S.mnuip.fileredemarrer ='Reiniciar Analyse';
    S.mnuip.fileterminus ='Término';

    S.mnuip.edit ='Edición';
    S.mnuip.editmajcan ='actualizar la información de los canales seleccionados.';
    S.mnuip.editcanal ='Canal';
    S.mnuip.editcopiecanal ='Copiar canal';
    S.mnuip.editdatautil ='Grupo de la carga útil';
    S.mnuip.editcatego ='Categoría';
    S.mnuip.editrebatircatego ='Reconstruir Categorías';
    S.mnuip.editecheltemps ='Escala de tiempo';

    S.mnuip.modif ='Modificar';
    S.mnuip.modifcorriger ='Corregir';
    S.mnuip.modifcouper ='&Cortar';
    S.mnuip.modifdecouper ='Recortar';
    S.mnuip.modifdecimate ='Diezmar';
    S.mnuip.modifrebase ='&Rebase';
    S.mnuip.modifrotation ='Rotación ';
    S.mnuip.modifsynchroess ='&Sincronizar los ensayos';
    S.mnuip.modifsynchrocan ='&Sincronizar los canales';

    S.mnuip.math ='Ma&th.';
    S.mnuip.mathderivfil ='Derivado/Filtro de';
    S.mnuip.mathderivfilbutter ='&ButterWorth';
    S.mnuip.mathderivfilsptool ='Con archivo sptool';
    S.mnuip.mathderivfildiffer ='&Differ';
    S.mnuip.mathderivfilpolynom ='Tratamiento polinómica';
    S.mnuip.mathintdef ='Integral definida';
    S.mnuip.mathintcum ='Integral acumulativo';
    S.mnuip.mathnormal ='Normalizar';
    S.mnuip.mathnormaltemp ='Normalización temporal';
    S.mnuip.mathellipsconf ='Confianza elipse';
    S.mnuip.mathmoyectyp ='Media y desviación estándar';
    S.mnuip.mathmoyectyp ='Moy./Ecart-type par catégorie';
    S.mnuip.mathmoyptmarq ='Promedio alrededor de los puntos marcados';
    S.mnuip.mathpentedrtregr ='Pendiente de la línea de regresión';
    S.mnuip.mathcalcang ='Calcula el ángulo';
    S.mnuip.mathtraitcan ='Tratamiento de canal';

    S.mnuip.emg ='Em&g';
    S.mnuip.emgrectif ='Rectificación';
    S.mnuip.emgliss ='Liso';
    S.mnuip.emgrms ='RMS';
    S.mnuip.emgmav ='MAV';
    S.mnuip.emgffm ='F-Mediana/Media/Máx';
    S.mnuip.emgnormal ='Normalización';
    S.mnuip.emgintegsucc ='Integraciones (sucesiva)';
    S.mnuip.emgchgpolar ='Cambio de polaridad';
    S.mnuip.emgdistprbampl ='Distribución de probabilidad de amplitud';

    S.mnuip.fplt ='FPlt';
    S.mnuip.fpltcop ='Centro de presión (COP) y COG AMTI';
    S.mnuip.fpltcopparammanuel ='La entrada manual de parámetros';
    S.mnuip.fpltcopparamfichier ='Entrada Parámetros por archivo';
    S.mnuip.fpltcopoptima ='COP y COG Optima';
    S.mnuip.fpltstat4cop ='Stat-4-COP';

    S.mnuip.trajet ='Trayectoria';
    S.mnuip.trajetgps ='GPS';
    S.mnuip.trajetgpsecef2lla ='(GPS)ECEF hacia LLA';
    S.mnuip.trajetecart ='Brecha';
    S.mnuip.trajetdiffinterpt ='Diferencia entre el punto';
    S.mnuip.trajetdistparcour ='Distancia recorrido X-Y-(Z)';
    S.mnuip.trajetamplmvt ='Amplitud de movimiento';
    S.mnuip.trajetdirect ='Dirección';
    S.mnuip.trajetcourb ='Curvatura';

    S.mnuip.ou ='Herramienta';
    S.mnuip.ouechtempo ='Escala de tiempo';
    S.mnuip.ouechtempodefaut ='Retorno a la escala predeterminada';
    S.mnuip.ouimportpoint ='Importar puntos (Y vs X)';
    S.mnuip.outrierpt ='Ordenar puntos anotados';
    S.mnuip.oumark ='Marcar';
    S.mnuip.ouzoom ='Zoom';
    S.mnuip.ouaffichercoord ='Mostrar coordenadas';
    S.mnuip.oucouleur ='Ver colores para ';
    S.mnuip.oucouleurcan ='diferenciar los canales';
    S.mnuip.oucouleuress ='diferenciar los ensayos';
    S.mnuip.oucouleurcat ='diferenciar los categorías';
    S.mnuip.oulegend ='Mostrar leyenda';
    S.mnuip.ouechant ='Mostrar muestras';
    S.mnuip.ouptmarkatexte ='Mostrar puntos marcados con el texto';
    S.mnuip.ouptmarkstexte ='Mostrar puntos marcados sin el texto';
    S.mnuip.ouaffprop ='Mostrar curva proporcional';
    S.mnuip.ouxy ='Mostrar (Canal-Y vs Canal-X)';

    S.mnuip.quelfichier ='Cual Archivo';

    S.mnuip.hlp ='Ayuda';
    S.mnuip.hlpdoc ='Pequeño recordatorio, en caso de pánico  :-)';
    S.mnuip.hlplog ='histórico';
    S.mnuip.hlplogbook ='Libro de registro';
    S.mnuip.hlpabout ='Sobre Analyse';

  	%___________________________________________________________________________
  	% Variable guiip
  	% BOUTON DE L'INTERFACE PRINCIPAL
    %---------------------------------------------------------------------------

    S.guiip.gntudebut ='Para comenzar debe abrir un archivo.';
    S.guiip.pbvide ='vacía';
    S.guiip.pbcanmarktip ='Selección del canal para el marcado manual';
    S.guiip.pbdelpttip ='Borrar el punto seleccionado';
    S.guiip.pbmarmantip ='Marcando manual con el ratón';
    S.guiip.pbcoord ='Coord.';
    S.guiip.pbcoordtip ='Visualización de uno cursor con sus coordenadas (X,Y)';

    %___________________________________________________________________________
    % Variable lire
    % GUI POUR LA LECTURE DES DIFFÉRENTS FORMATS SUPPORTÉS
    %---------------------------------------------------------------------------

    % mnouvre2
    S.lire.txtwbar ='Apertura el archivo: ';

    % Waitbar
    S.lire.lectfich ='lectura del archivo ';
    S.lire.lectfichs ='lectura de los archivos ';
    S.lire.vide ='';
    S.lire.vides ='';
    S.lire.patience =', espere por favor';
    S.lire.lectcanal ='Lectura del canal: ';
    S.lire.fichier ='Archivo: ';
    S.lire.concatinfo ='Concatenación de información: ';
    S.lire.canal ='Canal ';
    S.lire.fairess ='Construcción de la sesión: ';

    % Keithley
    S.lire.kiname ='Leer archivos de Keithley';
    S.lire.kichoixfich ='Archivo de keithley elección';
    S.lire.kiinscripath ='Escriba la ruta completa';
    S.lire.kiutilisezvous ='¿Utiliza múltiple ...?';
    S.lire.kitxtsess ='sesión';
    S.lire.kitxtcond ='condicion';
    S.lire.kitxtseqtyp ='seq-type';
    S.lire.kibuttonGo =auTravail;
    S.lire.kinomfich ='archivo de adquisición de datos de Keithley.';
    S.lire.kilectwbar ='lectura del archivo Keithley, espere por favor';

    %___________________________________________________________________________
    % Variable guipref
    % GUI DE LA GESTION DES PRÉFÉRENCES
    %---------------------------------------------------------------------------
    S.guipref.name ='Preferencias';

    S.guipref.ongen ='General';
    S.guipref.ongenconserv =['Guardar preferencias para las próximas sesiones.'];
    S.guipref.ongenlang ='Nombre de archivo para el idioma de trabajo (en el directorio "doc"): ';
    S.guipref.ongenrecent ='Número de archivos en el menú "recientemente inaugurado": ';
    S.guipref.ongenerr =['Visualización de los mensajes de error en la consola: '];
    S.guipref.ongenerrmnu ={'No se repite', 'Mensajes completos', ...
                          'Nombre de la función + Título del Mensaje', 'Sólo titulo del mensaje'};

    S.guipref.onaff ='Visualización';
    S.guipref.onafftip ='Configuración de opciones de gráficos';
    S.guipref.onafftxfix =sprintf('Bloqueo \nconfig.');
    S.guipref.onafftxactiv =sprintf('Activado\nsi se marca');
    S.guipref.onaffactxy ='Activar el modo XY';
    S.guipref.onaffpt ='Mostrar puntos anotados';
    S.guipref.onaffpttyp ={'Ocultar los puntos anotados', 'Mostrar los puntos anotados y la información', ...
                         'Mostrar los puntos anotados sin la información'};
    S.guipref.onaffzoom ='Activar el zoom';
    S.guipref.onaffcoord =S.mnuip.ouaffichercoord;
    S.guipref.onaffsmpl =S.mnuip.ouechant;
    S.guipref.onaffccan =[S.mnuip.oucouleur S.mnuip.oucouleurcan];
    S.guipref.onaffcess =[S.mnuip.oucouleur S.mnuip.oucouleuress];
    S.guipref.onaffccat =[S.mnuip.oucouleur S.mnuip.oucouleurcat];
    S.guipref.onaffleg =S.mnuip.oulegend;
    S.guipref.onaffproport =S.mnuip.ouaffprop;

    S.guipref.onot ='Au delà des rumeurs...';
    S.guipref.onottip ='Mas alla rumores...';
    S.guipref.onottit ='Preferencias';
    S.guipref.onotp1 =sprintf(['\nPreferencias guardadas se asegurarán de que la interfaz ' ...
                    'de trabajo será como usted lo necesita en cada abertura. ' ...
                    'No te olvides de hacer clic en el botón "Aplicar" para guardar Cambios.']);
    S.guipref.onotp2 =sprintf(['\nEn la pestaña "General", la opción "Guardar Preferencias..."' ...
                    '\n Si se marca, le permite mantener las preferencias para las sesiones futuras. ' ...
                    '\n Si no se marca, se iniciará con los defectos de los valores básicos.']);
    S.guipref.onotp3 =sprintf(['\nLa pantalla de mensajes de error, puede tomar muchas formas. ' ...
                    'Esto le permite tener más o menos texto mostrado por los errores sin importancia.']);
    S.guipref.onotp4 =sprintf(['\nEn la pestaña "Visualización", hay dos columnas: "Bloqueo config." y ' ...
                    '"Activado si se marca". Si marca la columna "Bloqueo ..." usted ' ...
                    'se impone sobre el valor de la casilla "Activado ..." para esta variable.']);
    S.guipref.onotp5 =sprintf(['\nPor contra, si no marque la casilla de la columna "Bloqueo ...", el valor ' ...
                    'Para esta variable será la cuando cierre la aplicación.' ...
                    '\n\n(Por ejemplo, la línea de "Activar el zoom"' ...
                    '\n  si la casilla "Bloqueo" está marcada' ...
                    '\n    Con casilla "Activado" marcada: el zoom se activará' ...
                    '\n    Con casilla "Activado" marcada: el zoom estará inactivo' ...
                    '\n\n  si la casilla "Bloqueo" no está marcada' ...
                    '\n    Al final de análisis, el estado de zoom va' ...
                    '\n    a decidir el valor al volver a abrir.)']);
    S.guipref.onotp6 =sprintf(['\nNota: para guardar los cambios, debe hacer clic en el botón "Aplicar" ']);

    S.guipref.onstat ='Introduzca sus preferencias por fin de mejorar su sesión de trabajo';

    S.guipref.btapplic ='Aplicar';

    %___________________________________________________________________________
    % Variable guimoypentri
    % GUI POUR MOYENNE/PENTE/TRIER POINTS
    %---------------------------------------------------------------------------
    S.guimoypentri.name1 ='MENÚ PROMEDIO DE ALREDEDOR DE ...';
    S.guimoypentri.name2 ='MENÚ DE PENDIENTE ENTRE DOS PUNTOS';
    S.guimoypentri.name3 ='MENÚ DE ORDENAR PUNTOS ...';

    S.guimoypentri.selcan ='Selección canales';
    S.guimoypentri.seless ='Selección ensayos';
    S.guimoypentri.toutess ='Todos los ensayos';

    S.guimoypentri.lesep ='Separador:';
    S.guimoypentri.selsep ={'coma','punto y coma','Tab'};

    S.guimoypentri.fentrav ='ventana de trabajo';
    S.guimoypentri.rangtrav ='Gama de puntos a ordenar';
    S.guimoypentri.fentravtip1 =sprintf('valor numérico -> Tiempo\n\nP0 o Pi -> primera muestra\nPF -> última muestra\np1 p2 p3 ... -> punto marcado');
    S.guimoypentri.fentravtip2 =sprintf('p0 o pi --> primera muestra\npf --> última muestra\np1 p2 p3 ... --> punto marcado');
    S.guimoypentri.rangtravtip =sprintf('P0, Pi, P1 --> primero punto\nPf o end --> último punto\nP1 P2 P3 ... --> punto marcado');

    S.guimoypentri.autpts ='Alrededor de los puntos';
    S.guimoypentri.autpttip =sprintf('valor numérico para indicar la medida antes y después\ndel punto a tener en cuenta a la media');
    S.guimoypentri.valneg ='Valor por ignorar';
    S.guimoypentri.valnegtip =sprintf('Valor numérico para cambiar el rango útil -> [(Primero punto + Valor) hasta (segundo punto - Valor)]');
    S.guimoypentri.tipunit ={'Muestras','segundos'};
    S.guimoypentri.maw =auTravail;

    S.guimoypentri.info1 ='Por defecto, si no la marca "Alrededor de los puntos", el promedio será de unos valores entre los dos terminales de la ventana de trabajo / si es marcado / haremos el promedio de alrededor de los puntos anotados.';
    S.guimoypentri.info2 ='El cálculo de la pendiente se llevará a cabo de acuerdo con la ventana de trabajo proporcionado y el "punto de emparejamiento" solicitada. El valor por ignorar reducirá el margen de trabajo: a la derecha del primer punto y a la izquierda del segundo.';
    S.guimoypentri.info3 ='Para ordenar en orden ascendente, se escribe: [P1 Pf]. Y en orden descendente: [Pf P1]. Del mismo modo, para ordenar el último 5: [end-4 end]';

    % Partie Au Travail
    S.guimoypentri.wbar1 ='Promediando';
    S.guimoypentri.wbar2 ='Cálculando';
    S.guimoypentri.wbar3 ='Ordenando puntos';

    S.guimoypentri.putfich1 ='Resultado de los promedios';
    S.guimoypentri.putfich2 ='Resultado de las Pendientes';
    S.guimoypentri.errfich ='Error en el archivo de salida.';

    S.guimoypentri.fichori ='Archivo original';
    S.guimoypentri.legcan ='Leyenda canales';
    S.guimoypentri.vnegli =S.guimoypentri.valneg;
    S.guimoypentri.moyfait1 ='El promedio fue hecha de';
    S.guimoypentri.moyfait2 ='El promedio se hace del espacio definido por arriba';
    S.guimoypentri.autpt ='alrededor del punto';
    S.guimoypentri.penfait ='La pendiente se hace del espacio definido por arriba';
    S.guimoypentri.titess ='Ensayo';

    S.guimoypentri.m2pt ='A menos de 2 puntos, no clasificación';
    S.guimoypentri.errsyn ='Error en la sintaxis de "Gama de puntos a ordenar"';
    S.guimoypentri.lecan ='para el canal';
    S.guimoypentri.less ='y el ensayo';

    %___________________________________________________________________________
    % Variable guitretcan
    % GUI DU TRAITEMENT DE CANAL
    %---------------------------------------------------------------------------
    S.guitretcan.name ='Tratamiento de canal';

    S.guitretcan.title ='Cálculo en los canales';
    S.guitretcan.alltrial ='Aplicar  a todos los ensayos';
    S.guitretcan.keeppt ='Preservar punto anotado';
    S.guitretcan.keeppttip ='Preservar punto anotado, cuando se escribe el resultado a un canal existente';
    S.guitretcan.seless ='Selección ensayos';
    S.guitretcan.selcat ='selección categorías';
    S.guitretcan.ligcommtip ='Cada elemento debe estar separado por comas';
    S.guitretcan.delstr ='Borr';
    S.guitretcan.canal ='Selección canales';
    S.guitretcan.clavnum ='Teclado / Operadores';
    S.guitretcan.clavfnctip =',  se interpretará como: C1 ';
    S.guitretcan.fonction ='selección Funciones';
    S.guitretcan.fnctlist ={'Pi',['La constante trigonométrica ' char(182)];...
                'Sin',sprintf('La función sin de Matlab,\nEx:\n-  Si se escribe:  C1,sin,\n-  se interpretará como:  sin(C1)');...
                'Cos',sprintf('La función cos de Matlab,\nEx:\n-  Si se escribe:  C1,cos,\n-  se interpretará como:  cos(C1)');...
                'Tan',sprintf('La función tan de Matlab,\nEx:\n-  Si se escribe:  C1,tan,\n-  se interpretará como:  tan(C1)');...
                'Diff',sprintf('La función diff de Matlab,\nEx:\n-  Si se escribe:  C1,diff,\n-  se interpretará como:  diff(C1)\n \nTenga en cuenta que la función diff nos devuelve un vector de longitud N-1,\nAnalise añade "0" como la primera muestra (manteniendo el mismo número de muestras\ncomo el canal de origen). ');...
                'Abs',sprintf('La función abs de Matlab,\nEx:\n-  Si se escribe:  C1,abs,\n-  se interpretará como:  abs(C1)');...
                'Distancia 1D',sprintf('Calcula la distancia entre dos puntos en una recta.\n- Requerirá dos canales (C1 et C2).\n- Por lo tanto el cálculo:\n \n__  OUT = abs( C1 - C2 )');...
                'Distancia 2D',sprintf('Calcula la distancia entre dos puntos en un plano.\n- Requerirá cuatro canales (C1,C2 et C3,C4).\n- Por lo tanto el cálculo:\n \n__  OUT = sqrt( (C1-C3)^2 + (C2-C4)^2 )');...
                'Distancia 3D',sprintf('Calcula la distancia entre dos puntos en un volumen.\n- Requerirá seis canales (C1,C2,C3 et C4,C5,C6).\n- Por lo tanto el cálculo:\n \n__  OUT = sqrt( (C1-C4)^2 + (C2-C5)^2 + (C3-C6)^2 )');...
                'Long. Vect.',sprintf('Calcula la longitud del vector cuyo origen es [0 0 0].\n- Requerirá tres canales (C1,C2,C3).\n- Por lo tanto el cálculo:\n \n__  OUT = sqrt( C1^2 + C2^2 + C3^2 )');...
                'Suma acum.',sprintf('La función cumsum de Matlab,\nEx:\n-  Si se escribe:  C1,csum,\n-  se interpretará como:  cumsum(C1)');...
                'Sqrt',sprintf('La función sqrt de Matlab,\nEx:\n-  Si se escribe:  C1,sqrt,\n-  se interpretará como:  sqrt(C1)');...
                'Exp',sprintf('La función exp de Matlab,\nEx:\n-  Si se escribe:  C1,N,exp,\n-  se interpretará como:  C1^N')};

    S.guitretcan.triginv ='Inv';
    S.guitretcan.triginvtip ='Para las funciones trigonométricas solamente (asin, acos ou atan), comprobado';
    S.guitretcan.deg ='Grado';
    S.guitretcan.degtip ='radianes, si no se controla';
    S.guitretcan.buttonGo =auTravail;

    %___________________________________________________________________________
    % Variable guimark
    % GUI DU MARQUAGE
    %---------------------------------------------------------------------------
    S.guimark.name ='PARA SALIR DE MARCADO, haga clic en la X a la derecha  > > > >';

    %(PP) PANEL PERMAMENT
    S.guimark.ppaid ='?';
    S.guimark.ppaidtip ='Documentación sobre el marcado, sólo en francés.';
    S.guimark.ppcansrc ='Origen';
    S.guimark.ppptsmrk ='Pts';
    S.guimark.ppdelptall ='Todos los pts';
    S.guimark.ppdelptalltip ='Seleccionar todos los puntos de los canales y los ensayos seleccionados para su eliminación';
    S.guimark.ppdelenumtip =sprintf('Índices de los puntos a eliminar, orden creciente, por ejemplo: 1,2,3,6:9,12 = 1 2 3 6 7 8 9 12');
    S.guimark.ppdelpthide ='Esconder';
    S.guimark.ppdelpthidetip =sprintf('Eliminar el punto deseado sin cambiar el orden de los siguientes.\nLos borrados puntos se convertirán en puntos falsos.');
    S.guimark.ppdelbutton ='Borr.';
    S.guimark.ppdelbuttontip ='Eliminar todos los puntos seleccionados anteriormente.';
    S.guimark.ppesscat ='Marcado ensayo (s) o categoría (s)';
    S.guimark.ppesscattip ='Si desactivada, se seleccionan todos los ensayos';
    S.guimark.ppreplace ='Vuelva a colocar los puntos seleccionados arriba';
    S.guimark.ppreplacetip ='En modo de exportación: el punto de origen (i) -> punto de destino (i)';

    % BOUTON GO...START...AU TRAVAIL
    S.guimark.buttonGo =auTravail;

    %(PO) PANEL DES ONGLETS

    % ONGLET EXPORTATION
    S.guimark.poexpletit ='Exp.';
    S.guimark.poexpletittip ='Exportación de un canal a otro';
    S.guimark.poexpnom ='Exportación';
    S.guimark.poexpcorr ='Correspondencia canal de origen (i) -> canal de destino (i)';
    S.guimark.poexpcorrtip ='Se debe tener: (número de canales de origen) = (número de canales de destino)';
    S.guimark.poexpcandst ='Destino';

    % ONGLET MINMAX
    S.guimark.pominletit ='Mín.';
    S.guimark.pominletittip ='Mín Máx';
    S.guimark.pominnom ='Mín.Máx.';
    S.guimark.pominmin ='Mínimo';
    S.guimark.pominmax ='Máximo';

    % ONGLET MONTÉ...
    S.guimark.pomonteletit ='Ascenso.';
    S.guimark.pomonteletittip ='Inicio - final: Ascenso - Descenso';
    S.guimark.pomontenom ='Ascenso - Descenso';
    S.guimark.pomontemnt ='Ascenso';
    S.guimark.pomontedbt ='Inicio';
    S.guimark.pomontefin ='Final';
    S.guimark.pomontedsc ='Descenso';
    S.guimark.pomontedytxt ='Delta Y';
    S.guimark.pomontedytxttip ='Diferencia de amplitud necesaria para considerar un ascenso o descenso';
    S.guimark.pomontedytip =sprintf('Valor de la variación en la amplitud (Ej: 10, 150, etc.)\no el porcentaje de max-min (Ej. 10%%, 45%%, etc.)\n de la que se tiene en cuenta que hay un ascenso o descenso.\nPor defecto (si se deja en 0) sera 50%%: (Max - Min) X 50%%');
    S.guimark.pomontedxtxt ='Delta X';
    S.guimark.pomontedxtxttip ='Diferencia temporaria (sec.) necesaria para subir o bajar de Delta Y';
    S.guimark.pomontedxtip ='Tiempo (sec.) en fin de tener una variación de amplitud de al menos DeltaY. Si se deja a 0: ¼ sec.';
    S.guimark.pomontedttxt ='Delta T';
    S.guimark.pomontedttxttip ='Número de muestras para ser considerado para discriminar a los "pequeños picos no deseados" (ruido)';
    S.guimark.pomontedttip ='Número de muestras para ser considerado para declarar un comienzo o un fin. Predeterminado = 3 (Si se deja en cero)';
    S.guimark.pomontedef ='D';
    S.guimark.pomontedeftip ='Predeterminados (o cero) de este marco';

    % ONGLET TEMPOREL
    S.guimark.potmpletit ='Tiempo.';
    S.guimark.potmpletittip ='Marcar el tiempo';
    S.guimark.potmpnom ='Marcar el tiempo';
    S.guimark.potmpvaltxt ='Tiempo preciso o punto índice: ';
    S.guimark.potmpvaltip ='Primera tiempo específico a marcar (puede ser el número de un punto existente para marcar los sucesivos puntos Ej: p1)';
    S.guimark.potmpstep ='Intervalo entre el punto subsiguiente: ';
    S.guimark.potmpsteptip ='De vez por encima, el número de segundos hasta el siguiente punto';

    % ONGLET AMPLITUDE
    S.guimark.poampletit ='Amplit.';
    S.guimark.poampletittip ='Marca de amplitud';
    S.guimark.poampnom ='amplitud Marcando';
    S.guimark.poampvaltxt ='Amplitud (o indice de punto) para marcar: ';
    S.guimark.poampvaltip =sprintf('(valor numérico=Amplitud) de otra manera,\nla amplitud del tema grabado se considera (p0, pi: primera muestra),\n(pf = última muestra), (y p1 p2 p ... Punto anotó)');
    S.guimark.poamppcenttxt ='% De la amplitud de punto por encima: ';
    S.guimark.poamppcenttip =sprintf('Si se ha registrado un punto en lugar de una amplitud anteriormente,\nes posible que desee un porcentaje de la amplitud correspondiente');
    S.guimark.poampdectxt ='Desplazamiento de tiempo +/-: ';
    S.guimark.poampdectip =sprintf('La amplitud se considera desde el punto que solicitó arriba,\ncompensar el valor de tiempo (en seg.) registrado aquí.');
    S.guimark.poampdirtxt ='Dirección: ';
    S.guimark.poampdir ={'Hacia el final >>>', '<<< Hacia el principio'};
    S.guimark.poampdirtip ='¿Por dónde empezar punto de puntuación Nº 1, de la izquierda o la derecha?';

    % ONGLET EMG
    S.guimark.poemgletit ='Emg.';
    S.guimark.poemgletittip ='Marcar el comienzo y final de la actividad muscular en la señal de EMG';
    S.guimark.poemgnom ='Marcando EMG';
    S.guimark.poemgrefdoc ='Ref/Doc';
    S.guimark.poemgaglrhtxt ='El umbral (h):';
    S.guimark.poemgaglrhtip =sprintf('Elija un valor h lo más pequeño posible que todavía produce\nuna cantidad tolerable de falsas alarmas.');
    S.guimark.poemgaglrltxt ='Ventana deslizante de prueba, en muestras (L):';
    S.guimark.poemgaglrltip =sprintf('Seleccionar L lo más grande posible (con el fin de obtener\nestimaciones de la varianza fiables después del cambio), pero más pequeño que la\népoca estacionaria más corto (es decir, época con varianza constante) a detectar.');
    S.guimark.poemgaglrdtxt ='Número mínimo de muestras (d):';
    S.guimark.poemgaglrdtip =sprintf('Número mínimo de muestras utilizado para estimar ML.\nElegir d tal que d + ta todavía se encuentra dentro de la época\nestacionaria indicada por la Corriente de alarma Tiempo ta. Este parámetro no\nes muy crítico. Por lo general, un pequeño número de muestras (por ejemplo, d = 10) lo hará.');
    S.guimark.poemgvoir ='Verificar';
    S.guimark.poemgvoirtip ='Probar los parámetros en el primer canal / ensayo seleccionado.';

    % ONGLET BIDON
    S.guimark.pobidletit ='Falso';
    S.guimark.pobidletittip ='Añadir un punto falso';
    S.guimark.pobidnom ='Punto falso';
    S.guimark.pobidpostxt ='Posición del punto falso: ';
    S.guimark.pobidposmantip ='Si se deja en blanco, el ListBox derecha se lee';
    S.guimark.pobidposmantxt ='(O, con el teclado): ';

    % ONGLET TEST
    S.guimark.potestletit ='Prueba';
    S.guimark.potestletittip ='Detección de cambios';
    S.guimark.potestnom ='Detección cambios';
    S.guimark.potestdoctxt ='Para una explicación, consulte: http://nbviewer.ipython.org/github/demotu/BMC/blob/master/notebooks/DetectCUSUM.ipynb';
    S.guimark.potestseuiltxt ='Umbral, (Threshold)';
    S.guimark.potestseuiltxttip ='El valor mínimo para la detección de un cambio';
    S.guimark.potestseuiltip ='Valor exceda durante la suma acumulada';
    S.guimark.potestgplus ='Ascenso (+)';
    S.guimark.potestgmoins ='Descenso (-)';
    S.guimark.potestdriftxt ='Deriva, (Drift)';
    S.guimark.potestdriftxttip ='Para evitar falsos positivos o suaves pendientes largos';
    S.guimark.potestdriftip ='Valor de deriva, también puede cancelar la parte de la señal de ruido';
    S.guimark.potestvoir ='Verificar';
    S.guimark.potestvoirtip ='Prueba el umbral y la deriva en el primero ensayo seleccionado y muestra g+ y g-';

    % EN COURS DE ROUTE
    S.guimark.po_ou ='o';
    S.guimark.po_et ='y';
    S.guimark.po_debut ='inicio';
    S.guimark.po_fin ='final';
    S.guimark.potravchmnm ='Tienes que eligir Min y/o Max';
    S.guimark.potravchmddm ='Tienes que hacer al menos una opción ascenso/descenso/start/end';
    S.guimark.potravchmd ='Tienes que hacer al menos una opción ascenso/descenso';
    S.guimark.potravchmontdesc ='ascenso/descenso';
    S.guimark.potravcan ='canal';
    S.guimark.potravess ='ensayo';
    S.guimark.potravnpt ='nú.punto';
    S.guimark.potravdfinterr ='Error en el inicio y / o final del rango de trabajo';
    S.guimark.potraverrfnc ='Error en la función';
    S.guimark.potravemgrech ='Buscando actividad muscular para';
    S.guimark.potravafflon ='La visualización de curvas y marcas puede ser larga ...';
    S.guimark.potravetmperr ='Mala expresión de tiempo';
    S.guimark.potraveincerr ='Mala expresión de incremento';
    S.guimark.potravexpr ='Expresión';
    S.guimark.potravnvalid ='mala';
    S.guimark.potravsderiv ='Los valores del umbral y de la deriva no pueden ser cero al mismo tiempo';
    S.guimark.potravcusumrech ='Buscando cambio ...';
    S.guimark.potravfermer ='El retorno a la pantalla regular puede ser bastante largo cuando hay varias marcas para mostrar';
    S.guimark.potravmaw ='cerebro electrónico en el trabajo';

    % TEXTE COMMUN
    S.guimark.pocommunrepet ='Núm. de repeticiones: ';
    S.guimark.pocommunint ='Toda intervalo';
    S.guimark.pocommuninttip ='repetir el marcado subsiguiente en todo el rango de trabajo.';
    S.guimark.pocommunintertxt ='[ Rango de trabajo ]';
    S.guimark.pocommunintertxttip =sprintf('(p0 = primera muestra, pf = última muestra)\n(valor numérico = tiempo en seg.) o\np1, p2 ... por un punto previamente marcado');
    S.guimark.pocommuninterdbttip ='Para empezar en la primera muestra, dejar P0 o Pi';
    S.guimark.pocommuninterfintip ='Si se deja a Pf, se usará la última muestra de este canal';
    S.guimark.pocommuncanexttip ='Ponga una copia de los puntos de anotar por encima a los canales elegidos por debajo de los contras';
    S.guimark.pocommunrempltip ='Copie reemplazando el punto si es necesario.';

    % BAR DE STATUS
    S.guimark.barstatus ='Comience eligiendo el tipo de marca, a continuación, rellene las opciones necesarias';

    %___________________________________________________________________________
    % Variable 
    % 

    % dlg.ctrgrdat     EDIT REGROUPER DATAS UTILES
    dlg.ctrgrdat.nom ='Regroupement des données utiles';
    dlg.ctrgrdat.titre ='Type de séparation';
    dlg.ctrgrdat.choix1 =['Autour d''un seul point'];
    dlg.ctrgrdat.choix1 ='À partir de deux points';
    dlg.ctrgrdat.choix1 ='';
    

    dlg.ctrl.status ='Vous devez ouvrir un fichier pour commencer.';
    dlg.ctxt.zoomxy ='Zoom en X et Y';
    dlg.ctxt.zoomx ='Zoom en X Seulement';
    dlg.ctxt.zoomy ='Zoom en Y Seulement';
    dlg.ctxt.zoomplein ='Pleine page';
    dlg.ctxt.zoomoff ='Désactivez le Zoom';

    %Écriture des textes dans le fichier
    if nargin
      if isempty(dir(varargin{1}))
    	  save(varargin{1},'-struct','S', '-v6');
    	else
    	  save(varargin{1},'-struct','S','-append');
    	end
    else
    	varargout(1) =S;
    end
  else
  	disp({'Dé un nombre de archivo de entrada o una variable para la salida';...
  	      'Ej.'; 'langue_es(''es.mat'') o ';'es = langue_es'});
  end
return
