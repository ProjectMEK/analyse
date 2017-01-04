function decimage(varargin)
%
% GRAME, avril 2002
% Correction Nov 2004 par MEK
%
% fonction pour effectuer un decimate sur les canaux (Ex: partir de 1000 Hz à 100 Hz)
% MENU: DECIMATE
%
%  *********A FAIRE: la fonction inverse (RESAMPLE)*************
%  Matlab a une fonction resample, il faudrait voir les besoins.
%
  if nargin == 0
    commande = 'ouverture';
  else
    commande = varargin{1};
    dc = guidata(gcf);
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
%
switch(commande)
%---------------
case 'ouverture'
  if vg.nad >2;letop =vg.nad;else;letop =vg.nad+1;end
  if vg.ess >2;top =vg.ess;else;top =vg.ess+1;end
  ymax=325;
  ltit=250;
  htit=25;
  htex=20;
  ledit=50;
  lebord1=25;largeur1=150;largeur2=125; largeur3=150;
  xmax=(4*lebord1)+largeur1+largeur2+largeur3;
  haut=125;
  lapos =positionfen('G','C',xmax,ymax);
  dc.fig(1) =figure('Name','DECIMATE', 'color',[0.8 0.8 0.8], ...
          'Position',lapos, ...
          'CloseRequestFcn','decimage(''fermer'')',...
          'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
          'defaultUIControlunits','pixels',...
          'defaultUIControlFontSize',9,...
          'Resize','off');
  ypos=ymax-htit-5;xpos=round((xmax-ltit)/2);
  dc.tit(1) =uicontrol('Parent',dc.fig(1), ...
          'HorizontalAlignment','center',...
          'Position',[xpos ypos ltit htit], ...
          'FontSize',12,...
          'FontWeight','bold',...
          'Style','text',...
          'String','Décimation des canaux');
  ypos=ypos-40;xpos=lebord1;
  dc.ctrl(1) =uicontrol('Parent',dc.fig(1), ...
           'Callback','decimage(''aff_ess'')', ...
           'Position',[xpos ypos largeur1 25], ...
           'String','Traiter tous les essais', ...
           'Style','checkbox', ...
           'Value',1);
  ypos=ypos-30;
  dc.tit(1) =uicontrol('Parent',dc.fig(1), ...
          'HorizontalAlignment','center',...
          'Position',[xpos ypos largeur1 htex], ...
          'String','Choix des canaux', ...
          'Style','text');
  xpos=xpos+largeur1+lebord1;
  dc.tit(2) =uicontrol('Parent',dc.fig(1), ...
          'HorizontalAlignment','center',...
          'Visible','Off', ...
          'Position',[xpos ypos largeur2 htex], ...
          'String','Choix des essais', ...
          'Style','text');
  if vg.niveau
    xpos=xpos+largeur2+lebord1;
    dc.tit(3) =uicontrol('Parent',dc.fig(1), ...
          'HorizontalAlignment','center',...
          'Visible','Off', ...
          'Position',[xpos ypos largeur3 htex], ...
          'String','Choix des catégories', ...
          'Style','text');
  end
  ypos=ypos-haut;xpos=lebord1;
  dc.ctrl(4) =uicontrol('Parent',dc.fig(1), ...
          'BackgroundColor',[1 1 1], ...
          'Position',[xpos ypos largeur1 haut], ...
          'String',hdchnl.adname, ...
          'Min',1,...
          'Max',letop,...
          'Style','listbox',...
          'Value',1);
  xpos=xpos+largeur1+lebord1;
  dc.ctrl(2) =uicontrol('Parent',dc.fig(1), ...
          'BackgroundColor',[1 1 1], ...
          'Position',[xpos ypos largeur2 haut], ...
          'String',vg.lesess, ...
          'Visible','Off', ...
          'Min',1,...
          'Max',top,...
          'Style','listbox',...
          'Value',1);
  xpos=xpos+largeur2+lebord1;
  if vg.niveau
  	ttt =length(vg.lescats);
  	if ttt <= 2, ttt =ttt+1;, end
    dc.ctrl(3) = uicontrol('Parent',dc.fig(1), 'BackgroundColor',[1 1 1], ...
          'Position',[xpos ypos largeur3 haut], 'String',vg.lescats, ...
          'Callback','decimage(''aff_ess2'')', 'Visible','Off', ...
          'Min',1, 'Max',ttt, 'Style','listbox', 'Value',1);
  end
  ypos=ypos-40;xpos=lebord1;
  dc.tit(4) =uicontrol('Parent',dc.fig(1), ...
          'HorizontalAlignment','right',...
          'FontWeight','bold',...
          'Position',[xpos ypos largeur1 htex], ...
          'String','Valeur de décimation: ', ...
          'Style','text');
  xpos=xpos+largeur1+5;
  dc.edit(1)=uicontrol('Parent',dc.fig(1), ...
            'BackgroundColor',[1 1 1], ...
            'Position',[xpos ypos ledit htit], ...
            'FontSize',11,...
            'Style','edit', ...
            'String','10');
