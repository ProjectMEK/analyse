%
% GRAME, été 2000
% par MEK
%
% fonction pour écrire les résultats (les points marqués) dans un fichier.
% On peut sélectionner les champs et les canaux désirés.
%
% Chacunes des lignes du fichier de résultat représentent un essai.
%
%*************************************
% Modification future...
% R =readtable('fichier_de_sortie_actuel')
% puis on sauvegarde R dans un fichier .mat
%
%
function resultats(varargin)
  if nargin == 0
     commande = 'ouverture';
  else
     commande = varargin{1};
      wr = guidata(gcf);
  end
  hA =CAnalyse.getInstance();
  hF =hA.findcurfich();
  hdchnl =hF.Hdchnl;
  tpchnl =hF.Tpchnl;
  vg =hF.Vg;
  %
  switch(commande)

  %-------------------------------------
  % Fabrication de l'interface Graphique
  %---------------
  case 'ouverture'
    global lebord1 lebord2;
    if vg.nad>2;letop=vg.nad;else;letop=vg.nad+1;end
    xmax =600; ymax =350; Mx =25; Lcan =150; lebord1 =Lcan+2*Mx; lebord2 =floor((xmax+lebord1)/2);
    Larg =lebord2-lebord1-15; Lbox =15; Larg2 =lebord2-lebord1-Mx-Lbox;
    lapos =positionfen('G','H',xmax,ymax);
    wr.fig(1) = figure('Name','MENU-RÉSULTAT', ...
            'Position',lapos, ...
            'CloseRequestFcn','resultats(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIControlunits','pixels',...
            'DefaultUIControlFontSize',9,...
            'DefaultUIControlStyle','checkbox', ...
            'DefaultUIControlHorizontalAlignment','left',...
            'Resize', 'off');															%
    ypos=ymax-30;xpos=round((xmax-400)/2);
    wr.tit(1) =  uicontrol('Parent',wr.fig(1), ...
            'HorizontalAlignment','center',...
            'Position',[xpos ypos 400 25], ...
            'FontWeight','bold',...
            'FontSize',12,...
            'Style','text',...
            'String','Choix des champs à exporter');
    ypos =ypos-30; xpos =Mx;
    wr.tit(2) = uicontrol('Parent',wr.fig(1), ...
            'HorizontalAlignment','center',...
            'Position',[xpos ypos Lcan 25], ...
            'String','Choix des canaux', ...
            'FontSize',12,...
            'Style','text');
    p =ypos; haut =200; ypos =ypos-haut;
    texte ={'Parent';wr.fig(1); 'BackgroundColor';[1 1 1]; 'Position';[xpos ypos Lcan haut]; ...
            'String';hdchnl.Listadname; 'Min';1; 'Max';letop; 'FontSize';10; ...
            'Style';'listbox'; 'Value';1};
    wr.cano =CListBox1(texte);
    ypos=p+20;
    % ****************on étale de gauche à droite
    adroite=0;
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    wr.entete = uicontrol('Parent',wr.fig(1), ...
            'Position',[xpos ypos Larg 25], ...
            'String','Écrire une ligne de titre',...
            'Value',1);
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    wr.noess = uicontrol('Parent',wr.fig(1), ...
            'Position',[xpos ypos Larg 25], ...
            'String','# de l''essai',...
            'Value',1);
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    wr.Com1 =uicontrol('Parent',wr.fig(1), 'Position',[xpos ypos Lbox 25], ...
            'String',' ', 'Value',0, 'ToolTipString','Ajouter un champ commentaire');
    wr.Com1Txt =uicontrol('Parent',wr.fig(1), 'Position',[xpos+Lbox ypos Larg2 25], 'Tag','Com1Txt', ...
                'BackgroundColor',[1 1 1], 'String','', 'Style','edit', 'ToolTipString','Ajouter un champ commentaire');
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    wr.Com2 =uicontrol('Parent',wr.fig(1), 'Position',[xpos ypos Lbox 25], ...
            'String',' ', 'Value',0, 'ToolTipString','Ajouter un champ commentaire');
    wr.Com2Txt =uicontrol('Parent',wr.fig(1), 'Position',[xpos+Lbox ypos Larg2 25], 'Tag','Com2Txt', ...
                'BackgroundColor',[1 1 1], 'String','', 'Style','edit', 'ToolTipString','Ajouter un champ commentaire');
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    wr.categ = uicontrol('Parent',wr.fig(1), ...
            'Position',[xpos ypos Larg 25], ...
            'String','Nom des catégories',...
            'Value',1);
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    wr.adname = uicontrol('Parent',wr.fig(1), ...
            'Position',[xpos ypos Larg 25], ...
            'String','Nom du canal',...
            'Value',1);
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    wr.nomstim = uicontrol('Parent',wr.fig(1), ...
            'Position',[xpos ypos Larg 25], ...
            'String','Nom du stimlus',...
            'Value',0);
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    wr.numero = uicontrol('Parent',wr.fig(1), ...
            'Position',[xpos ypos Larg 25], ...
            'String','# du stimulus',...
            'Value',0);
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    wr.point = uicontrol('Parent',wr.fig(1), ...
            'Position',[xpos ypos Larg 25], ...
            'String','points marqués (abcisse)',...
            'Value',1);
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    wr.amplit = uicontrol('Parent',wr.fig(1), ...
            'Position',[xpos ypos Larg 25], ...
            'String','Amplitude correspondante',...
            'Value',1);
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    letype ={'virgule'; 'point virgule'; 'espace'; 'Tab'};
    Ffu =floor(Larg/3);
    wr.separe =uicontrol('Parent',wr.fig(1), 'Position',[xpos ypos Ffu 25], 'String',letype, ...
                         'Style','popupmenu', 'Value',1);
    xpos=xpos+Ffu;
    uicontrol('Parent',wr.fig(1), 'Position',[xpos ypos Larg-Ffu 20], 'String','Séparateur', 'Style','text');
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    S ={'Aucune'};
    if tpchnl.nbech
      Stmp =tpchnl.FaireListEchel();
      S(2:length(Stmp)+1) =Stmp;
    end
    letype ={'virgule'; 'point virgule'; 'espace'; 'Tab'};
    uicontrol('Parent',wr.fig(1), 'Position',[xpos ypos Ffu 25], 'Tag','EchelleTps', 'String',S, ...
              'Style','popupmenu', 'Value',1);
    xpos =xpos+Ffu;
    wr.tmp =uicontrol('Parent',wr.fig(1), 'Position',[xpos ypos Larg-Ffu 20], ...
                      'String','Éch. de temps', 'Style','text');
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    LFfu =round(0.6*Ffu);
    uicontrol('Parent',wr.fig(1), 'Position',[xpos ypos LFfu 25], 'Tag','NbChiffPrecis', ...
              'String','4', 'Style','edit');
    xpos =xpos+LFfu;
    uicontrol('Parent',wr.fig(1), 'Position',[xpos ypos Larg-LFfu 20], ...
                      'String',' Précision décimale', 'Style','text');
    [xpos,ypos,adroite] =Replace(xpos,ypos,adroite);
    wr.comment =uicontrol('Parent',wr.fig(1), 'Position',[xpos ypos Larg 25], 'String','Champ vide', 'Value',0);
    lebord1 =200; lebord2 =400;  % voir aussi en bas completement
    xpos = floor((lebord1+lebord2)/2);
    ypos = 20;
    uicontrol('Parent',wr.fig(1), 'Callback','resultats(''au travail'')', 'FontSize',12, 'Style','pushbutton',...
              'HorizontalAlignment','center', 'Position',[xpos ypos 80 25], 'String','Au travail');
    set(wr.fig(1),'WindowStyle','modal');
    guidata(gcf,wr);
  case 'au travail'
    saut = [char(13) char(10)];
    [fname,pname] = uiputfile('*.*','Écriture des résultats');
    if ~ischar(fname)
      return
    end
    ptchnl =hF.Ptchnl;
    catego =hF.Catego;
    wr.path    =pname;
    wr.curpath =pwd;
    wr.foname  =fname;
    p =get(wr.separe,'Value');                      % ## séparateur = p
    foo ={',', ';', ' ', char(9)};
    formul.p         = foo{p};
    formul.lescan    =wr.cano.getValue();          % ## canaux utiles
    formul.entete    = get(wr.entete,'Value');     % ## on écrit une ligne d'entête
    formul.noess     = get(wr.noess,'Value');      % ## on écrit le # de l'essai
    formul.com1      = get(wr.Com1,'Value');       % ## on écrit le premier champ commentaire
    formul.com1txt   = get(wr.Com1Txt,'String');   % ## on lit le premier champ commentaire
    formul.com2      = get(wr.Com2,'Value');       % ## on écrit le second champ commentaire
    formul.com2txt   = get(wr.Com2Txt,'String');   % ## on lit le second champ commentaire
    formul.categ     = get(wr.categ,'Value');      % ## on écrit le nom des catégories
    formul.adname    = get(wr.adname,'Value');     % ## on écrit le nom des canaux
    formul.nomstim   = get(wr.nomstim,'Value');    % ## on écrit le nom du stim
    formul.numero    = get(wr.numero,'Value');     % ## on écrit le numero du stim
    formul.point     = get(wr.point,'Value');      % ## on écrit la position des pts (abcisse)
    formul.amplit    = get(wr.amplit,'Value');     % ## on écrit l'amplitude des pts (ordonnée)
    formul.comment   = get(wr.comment,'Value');    % ## on ajoute un champ vide
    formul.echel     =get(findobj('Tag','EchelleTps'), 'Value')-1;
    formul.precis    =strtrim(get(findobj('Tag','NbChiffPrecis'), 'String'));
    if formul.categ & ~vg.niveau
      formul.categ=0;
    end
    for i=1:vg.nad
      formul.val(i)=max(hdchnl.npoints(i,:));
    end
    cd(wr.path);
    fid = fopen(wr.foname,'w');
    if formul.entete
      ligne_entete = creer_entete(formul,catego,vg);
      fprintf(fid,'%s',ligne_entete);
    end
    ecrit_data(hF,fid,formul,hdchnl,tpchnl,ptchnl,catego,vg);
    fclose(fid);
    cd(wr.curpath);
    delete(wr.fig(1));
    vg.valeur=0;
  case 'fermer'
    delete(wr.fig(1));
    vg.valeur=0;
  end
