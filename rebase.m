%
% Labo GRAME
% dernière modif 24-01-2003
%
% DialogBox pour demander les infos relatives au rebase
% puis on passe à l'action.
%
% Rebase ajoute, ou enlève, une valeur (offset) aux datas du canal.
%
function rebase(varargin)
  if nargin == 0
    commande = 'ouverture';
  else
    commande = varargin{1};
    reb = guidata(gcf);
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;

  switch(commande)
  %-------------------
  % fabrication du GUI
  %---------------
  case 'ouverture'
    vg.valeur=1;
    if vg.nad>2;letop=vg.nad;else;letop=vg.nad+1;end
    letype ={'Moyenne entre T1 et T2'; 'Valeur (Y) repositionnement du premier pt'; 'Première donnée du canal'; ...
             'Moyenne des n premier points'; 'Moyenne des n dernier points'; 'Moyenne de tous les points'; ...
             'Valeur minimun du canal'; 'Valeur maximun du canal|'; 'Valeur (X) choisie par l''usager'; ...
             'Point marqué du canal'};
    lapos =positionfen('G','C',300,450);
    reb.fig(1) =figure('Name','MENUREBASE', ...
            'Position',lapos, ...
            'CloseRequestFcn','rebase(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIControlunits','pixels',...
            'defaultUIControlFontSize',12,...
            'Resize','off');
    reb.titre(1) =uicontrol('Parent',reb.fig(1), ...
            'Position',[25 415 250 25], ...
            'FontWeight','bold',...
            'Style','text',...
            'String','Choix du type de Rebase');
    reb.control(1) =uicontrol('Parent',reb.fig(1), ...
            'ListboxTop',3, ...
            'Position',[25 385 250 25], ...
            'String',letype, ...
            'Callback','rebase(''choix'')', ...
            'Style','popupmenu', ...
            'Value',1);
    reb.titre(2) =uicontrol('Parent',reb.fig(1), ...
            'FontWeight','bold',...
            'Position',[25 345 250 25], ...
            'String','Choix des canal/aux à Rebaser', ...
            'Style','text');
    reb.control(2) =uicontrol('Parent',reb.fig(1), ...
            'BackgroundColor',[1 1 1], ...
            'Position',[50 180 200 160], ...
            'String',hdchnl.adname, ...
            'Min',1,...
            'Max',letop,...
            'Style','listbox', ...
            'Value',1);
    reb.text(1) =uicontrol('Parent',reb.fig(1), ...
            'Position',[50 140 200 25], ...
            'Style','text',...
            'String','Temps à considérer (sec)');
    reb.text(2) =uicontrol('Parent',reb.fig(1), ...
            'Position',[50 115 25 20], ...
            'Style','text',...
            'String','T1:');
    reb.ed(1) =uicontrol('Parent',reb.fig(1), ...
            'Position',[75 115 50 20], ...
            'Style','edit');
    reb.text(3) =uicontrol('Parent',reb.fig(1), ...
            'Position',[175 115 25 20], ...
            'Style','text',...
            'String','T2');
    reb.ed(2) =uicontrol('Parent',reb.fig(1), ...
            'Position',[200 115 50 20], ...
            'Style','edit');
    reb.control(3) =uicontrol('Parent',reb.fig(1), ...
            'Callback','rebase(''travail'')', ...
            'Position',[100 45 100 20], ...
            'String','Au travail');
    set(reb.fig(1),'WindowStyle','modal');
    guidata(gcf,reb);

  %----------------------------------------------------
  % en fonction de la sélection faite dans le popupmenu
  % on aura des ajout ou retrait à faire dans le GUI
  %-----------
  case 'choix'
    bouton =get(reb.control(1),'Value');

    switch(bouton)
    case 1
      effacer(vg.valeur,reb)
      reb.text(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',[50 140 200 25], ...
            'FontSize',12,...
            'Style','text',...
            'String','Temps à considérer (sec)');
      reb.text(2) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',[50 115 25 20], ...
            'FontSize',12,...
            'Style','text',...
            'String','T1:');
      reb.ed(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'ListboxTop',0, ...
            'Position',[75 115 50 20], ...
            'Style','edit', ...
            'Tag','EditText1');
      reb.text(3) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',[175 115 25 20], ...
            'FontSize',12,...
            'Style','text',...
            'String','T2');
      reb.ed(2) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'ListboxTop',0, ...
            'Position',[200 115 50 20], ...
            'Style','edit', ...
            'Tag','EditText1');

    case 2
      effacer(vg.valeur,reb)
      reb.text(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',[25 115 200 20], ...
            'FontSize',12,...
            'Style','text',...
            'String','Valeur à considérer (en Y):');
      reb.ed(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'ListboxTop',0, ...
            'Position',[225 115 50 20], ...
            'Style','edit', ...
            'Tag','EditText1');

    case 3
      effacer(vg.valeur,reb)

    case 4
      effacer(vg.valeur,reb)
      reb.text(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',[25 115 200 20], ...
            'FontSize',12,...
            'Style','text',...
            'String','Nb de points à considérer:');
      reb.ed(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'ListboxTop',0, ...
            'Position',[225 115 50 20], ...
            'Style','edit', ...
            'Tag','EditText1');

    case 5
      effacer(vg.valeur,reb)
      reb.text(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',[25 115 200 20], ...
            'FontSize',12,...
            'Style','text',...
            'String','Nb de points à considérer:');
      reb.ed(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'ListboxTop',0, ...
            'Position',[225 115 50 20], ...
            'Style','edit', ...
            'Tag','EditText1');

    case 6
      effacer(vg.valeur,reb)

    case 7
      effacer(vg.valeur,reb)

    case 8
      effacer(vg.valeur,reb)

    case 9
      effacer(vg.valeur,reb)
      reb.text(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',[25 115 200 20], ...
            'FontSize',12,...
            'Style','text',...
            'String','Valeur à considérer (en X):');
      reb.ed(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'ListboxTop',0, ...
            'Position',[225 115 50 20], ...
            'Style','edit', ...
            'Tag','EditText1');

    case 10
      effacer(vg.valeur,reb)
      reb.text(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',[25 115 200 20], ...
            'FontSize',12,...
            'Style','text',...
            'String','# du point à considérer:');
      reb.ed(1) =uicontrol('Parent',reb.fig(1), ...
            'Units','pixels', ...
            'ListboxTop',0, ...
            'Position',[225 115 50 20], ...
            'Style','edit', ...
            'Tag','EditText1');
    end
    guidata(gcf,reb);
    vg.valeur =bouton;

  %---------------------------------
  % on a cliqué le bouton Au travail
  %-------------
  case 'travail'
    dtchnl =CDtchnl();
    hdchnl =Ofich.Hdchnl;
    ptchnl =Ofich.Ptchnl;
    afaire =get(reb.control(1),'Value');
    lescan =get(reb.control(2),'Value')';
    nombre =size(lescan,1);

    switch(afaire)
    %-----------------------
    % MOYENNE ENTRE T1 ET T2
    %-----
    case 1
      tps1 =get(reb.ed(1),'String');  % Lecture des paramètres dans l'interface
      tps2 =get(reb.ed(2),'String');
      temps1 =str2double(tps1);
      temps2 =str2double(tps2);
      comment =strcat('Rebase, Moy. entre T1=',tps1,' et T2=',tps2,'//');
      if temps2 < temps1; tt =temps1; temps1 =temps2; temps2 =tt; end
      for i =1:nombre
        Ofich.getcanal(dtchnl, lescan(i));
        N =dtchnl.Nom;
        for j =1:vg.ess
          tic1 =round(temps1*hdchnl.rate(lescan(i),j));
          if tic1 == 0; tic1 =1; end
          tic2 =round(temps2*hdchnl.rate(lescan(i),j));
          rbs =mean(dtchnl.Dato.(N)(tic1:tic2, j));
          tout =1:hdchnl.nsmpls(lescan(i),j);
          dtchnl.Dato.(N)(tout,j) =dtchnl.Dato.(N)(tout,j)-rbs;
          hdchnl.max(lescan(i),j) =max(dtchnl.Dato.(N)(tout,j));
          hdchnl.min(lescan(i),j) =min(dtchnl.Dato.(N)(tout,j));
        end
        Ofich.setcanal(dtchnl);
      end
    %----------------------------------------
    % REPOSITIONNER EN FONCTION DU PREMIER PT
    %-----
    case 2
      crbs =get(reb.ed(1),'String');
      rbs =str2double(crbs);
      comment =strcat('Rebase, Val(Y) choisie=',crbs,'//');
      for i =1:nombre
        Ofich.getcanal(dtchnl, lescan(i));
        N =dtchnl.Nom;
        vrbs =dtchnl.Dato.(N)(1,:)-rbs;
        for j=1:vg.ess
          tout =1:hdchnl.nsmpls(lescan(i),j);
          dtchnl.Dato.(N)(tout,j)=dtchnl.Dato.(N)(tout,j)-vrbs(j);
          hdchnl.max(lescan(i),j) =max(dtchnl.Dato.(N)(tout,j));
          hdchnl.min(lescan(i),j) =min(dtchnl.Dato.(N)(tout,j));
        end
        Ofich.setcanal(dtchnl);
      end
    %-------------------------
    % PREMIÈRE DONNÉE DU CANAL
    %-----
    case 3
    comment =strcat('Rebase, premier pt','//');
    for i =1:nombre
      Ofich.getcanal(dtchnl, lescan(i));
      N =dtchnl.Nom;
      rbs =dtchnl.Dato.(N)(1,:);
      for j =1:vg.ess
        tout =1:hdchnl.nsmpls(lescan(i),j);
        dtchnl.Dato.(N)(tout,j)=dtchnl.Dato.(N)(tout,j)-rbs(j);
        hdchnl.max(lescan(i),j) =max(dtchnl.Dato.(N)(tout,j));
        hdchnl.min(lescan(i),j) =min(dtchnl.Dato.(N)(tout,j));
      end
      Ofich.setcanal(dtchnl);
    end
    %-----------------------------
    % MOYENNE DES N PREMIER POINTS
    %-----
    case 4
    lpts =get(reb.ed(1),'String');
    lespts =str2double(lpts);
    comment =['Rebase, Moy. des ' lpts ' prem. pt','//'];
    for i =1:nombre
      Ofich.getcanal(dtchnl, lescan(i));
      N =dtchnl.Nom;
      rbs =mean(dtchnl.Dato.(N)(1:lespts,:));
      for j =1:vg.ess
        tout =1:hdchnl.nsmpls(lescan(i),j);
        dtchnl.Dato.(N)(tout,j) =dtchnl.Dato.(N)(tout,j)-rbs(j);
        hdchnl.max(lescan(i),j) =max(dtchnl.Dato.(N)(tout,j));
        hdchnl.min(lescan(i),j) =min(dtchnl.Dato.(N)(tout,j));
      end
      Ofich.setcanal(dtchnl);
    end
    %-----------------------------
    % MOYENNE DES N DERNIER POINTS
    %-----
    case 5
    lpts =get(reb.ed(1),'String');
    lespts =str2num(lpts);
    comment =['Rebase, Moy. des ' lpts ' dern. pt','//'];
    for i =1:nombre
      Ofich.getcanal(dtchnl, lescan(i));
      N =dtchnl.Nom;
      for j =1:vg.ess
        ssm =hdchnl.nsmpls(lescan(i),j);
        tout =1:ssm;
        rbs =mean(dtchnl.Dato.(N)(ssm-lespts+1:ssm,:));
        dtchnl.Dato.(N)(tout,lescan(i),j) =dtchnl.Dato.(N)(tout,j)-rbs(j);
        hdchnl.max(lescan(i),j) =max(dtchnl.Dato.(N)(tout,j));
        hdchnl.min(lescan(i),j) =min(dtchnl.Dato.(N)(tout,j));
      end
      Ofich.setcanal(dtchnl);
    end
    %---------------------------
    % MOYENNE DE TOUS LES POINTS
    %-----
    case 6
    comment =['Rebase, Moy. tous les pt','//'];
    for i =1:nombre
    	Ofich.getcanal(dtchnl, lescan(i));
    	N =dtchnl.Nom;
      for j =1:vg.ess
      	tout =1:hdchnl.nsmpls(lescan(i),j);
      	rbs =mean(dtchnl.Dato.(N)(tout,j));
        dtchnl.Dato.(N)(tout,j) =dtchnl.Dato.(N)(tout,j)-rbs;
        hdchnl.max(lescan(i),j) =max(dtchnl.Dato.(N)(tout,j));
        hdchnl.min(lescan(i),j) =min(dtchnl.Dato.(N)(tout,j));
      end
      Ofich.setcanal(dtchnl);
    end
    %------------------------
    % VALEUR MINIMUN DU CANAL
    %-----
    case 7
    comment =['Rebase, Min. du canal','//'];
    for i =1:nombre
    	Ofich.getcanal(dtchnl, lescan(i));
    	N =dtchnl.Nom;
      for j =1:vg.ess
      	tout =1:hdchnl.nsmpls(lescan(i),j);
      	rbs =hdchnl.min(lescan(i),j);
        dtchnl.Dato.(N)(tout,j) =dtchnl.Dato.(N)(tout,j)-rbs;
        hdchnl.max(lescan(i),j) =max(dtchnl.Dato.(N)(tout,j));
        hdchnl.min(lescan(i),j) =min(dtchnl.Dato.(N)(tout,j));
      end
      Ofich.setcanal(dtchnl);
    end
    %------------------------
    % VALEUR MAXIMUN DU CANAL
    %-----
    case 8
    comment=['Rebase, Max. du canal','//'];
    for i =1:nombre
    	Ofich.getcanal(dtchnl, lescan(i));
    	N =dtchnl.Nom;
      for j =1:vg.ess
      	tout =1:hdchnl.nsmpls(lescan(i),j);
      	rbs =hdchnl.max(lescan(i),j);
        dtchnl.Dato.(N)(tout,j) =dtchnl.Dato.(N)(tout,j)-rbs;
        hdchnl.max(lescan(i),j) =max(dtchnl.Dato.(N)(tout,j));
        hdchnl.min(lescan(i),j) =min(dtchnl.Dato.(N)(tout,j));
      end
      Ofich.setcanal(dtchnl);
    end
    %-----------------------------
    % VALEUR EN SECONDE, AXE DES X
    %-----
    case 9
      crbs =get(reb.ed(1),'String');
      rbs =str2num(crbs);
      comment =strcat('Rebase, Val(X) choisie=',crbs,'//');
      for i =1:nombre
      	Ofich.getcanal(dtchnl, lescan(i));
      	N =dtchnl.Nom;
        for j =1:vg.ess
        	tout =1:hdchnl.nsmpls(lescan(i),j);
          ttp =round((rbs-hdchnl.frontcut(lescan(i),j))*hdchnl.rate(lescan(i),j));
          vrbs =dtchnl.Dato.(N)(ttp,j);
          dtchnl.Dato.(N)(tout,j) =dtchnl.Dato.(N)(tout,j)-vrbs;
          hdchnl.max(lescan(i),j) =max(dtchnl.Dato.(N)(tout,j));
          hdchnl.min(lescan(i),j) =min(dtchnl.Dato.(N)(tout,j));
        end
        Ofich.setcanal(dtchnl);
      end
    %------------------------
    % # DU POINT À CONSIDÉRER
    %------
    case 10
      crbs =get(reb.ed(1),'String');
      rbs =str2num(crbs);
      ttest =Ofich.assezpt(lescan, rbs);
      if ttest
        delete(reb.fig(1));
        vg.valeur =0;
        return;
      end
      comment =['Rebase,Point(' crbs ')//'];
      for i =1:nombre
      	Ofich.getcanal(dtchnl, lescan(i));
      	N =dtchnl.Nom;
        for j =1:vg.ess
          tout =1:hdchnl.nsmpls(lescan(i),j);
          ttp =ptchnl.Dato(rbs,hdchnl.point(lescan(i),j),1);
          vrbs =dtchnl.Dato.(N)(ttp,j);
          dtchnl.Dato.(N)(tout,j) =dtchnl.Dato.(N)(tout,j)-vrbs;
          hdchnl.max(lescan(i),j) =max(dtchnl.Dato.(N)(tout,j));
          hdchnl.min(lescan(i),j) =min(dtchnl.Dato.(N)(tout,j));
        end
        Ofich.setcanal(dtchnl);
      end
    %--
    end
    for i =1:vg.ess
      for j =1:nombre
        vc =['R.' hdchnl.comment{lescan(j), i} comment];
        hdchnl.comment{lescan(j), i} =vc;
      end
    end
    delete(dtchnl);
    delete(reb.fig(1));
    vg.sauve =1;
    vg.valeur =0;
    OA.OFig.affiche();

  %--------------
  case 'fermer'
    delete(reb.fig(1));
    vg.valeur =0;
  end
end

function effacer(chose,reb)
  %
  % efface les boutons inutiles
  %
  switch(chose)
  case 1
    delete(reb.text(1));
    delete(reb.text(2));
    delete(reb.ed(1));
    delete(reb.text(3));
    delete(reb.ed(2));
  case 2
    delete(reb.text(1));
    delete(reb.ed(1));
  case 3
  % rien à enlever
  case 4
    delete(reb.text(1));
    delete(reb.ed(1));
  case 5
    delete(reb.text(1));
    delete(reb.ed(1));
  case 6
  % rien à enlever
  case 7
  % rien à enlever
  case 8
  % rien à enlever
  case 9
    delete(reb.text(1));
    delete(reb.ed(1));
  case 10
    delete(reb.text(1));
    delete(reb.ed(1));
  end
end
