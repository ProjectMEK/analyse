%
% Interface graphique pour la classe CPenteDroiteReg
%
% dont le but est de trouver la pente de la droite de régression des échantillons
% entre deux points marqués et d'inscrire le résultat dans un fichier texte.
%
function varargout = GuiPenteDroiteReg(Ppa)

    % création de la figure
    Lfen=450; Hfen=500;
    lapos =positionfen('G', 'H', Lfen, Hfen);
    fig =figure('Name', 'MENU PENTE ENTRE DEUX POINTS', ...
            'Position',lapos, 'CloseRequestFcn',@Ppa.fermer,...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIControlunits','pixels',...
            'DefaultUIControlFontSize',10,...
            'Resize', 'off');

    % titre pour le choix des canaux
    mx=25; mxtext=mx; posx=mxtext; large=round((Lfen-2*mxtext)/2); largstd=125; corry=5;
    ddy=10; dy=2*ddy; posy=Hfen-45; Htext=22; haut=Htext;
    uicontrol('Parent',fig, 'FontWeight','bold',...
            'Position',[posx posy large haut], ...
            'String','Choix du/des canal/aux', ...
            'Style','text');

    % titre pour le choix des essais
    uicontrol('Parent',fig, 'FontWeight','bold',...
            'Position',[posx+large posy large haut], ...
            'String','Choix du/des essais:', ...
            'Style','text');

    % listbox pour le choix des canaux
    if Ppa.vg.nad>2;letop =Ppa.vg.nad;else letop =Ppa.vg.nad + 1;end
    haut=100; posy=posy-haut;
    uicontrol('Parent',fig, 'Tag','LBchoixCan', ...
            'BackgroundColor',[1 1 1], 'Style','listbox', ...
            'Position',[posx posy large haut], ...
            'String',Ppa.hdchnl.Listadname, ...
            'Min',1, 'Max',letop, 'Value',1);

    % listbox pour le choix des essais
    if Ppa.vg.ess>2;lemax =Ppa.vg.ess;else lemax =Ppa.vg.ess + 1;end
    uicontrol('Parent',fig, 'Tag','LBchoixEss', ...
            'BackgroundColor',[1 1 1], 'Style','listbox', ...
            'Position',[posx+large posy large haut], ...
            'String',Ppa.vg.lesess, ...
            'Min',1, 'Max',lemax, 'Value',1);

    % checkbox pour le choix des essais
    haut=Htext; posy=posy-haut;
    uicontrol('Parent',fig, 'Tag','CBchoixEss', ...
            'Position',[posx+large posy large haut], ...
            'String','tous les essais', 'Style','checkbox', ...
            'Value',0, 'Callback',@Ppa.tous);

    % titre fenêtre de travail
    large=largstd+2*mx; posy =posy-haut-dy; retoury=posy;
    uicontrol('Parent',fig, 'FontWeight','bold', 'Style','text', ...
            'Position',[posx posy large haut], 'String','Fenêtre de travail');

    % fenêtre de travail (début)
    posx=posx+round(large/2); large=round(large/3); posx=posx-large; posy=posy-haut; retourx=posx;
    quoi=sprintf('p0 ou pi --> premier échantillon\npf --> dernier échantillon\np1 p2 p... --> point marqué');
    uicontrol('Parent',fig, 'Tag','EDfenTravDebut', 'FontSize',11, 'Style','edit', ...
            'Position',[posx posy-corry large haut+corry], 'String','p0', 'TooltipString',quoi);

    % fenêtre de travail (fin)
    uicontrol('Parent',fig, 'Tag','EDfenTravFin', 'FontSize',11, 'Style','edit', ...
            'Position',[posx+large posy-corry large haut+corry], 'String','pf', 'TooltipString',quoi);

    % titre valeur à négliger
    posx=posx+2*large+2*mx; large=largstd-50; posy=retoury;
    uicontrol('Parent',fig, 'FontWeight','bold', 'Style','text', ...
            'Position',[posx posy 2*large haut], 'String','Valeur à négliger');

    % nombre d'échantillon ou de secondes à garder avant et après
    quoi=sprintf('Valeur numérique pour modifier la plage utile --> [(1er point + Valeur) jusqu''à (2ième point - Valeur)]');
    posy=posy-haut;
    uicontrol('Parent',fig, 'Tag','EDnombreAvantApres', 'FontSize',11,...
            'Position',[posx posy-corry large haut+corry], 'String','0', 'Style','edit', ...
            'TooltipString',quoi);

    % type d'unité, échantillon ou seconde
    posx =posx+large; large=large+50;
    uicontrol('Parent',fig, 'Tag','PMchoixUnit', 'FontSize',11, ...
            'Position',[posx posy large haut], 'Style','popupmenu', ...
            'String',{'échantillons','secondes'}, 'Value',1);

    % popupmenu pour le type de pairage des points
    posy=posy-haut-ddy; posx=retourx; large=largstd+25;
    leschoix ={'Pairage des points --> [1er pt avec 2ième] [3ième avec 4ième] ...', ...
               'Pairage des points --> [1er pt avec 2ième] [2ième avec 3ième] ...', ...
               'Calculer une seule pente à partir de la fenêtre de travail'};
    uicontrol('Parent',fig, 'Tag','PMpairagePoints', 'style','popupmenu', ...
            'Position',[posx posy large haut-corry], 'string',leschoix, 'Value',1);

    % titre "séparateurs"
    large=largstd; posx=round((Lfen-large)/2); posy =posy-haut-2*dy;
    uicontrol('Parent',fig, 'FontWeight','bold', 'Position',[posx posy large haut], ...
            'String','Séparateur:', 'Style','text');

    % popupmenu pour le choix du "séparateur"
    separa ={'virgule','point virgule','Tab'};
    uicontrol('Parent',fig, 'Tag','PMchoixSep', 'FontSize',11, 'Style','popupmenu', ...
            'Position',[posx posy-haut large haut], 'String',separa, 'Value',1);

    % bouton au travail
    large=85; posx=round((Lfen-large)/2); haut=Htext; posy=posy-haut-5*ddy;
    uicontrol('Parent',fig, 'Callback',@Ppa.travail, ...
            'Position',[posx posy large haut], 'String','Au travail');

    % info sommaire au bas de la fenêtre
    posy=posy-haut-dy;
    uicontrol('Parent',fig, 'FontWeight','bold', 'Position',[0 posy Lfen haut], 'Style','text', ...
            'String','-------------------------------------------------------------------------------------');
    posx=mx; large=Lfen-2*posx; haut=2*Htext; posy=posy-haut-5;
    uicontrol('Parent',fig, 'FontSize',9, 'Position',[posx posy large haut], 'Style','text', ...
            'String','Le calcul de la pente sera effectué selon la fenêtre de travail fournie et le "pairage de point" demandé. La valeur à négliger réduira la plage de travail à droite du premier point et à gauche du second.');

    set(fig,'WindowStyle','modal');

    if nargout
    	% si la fonction père demande un retour, on lui envoie 'fig'
    	varargout{1} =fig;
    end

end
