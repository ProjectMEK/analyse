%
% fonction pour demander les infos afin d'importer un fichier Keithley
% MEK, mars 2016
%
function GUILirKeithley(Ppa)
  largeur =400;                                 % largeur fenêtre totale
  hauteur  =350;                                % hauteur fenêtre totale
  lapos =positionfen('g','t',largeur,hauteur);
  %_____________________________________________________________________________
  % On récupère le handle de l'objet contenant le texte à afficher selon le
  % choix de la langue.
  %-----------------------------------------------------------------------------
  kt =Ppa.txtml;
  fig =figure('Name',kt.kiname, 'Position',lapos, ...
       'DefaultUIControlBackgroundColor',[0.8 0.8 0.8], 'defaultUIControlunits','pixels',...
       'defaultUIControlFontSize',9,	'Resize','off', 'CloseRequestFcn',@Ppa.Fermeture);
  Ppa.Fig =fig;
  hbout=25; hboutm=hbout-10; dy=10; dym=dy-5; dyp=dy+5; mx1=25; mx2=100;
  large=300; posy=hauteur-hbout-dyp;
  uicontrol('Parent',fig, 'Position',[mx1 posy large hbout], 'FontSize',12,...
      'Style','text','String',kt.kichoixfich);
  % entrée du nom de fichier
  posy=posy-hbout-dy;
  uicontrol('Parent',fig, 'BackgroundColor',[1 1 1], 'FontSize',10, ...
      'HorizontalAlignment','Left', 'Position',[mx1 posy large hbout], 'Tag','NomFich', ...
      'Style','edit');
  % Avertissement, path au complet
  uicontrol('Parent',fig, 'Position',[mx1 posy-hboutm large hboutm], 'HorizontalAlignment','Left', ...
      'FontSize',6, 'Style','text', 'String',kt.kiinscripath);
  uicontrol('Parent',fig, 'Callback',@Ppa.choixFichier, ...
	    'Position',[mx1+large+1 posy 20 hbout], 'String','...');
	% Question sur les choix des éléments utilisés
	posy=posy-hbout-3*dyp;
  uicontrol('Parent',fig, 'Position',[mx2 posy 2*mx2 hbout], 'HorizontalAlignment','left', ...
      'FontSize',10, 'Style','text', 'String',kt.kiutilisezvous);
  % Session ?
	posy=posy-hbout-dy;
  uicontrol('Parent',fig, 'Position',[mx2 posy mx2 hbout], 'HorizontalAlignment','left',...
      'String',kt.kitxtsess, 'Style','checkbox', 'Value',0, 'Tag','CBSession1', ...
      'Callback',@Ppa.changeStatusCheckbox);
  % Condition ?
	posy=posy-hbout-dy;
  uicontrol('Parent',fig, 'Position',[mx2 posy mx2 hbout], 'HorizontalAlignment','left',...
      'String',kt.kitxtcond, 'Style','checkbox', 'Value',0, 'Tag','CBCondition2', ...
      'Callback',@Ppa.changeStatusCheckbox);
  % Séq-type ?
	posy=posy-hbout-dy;
  uicontrol('Parent',fig, 'Position',[mx2 posy mx2 hbout], 'HorizontalAlignment','left',...
      'String',kt.kitxtseqtyp, 'Style','checkbox', 'Value',1, 'Tag','CBSeqType3', ...
      'Callback',@Ppa.changeStatusCheckbox);
  % Au Travail
	posy=posy-hbout-3*dyp; large=80; posx=round((largeur-large)/2);
  uicontrol('Parent',fig, 'Callback',@Ppa.lecture, 'FontSize',11, ...
      'Position',[posx posy large hbout], 'String',kt.kibuttonGo);
  set(fig,'WindowStyle','modal');
end