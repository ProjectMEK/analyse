%
% Moyenne et écart-type (de la courbe, pour chaque stimulus)
%
% ici il faudrait revoir ce que la fonction fait et peut-être
% ajouter des choix, par essai ???
%
function essmoy(varargin)
  if nargin == 0                             % condition sur les
    commande ='ouverture';                    % arguments de la
  else                                       % fonction
    commande =varargin{1};
    sh =guidata(gcf);
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  catego =Ofich.Catego;
  %---------------
  switch(commande)
  %---------------
  case 'ouverture'
    largtot =300; hautot =425; posy =hautot;
    %%
    if vg.nad > 2;letop =vg.nad;else letop =vg.nad+1;end
    lapos =positionfen('G','H',largtot,hautot);
    sh.fig(1) =figure('Name', 'MENU MOYENNE', 'Position',lapos, ...
            'CloseRequestFcn','essmoy(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIControlunits','pixels',...
            'DefaultUIControlFontSize',10,...
            'Resize', 'off');
    posy =posy-50;
    uicontrol('Parent',sh.fig(1), 'FontWeight','bold', 'Position',[25 posy 250 25], ...
            'String','Choix du/des canal/aux à moyenner', 'Style','text');
    haut =100;posy =posy-haut-10;
    sh.control(1) =uicontrol('Parent',sh.fig(1), 'BackgroundColor',[1 1 1], ...
            'Position',[50 posy 200 haut], 'String',hdchnl.Listadname, ...
            'Min',1, 'Max',letop, 'Style','listbox', 'Value',1);
    posy =posy-50;
    uicontrol('Parent',sh.fig(1), 'FontWeight','bold', 'Position',[25 posy 250 25], ...
            'String','Choix de la catégorie', 'Style','text');
    if vg.niveau
      for i =1:vg.niveau
        listniv{i} =catego.Dato(1,i,1).nom;
      end
    else
      listniv ='aucune';
    end
    posy =posy-haut-10;
    sh.control(2) =uicontrol('Parent',sh.fig(1), 'BackgroundColor',[1 1 1], ...
            'Position',[50 posy 200 haut], 'String',listniv, ...
            'Max',1, 'Style','listbox', 'Value',1);
    posy =posy-50;posx =floor((largtot-100)/2);
    sh.control(3) =uicontrol('Parent',sh.fig(1), 'Callback','essmoy(''travail'')', ...
            'Position',[posx posy 100 25], 'String','au travail');
    posy =posy-25;
    uicontrol('Parent',sh.fig(1), 'FontWeight','bold', 'Position',[0 posy 300 20], ...
            'String','-----------------------------------------------------------------------------', ...
            'Style','text');
    posy =posy-50;
    uicontrol('Parent',sh.fig(1), 'FontSize',9, 'Style','text', 'Position',[25 posy 250 46], ...
            'String','Fait la moyenne des courbes par catégories');
    set(sh.fig(1),'WindowStyle','modal');
    guidata(gcf,sh);
  %-------------
  case 'travail'
    Vcan =get(sh.control(1),'Value');
    catou  =get(sh.control(2),'Value');
    nombre =length(Vcan);
    %------------------------
    % Ajout des canaux utiles
    Ncan =vg.nad+1:vg.nad+(2*nombre);
    ccc =sort([Vcan Vcan]);
    hdchnl.duplic(ccc);
    dtchnl =CDtchnl();
    dtmoy =CDtchnl();
    dtmoy.Nom ='moy';
    dtect =CDtchnl();
    dtect.Nom ='ect';
    h1 =waitbar(0,'traitement en cours');
    nbgrp =catego.Dato(1,catou,1).ncat;
    etap =nbgrp*nombre;
    for cc =1:nombre
      cmoy =vg.nad+(2*cc)-1;
      cect =vg.nad+(2*cc);
      waitbar((cc-1)/nombre);
      Ofich.getcanal(dtchnl, Vcan(cc));
      dtmoy.Dato.moy =zeros(size(dtchnl.Dato.(dtchnl.Nom)));
      dtect.Dato.ect =dtmoy.Dato.moy;
      for i =1:nbgrp
        fait =(i-1)*nombre+i;
        waitbar(fait/etap);
        tri_util =find(catego.Dato(2,catou,i).ess);
        if length(tri_util)
          nsmp =min(hdchnl.nsmpls(Vcan(cc),tri_util));
          dtmoy.Dato.moy(1:nsmp,tri_util(1)) =mean(dtchnl.Dato.(dtchnl.Nom)(1:nsmp,tri_util),2);
          dtect.Dato.ect(1:nsmp,tri_util(1)) =std(dtchnl.Dato.(dtchnl.Nom)(1:nsmp,tri_util),0,2);
          vc =['Moyenne, catégories : ',catego.Dato(2,catou,i).nom];
          vc1 =['Écart Type, catégories : ',catego.Dato(2,catou,i).nom];
          nc =['Moy.' deblank(hdchnl.adname{Vcan(cc)}) '/' deblank(catego.Dato(1,catou,1).nom)];
          nc1 =['É.Typ.' nc(5:end)];
          hdchnl.adname{cmoy} =nc;
          hdchnl.adname{cect} =nc1;
          for U =1:length(tri_util)
            dtmoy.Dato.moy(1:nsmp,tri_util(U)) =dtmoy.Dato.moy(1:nsmp,tri_util(1));
            dtect.Dato.ect(1:nsmp,tri_util(U)) =dtect.Dato.ect(1:nsmp,tri_util(1));
            hdchnl.comment{cmoy, tri_util(U)} =vc;
            hdchnl.comment{cect, tri_util(U)} =vc1;
          end
          hdchnl.nsmpls(cmoy,tri_util) =nsmp;
          hdchnl.sweeptime(cmoy,tri_util) =nsmp./hdchnl.rate(cmoy,tri_util);
          hdchnl.max(cmoy,tri_util) =max(dtmoy.Dato.moy(1:nsmp,tri_util(1)));
          hdchnl.min(cmoy,tri_util) =min(dtmoy.Dato.moy(1:nsmp,tri_util(1)));
          hdchnl.nsmpls(cect,tri_util) =nsmp;
          hdchnl.sweeptime(cect,tri_util) =nsmp./hdchnl.rate(cect,tri_util);
          hdchnl.max(cect,tri_util) =max(dtect.Dato.ect(1:nsmp,tri_util(1)));
          hdchnl.min(cect,tri_util) =min(dtect.Dato.ect(1:nsmp,tri_util(1)));
        end
      end  %for i =1:nbgrp
      Ofich.setcanal(dtmoy, cmoy);
      Ofich.setcanal(dtect, cect);
      dtmoy.MaZdato();
      dtect.MaZdato();
    end
    close(h1)
    vg.nad =vg.nad+(2*nombre);
    delete(sh.fig(1));
    delete(dtchnl);
    delete(dtmoy);
    delete(dtect);
    vg.sauve =1;
    gaglobal('editnom');
  %------------
  case 'fermer'
    delete(sh.fig(1));
  %--
  end
end
