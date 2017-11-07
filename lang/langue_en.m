%
% Function langue_en
%
% Créateur: MEK, mars 2009
% Rigorously resumed in April 2015
%
% English
%
function varargout =langue_en(varargin)
  if nargout | nargin

    %___________________________________________________________________________
  	% Variable repetitive
    %---------------------------------------------------------------------------
    auTravail='Au travail';

    %___________________________________________________________________________
  	%TO DISPLAY THE WORKING LANGUAGE
    %---------------------------------------------------------------------------
  	S.langue ='English';

    %___________________________________________________________________________
  	% Variable mnuip
  	% MENU OF THE MAIN GUI
    %---------------------------------------------------------------------------
    S.mnuip.file ='&File';
    S.mnuip.fileouvrir ='&Open';
    S.mnuip.fileouvrirot ='Ot&her file format';
    S.mnuip.fileouvrirottxt ='&Delimiter-separated values (text)';
    S.mnuip.fileouvrirotauto21 ='.&XML (Auto21)';
    S.mnuip.fileouvriroti2m ='.&H5 (I2M)';
    S.mnuip.fileouvrirotc3d ='.&C3D (Vicon)';
    S.mnuip.fileouvrirotemg ='.&MAT (Emg)';
    S.mnuip.fileouvrirotkeit ='.ADW (&Keitley)';
    S.mnuip.fileajout ='&Add';
    S.mnuip.filebatch ='&Batch Processing';
    S.mnuip.filefermer ='&Close';
    S.mnuip.filesave ='&Save';
    S.mnuip.filesaveas ='Sa&ve as';
    S.mnuip.fileexport ='&Export';
    S.mnuip.fileecritresult ='&Writing results';
    S.mnuip.fileprint ='&Print';
    S.mnuip.fileprintcopiecoller ='&Copy-to-Paste';
    S.mnuip.fileprintjpeg ='&JPEG file';
    S.mnuip.fileprintimprimer ='&Print';
    S.mnuip.filedernierouvert ='Recentl&y opened';
    S.mnuip.filepreferences ='Pre&ferences';
    S.mnuip.fileredemarrer ='&Restart Analyse';
    S.mnuip.fileterminus ='&Terminus';

    S.mnuip.edit ='&Edit';
    S.mnuip.editmajcan ='Update infos on selected channels';
    S.mnuip.editcanal ='&Channel';
    S.mnuip.editcopiecanal ='Copy channel';
    S.mnuip.editdatautil ='Group the payload';
    S.mnuip.editcatego ='Categories';
    S.mnuip.editrebatircatego ='Rebuilding Categories';
    S.mnuip.editecheltemps ='Time scale';

    S.mnuip.modif ='&Modify';
    S.mnuip.modifsuppcan ='Delete channel';
    S.mnuip.modifcorriger ='Correct';
    S.mnuip.modifcouper ='Cut';
    S.mnuip.modifdecouper ='Slice';
    S.mnuip.modifdecimate ='Decimate';
    S.mnuip.modifrebase ='&Rebase';
    S.mnuip.modifrotation ='R&otation';
    S.mnuip.modifsynchroess ='Sync Trials';
    S.mnuip.modifsynchrocan ='Sync Channels';

    S.mnuip.math ='Ma&th.';
    S.mnuip.mathderivfil ='&Derivative/Filter';
    S.mnuip.mathderivfilbutter ='&ButterWorth';
    S.mnuip.mathderivfilsptool ='With SPTOOL''s file';
    S.mnuip.mathderivfildiffer ='&Differ';
    S.mnuip.mathderivfilpolynom ='Polynomial treatment';
    S.mnuip.mathintdef ='Definite integral';
    S.mnuip.mathintcum ='Cumulative integral';
    S.mnuip.mathnormal ='&Normalise';
    S.mnuip.mathnormaltemp ='Temporal standardization';
    S.mnuip.mathellipsconf ='Confidence ellipse';
    S.mnuip.mathmoyectyp ='Mean and Standard Deviation';
    S.mnuip.mathmoyptmarq ='Mean around points scored';
    S.mnuip.mathpentedrtregr ='Slope of the regression line';
    S.mnuip.mathcalcang ='Calculates angles';
    S.mnuip.mathtraitcan ='Channel treatment...';

    S.mnuip.emg ='Em&g';
    S.mnuip.emgrectif ='&Rectification';
    S.mnuip.emgliss ='&Smooth';
    S.mnuip.emgrms ='R&MS';
    S.mnuip.emgmav ='M&AV';
    S.mnuip.emgffm ='&F-mid-mean-max';
    S.mnuip.emgnormal ='&Normalisation';
    S.mnuip.emgintegsucc ='Successive integrations';
    S.mnuip.emgchgpolar ='&Polarity change';
    S.mnuip.emgdistprbampl ='&Amplitude probability distribution';

    S.mnuip.fplt ='&FPlt';
    S.mnuip.fpltcop ='Center of Pressure (COP) and COG AMTI';
    S.mnuip.fpltcopparammanuel ='Manual entering settings';
    S.mnuip.fpltcopparamfichier ='entering settings from a file';
    S.mnuip.fpltcopoptima ='COP and COG Optima';
    S.mnuip.fpltstat4cop ='Stat-4-COP';

    S.mnuip.trajet ='T&rajectory';
    S.mnuip.trajetgps ='GPS';
    S.mnuip.trajetgpsecef2lla ='(GPS)ECEF to LLA';
    S.mnuip.trajetecart ='&Gap';
    S.mnuip.trajetdiffinterpt ='&Difference between point';
    S.mnuip.trajetdistparcour ='Distance &X-Y-(Z)';
    S.mnuip.trajetamplmvt ='&motion amplitude';
    S.mnuip.trajetdirect ='D&irection';
    S.mnuip.trajetcourb ='&Curvature';

    S.mnuip.ou ='Tools';
    S.mnuip.ouechtempo ='Time scale';
    S.mnuip.ouechtempodefaut ='Return to the default scale';
    S.mnuip.ouimportpoint ='&Import point (Y vs X)';
    S.mnuip.outrierpt ='Sort points scored';
    S.mnuip.oumark ='&Mark';
    S.mnuip.ouzoom ='Zoom';
    S.mnuip.ouaffichercoord ='Show coordinates';
    S.mnuip.oucouleur ='Show color to ';
    S.mnuip.oucouleurcan ='dDifferentiate the channels';
    S.mnuip.oucouleuress ='differentiate the trials';
    S.mnuip.oucouleurcat ='differentiate the categories';
    S.mnuip.oulegend ='display Legend';
    S.mnuip.ouechant ='View samples';
    S.mnuip.ouptmarkatexte ='Show the points scored and text';
    S.mnuip.ouptmarkstexte ='Show only points scored';
    S.mnuip.ouaffprop ='Proportional curve display';
    S.mnuip.ouxy ='(Canal-Y vs Canal-X) display mode';

    S.mnuip.quelfichier ='&Which file';

    S.mnuip.hlp ='&Help';
    S.mnuip.hlpdoc ='In case of panic Reminder  :-)';
    S.mnuip.hlplog ='Historical';
    S.mnuip.hlplogbook ='Log book';
    S.mnuip.hlpabout ='About';

  	%___________________________________________________________________________
  	% Variable guiip
  	% BOUTON DE L'INTERFACE PRINCIPAL
    %---------------------------------------------------------------------------

    S.guiip.gntudebut ='You must open a file to begin.';
    S.guiip.pbvide ='empty';
    S.guiip.pbcanmarktip ='Select the channel for manual marking';
    S.guiip.pbdelpttip ='Delete selected point';
    S.guiip.pbmarmantip ='Manual marking with the mouse';
    S.guiip.pbcoord ='Coord.';
    S.guiip.pbcoordtip ='Display a cursor with his coordinates (X,Y)';

    %___________________________________________________________________________
    % Variable lire
    % GUI POUR LA LECTURE DES DIFFÉRENTS FORMATS SUPPORTÉS
    %---------------------------------------------------------------------------

    % mnouvre2
    S.lire.txtwbar ='Opening the file: ';

    % Waitbar
    S.lire.lectfich ='Reading ';
    S.lire.lectfichs ='Reading ';
    S.lire.vide ='file ';
    S.lire.vides ='files ';
    S.lire.patience =', please wait';
    S.lire.lectcanal ='Reading channel: ';
    S.lire.fichier ='File: ';
    S.lire.concatinfo ='Concatenation information: ';
    S.lire.canal ='Channel ';
    S.lire.fairess ='Construction of trials: ';

    % Keithley
    S.lire.kiname ='Open Keithley''s file format';
    S.lire.kichoixfich ='Keithley''s file format';
    S.lire.kiinscripath ='Write the complete PATH';
    S.lire.kiutilisezvous ='Have you used many...?';
    S.lire.kitxtsess ='trial';
    S.lire.kitxtcond ='condition';
    S.lire.kitxtseqtyp ='seq-type';
    S.lire.kibuttonGo =auTravail;
    S.lire.kinomfich ='Data Logging file Keithley.';
    S.lire.kilectwbar ='Reading Keithley file, please wait';

    % HDF5
    S.lire.h5ouvfich ='Opening a file H5 ()';
    S.lire.h5wbarinfocan ='Playing on information channels';

    % A21XML
    S.lire.a21ouvfich ='Opening a file XML (Auto 21)';

    %___________________________________________________________________________
    % Variable guipref
    % GUI TO SET PREFERENCES
    %---------------------------------------------------------------------------
    S.guipref.name ='Preferences';

    S.guipref.ongen ='General';
    S.guipref.ongenconserv ='Save preferences for the next sessions.';
    S.guipref.ongenlang ='File name for the working language file (in the "doc" folder): ';
    S.guipref.ongenrecent ='Number of file in the "recently opened" menu: ';
    S.guipref.ongenerr ='Error message to display at the console: ';
    S.guipref.ongenerrmnu ={'Do not display', 'Full message', ...
                          'Function name + Post Subject', 'Message title only'};

    S.guipref.onaff ='View';
    S.guipref.onafftip ='Configuring graphics options';
    S.guipref.onafftxfix =sprintf('Lock \nconfig.');
    S.guipref.onafftxactiv =sprintf('On if\nchecked');
    S.guipref.onaffactxy ='Enable XY mode';
    S.guipref.onaffpt ='Show points scored';
    S.guipref.onaffpttyp ={'Hide points', 'Show the points scored and text', ...
                         'Show only points scored'};
    S.guipref.onaffzoom ='Enable Zoom';
    S.guipref.onaffcoord =S.mnuip.ouaffichercoord;
    S.guipref.onaffsmpl =S.mnuip.ouechant;
    S.guipref.onaffccan =[S.mnuip.oucouleur S.mnuip.oucouleurcan];
    S.guipref.onaffcess =[S.mnuip.oucouleur S.mnuip.oucouleuress];
    S.guipref.onaffccat =[S.mnuip.oucouleur S.mnuip.oucouleurcat];
    S.guipref.onaffleg =S.mnuip.oulegend;
    S.guipref.onaffproport =S.mnuip.ouaffprop;

    S.guipref.onot =['M' char(225) 's all' char(225) ' rumores '];
    S.guipref.onottip ='beyond rumors...';
    S.guipref.onottit ='Preferences';
    S.guipref.onotp1 =sprintf(['\nBy setting preferences you will ensure that the working interface ' ...
                    'will be like you need it at each opening. ' ...
                    'But, do not forget to click the "Apply" button to save the changes.']);
    S.guipref.onotp2 =sprintf(['\nIn the "General" tab, the option "Save Preferences ..." ' ...
                    'if checked, allows you to keep your preferences for future sessions. ' ...
                    'if unchecked, you will start with the default values of the software.']);
    S.guipref.onotp3 =sprintf(['\nThe display for error messages, can take many forms. ' ...
                    'This allows you to have more or less text displayed for errors unimportant.']);
    S.guipref.onotp4 =sprintf(['\nIn the "View" tab, there are two columns: "Lock Config." and ' ...
                    '"On if checked". If you check the box in the column "Lock ...", ' ...
                    'you impose the value of the box "On if ..." for this variable.']);
    S.guipref.onotp5 =sprintf(['\nBy cons, if you do not check the box in the column "Lock ...", the value ' ...
                    'for this variable will be the one when closing the application.' ...
                    '\n\n(For example, the line "Enable zoom"' ...
                    '\n  if the "Lock" is checked' ...
                    '\n    if the "On if" is checked: Zoom will be enable at the opening' ...
                    '\n    if "On if" is unchecked: Zoom will be disable at the opening' ...
                    '\n\n  if the "Lock" is unchecked' ...
                    '\n    At the close of analysis, the zoom state' ...
                    '\n    will decide the value for the re-opening.)']);
    S.guipref.onotp6 =sprintf(['\nRemember: to save the changes, you must click the "Apply" button']);

    S.guipref.onstat ='Enter your preferences in order to improve your work session';

    S.guipref.btapplic ='Apply';

    %___________________________________________________________________________
    % Variable guimoypentri
    % GUI POUR MOYENNE/PENTE/TRIER POINTS
    %---------------------------------------------------------------------------
    S.guimoypentri.name1 ='MENU OF AVERAGES AROUND ...';
    S.guimoypentri.name2 ='MENU SLOPE BETWEEN TWO POINTS';
    S.guimoypentri.name3 ='MENU SORT POINTS...';

    S.guimoypentri.selcan ='Channels selection';
    S.guimoypentri.seless ='Trials selection';
    S.guimoypentri.toutess ='All trials';

    S.guimoypentri.lesep ='Separator:';
    S.guimoypentri.selsep ={'comma','semicolon','tab'};

    S.guimoypentri.fentrav ='Working window';
    S.guimoypentri.rangtrav ='Range of points to sort';
    S.guimoypentri.fentravtip1 =sprintf('Numerical value --> time\n\np0 ou pi --> first sample\npf --> last sample\np1 p2 p3 ... --> point scored');
    S.guimoypentri.fentravtip2 =sprintf('p0 ou pi --> first sample\npf --> last sample\np1 p2 p3 ... --> point scored');
    S.guimoypentri.rangtravtip =sprintf('P0, Pi, P1 --> premier point\nPf ou end --> dernier point\nP1 P2 P3 ... --> point scored');

    S.guimoypentri.autpts ='Around points';
    S.guimoypentri.autpttip =sprintf('Numeric value to indicate the extent before and\nafter the point to be considered for averaging');
    S.guimoypentri.valneg ='Value to be neglected';
    S.guimoypentri.valnegtip =sprintf('Numeric value to change the useful range -> [(1st point + Value) to (2nd point - Value)]');
    S.guimoypentri.tipunit ={'sample','second'};
    S.guimoypentri.maw =auTravail;

    S.guimoypentri.info1 ='By default, if "Around points" is not checked, the average will be between the two values of the working window / if checked / averaged around every marked points in the working window.';
    S.guimoypentri.info2 ='The calculation of the slope will be carried out according to the working window supplied and the "point pairing" requested. The value to be neglected will reduce the working range to the right of the first point and to the left of the second point.';
    S.guimoypentri.info3 ='To sort in ascending order, we write: [P1 Pf]. In descending order it will be: [Pf P1]. Similarly, to sort the last 5: [end-4 end]';

    % Partie Au Travail
    S.guimoypentri.wbar1 ='Averaging';
    S.guimoypentri.wbar2 ='Calculing';
    S.guimoypentri.wbar3 ='Sorting points';

    S.guimoypentri.putfich1 ='Average Result';
    S.guimoypentri.putfich2 ='Slope Result';
    S.guimoypentri.errfich ='Error in the output file.';

    S.guimoypentri.fichori ='Original file';
    S.guimoypentri.legcan ='Legend of the channels';
    S.guimoypentri.vnegli =S.guimoypentri.valneg;
    S.guimoypentri.moyfait1 ='The average was made on';
    S.guimoypentri.moyfait2 ='The average is done on the space defined above';
    S.guimoypentri.autpt ='around point';
    S.guimoypentri.penfait ='The slope is done on the space defined above';
    S.guimoypentri.titess ='Trial';

    S.guimoypentri.m2pt ='Less than 2 points, no sorting';
    S.guimoypentri.errsyn ='Error in the syntax of "Range of points to sort"';
    S.guimoypentri.lecan ='for the channel';
    S.guimoypentri.less ='and trial';

    %___________________________________________________________________________
    % Variable guitretcan
    % CHANNEL TREATMENT GUI
    %---------------------------------------------------------------------------
    S.guipref.name ='Channel treatment';

    S.guitretcan.title ='calculation on channels';
    S.guitretcan.alltrial ='Apply to all trials';
    S.guitretcan.keeppt ='Preserve point scored';
    S.guitretcan.keeppttip ='Preserve point scored when you write the result to an existing channel';
    S.guitretcan.seless ='Trials selection';
    S.guitretcan.selcat ='categories selection';
    S.guitretcan.ligcommtip ='Each element must be separated by commas';
    S.guitretcan.delstr ='Del';
    S.guitretcan.canal ='Channels selection';
    S.guitretcan.clavnum ='Keypad/Operators';
    S.guitretcan.clavfnctip =',  will be interpreted as: C1 ';
    S.guitretcan.fonction ='Functions selection';
    S.guitretcan.fnctlist ={'Pi',['The trigonometric constant ' char(182)];...
                'Sin',sprintf('The sin function of Matlab,\nEg:\n-  If you write:  C1,sin,\n-  it will be interpreted as:  sin(C1)');...
                'Cos',sprintf('The cos function of Matlab,\nEg:\n-  If you write:  C1,cos,\n-  it will be interpreted as:  cos(C1)');...
                'Tan',sprintf('The tan function of Matlab,\nEg:\n-  If you write:  C1,tan,\n-  it will be interpreted as:  tan(C1)');...
                'Diff',sprintf('The diff function of Matlab,\nEg:\n-  If you write:  C1,diff,\n-  it will be interpreted as:  diff(C1)\n \nPlease note that the diff function returns a vector of length N-1,\nAnalyse adds "0" as the first sample \n(thus keeping the same number of sample as the source channel).');...
                'Abs',sprintf('The abs function of Matlab,\nEg:\n-  If you write:  C1,abs,\n-  it will be interpreted as:  abs(C1)');...
                'Distance 1D',sprintf('Calculates the distance between two points on a line. \n- Will require two channels (C1 and C2). \n- Thus calculate:\n \n__  OUT = abs( C1 - C2 )');...
                'Distance 2D',sprintf('Calculates the distance between two points in a plane. \n- Will require four channels (C1, C2 and C3, C4). \n- Thus calculate:\n \n__  OUT = sqrt( (C1-C3)^2 + (C2-C4)^2 )');...
                'Distance 3D',sprintf('Calculates the distance between two points in a volume. \n- Will require six channels (C1, C2, C3 and C4, C5, C6). \n- Thus calculate:\n \n__  OUT = sqrt( (C1-C4)^2 + (C2-C5)^2 + (C3-C6)^2 )');...
                'V. Length',sprintf('Calculates the length of the vector whose origin is [0 0 0]. \n- Will require three channels (C1, C2, C3). \n- thus calculate:\n \n__  OUT = sqrt( C1^2 + C2^2 + C3^2 )');...
                'Cum. sum.',sprintf('The cumsum function of Matlab,\nEg:\n-  If you write:  C1,csum,\n-  it will be interpreted as:  cumsum(C1)');...
                'Sqrt',sprintf('The sqrt function of Matlab,\nEg:\n-  If you write:  C1,sqrt,\n-  it will be interpreted as:  sqrt(C1)');...
                'Exp',sprintf('The Exp function of Matlab,\nEg:\n-  If you write:  C1,N,exp,\n-  it will be interpreted as:  C1^N')};

    S.guitretcan.triginv ='Inv';
    S.guitretcan.triginvtip ='For trigonometric functions only, checked for: asin, acos ou atan';
    S.guitretcan.deg ='Degree';
    S.guitretcan.degtip ='radians, if unchecked';
    S.guitretcan.buttonGo =auTravail;

    %___________________________________________________________________________
    % Variable guimark
    % GUI DU MARQUAGE
    %---------------------------------------------------------------------------
    S.guimark.name ='TO EXIT MARKING, click the X to the right  > > > >';

    %(PP) PANEL PERMAMENT
    S.guimark.ppaid ='?';
    S.guimark.ppaidtip ='Documentation on marking';
    S.guimark.ppcansrc ='Source';
    S.guimark.ppptsmrk ='Pts';
    S.guimark.ppdelptall ='All points';
    S.guimark.ppdelptalltip ='Select all points of the selected channels and trials for deletion';
    S.guimark.ppdelenumtip =sprintf('indices of the points to remove, ascending order,\nEg: 1,2,3,6:9,12 = 1 2 3 6 7 8 9 12');
    S.guimark.ppdelpthide ='Hide';
    S.guimark.ppdelpthidetip =sprintf('Delete the desired point without changing the order of the following.\nThe deleted points will become bogus points.');
    S.guimark.ppdelbutton ='Del.';
    S.guimark.ppdelbuttontip ='Delete all selected points above.';
    S.guimark.ppesscat ='Marking trial(s) or category(ies)';
    S.guimark.ppesscattip ='If unchecked, all trials are selected';
    S.guimark.ppreplace ='Replace points selected above';
    S.guimark.ppreplacetip ='Export mode: source point(i)-->destination point(i)';

    % BOUTON GO...START...AU TRAVAIL
    S.guimark.buttonGo =auTravail;

    %(PO) PANEL DES ONGLETS

    % ONGLET EXPORTATION
    S.guimark.poexpletit ='Exp.';
    S.guimark.poexpletittip ='Export from one channel to the other';
    S.guimark.poexpnom ='Export';
    S.guimark.poexpcorr ='Correspondence source channel (i) --> destination channel (i)';
    S.guimark.poexpcorrtip ='It must have: channel sources number = channel destinations number';
    S.guimark.poexpcandst ='Destination';

    % ONGLET MINMAX
    S.guimark.pominletit ='Min.';
    S.guimark.pominletittip ='Min Max';
    S.guimark.pominnom ='Min.Max.';
    S.guimark.pominmin ='Minimum';
    S.guimark.pominmax ='Maximum';

    % ONGLET MONTÉ...
    S.guimark.pomonteletit ='Ascent.';
    S.guimark.pomonteletittip ='Start - end: Ascent - Descent';
    S.guimark.pomontenom ='Ascent - Descent';
    S.guimark.pomontemnt ='Ascent';
    S.guimark.pomontedbt ='Start';
    S.guimark.pomontefin ='End';
    S.guimark.pomontedsc ='Descent';
    S.guimark.pomontedytxt ='Delta Y';
    S.guimark.pomontedytxttip ='Amplitude difference necessary to consider a climb or descent';
    S.guimark.pomontedytip =sprintf('Value of the variation in amplitude (Eg: 10, 150, etc.)\n or percentage of max-min (Eg: 10%%, 45%%, etc.)\n from which you consider that there are a climb or descent.\n By default 50%% (if left at 0):  (Max - Min) X 50%%');
    S.guimark.pomontedxtxt ='Delta X';
    S.guimark.pomontedxtxttip ='Time Difference (sec) necessary to raise or lower Delta Y';
    S.guimark.pomontedxtip ='Time (sec.) in order to have an amplitude variation of at least DeltaY. If left at 0: ¼ sec.';
    S.guimark.pomontedttxt ='Delta T';
    S.guimark.pomontedttxttip ='Number of samples to be considered to discriminate against "unwanted small peaks" (noise)';
    S.guimark.pomontedttip ='Number of samples to be considered to declare a start or an end. Default = 3 (If left at zero)';
    S.guimark.pomontedef ='D';
    S.guimark.pomontedeftip ='Defaults, for this frame "0"';

    % ONGLET TEMPOREL
    S.guimark.potmpletit ='Time.';
    S.guimark.potmpletittip ='Marking time';
    S.guimark.potmpnom ='Marking time';
    S.guimark.potmpvaltxt ='Precise time or index point: ';
    S.guimark.potmpvaltip ='First specific time mark (may be an indice of a point for the subsequent marking Eg: p1)';
    S.guimark.potmpstep ='Interval between subsequent point: ';
    S.guimark.potmpsteptip ='From time above, number of second to the next point';

    % ONGLET AMPLITUDE
    S.guimark.poampletit ='Amplit.';
    S.guimark.poampletittip ='Mark amplitude';
    S.guimark.poampnom ='Marking amplitude';
    S.guimark.poampvaltxt ='Amplitude (or index point) to mark: ';
    S.guimark.poampvaltip =sprintf('(numerical value = magnitude) otherwise,\n the amplitude of the recorded item will be considered (p0, pi: first sample),\n (pf = last sample), (and p1 p2 p... point scored)');
    S.guimark.poamppcenttxt ='% Of the amplitude of point above: ';
    S.guimark.poamppcenttip =sprintf('If you have registered a point rather than an amplitude above,\n you may want a percentage of the corresponding amplitude');
    S.guimark.poampdectxt ='time Offset +/-: ';
    S.guimark.poampdectip =sprintf('The amplitude will be considered from the point requested above,\noffset the time value (in sec.) recorded here.');
    S.guimark.poampdirtxt ='Direction: ';
    S.guimark.poampdir ={'towards the end >>>', '<<< towards the beginning'};
    S.guimark.poampdirtip ='Where to start scoring point No. 1, from the left or right';

    % ONGLET EMG
    S.guimark.poemgletit ='Emg.';
    S.guimark.poemgletittip ='Mark the beginnings and ends of muscle activity in EMG signal';
    S.guimark.poemgnom ='Mark EMG';
    S.guimark.poemgrefdoc ='Ref/Doc';
    S.guimark.poemgaglrhtxt ='the threshold (h):';
    S.guimark.poemgaglrhtip =sprintf('Choose a value h as small as possible which still produces\na tolerable rate of false alarms.');
    S.guimark.poemgaglrltxt ='Sliding test window, in samples (L):';
    S.guimark.poemgaglrltip =sprintf('select L as large as possible (in order to obtain reliable variance\nestimates after change), but smaller than the shortest stationary epoch\n(i.e., epoch with constant variance) to be detected.');
    S.guimark.poemgaglrdtxt ='Minimum number of samples. (d):';
    S.guimark.poemgaglrdtip =sprintf('Minimum number of samples used for ML estimation.\nChoose d such that ta+d still will be located within the stationary\nepoch indicated by the current Alarm Time ta. This parameter is not\nvery critical. Usually, a small number of samples (e.g, d=10) will do.');
    S.guimark.poemgvoir ='Check';
    S.guimark.poemgvoirtip ='Test the parameters on the first channel/trial selected';

    % ONGLET BIDON
    S.guimark.pobidletit ='Bogus';
    S.guimark.pobidletittip ='Add a bogus point';
    S.guimark.pobidnom ='Bogus point';
    S.guimark.pobidpostxt ='Position for the bogus point: ';
    S.guimark.pobidposmantip ='If left blank, the right ListBox is read';
    S.guimark.pobidposmantxt ='(Or, with the keyboard): ';

    % ONGLET TEST
    S.guimark.potestletit ='Test';
    S.guimark.potestletittip ='Change Detection';
    S.guimark.potestnom ='Change Detection';
    S.guimark.potestdoctxt ='For explanation, read: http://nbviewer.ipython.org/github/demotu/BMC/blob/master/notebooks/DetectCUSUM.ipynb';
    S.guimark.potestseuiltxt ='Threshold';
    S.guimark.potestseuiltxttip ='Minimum value for detection of a change';
    S.guimark.potestseuiltip ='Value to exceed during the cumulative sum';
    S.guimark.potestgplus ='Ascent (+)';
    S.guimark.potestgmoins ='Descent (-)';
    S.guimark.potestdriftxt ='Drift';
    S.guimark.potestdriftxttip ='To avoid false positives or long gentle slopes';
    S.guimark.potestdriftip ='Drift value, can also cancel some of the noise signal';
    S.guimark.potestvoir ='Check';
    S.guimark.potestvoirtip ='Tests the threshold and drift on the first selected trial and displays g+ and g-';

    % TEXTE COMMUN
    S.guimark.pocommunrepet ='Nb of repetition: ';
    S.guimark.pocommunint ='whole interval';
    S.guimark.pocommuninttip ='repeat the subsequent marking on the entire working range.';
    S.guimark.pocommunintertxt ='[ Working range ]';
    S.guimark.pocommunintertxttip =sprintf('(p0=first sample, pf=last sample)\n(numerical value=time in sec.) or\np1, p2... for a previously scored point');
    S.guimark.pocommuninterdbttip ='To start at the first sample, let Pi or P0';
    S.guimark.pocommuninterfintip ='If left at Pf, the last sample of the channel will be used.';
    S.guimark.pocommuncanexttip ='Put a copy of the points to score above to channels chosen below cons';
    S.guimark.pocommunrempltip ='Copy replacing the point if necessary';

    % EN COURS DE ROUTE
    S.guimark.po_ou ='or';
    S.guimark.po_et ='and';
    S.guimark.po_debut ='start';
    S.guimark.po_fin ='end';
    S.guimark.potravchmnm ='You have to choose Min and/or Max';
    S.guimark.potravchmddm ='You have to do at least one choice Ascent/Descent/start/end';
    S.guimark.potravchmd ='You have to do at least one choice Ascent/Descent';
    S.guimark.potravchmontdesc ='Ascent/Descent';
    S.guimark.potravcan ='channel';
    S.guimark.potravess ='trial';
    S.guimark.potravnpt ='no.point';
    S.guimark.potravdfinterr ='Error in the start and/or end of the working range';
    S.guimark.potraverrfnc ='Error in the function';
    S.guimark.potravemgrech ='Searching muscular activity for';
    S.guimark.potravafflon ='The display of curves and points can be long ...';
    S.guimark.potravetmperr ='Bad expression of time';
    S.guimark.potraveincerr ='Bad expression of increment';
    S.guimark.potravexpr ='Expression';
    S.guimark.potravnvalid ='bad';
    S.guimark.potravsderiv ='Values of the threshold and the drift can not be zero at the same time';
    S.guimark.potravcusumrech ='Searching for change...';
    S.guimark.potravfermer ='The return to the regular display can be quite long when there are several markss to display';
    S.guimark.potravmaw ='CPU at work';
    % BAR DE STATUS
    S.guimark.barstatus ='Start by choosing the type of marking, then fill in the necessary options';

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
  	disp({'Give an input file name or a variable for the output';...
  	      'Eg.'; 'langue-en(''en.mat'') or';'test =langue-en'});
  end
return
