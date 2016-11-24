%
% Interface (GUI) pour demander les infos afin d'importer des points
% à partir d'un fichier .INI
% MEK, mars 2012
%
% EN ENTRÉE on a  Ppa --> un objet de la classe CImportPoint
%
function IImportPoint(Ppa)
  largeur =400;                                 % largeur fenêtre totale
  hauteur  =340;                                 % hauteur fenêtre totale
  mx =25;
  my =30;
  epais =20;                                  % épaisseur normale d'un objet
  bouton =20;                                 % largeur d'un bouton
  largfen =250;                               % largeur fenêtre input texte
  largrep =35;
  largtit =45;
  lapos =positionfen('g', 't', largeur, hauteur);
  lafig =figure('Name','Importation', 'tag','LirePoint', 'Position',lapos, ...
        'DefaultUIControlBackgroundColor',[0.8 0.8 0.8], 'Resize','off', ...
        'defaultUIControlunits','pixels', 'defaultUIControlFontSize',11,...
      	'CloseRequestFcn',@Ppa.Fermeture);
  Ppa.Fig =lafig;
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  haut =epais; posx =mx; large =largeur-2*mx; posy =hauteur-my-haut; corry =4;
  uicontrol('Parent',lafig, 'Position',[posx posy large haut], 'HorizontalAlignment','center', ...
            'Style','text', 'String','Choix des canaux à marquer');
  posy =posy-2*haut; largcan =large-largtit;
  uicontrol('Parent',lafig, 'Position',[posx posy-corry largtit haut], 'HorizontalAlignment','right', ...
            'Style','text', 'String','Col-1:  ');
  uicontrol('Parent',lafig, 'tag','ChoixCanX', 'BackgroundColor',[1 1 1], 'Position',[posx+largtit posy largcan haut], ...
            'Style','popupmenu', 'String',hdchnl.Listadname, 'Value',1);
  posy =posy-haut-2*corry;
  uicontrol('Parent',lafig, 'Position',[posx posy-corry largtit haut], 'HorizontalAlignment','right', ...
            'Style','text', 'String','Col-2:  ');
  uicontrol('Parent',lafig, 'tag','ChoixCanY', 'BackgroundColor',[1 1 1], 'Position',[posx+largtit posy largcan haut], ...
            'Style','popupmenu', 'String',hdchnl.Listadname, 'Value',1);
  posx =mx; large =largeur-2*mx; posy =posy-my-haut;
  uicontrol('Parent',lafig, 'Position',[posx posy large haut], 'HorizontalAlignment','center', ...
            'Style','text', 'String','Canal à marquer');
  posy =posy-haut;
  uicontrol('Parent',lafig, 'tag','CanMark', 'BackgroundColor',[1 1 1], 'Position',[posx+largtit posy largcan haut], ...
            'Style','popupmenu', 'String',hdchnl.Listadname, 'Value',1);
  haut =epais; posy =posy-my-haut; large =largfen; posx =mx;
  uicontrol('Parent',lafig, 'Position',[posx posy large haut], 'FontSize',11, 'HorizontalAlignment','right', ...
            'Style','text', 'String','Rayon de recherche: ');
  posx =posx+large; large =largrep;
  uicontrol('Parent',lafig, 'tag','Aparicion', 'BackgroundColor',[1 1 1], 'FontSize',10, ...
            'TooltipString','Distance max à considérer pour trouver une occurence (les unités sont celles du canal)', ...
            'Position',[posx posy large haut], 'Style','edit', 'String',num2str(Ppa.Rmax), ...
            'HorizontalAlignment','Center', 'Callback',@Ppa.TestAparicion);
  posy =posy-10-haut; large =largfen+largrep; posx =mx;
  uicontrol('Parent',lafig, 'Position',[posx posy large haut], 'FontSize',11, 'Tag','OnTrie', ...
            'Style','radiobutton', 'Value',Ppa.OnTrie, 'String','Trier les points en ordre chronologique?');
% ***********Fin des fenêtres d'édition
  haut =bouton; posy =posy-my-haut; large =80; posx =floor((largeur-large)/2);
  uicontrol('Parent',lafig, 'Callback',@Ppa.Lecture, ...     % Au Travail
	          'FontSize',11, 'Position',[posx posy large haut], 'String','Au Travail');
  set(lafig,'WindowStyle','modal');
end