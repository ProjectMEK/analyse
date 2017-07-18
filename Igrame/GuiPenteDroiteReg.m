%
% Interface graphique pour la classe CPenteDroiteReg
%
% dont le but est de trouver la pente de la droite de r�gression des �chantillons
% entre deux points marqu�s et d'inscrire le r�sultat dans un fichier texte.
%
function varargout = GuiPenteDroiteReg(Ppa)

    % appel les menus multi-lingues
    hL =CGuiMLMoyPenteTrie();

    % cr�ation de la figure
    Lfen=450; Hfen=500;
    lapos =positionfen('G', 'H', Lfen, Hfen);
    fig =figure('Name', hL.name2, ...
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
            'String',hL.selcan, ...
            'Style','text');

    % titre pour le choix des essais
    uicontrol('Parent',fig, 'FontWeight','bold',...
            'Position',[posx+large posy large haut], ...
            'String',hL.seless, ...
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
            'String',hL.toutess, 'Style','checkbox', ...
            'Value',0, 'Callback',@Ppa.tous);

    % titre fen�tre de travail
    large=largstd+2*mx; posy =posy-haut-dy; retoury=posy;
    uicontrol('Parent',fig, 'FontWeight','bold', 'Style','text', ...
            'Position',[posx posy large haut], 'String',hL.fentrav);

    % fen�tre de travail (d�but)
    posx=posx+round(large/2); large=round(large/3); posx=posx-large; posy=posy-haut; retourx=posx;
    uicontrol('Parent',fig, 'Tag','EDfenTravDebut', 'FontSize',11, 'Style','edit', ...
            'Position',[posx posy-corry large haut+corry], 'String','p0', 'TooltipString',hL.fentravtip2);

    % fen�tre de travail (fin)
    uicontrol('Parent',fig, 'Tag','EDfenTravFin', 'FontSize',11, 'Style','edit', ...
            'Position',[posx+large posy-corry large haut+corry], 'String','pf', 'TooltipString',hL.fentravtip2);

    % titre valeur � n�gliger
    posx=posx+2*large+2*mx; large=largstd-50; posy=retoury;
    uicontrol('Parent',fig, 'FontWeight','bold', 'Style','text', ...
            'Position',[posx posy 2*large haut], 'String',hL.valneg);

    % nombre d'�chantillon ou de secondes � garder avant et apr�s
    posy=posy-haut;
    uicontrol('Parent',fig, 'Tag','EDnombreAvantApres', 'FontSize',11,...
            'Position',[posx posy-corry large haut+corry], 'String','0', 'Style','edit', ...
            'TooltipString',hL.valnegtip);

    % type d'unit�, �chantillon ou seconde
    posx =posx+large; large=large+50;
    uicontrol('Parent',fig, 'Tag','PMchoixUnit', 'FontSize',11, ...
            'Position',[posx posy large haut], 'Style','popupmenu', ...
            'String',hL.tipunit, 'Value',1);

    % popupmenu pour le type de pairage des points
    posy=posy-haut-ddy; posx=retourx; large=largstd+25;
    leschoix ={'Pairage des points --> [1er pt avec 2i�me] [3i�me avec 4i�me] ...', ...
               'Pairage des points --> [1er pt avec 2i�me] [2i�me avec 3i�me] ...', ...
               'Calculer une seule pente � partir de la fen�tre de travail'};
    uicontrol('Parent',fig, 'Tag','PMpairagePoints', 'style','popupmenu', ...
            'Position',[posx posy large haut-corry], 'string',leschoix, 'Value',1);

    % titre "s�parateurs"
    large=largstd; posx=round((Lfen-large)/2); posy =posy-haut-2*dy;
    uicontrol('Parent',fig, 'FontWeight','bold', 'Position',[posx posy large haut], ...
            'String',hL.lesep, 'Style','text');

    % popupmenu pour le choix du "s�parateur"
    uicontrol('Parent',fig, 'Tag','PMchoixSep', 'FontSize',11, 'Style','popupmenu', ...
            'Position',[posx posy-haut large haut], 'String',hL.selsep, 'Value',1);

    % bouton au travail
    large=85; posx=round((Lfen-large)/2); haut=Htext; posy=posy-haut-5*ddy;
    uicontrol('Parent',fig, 'Callback',@Ppa.travail, ...
            'Position',[posx posy large haut], 'String',hL.maw);

    % info sommaire au bas de la fen�tre
    posy=posy-haut-dy;
    uicontrol('Parent',fig, 'FontWeight','bold', 'Position',[0 posy Lfen haut], 'Style','text', ...
            'String','-------------------------------------------------------------------------------------');
    posx=mx; large=Lfen-2*posx; haut=2*Htext; posy=posy-haut-5;
    uicontrol('Parent',fig, 'FontSize',9, 'Position',[posx posy large haut], 'Style','text', ...
              'String',hL.info2);

    set(fig,'WindowStyle','modal');

    if nargout
    	% si la fonction p�re demande un retour, on lui envoie 'fig'
    	varargout{1} =fig;
    end

end
