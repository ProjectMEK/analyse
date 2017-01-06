%
% INTEGRATIONS/INTEGRATIONS SUCCESSIVES
%
% Laboratoire GRAME
% Mai 2000, juillet 2002, dec 2008, nov 2010
%
% Fonction qui calcule l'intégrale de la courbe entre 2 points, et
% éventuellement l'intégrale normalisée (pour le temps), calculs qui 
% peuvent se diviser sur plusieurs intervalles successifs; les 
% résultats sont sauvegardés dans un fichier texte.
%
% Le calcul de l'intégrale se fait grâce à la fonction Matlab prédéfinie "trapz".
% Les paramètres à choisir sont: le choix des canaux, l'intervalle de 
% calcul, le nombre d'intégrales successives, le séparateur (espace, 
% virgule,...) pour la sauvegarde dans le fichier texte.
%
function integSuc(varargin)
  if nargin == 2
    commande = 'ouverture';														%
  	if varargin{1}
  		nsuc ='on';
  	else
  		nsuc ='off';
  	end
  	if varargin{2}
  		noor ='on';
  	else
  		noor ='off';
  	end
  else
    commande = varargin{1};
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  %---------------
  switch(commande)																	
  %---------------
  case 'ouverture'
    vg.valeur = 1;
    if vg.nad > 2, letop =vg.nad;
    else, letop =vg.nad + 1;
    end
    separa ={'virgule','point virgule','Tab'};
    lapos =positionfen('G','H',300,550);
    lafig = figure('Name', 'INTEGRATIONS (SUCCESSIVES)', 'tag','FintSucc',...
            'Position',lapos, ...
            'CloseRequestFcn','integSuc(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIControlunits','pixels',...
            'DefaultUIControlFontSize',11,'Resize', 'off');
    uicontrol('Parent',lafig, ...
            'Position',[20 510 250 25], ...
            'String','Choix des canaux:', ...
            'Style','text');
    uicontrol('Parent',lafig, 'tag','ChoixCan',...
            'BackgroundColor',[1 1 1], ...
            'Position',[50 395 200 110], ...
            'String',hdchnl.Listadname, ...
            'Min',1,...
            'Max',letop,...
            'Style','listbox', ...
            'Value',1);
    uicontrol('Parent',lafig, ...
            'Position',[50 335 200 25], ...
            'String','Points/temps de depart et fin:', ...
            'HorizontalAlignment','Center','Style','text');
    uicontrol('Parent',lafig, ...
            'Position',[50 320 80 20], ...
            'String','Debut', 'FontSize',10,...
            'HorizontalAlignment','Center','Style','text');
    uicontrol('Parent',lafig, ...
            'Position',[165 320 80 20], ...
            'String','Fin', 'FontSize',10,...
            'HorizontalAlignment','Center','Style','text');
    uicontrol('Parent',lafig,'tag','EdDebut', ...
            'style', 'edit', ...
            'TooltipString','(p0=premier échantillon, pf le dernier) (valeur numérique=temps en sec) ou bien p1, p2... pour un point déjà marqué',...
            'position', [65 300 50 20], ...
            'string', 'P0');
    uicontrol('Parent',lafig,'tag','EdFin', ...
            'TooltipString','(p0=premier échantillon, pf le dernier) (valeur numérique=temps en sec) ou bien p1, p2... pour un point déjà marqué',...
            'style', 'edit', ...
            'position', [180 300 50 20], ...
            'string', 'Pf');
    uicontrol('Parent',lafig, ...
            'Position',[30 230 150 40], 'visible',nsuc,...
            'String','Nbre d´integrales successives voulues:', ...
            'HorizontalAlignment','Center','Style','text');
    uicontrol('Parent',lafig,'tag','EdSucc', ...
            'style', 'edit', 'visible',nsuc,...
            'position', [185 230 40 20], ...
            'string', '1');
    uicontrol('Parent',lafig, ...
            'Position',[20 180 100 20], ...
            'String','Separateur:', ...
            'Style','text');
    uicontrol('Parent',lafig,'tag','Separatiss', ...
            'Position',[125 175 100 25], 'String',separa, ...
            'Style','popupmenu', 'Value',1);
    uicontrol('Parent',lafig,'tag','AirNorm', ...
          'Style','checkbox','visible',noor,...
          'position', [25 120 250 20], ...
          'string','Avoir en plus la valeur de l`aire',...
          'Value',0);
    uicontrol('Parent',lafig, 'visible',noor,...
          'String','normalisée par rapport au temp.', ...
          'Position',[25 80 250 35], 'Style','text');
    uicontrol('Parent',lafig, 'Callback','integSuc(''travail'')', ...
            'Position',[100 25 100 25], 'String','au travail');
    set(lafig,'WindowStyle','modal');
  %-------------
  case 'travail'
  	%
  	% si la fenêtre d'intégration comprend 117 échantillonss et que l'on veuille 10 intervales,
  	% ça veut dire 11 échantillons par intégration. les 7 dernier seront négligés.
  	%
  	ptchnl =Ofich.Ptchnl;
  	catego =Ofich.Catego;
    canaux =get(findobj('tag','ChoixCan'),'Value')';
    nbcan =size(canaux,1);
    Txtdeb =get(findobj('tag','EdDebut'),'string');
    Txtfin =get(findobj('tag','EdFin'),'string');
    succ =str2num(get(findobj('tag','EdSucc'),'String'));
    airnorm =get(findobj('tag','AirNorm'),'value');
    airen =zeros(succ,nbcan,vg.ess);
    valutil(succ,nbcan,vg.ess) =0;
    [nomfich,lieu] =uiputfile('*.*','Integration');
    pcourant =pwd;
    stimu =['Catégorie'];
    saut =[char(13), char(10)];
    sep =[',' ';' char(9)];
    tab =sep(get(findobj('tag','Separatiss'),'Value'));
    nom_ess =vg.lesess;
    %___________________________________________________________________________
    % Préparation pour la ligne de titre
    %---------------------------------------------------------------------------
    if airnorm
      air =['Aire1---' tab 'Aire1-Normalisé'];
    else
      air =['Aire1---'];
    end
    for n =2:succ
      if airnorm
        air =[air tab 'Aire' num2str(n) '---' tab 'Aire' num2str(n) '-Normalisé'];
      else
        air =[air tab 'Aire' num2str(n) '---'];
      end
    end
    air =[air tab 'Delta t'];
    deltat =zeros(nbcan,vg.ess);
    dtchnl =CDtchnl();
    for ncan=1:nbcan
      Ofich.getcanal(dtchnl, canaux(ncan));
      N =dtchnl.Nom;
      for j = 1:vg.ess
        fs = hdchnl.rate(canaux(ncan),j);
        tdeb =ptchnl.valeurDePoint(Txtdeb,canaux(ncan),j);
        tfin =ptchnl.valeurDePoint(Txtfin,canaux(ncan),j);
        if isempty(tfin) || isempty(tdeb) || (tfin == 0) || (tdeb == 0)
        	continue
        end
        if tdeb > tfin
          tmpp =tdeb; tdeb=tfin; tfin =tmpp;
        end;
        twindow =floor((tfin-tdeb)/succ);
        tfin =tdeb+(twindow*succ);
        window =(tfin-tdeb)/fs/succ;
        a =tdeb;
        aa =a/fs;
        b =a+twindow;
        bb =aa+window;
        periode =1/fs;
        X =[aa:periode:bb];
        deltat(ncan,j) =(tfin - tdeb)/fs/succ;         % en s.
        for n =1:succ
          valutil(n,ncan,j) =trapz(X,dtchnl.Dato.(N)(a:b,j));
          airen(n,ncan,j) =(valutil(n,ncan,j)/window);
          X =X+twindow;
          a =a+twindow;
          b =b+twindow;
        end
      end
    end
    contenu =['Essai' tab stimu];
    for dd =1:nbcan
      contenu =[contenu tab 'Canal' tab air];
    end
    for j =1:vg.ess
    	mot =nom_ess{j};
    	if vg.niveau > 0 && vg.defniv <= vg.niveau
    	  stimu =catego.getNomCatego(vg.defniv, j);
    	elseif ~isempty(vg.nomstim) && length(vg.nomstim) >= hdchnl.numstim(j)
        stimu =vg.nomstim{hdchnl.numstim(j)};
      else
        stimu =[];
      end
      contenu =[contenu saut num2str(j) tab stimu];
      for ncan =1:nbcan
        cana =deblank(hdchnl.adname{canaux(ncan)});
        contenu =[contenu tab cana];
        for k =1:succ
          contenu =[contenu tab num2str(valutil(k,ncan,j))];
          if airnorm
            contenu =[contenu tab num2str(airen(k,ncan,j))];
          end
        end
        contenu = [contenu tab num2str(deltat(ncan,j))];
      end
    end
    cd(lieu);
    fid =fopen(nomfich, 'w');
    fprintf(fid, '%s', contenu);
    pause(0.4);
    fclose(fid);
    lafig =findobj('tag','FintSucc');
    delete(lafig);		
    delete(dtchnl);									   		%
    cd(pcourant);
  %------------
  case 'fermer'																%qd on abandonne
    lafig =findobj('tag','FintSucc');
    delete(lafig);														%arrete et efface
  %--
  end																					
end