%************************************
% si on ajoute le paramètre du filtre
%dc.edit(2)= uicontrol('Parent',dc.fig(1), ...
%            'BackgroundColor',[1 1 1], ...
%            'Position',[xpos ypos-24 ledit htit], ...
%            'FontSize',11,...
%            'Style','edit', ...
%            'String','8');
  xpos=xpos+ledit+3*lebord1;
  dc.btn(1) =uicontrol('Parent',dc.fig(1), ...
          'Callback','decimage(''au travail'')', ...
          'FontSize',12,...
          'HorizontalAlignment','center',...
          'Position',[xpos ypos 80 25], ...
          'String','Au travail');
  xpos=lebord1; ypos=ypos-(2*htex);
  dc.ctrl(5) =uicontrol('Parent',dc.fig(1), ...
          'Position',[xpos ypos 2*largeur2 htex], ...
          'HorizontalAlignment','left',...
          'String','Placer le résultat dans le même canal',...
          'Style','checkbox', ...
          'Value',0);
  set(dc.fig(1),'WindowStyle','modal');
  guidata(gcf,dc);
%-------------
case 'aff_ess'  % si on prend tous les essais ou non, on doit afficher les fen. cat et ess
  if get(dc.ctrl(1),'Value')
    set(dc.ctrl(2),'Visible','Off');
    set(dc.tit(2),'Visible','Off');
    if vg.niveau
      set(dc.ctrl(3),'Visible','Off');
      set(dc.tit(3),'Visible','Off');
    end
  else
    set(dc.ctrl(2),'Visible','On');
    set(dc.tit(2),'Visible','On');
    if vg.niveau
      set(dc.ctrl(3),'Visible','On');
      set(dc.tit(3),'Visible','On');
    end
  end
%--------------
case 'aff_ess2'
  catego =Ofich.Catego;
  lalist=get(dc.ctrl(3),'Value')';   %'
  lamat=zeros(vg.niveau,vg.ess);
  a=zeros(vg.niveau);
  niv=1;
  tot=catego.Dato(1,1,1).ncat;
  for i=1:size(lalist,1)
    while lalist(i) > tot
      niv=niv+1;
      tot=tot+catego.Dato(1,niv,1).ncat;
    end
    a(niv)=a(niv)+1;
    lacat=lalist(i)-(tot-catego.Dato(1,niv,1).ncat);
    lamat(niv,:)=lamat(niv,:)+catego.Dato(2,niv,lacat).ess(:)';  %'
  end
  final=ones(vg.ess,1);
  for i=1:vg.niveau
    if a(i)
      for j=1:vg.ess
        final(j,1)=final(j,1) & lamat(i,j);
      end
    end
  end
  if max(final)>0
    i=1;
    while ~final(i,1)
      i=i+1;
    end
    lestri(1)=i;
    k=2;
    for j=i+1:vg.ess
      if final(j)
        lestri(k,1)=j;
        k=k+1;
      end
    end
  else
    lestri=0;
  end
  if lestri
    set(dc.ctrl(2),'Value',lestri);
  end
