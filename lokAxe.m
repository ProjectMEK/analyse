%
% fonction pour gérer l'affichage des axes X et Y
% Afin de pouvoir afficher/barrer l'abcisse ou/et l'ordonnée.
%
function lokAxe(varargin)
  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
    fl =guidata(gcf);
  end
  hA =CAnalyse.getInstance();
  hF =hA.findcurfich();
  vg =hF.Vg;
  %
  switch commande
  %---------------
  case 'ouverture'
    fl.xval =vg.xval;
    fl.yval =vg.yval;
    margx=15;
    margy=15;
    posx=150;
    posy=140;
    largfrm=145;
    hautfrm=230;
    largbtn=70;
    hautbtn=20;
    hauttit=25;
    fnt1=16;
    fnt2=10;
    largfig=(2*margx)+(2*largfrm);
    hautfig=(4*margy)+hautfrm+hautbtn;
    %
    % en largeur: margx + frame + frame  + margx
    % en hauteur: margy + frame + 2 margy + bouton + margy
    %
    lapos =positionfen('G','H', largfig, hautfig, gcf);
    fl.fig =figure('Name','Gestion des Axes', 'CloseRequestFcn','lokAxe(''fermer'')',...
          'DefaultUIControlBackgroundColor',[0.8 0.8 0.8], 'defaultUIControlunits','pixels',...
          'defaultUIControlFontSize',fnt2, 'Position',lapos, 'Resize','off');
    posx =margx; posy =(3*margy)+hautbtn;
    largeur =largfrm; hauteur =hautfrm;
    fl.frame(1) =uicontrol('Parent',fl.fig, 'Position',[posx posy largeur hauteur], 'Style','frame');
    posx =posx+largfrm;
    fl.frame(2) =uicontrol('Parent',fl.fig, 'Position',[posx posy largeur hauteur], 'Style','frame');
    posx =3*margx; posy =posy+hautfrm-(2*margy);
    largeur =largfrm-(4*margx); hauteur =hauttit;
    uicontrol('Parent',fl.fig, 'HorizontalAlignment','center', 'FontSize',fnt1, 'Style','text', ...
              'FontWeight','bold', 'Position',[posx posy largeur hauteur], 'String','X');
    posx =posx+largfrm;
    uicontrol('Parent',fl.fig, 'HorizontalAlignment','center', 'FontSize',fnt1, 'Style','text',...
              'FontWeight','bold', 'Position',[posx posy largeur hauteur], 'String','Y');
    largeur =largbtn; hauteur =hautbtn;
    posy =posy-margy-hauteur; posx =floor(margx+(0.5*largfrm)-(0.5*largeur));
    fl.ctrl(1) =uicontrol('Parent',fl.fig, 'Callback','lokAxe(''limx'')', ...
               'TooltipString','Limite inférieure et supérieure, en Abcisse',...
               'Position',[posx posy largeur hauteur], ...
               'Style','checkbox', 'String','Manuel', 'Value',vg.xlim);
    posx =posx+largfrm;
    fl.ctrl(2) =uicontrol('Parent',fl.fig, 'Callback','lokAxe(''limy'')', ...
               'TooltipString','Limite inférieure et supérieure, en Ordonnée',...
               'Position',[posx posy largeur hauteur], ...
               'Style','checkbox', 'String','Manuel', 'Value',vg.ylim);
    largeur =largbtn; hauteur =hautbtn;
    posx =floor(margx+(0.5*largfrm)-(0.5*largeur)); posy =posy-margy-hauteur;
    letexte =num2str(fl.xval(2));
    fl.edtx(1) =uicontrol('Parent',fl.fig, 'TooltipString','Limite supérieure, en abcisse',...
              'HorizontalAlignment','Left', 'Position',[posx posy largeur hauteur], ...
              'Enable','Off', 'Style','edit', 'String',letexte);
    posx =posx+largfrm;
    letexte =num2str(fl.yval(2));
    fl.edty(1) =uicontrol('Parent',fl.fig, 'TooltipString','Limite supérieure, en ordonnée',...
              'HorizontalAlignment','Left', 'Position',[posx posy largeur hauteur], ...
              'Enable','Off', 'Style','edit', 'String',letexte);
    posx =floor(margx+(0.5*largfrm)-(0.5*largeur)); posy =posy-floor(margy/5)-hauteur;
    letexte =num2str(fl.xval(1));
    fl.edtx(2) =uicontrol('Parent',fl.fig, 'TooltipString','Limite inférieure, en abcisse',...
              'HorizontalAlignment','Left', 'Position',[posx posy largeur hauteur], ...
              'Enable','Off', 'Style','edit', 'String',letexte);
    posx =posx+largfrm;
    letexte =num2str(fl.yval(1));
    fl.edty(2) =uicontrol('Parent',fl.fig, 'TooltipString','Limite inférieure, en ordonnée',...
              'HorizontalAlignment','Left', 'Position',[posx posy largeur hauteur], ...
              'Enable','Off', 'Style','edit', 'String',letexte);
    largeur =floor(largfrm*0.85);
    posx =floor(margx+(0.5*largfrm)-(0.5*largeur)); posy =posy-margy-hauteur;
    uicontrol('Parent',fl.fig, 'HorizontalAlignment','center', ...
              'Position',[posx posy largeur hauteur], 'Style','text', 'String','<<-Déroulement->>');
    largeur =floor(largfrm*0.33);
    posx =margx+floor(largfrm*0.33/2); posy =posy-margy-hauteur;
    letexte =num2str(vg.deroul(1));
    fl.edtx(3) =uicontrol('Parent',fl.fig, 'TooltipString','Déplacement en pourcentage du temps total',...
              'HorizontalAlignment','Left', 'Position',[posx posy largeur hauteur], ...
              'Enable','Off', 'Style','edit', 'String',letexte);
    posx =posx+largeur+5;
    letexte =num2str(vg.deroul(2));
    fl.edtx(4) =uicontrol('Parent',fl.fig, 'TooltipString','Déplacement rapide en pourcentage du temps total',...
              'HorizontalAlignment','Left', 'Position',[posx posy largeur hauteur], ...
              'Enable','Off', 'Style','edit', 'String',letexte);
    hauteur =hautbtn; largeur =largbtn;
    posx =margx+largfrm-round(largeur/2); posy =margy;
    fl.c8 =uicontrol('Parent',fl.fig, 'Callback','lokAxe(''travail'')', ...
  	          'Position',[posx posy largeur hauteur], 'String','Utiliser');
    set(fl.fig,'WindowStyle','modal');
    guidata(gcf,fl);
    if vg.xlim; lokAxe('limx'); end
    if vg.ylim; lokAxe('limy'); end
  %----------
  case 'limx'
    lex=get(fl.ctrl(1),'Value');
    if lex
      set(fl.edtx(1),'Enable','On','BackgroundColor',[1 1 1])
      set(fl.edtx(2),'Enable','On','BackgroundColor',[1 1 1])
      set(fl.edtx(3),'Enable','On','BackgroundColor',[1 1 1])
      set(fl.edtx(4),'Enable','On','BackgroundColor',[1 1 1])
    else
      set(fl.edtx(1),'Enable','Off','BackgroundColor',[0.8 0.8 0.8])
      set(fl.edtx(2),'Enable','Off','BackgroundColor',[0.8 0.8 0.8])
      set(fl.edtx(3),'Enable','Off','BackgroundColor',[0.8 0.8 0.8])
      set(fl.edtx(4),'Enable','Off','BackgroundColor',[0.8 0.8 0.8])
    end
  %----------
  case 'limy'
    lex=get(fl.ctrl(2),'Value');
    if lex
      set(fl.edty(1),'Enable','On','BackgroundColor',[1 1 1])
      set(fl.edty(2),'Enable','On','BackgroundColor',[1 1 1])
    else
      set(fl.edty(1),'Enable','Off','BackgroundColor',[0.8 0.8 0.8])
      set(fl.edty(2),'Enable','Off','BackgroundColor',[0.8 0.8 0.8])
    end
  %-------------
  case 'travail'
    hdchnl =hF.Hdchnl;
    lex =get(fl.ctrl(1),'Value');
    leminy =min(hdchnl.min(:));
    lemaxy =max(hdchnl.max(:));
    if lex
      vg.xlim =1;
      textmin =str2num(get(fl.edtx(2),'String'));
      textmax =str2num(get(fl.edtx(1),'String'));
      textlent =str2num(get(fl.edtx(3),'String'));
      textvite =str2num(get(fl.edtx(4),'String'));
      if textmin > textmax
        a =textmax;
        textmax =textmin;
        textmin =a;
      end
      vg.xval =[textmin textmax];
      if vg.xy
        lemin =min(leminy,textmin);
        lemax =max(lemaxy,textmax);
      else
        lemin=min([hdchnl.frontcut(:)' textmin]);
        lemax=max([hdchnl.sweeptime(:)' textmax]);
      end
      if textlent > textvite
        a =textvite; textvite =textlent; textlent =a;
      end
      vg.deroul =[textlent textvite];
      set(findobj('Type','uicontrol','tag', 'IpAxeSlider'), 'Max',lemax, 'Min', lemin,...
                  'Value', vg.xval(1),'Visible','On', 'SliderStep', vg.deroul );
    else
    	vg.xlim =0;
    end
    ley =get(fl.ctrl(2),'Value');
    if ley
      vg.ylim =1;
      textmin =str2num(get(fl.edty(2),'String'));
      textmax =str2num(get(fl.edty(1),'String'));
      if textmin > textmax
        a =textmax;
        textmax =textmin;
        textmin =a;
      end
      vg.yval =[textmin textmax];
      lemin =min(leminy, vg.yval(1));
      lemax =max(lemaxy, vg.yval(2));
      set(findobj('Type','uicontrol','tag', 'IpAxeSliderY'), 'Max',lemax, 'Min',lemin,...
                  'Value', vg.yval(1),'Visible','On', 'SliderStep', vg.deroul );
    else
    	vg.ylim=0;
    end
    delete(fl.fig);
    hA.OFig.affiche();

  %------------
  case 'fermer'
    delete(fl.fig);
  %--
  end
end
