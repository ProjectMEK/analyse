%
% Interface (GUI) pour demander les infos afin d'importer un fichier texte
% du format XML, utilisé dans le projet Auto-21
% MEK, mai 2011
%
% EN ENTRÉE on a  Ppa --> un objet de la classe CLirA21XML
%
function ILirA21XML(Ppa)
  largeur =400;                                 % largeur fenêtre totale
  hauteur  =140;                                 % hauteur fenêtre totale
  mx =25;
  my =30;
  epais =25;                                  % épaisseur normale d'un objet
  bouton =20;                                 % largeur d'un bouton
  largfen =295;                                % largeur fenêtre input texte
  largrep =35;
  lapos =positionfen('g', 't', largeur, hauteur);
  lafig =figure('Name','Auto21(XML)', 'tag','LireXML', 'Position',lapos, ...
        'DefaultUIControlBackgroundColor',[0.8 0.8 0.8], 'Resize','off', ...
        'defaultUIControlunits','pixels', 'defaultUIControlFontSize',11,...
      	'CloseRequestFcn',@Ppa.Fermeture);
  Ppa.Fig =lafig;
  haut =epais; posy =hauteur-my-haut; large =largfen; posx =mx;
  uicontrol('Parent',lafig, 'HorizontalAlignment','right', ...
        'Position',[posx posy large haut], 'FontSize',12,...
        'Style','text', 'String','Quel est la fréquence d''acquisition? (Hz)  ');
  posx =posx+large; large =largrep;
  uicontrol('Parent',lafig, 'tag','Frecuencia', 'BackgroundColor',[1 1 1], 'FontSize',10, ...
            'TooltipString','Entrez la fréquence du GPS', 'HorizontalAlignment','Center', ...
            'Position',[posx posy large haut], 'Style','edit', 'String',num2str(Ppa.frq), ...
            'Callback',@Ppa.TestFrecuencia);
% ***********Fin des fenêtres d'édition
  haut =bouton; posy =posy-my-haut; large =80; posx =floor((largeur-large)/2);
  uicontrol('Parent',lafig, 'Callback',@Ppa.Lecture, ...     % Au Travail
	          'FontSize',11, 'Position',[posx posy large haut], 'String','Au Travail');
  set(lafig,'WindowStyle','modal');
end