%----------------
case 'au travail'
  dtchnl =CDtchnl();
  dc.vtdecim =get(dc.edit(1),'String');    % il faut un Integer Positif
  dc.vdecim =floor(str2num(dc.vtdecim));
  if dc.vdecim < 2
    errordlg('Vous devez entrer une valeur entière positive','Décimation impossible!!!');
    return;
  end
  %************************************
  % Si on ajoute le paramètre du filtre
  %dc.lefilt= get(dc.edit(2),'String');
  %dc.lefilt =floor(str2num(dc.lefilt));
  dc.lefilt =8;                             % valeur par défaut
  tous =get(dc.ctrl(1),'Value');            % affiche tous les essais ???
  if tous
    dc.lestri =[1:vg.ess]';                 % liste des essais à traiter
  else
    dc.lestri =get(dc.ctrl(2),'Value')';
  end
  dc.lescan =get(dc.ctrl(4),'Value')';      % liste des canaux à modifier
  ecrase =get(dc.ctrl(5),'Value');
  if ecrase
    dc.output =dc.lescan;                   % contiendra le canal de sortie (la réponse)
  else
    ladim =length(dc.lescan);
    dc.output =[vg.nad+1:vg.nad+ladim]';
    vg.nad =vg.nad+ladim;
  end
  delete(dc.fig(1));
  ptchnl =Ofich.Ptchnl;
  wbr =waitbar(0.01,'Décimation en cours');
  stri =size(dc.lestri,1);
  scan =size(dc.lescan,1);
  ptt =scan*stri;
  ptot =ptt*1.15;
  vd =dc.vdecim;
  lehndl =findobj('type','figure','tag','IpTraitement');
  if (dc.output(1)-dc.lescan(1))
    %------------------------
    % Ajout des canaux utiles
    hdchnl.duplic(dc.lescan);
    hdchnl.npoints(vg.nad+1:vg.nad+scan,:) =0;
    hdchnl.point(vg.nad+1:vg.nad+scan,:) =0;
  end
  for i =1:scan   % on traite les canaux sélectionnés
    Ofich.getcanal(dtchnl, dc.lescan(i));
    N =dtchnl.Nom;
    for j =1:stri
      long =hdchnl.nsmpls(dc.lescan(i),dc.lestri(j));
      if vd >= long
        continue;
      end
      lout =floor(long/vd);
      dtchnl.Dato.(N)(1:lout,dc.lestri(j)) =dtchnl.Dato.(N)(vd:vd:long,dc.lestri(j));
      waitbar((((i-1)*stri)+j)/ptot,wbr,['Canal: ' num2str(dc.lescan(i)) '  Essai: ' num2str(dc.lestri(j))]);
      hdchnl.nsmpls(dc.output(i),dc.lestri(j)) =lout;
      lerate =hdchnl.rate(dc.lescan(i),dc.lestri(j));
      hdchnl.rate(dc.output(i),dc.lestri(j)) =hdchnl.rate(dc.output(i),dc.lestri(j))/vd;
      hdchnl.sweeptime(dc.output(i),dc.lestri(j)) =lout/hdchnl.rate(dc.output(i),dc.lestri(j));
      hdchnl.max(dc.output(i),dc.lestri(j)) =max(dtchnl.Dato.(N)(1:lout,dc.lestri(j)));
      hdchnl.min(dc.output(i),dc.lestri(j)) =min(dtchnl.Dato.(N)(1:lout,dc.lestri(j)));
    end
    Ofich.setcanal(dtchnl, dc.output(i));
  end
  if (dc.output(1) - dc.lescan(1))
    cc =['Dc(' num2str(vd) ') '];
    cccc =['Décimation(' num2str(vd) ')//'];
    spt =size(ptchnl.Dato,2)+1;
    for i =1:scan
      nc =[cc deblank(hdchnl.adname{dc.lescan(i)})];
      hdchnl.adname{dc.output(i)} =nc;
      for j =1:stri
        hdchnl.comment{dc.output(i), dc.lestri(j)} =[cccc hdchnl.comment{dc.lescan(i), dc.lestri(j)}];
        nbpts =hdchnl.npoints(dc.lescan(i),dc.lestri(j));
        if nbpts
          ppt =round(ptchnl.Dato(1:nbpts, hdchnl.point(dc.lescan(i),dc.lestri(j)), 1)./vd);
          if ~ppt
            ppt =1;
          end
          ptchnl.Dato(1:nbpts, spt, 1) =ppt;
          ptchnl.Dato(1:nbpts, spt, 2) =ptchnl.Dato(1:nbpts, hdchnl.point(dc.lescan(i),dc.lestri(j)), 2);
          hdchnl.point(dc.output(i),dc.lestri(j)) =spt;
          hdchnl.npoints(dc.output(i),dc.lestri(j)) =nbpts;
          spt =spt+1;
        end
      end
      waitbar(((j/stri*(ptot-ptt))+ptt)/ptot);
    end
  else   % on écrase les canaux
    for i =1:scan
      for j =1:stri
        if hdchnl.npoints(dc.output(i),dc.lestri(j))
          ppt =round(ptchnl.Dato(:, hdchnl.point(dc.output(i),dc.lestri(j)), 1)./vd);
          if ~ppt
            ppt =0;
          end
          ptchnl.Dato(:, hdchnl.point(dc.output(i),dc.lestri(j)), 1) =ppt;
        end
      end
    end
  end
  delete(wbr);
  vg.sauve =1;
  vg.valeur =0;
  if ecrase
    OA.OFig.affiche();
  else
    gaglobal('editnom');
  end
%--------------
case 'fermer'
  delete(dc.fig(1));
  vg.valeur=0;
end
end
