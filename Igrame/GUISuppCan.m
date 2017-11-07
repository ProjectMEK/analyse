%
% DialogBox pour demander les infos relatives à la suppression de canaux
%
% En entrée:  Ppa  --> objet de la classe CSuppCan(Bat)
%
function GUISuppCan(Ppa, Listadname)
  % pour améliorer le coup d'oeil du code
  P =CAideGUI();
  BLANC =[1 1 1];
  % à cause d'un "bug" dans matlab
  letop =max(2,length(Listadname));
  lapos =positionfen('G','C',300,450);
  P.posx=lapos(1);P.posy=lapos(2);P.large=lapos(3);P.haut=lapos(4);
  % La figure
  lafig =figure('Name','SUPPRIME_CANAUX', 'Position',P.pos, 'CloseRequestFcn',@onFerme, ...
         'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],'defaultUIControlunits','pixels',...
         'defaultUIControlFontSize',10,'Resize','off');
  Ppa.fig =lafig;
  P.posx=15;P.posy=140;P.large=15;P.haut=25;
  % CheckBox Supprimer/Conserver
  uicontrol('Parent',lafig, 'tag','OnConserveCan', 'Position',P.pos, ...
            'HorizontalAlignment','left', 'Style','checkbox', 'Value',0, ...
            'String',' ','callback',@Ppa.modifCheckbox, ...
            'TooltipString','Si coché, on conservera les canaux sélectionnés.');
  P.posx=30;P.large=250;
  % Texte "choix de canaux"
  uicontrol('Parent',lafig, 'tag','TitSuppCOns','FontSize',12, 'Position',P.pos, ...
            'String','Choix des canaux à supprimer', 'Style','text');
  P.posx=50;P.posy=175;P.large=200;P.haut=225;
  % Listbox des choix de canaux
  uicontrol('Parent',lafig, 'tag','ListeCan', 'BackgroundColor',BLANC, ...
            'Position',P.pos, 'String',Listadname, ...
            'Min',1, 'Max',letop, 'Style','listbox', 'Value',1);
  P.posx=45;P.posy=25;P.large=100;P.haut=25;
  % Bouton au travail
  uicontrol('Parent',lafig, 'Callback',@Ppa.travail, 'Position',P.pos, ...
            'String','Au travail!','tag','boutonTravail');
  set(lafig,'WindowStyle','modal');
end

function onFerme(varargin)
  delete(gcf);
end