end

function a = creer_entete(formul,catego,vg);
  saut = [char(13) char(10)];
  a = '';
  pavid=0;
  if formul.noess
    a = 'essai';
    pavid=1;
  end
  if formul.com1
    if pavid
      a =[a,formul.p,'COM1'];
    else
      a ='COM1';
      pavid =1;
    end
  end
  if formul.com2
    if pavid
      a =[a,formul.p,'COM2'];
    else
      a ='COM2';
      pavid =1;
    end
  end
  if formul.categ
    for i=1:vg.niveau
      if pavid
        a = [a,formul.p,catego.Dato(1,i,1).nom];
      else
        a = strtrim(catego.Dato(1,i,1).nom);
        pavid=1;
      end
    end
  end
  if formul.nomstim
    if pavid
      a = [a,formul.p,'Stimulus'];
    else
      a = 'Stimulus';
      pavid=1;
    end
  end
  if formul.numero
    if pavid
      a = [a,formul.p,'No_Stim'];
    else
      a = 'No_Stim';
      pavid=1;
    end
  end
  if formul.comment
    if pavid
      a = [a,formul.p,'comment.'];
    else
      a = 'comment.';
      pavid=1;
    end
  end
  if formul.adname
    if pavid
      for i =1:length(formul.lescan)
        b =int2str(formul.lescan(i));
        a =[a formul.p 'canal_' b];
        for j =1:formul.val(formul.lescan(i))
          c =int2str(j);
          if formul.point
            a =[a,formul.p,'Xc',b,'_p',c];
          end
          if formul.amplit
            a =[a,formul.p,'Yc',b,'_p',c];
          end
        end
      end
    else
      b =int2str(formul.lescan(1));
      a =['canal_',b];
      pavid =1;
      for j =1:formul.val(formul.lescan(1))
        c =int2str(j);
        if formul.point
          a =[a,formul.p,'Xc',b,'_p',c];
        end
        if formul.amplit
          a =[a,formul.p,'Yc',b,'_p',c];
        end
      end
      for i=2:size(formul.lescan,1)
        b = int2str(formul.lescan(i));
        a = [a,formul.p,'canal_',b];
        for j=1:formul.val(formul.lescan(i))
          c = int2str(j);
          if formul.point
            a = [a,formul.p,'Xc',b,'_p',c];
          end
          if formul.amplit
            a = [a,formul.p,'Yc',b,'_p',c];
          end
        end
      end
    end
  else    % si on n'écrit pas le nom du canal
    if pavid
      for i=1:size(formul.lescan,1)
        b = int2str(formul.lescan(i));
        for j=1:formul.val(formul.lescan(i))
          c = int2str(j);
          if formul.point
            a = [a,formul.p,'Xc',b,'_p',c];
          end
          if formul.amplit
            a = [a,formul.p,'Yc',b,'_p',c];
          end
        end
      end
    else
      b = int2str(formul.lescan(1));
      for j=1:formul.val(formul.lescan(1))
        c = int2str(j);
        if formul.point
          if pavid
            a = [a,formul.p,'Xc',b,'_p',c];
          else
            a = ['Xc',b,'_p',c];
            pavid=1;
          end
        end
        if formul.amplit
          if pavid
            a = [a,formul.p,'Yc',b,'_p',c];
          else
            a = ['Yc',b,'_p',c];
            pavid=1;
          end
        end
      end
      for i=2:size(formul.lescan,2)
        b = int2str(formul.lescan(i));
        for j=1:formul.val(formul.lescan(i))
          c = int2str(j);
          if formul.point
            a = [a,formul.p,'Xc',b,'_p',c];
          end
          if formul.amplit
            a = [a,formul.p,'Yc',b,'_p',c];
          end
        end
      end
    end
  end
  a = [a saut];
