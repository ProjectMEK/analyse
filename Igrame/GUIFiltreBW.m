%
% DialogBox pour demander les infos relatives au Butterworth
% puis on passe à l'action.
%
% Les choix sont : passe-bas
%                  passe-haut
%                  passe-bande
%                  coupe-bande (fiter-notch)
%
% En entrée:         Ppa  --> objet de la classe CFiltreBW(Bat)
%             Listadname  --> liste des noms de canaux
%-----------------------------------------------------------------
function GUIFiltreBW(Ppa, Listadname)
    BLANC =[1 1 1];
    letype ={'Passe-Bas (défaut)','Passe-Haut','Passe bande','Coupe bande (Notch Filter)'};
    letop =max(2,length(Listadname));
    lapos =positionfen('G','H',300,470);
    lafig =figure('Name','MENUFILTRAGE', 'Position',lapos, ...
           'CloseRequestFcn',@onFerme,'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
           'defaultUIControlunits','pixels','defaultUIControlFontSize',12, 'Resize','off');
    Ppa.fig =lafig;
    %________________________
    % Choix du filtre à faire
    uicontrol('Parent',lafig,'Position',[25 435 250 25],'FontWeight','bold',...
              'Style','text','String','Choix du type de ButterWorth');
    uicontrol('Parent',lafig,'tag','QuelFiltre','Position',[25 405 250 25], ...
              'Style','popupmenu','String',letype,'Callback',@Ppa.quelChoix,'Value',1);
    %___________________________
    % Choix des canaux à filtrer
    uicontrol('Parent',lafig,'FontWeight','bold','Position',[25 365 250 25], ...
              'Style','text','String','Choix du/des canal/aux');
    uicontrol('Parent',lafig,'tag','ChoixCanFiltre','Style','listbox', ...
              'Position',[50 200 200 160],'String',Listadname, ...
              'Min',1,'Max',letop,'Value',1,'BackgroundColor',BLANC);
    %___________________________
    % Choix de l'ordre du filtre
    uicontrol('Parent',lafig,'tag','TextOrdreFiltre','Style','text', ...
              'Position',[35 125 165 20],'String','     ordre du filtre:');
    uicontrol('Parent',lafig,'tag','EditOrdreFiltre','Position',[200 125 50 20], ...
              'Style','edit','String','4');
    %___________________________________
    % Choix de la fréquence de coupure 1
    uicontrol('Parent',lafig,'tag','TextFreqCoupe1','Position',[35 70 165 20], ...
              'Style','text','String','Fréquence de coupure:');
    uicontrol('Parent',lafig,'tag','EditFreqCoupe1','Position',[200 70 50 20], ...
              'Style','edit','String','10');
    %___________________________________
    % Choix de la fréquence de coupure 2
    uicontrol('Parent',lafig,'tag','TextFreqCoupe2','Position',[50 85 200 20], 'Style','text', ...
              'String','Min                         Max', 'visible','off');
    uicontrol('Parent',lafig,'tag','EditFreqCoupe2', 'Position',[175 60 50 20], ...
              'Style','edit', 'String','20', 'visible','off');
    %______________________________________
    % Placer le résultat dans le même canal
    uicontrol('Parent',lafig,'tag','EcraseCanal','Position',[50 170 274 25], ...
              'Style','checkbox','FontSize',9,'HorizontalAlignment','left',...
              'String','Placer le résultat dans le même canal','Value',0);
    %___________
    % Au travail
    uicontrol('Parent',lafig,'tag','boutonTravail','Callback',@Ppa.travail,...
              'Position',[100 15 100 20],'string','Au travail');
    set(lafig,'WindowStyle','modal');
end

function onFerme(varargin)
  delete(gcf);
end
