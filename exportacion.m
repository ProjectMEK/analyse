%
% Exportation des donn�es dans un fichier texte
%
function exportacion(varargin)
  if nargin == 0                % condition sur les arguments de la fonction
    commande ='ouverture';
  else
    commande =varargin{1};
    sh =guidata(gcf);
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  %---------------
  switch(commande)
  %---------------
  case 'ouverture'
    if vg.nad>2;letop = vg.nad;else letop = vg.nad + 1;end
    if vg.ess>2;lemax = vg.ess;else lemax = vg.ess + 1;end
    separa = strcat('virgule','|','point virgule','|','Tab');
    Lfen =300; Hfen =450;
    lapos =positionfen('G', 'H', Lfen, Hfen);
    sh.fig(1) = figure('Name', 'MENU EXPORTATION', ...
            'Position',lapos, 'CloseRequestFcn','exportacion(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIControlunits','pixels',...
            'DefaultUIControlFontSize',10,...
            'Resize', 'off');
    mx =25; mxtext =50; posx =mxtext; large =Lfen-2*mxtext; posy =Hfen-45; Htext =25; haut =Htext;
    sh.titre(1) =  uicontrol('Parent',sh.fig(1), ...
            'FontWeight','bold',...
            'Position',[posx posy large haut], ...
            'String','Choix du/des canal/aux', ...
            'Style','text');
    haut =60; posy =posy-haut;
    sh.control(1) = uicontrol('Parent',sh.fig(1), ...
            'BackgroundColor',[1 1 1], ...
            'Position',[posx posy large haut], ...
            'String',hdchnl.Listadname, ...
            'Min',1,...
            'Max',letop,...
            'Style','listbox', ...
            'Value',1);
    haut =Htext; posy =posy-45;
    sh.titre(2) =  uicontrol('Parent',sh.fig(1), ...
            'FontWeight','bold',...
            'Position',[posx posy large haut], ...
            'String','Choix du/des essais:', ...
            'Style','text');
    sh.control(2) = uicontrol('Parent',sh.fig(1), ...
            'BackgroundColor',[1 1 1], ...
            'Position',[90 259 120 50], ...
            'String',vg.lesess, ...
            'Min',1,...
            'Max',lemax,...
            'Style','listbox', ...
            'Value',1);
    sh.titre(3) =  uicontrol('Parent',sh.fig(1), ...
            'FontWeight','bold',...
            'Position',[100 226 100 20], ...
            'String','S�parateur:', ...
            'Style','text');
    sh.control(3) = uicontrol('Parent',sh.fig(1), ...
            'Position',[100 200 100 25], ...
            'FontSize',11,...
            'String',separa, ...
            'Style','popupmenu', ...
            'Value',1);

% introduire ici la pr�cision d�cimale que l'on retrouve dans wresul

    sh.titre(6) =  uicontrol('Parent',sh.fig(1), ...
            'FontWeight','bold',...
            'Position',[50 150 200 22], ...
            'String','Choix des �chantillons pris:', ...
            'Style','text');
    sh.titre(7) =  uicontrol('Parent',sh.fig(1), ...
            'FontSize',11,...
            'Position',[105 128 30 22], ...
            'String','1 / ', ...
            'Style','text');
    sh.ed(1) = uicontrol('Parent',sh.fig(1), ...
            'style', 'edit', ...
            'position', [135 130 50 21], ...
            'string', '1');
    large =85; posx =round((Lfen-large)/2); haut =Htext;
    sh.control(4) = uicontrol('Parent',sh.fig(1), ...
            'Callback','exportacion(''travail'')', ...
            'Position',[posx 85 large haut], ...
            'String','Au travail');
    sh.titre(4) =  uicontrol('Parent',sh.fig(1), ...
            'FontWeight','bold',...
            'Position',[0 50 300 20], ...
            'String','-----------------------------------------------------------------------------', ...
            'Style','text');
    sh.titre(5) =  uicontrol('Parent',sh.fig(1), ...
            'FontSize',9,...
            'Position',[25 5 250 46], ...
            'String','Sauvegarder les canaux/essais choisis en format texte', ...
            'Style','text');
    set(sh.fig(1),'WindowStyle','modal');
    guidata(gcf,sh);
  %------------------------------------------------------------------------------------------
  case 'travail'
    canaux =get(sh.control(1),'Value')';
    essai =get(sh.control(2),'Value')';
    nombre =length(canaux);
    nombress =length(essai);
    pas =str2double(get(sh.ed(1),'String'));
    [nomfich,lieu] =uiputfile('*.*','Exportation');
    pcourant =pwd;
    cd(lieu);
    fileident =fopen(nomfich,'w');
    saut =[char(13) char(10)];
    sep =get(sh.control(3),'Value');
    seplist ={','; ';'; char(9)};
    tab =seplist{sep};
    h1 =waitbar(0,'traitement en cours');
    % Ligne d'ent�te g�n�rale
    contenu =['Fichier d`origine: ' Ofich.Info.finame '  (FRONTCUT = ' num2str(hdchnl.frontcut(canaux(1),essai(1))) ')' saut];
    fprintf(fileident, '%s', contenu);
    % Ligne de titre des canaux � exporter
    valcan ='No �chantillon';
    frequence ='Fr�quence';
    for m =1:nombre
      Dt{m} =CDtchnl();
      Ofich.getcaness(Dt{m}, essai, canaux(m));
      valcan =[valcan tab deblank(hdchnl.adname{canaux(m)})];
      frequence =[frequence tab num2str(hdchnl.rate(canaux(m),essai(1))) ' Hz'];
    end
    valcan =[valcan saut];
    frequence =[frequence saut];
    nbdonmax =max(hdchnl.nsmpls(canaux,1));
    for ij =1:nombress
      % Ligne de titre par essai � exporter
      contenu =[saut 'NO ESSAI: ' num2str(essai(ij)) ' (Stimulus: ' vg.nomstim{hdchnl.numstim(essai(ij))} ')' saut];
      fprintf(fileident, '%s', contenu);
      fprintf(fileident, '%s', frequence);
      fprintf(fileident, '%s', valcan);
      for i =1:nbdonmax/pas
        ptrs =((i-1)*pas) + 1;
        contenu =num2str(ptrs);
        for can =1:nombre
          curDt =Dt{can};
          % au cas ou on a diff�rentes fr�quences d'�chantillonage
          if ptrs > hdchnl.nsmpls(canaux(can),essai(ij))
            contenu =[contenu, tab];
          else
            contenu =[contenu, tab, num2str(curDt.Dato.(curDt.Nom)(ptrs, ij))];
          end
        end
        contenu =[contenu saut];
        fprintf(fileident, '%s', contenu);
        waitbar(i/(nbdonmax/pas));   
      end
    end
    for m =1:nombre
      delete(Dt{m});
    end
    fclose(fileident);
    close(h1);
    delete(sh.fig(1));
    cd(pcourant);
  %------------
  case 'fermer'
     delete(sh.fig(1));
  %--
  end
end