end

function ecrit_data(hF, fid, formul, hdchnl, tpchnl, ptchnl, catego, vg)
  hDt =CDtchnl();
  saut =[char(13) char(10)];
  % évaluation de la précision
  ElFormat ='%0.4f';
  if ~isnan(str2double(formul.precis))
    ElFormat =['%0.' num2str(formul.precis) 'f'];
  end
  lescan =formul.lescan;
  nombre =length(lescan);
  pavid =zeros(vg.ess);
  hW =waitbar(0.001, 'Travail en cours');
  for U =1:vg.ess
    a.(['A' num2str(U)]) ='';
  end
  for j =1:vg.ess
    barre =j/vg.ess*0.2;
    waitbar(barre, hW);
    if formul.noess
      a.(['A' num2str(j)]) =int2str(j);
      pavid(j) =1;
    end
    if formul.com1
      if pavid(j)
        a.(['A' num2str(j)]) =[a.(['A' num2str(j)]) formul.p strtrim(formul.com1txt)];
      else
        a.(['A' num2str(j)]) =strtrim(formul.com1txt);
        pavid(j) =1;
      end
    end
    if formul.com2
      if pavid(j)
        a.(['A' num2str(j)]) =[a.(['A' num2str(j)]) formul.p strtrim(formul.com2txt)];
      else
        a.(['A' num2str(j)]) =strtrim(formul.com2txt);
        pavid(j) =1;
      end
    end
    if formul.categ
      for i=1:vg.niveau
        if catego.Dato(1,i,1).ess(j)
          if pavid(j)
            a.(['A' num2str(j)]) =[a.(['A' num2str(j)]),formul.p,'--'];
          else
            a.(['A' num2str(j)]) ='--';
            pavid(j)=1;
          end
        else
          for k=1:catego.Dato(1,i,1).ncat
            if catego.Dato(2,i,k).ess(j)
              if pavid(j)
                a.(['A' num2str(j)]) =[a.(['A' num2str(j)]),formul.p,deblank(catego.Dato(2,i,k).nom)];
              else
                a.(['A' num2str(j)]) =deblank(catego.Dato(2,i,k).nom);
                pavid(j)=1;
              end
            end
          end
        end % if catego.Dato(1,i,1).ess(j)
      end
    end
    if formul.nomstim
      if pavid(j)
        a.(['A' num2str(j)]) =[a.(['A' num2str(j)]) formul.p deblank(vg.nomstim{hdchnl.numstim(j)})];
      else
        a.(['A' num2str(j)]) = deblank(vg.nomstim{hdchnl.numstim(j)});
        pavid(j)=1;
      end
    end
    if formul.numero
      if pavid(j)
        a.(['A' num2str(j)]) =[a.(['A' num2str(j)]),formul.p,num2str(hdchnl.numstim(j))];
      else
        a.(['A' num2str(j)]) =num2str(hdchnl.numstim(j));
        pavid(j)=1;
      end
    end
    if formul.comment
      if pavid(j)
        a.(['A' num2str(j)]) =[a.(['A' num2str(j)]),formul.p,'vide'];
      else
        a.(['A' num2str(j)]) ='vide';
        pavid(j)=1;
      end
    end
  end
  lepp =zeros(1, vg.ess, 'single');
  if formul.echel
    for U =1:vg.ess
      fs1 =hdchnl.rate(tpchnl.Dato{formul.echel}.canal, U);
      if ptchnl.Dato(tpchnl.Dato{formul.echel}.point,hdchnl.point(tpchnl.Dato{formul.echel}.canal, U),2) ~= -1
        lepp(U) =ptchnl.Dato(tpchnl.Dato{formul.echel}.point,hdchnl.point(tpchnl.Dato{formul.echel}.canal, U),1);
        lepp(U) =single(lepp(U))/fs1;
      end
    end
  end
  for i =1:nombre
    hF.getcanal(hDt, lescan(i)); 
    for j =1:vg.ess
      barre =(((i-1)*nombre+j)/(vg.ess*nombre)*0.7)+0.2;
      waitbar(barre, hW);
      if formul.adname
        if pavid(j)
          a.(['A' num2str(j)]) =[a.(['A' num2str(j)]) formul.p strtrim(hdchnl.adname{lescan(i)})];
        else
          a.(['A' num2str(j)]) =strtrim(hdchnl.adname{lescan(i)});
          pavid(j)=1;
        end
      end
      for m =1:formul.val(lescan(i))
        if (hdchnl.npoints(lescan(i),j) >= m) & (ptchnl.Dato(m,hdchnl.point(lescan(i),j),2)==-1)
          if formul.point
            if pavid(j)
              a.(['A' num2str(j)]) =[a.(['A' num2str(j)]),formul.p,'Bidon'];
            else
              a.(['A' num2str(j)]) =[formul.p 'Bidon'];
              pavid(j)=1;
            end
          end
          if formul.amplit
            if pavid(j)
              a.(['A' num2str(j)]) =[a.(['A' num2str(j)]),formul.p,'Bidon'];
            else
              a.(['A' num2str(j)]) =[formul.p 'Bidon'];
              pavid(j)=1;
            end
          end
        elseif hdchnl.npoints(lescan(i),j) >= m
          if formul.point
            abc = double(ptchnl.Dato(m,hdchnl.point(lescan(i),j),1))/hdchnl.rate(lescan(i),j)+hdchnl.frontcut(lescan(i),j);
            if pavid(j)
              a.(['A' num2str(j)]) =[a.(['A' num2str(j)]),formul.p,num2str(abc-lepp(j))];
            else
              a.(['A' num2str(j)]) =num2str(abc-lepp(j));
              pavid(j)=1;
            end
          end
          if formul.amplit
            if ptchnl.Dato(m,hdchnl.point(lescan(i),j)) <= 0
              amp = ' ';
            else
              amp = num2str(hDt.Dato.(hDt.Nom)(ptchnl.Dato(m,hdchnl.point(lescan(i),j),1),j), ElFormat);
            end
            if pavid(j)
              a.(['A' num2str(j)]) =[a.(['A' num2str(j)]),formul.p,amp];
            else
              a.(['A' num2str(j)]) =amp;
              pavid(j)=1;
            end
          end
        else  % aucun points marqué
          if formul.point
            if pavid(j)
              a.(['A' num2str(j)]) =[a.(['A' num2str(j)]),formul.p];
            else
              a.(['A' num2str(j)]) =formul.p;
              pavid(j)=1;
            end
          end
          if formul.amplit
            if pavid(j)
              a.(['A' num2str(j)]) =[a.(['A' num2str(j)]),formul.p];
            else
              a.(['A' num2str(j)]) = formul.p;
              pavid(j)=1;
            end
          end
        end
      end  % for m=1:formul...
    end
  end
  for V =1:vg.ess
    barre =(V/vg.ess*0.1)+0.9;
    waitbar(barre, hW);
    a.(['A' num2str(V)]) = [a.(['A' num2str(V)]) saut];
    fprintf(fid,'%s',a.(['A' num2str(V)]));
  end
  delete(hDt);
  delete(hW);
end

function [xpos,ypos,adroite] =Replace(xpos,ypos,adroite)
  global lebord1 lebord2;
  if adroite
    xpos = lebord2;
    adroite=0;
  else
    xpos = lebord1;
    ypos = ypos - 35;
    adroite=1;
  end
end
