%
% Interface graphique pour la classe CTrierPt
%
% dont le but est de trier les points marqu�s
%
function varargout = GuiMoyAutourPt(Ppa)

    % cr�ation de la figure
    Lfen=450; Hfen=400;
    lapos =positionfen('G', 'H', Lfen, Hfen);
    fig =figure('Name', 'MENU TRIER POINTS...', ...
            'Position',lapos, 'CloseRequestFcn',@Ppa.fermer,...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIControlunits','pixels',...
            'DefaultUIControlFontSize',10,...
            'Resize', 'off');

    % titre pour le choix des canaux
    mx=25; mxtext=mx; posx=mxtext; large=round((Lfen-2*mxtext)/2); largstd=125; ddy=10; dy=2*ddy; posy=Hfen-45; Htext=22; haut=Htext;
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

    % titre fen�tre de travail
    posy=posy-haut-dy; large=largstd+2*mx; posx=round((Lfen-large)/2);
    uicontrol('Parent',fig, 'FontWeight','bold',...
            'Position',[posx posy large haut], ...
            'String','Range de points � trier', 'Style','text');

    % fen�tre de travail (d�but)
    large=round(large/3); posx=round((Lfen-2*large)/2); posy=posy-haut;
    quoi=sprintf('P0, Pi, P1 --> premier point\nPf ou end --> dernier point\nP1, P2 P... --> point marqu�');
    uicontrol('Parent',fig, 'Tag','EDfenTravDebut', 'FontSize',11,...
            'Position',[posx posy large haut], 'String','p1', 'Style','edit', ...
            'TooltipString',quoi);

    % fen�tre de travail (fin)
    uicontrol('Parent',fig, 'Tag','EDfenTravFin', 'FontSize',11,...
            'Position',[posx+large posy large haut], 'String','pf', 'Style','edit', ...
            'TooltipString',quoi);

    % bouton au travail
    large=85; posx=round((Lfen-large)/2); haut=Htext; posy=posy-haut-2*dy;
    uicontrol('Parent',fig, 'Callback',@Ppa.travail, ...
            'Position',[posx posy large haut], 'String','Au travail');

    % info sommaire au bas de la fen�tre
    posy=posy-haut-dy;
    uicontrol('Parent',fig, 'FontWeight','bold', 'Position',[0 posy Lfen haut], 'Style','text', ...
            'String','-------------------------------------------------------------------------------------');
    posx=mx; large=Lfen-2*posx; haut=2*Htext; posy=posy-haut-5;
    uicontrol('Parent',fig, 'FontSize',9, 'Position',[posx posy large haut], 'Style','text', ...
            'String','Pour trier en ordre croissant, on �crira: [P1  Pf]. En ordre d�croissant se sera: [Pf  P1]. De m�me, pour trier les 5 derniers: [end-4 end]');

    set(fig,'WindowStyle','modal');

    if nargout
    	% si la fonction p�re demande un retour, on lui envoie 'fig'
    	varargout{1} =fig;
    end

end
