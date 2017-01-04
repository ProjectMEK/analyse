% 
% DialogBox pour demander les infos relatives à la différenciation
% puis on passe à l'action.
%
% Les calculs se font par la méthode des moindres carrés
% avec un polynome du troisième degré ou bien, par fit
% polynomial ou l'on spécifie l'ordre du polynome désiré
% ainsi que la fenêtre de travail.
%
% pour une courbe qui ne vari pas beaucoup, l'ordre trois
% suffit largement. Pour la fenêtre de travail, il n'y a
% rien de mieux que de faire quelques tests avant de
% procéder au traitement final.
%
function moindreCarre(varargin)
  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
    mh =guidata(findobj('Tag','FIG_MCARRE'));
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  switch(commande)
  %---------------
  case 'ouverture'
    vg.valeur =1;
    letype ={'Lissage','Première dérivé','Deuxième dérivé'};
    if vg.nad > 2;letop =vg.nad;else letop =vg.nad+1;end
    largfig =300; hautfig =470;
    largeur =largfig; hauteur =hautfig;
    lapos =positionfen('G','H',largfig,hautfig);
    fig =figure('Name','MENU MOINDRE', 'Position',lapos, 'Tag','FIG_MCARRE', ...
            'CloseRequestFcn','moindreCarre(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIControlunits','pixels',...
            'DefaultUIControlFontSize',12, 'Resize','off');
    % Choix entre {Lissage/Première Dérivé/Seconde Dérivé}
    mh.titre(1) =uicontrol('Parent',fig, 'Position',[25 435 250 25], ...
            'FontWeight','bold', 'Style','text', 'String','Ordre de la dérivé');
    mh.control(1) =uicontrol('Parent',fig, 'Position',[25 405 250 25], ...
            'String',letype, 'Style','popupmenu', 'Value',1);
    % Choix du canal à travailler
    mh.titre(2) =uicontrol('Parent',fig, 'Position',[25 365 250 25], ...
            'FontWeight','bold', 'String','Choix du/des canal/aux', 'Style','text');
    mh.control(2) =uicontrol('Parent',fig, 'Position',[50 200 200 160], ...
            'BackgroundColor',[1 1 1], 'String',hdchnl.Listadname, ...
            'Min',1, 'Max',letop, 'Style','listbox', 'Value',1);
    % Largeur de la fenêtre coulissante
    mh.titre(3) =uicontrol('Parent',fig, 'FontWeight','bold',...
            'Position',[35 100 165 20], 'String','Fenêtre de calcul', 'Style','text');
    mh.control(3) =uicontrol('Parent',fig, 'BackgroundColor',[1 1 1], 'Style','edit', ...
                   'Position',[200 100 50 20], 'String','21', 'Tag','EditText1', ...
                   'Callback',@checkFenCouliss, 'TooltipString','Entier impaire seulement');
    mh.titre(8) = uicontrol('Parent',fig, 'FontWeight','bold', 'Enable','off', ...
            'Position',[35 65 165 20], 'String','Ordre du polynôme', 'Style','text');
    mh.control(8) = uicontrol('Parent',fig, 'BackgroundColor',[1 1 1], 'Enable','off', ...
            'Position',[200 65 50 20], 'Style','edit', 'String','2', 'Tag','EditText1');
    mh.control(4) =uicontrol('Parent',fig, 'Position',[30 170 220 25], ...
            'FontSize',9, 'String','Placer le résultat dans le même canal',...
            'Style','checkbox', 'Value',0);
    mh.control(7) =uicontrol('Parent',fig, 'Position',[30 140 100 25], ...
            'Callback','moindreCarre(''voirpoly'')', 'FontSize',9, 'Tag','PolyOUPas', ...
            'String','Polynomial Fit', 'Style','checkbox', 'Value',0, ...
            'TooltipString','Par défaut, on utilisera un polynome du 3ième degré avec la méthode des moindres carrés');
    largeur =125; hauteur =20;
    posx =floor((largfig-largeur)/2); posy =35;
    mh.control(5) =uicontrol('Parent',fig, 'Position',[posx posy largeur hauteur],...
            'Callback','moindreCarre(''travail'')', 'String','Au travail');
    set(fig,'WindowStyle','modal');
    guidata(fig,mh);
  %--------------
  case 'voirpoly'
    foo =findobj('Tag','PolyOUPas');
    tmp =[mh.titre(8) mh.control(8)];
    if get(foo, 'Value')
      set(tmp, 'Enable','on');
    else
      set(tmp, 'Enable','off');
    end
  %-------------
  case 'travail'
    leWarn =warning();
    warning off;
    foo =get(findobj('Tag','PolyOUPas'),'Value'); % option du Polynomial Fit
    Vcan =get(mh.control(2),'Value');
    nouveau =abs(get(mh.control(4),'Value')-1);  % on écrase le canal source
    nombre =length(Vcan);
    fen =get(mh.control(3),'String');
    fenetre =str2num(fen);                  % Nb de point pour le lissage en chiffre
    rayon =floor(fenetre/2);                % et on s'assure que la fenêtre sera impaire
    afaire =get(mh.control(1),'Value');
    if nouveau
      hdchnl.duplic(Vcan);
      Ncan =vg.nad+1:vg.nad+nombre;
      vg.nad =vg.nad+nombre;
    else
      Ncan =Vcan;
    end
    hwb =laWaitbar(0, 'Calcul en cours, veuillez patienter', 'C', 'B', gcf);
    dtchnl =CDtchnl();
    Ndt =CDtchnl();
    if foo % Polynomial Fit
      polyor =get(mh.control(8),'String');
      polyordre =str2num(polyor);             % ordre du polynome
      vccom =num2str(afaire-1);
      p =1:polyordre+1; % ***** ajouté pour la compilation *****
      letout =nombre*vg.ess;
      for i =1:nombre
        Ofich.getcanal(dtchnl, Vcan(i));
        N =dtchnl.Nom;
        Ndt.Dato.N =zeros(size(dtchnl.Dato.(N)));
        for n =1:vg.ess
          if fenetre >= hdchnl.nsmpls(Vcan(i),n)
            disp(['L''essai ' num2str(n) '(canal ' num2str(Vcan(i)) ') est plus petit que la fenêtre de travail']);
            continue;
          end
          % interval de temps entre deux lecture (Période)
          bof =1/hdchnl.rate(Vcan(i),n);
          % vecteur du temps
          temps =(bof+hdchnl.frontcut(Vcan(i),n):bof:(hdchnl.nsmpls(Vcan(i),n)/hdchnl.rate(Vcan(i),1))+hdchnl.frontcut(Vcan(i),n))';
          lerange =0:fenetre-1;
          for k =rayon+1:hdchnl.nsmpls(Vcan(i),n)-rayon
            lerange(:) =lerange+1;
            p(:) =polyfit(temps(lerange,1),dtchnl.Dato.(N)(lerange,n),polyordre);
            if afaire == 1
              Ndt.Dato.N(k,n) =polyval(p,temps(k,1));
            elseif afaire == 2
%              %
%              % pour accélérer les calculs, on va l'écrire implicitement pour 1,2,3
%              % finalement ça donnait environ 1/3 sec de différence alors on va le garder en commentaire
%              %
%              if polyordre == 1
%                Ndt.Dato.N(k,n) =p(1);
%              elseif polyordre == 2
%                Ndt.Dato.N(k,n) =(p(1)*2*(temps(k,1)))+p(2);
%              elseif polyordre == 3
%                Ndt.Dato.N(k,n) =(p(1)*3*(temps(k,1))*(temps(k,1)))+(p(2)*2*(temps(k,1)))+p(3);
%              else
%
              for j =1:polyordre
                Ndt.Dato.N(k,n) =Ndt.Dato.N(k,n)+(p(j)*(polyordre+1-j)*(temps(k,1)^(polyordre-j)));
              end
%              end
            elseif afaire == 3
              for j =1:polyordre-1
                Ndt.Dato.N(k,n) =Ndt.Dato.N(k,n)+(p(j)*(polyordre+1-j)*(polyordre-j)*(temps(k,1)^(polyordre-1-j)));
              end
            end
          end  % for k=rayon...
          Ndt.Dato.N(1:rayon,n) =Ndt.Dato.N(rayon+1,n);
          Ndt.Dato.N(hdchnl.nsmpls(Vcan(i),n)-rayon+1:hdchnl.nsmpls(Vcan(i),n),n) =Ndt.Dato.N(hdchnl.nsmpls(Vcan(i),n)-rayon,n);
          hdhcnl.max(Ncan(i),n) =max(Ndt.Dato.N(1:hdchnl.nsmpls(Vcan(i),n),n));
          hdhcnl.min(Ncan(i),n) =min(Ndt.Dato.N(1:hdchnl.nsmpls(Vcan(i),n),n));
          waitbar((((i-1)*nombre)+n)/letout, hwb);
        end  % for n =1:vg.ess
        Ofich.setcanal(Ndt, Ncan(i));
        Ndt.MaZdato();
      end  % for i =1:nombre
      if nouveau
        for i =1:nombre
          hdchnl.adname{Ncan(i)} =['PD' vccom '.' deblank(hdchnl.adname{Ncan(i)})];
       	  for j =1:vg.ess
            vc =['PD' vccom '.' hdchnl.comment{Ncan(i), j} ' Polynom.Fit,Ord= ' polyor ', Fen=' fen '//'];
            hdchnl.comment{Ncan(i), j} =vc;
       	  end
        end
      else
        for i =1:nombre
          for j=1:vg.ess
            vc = ['PD' vccom '.' hdchnl.comment{Vcan(i), j} ' Polynom.Fit,Ord= ' polyor ', Fen=' fen '//'];
            hdchnl.comment{Vcan(i), j} =vc;
          end
        end
      end
    %----------------------
    % pas de Polynomial Fit
    %
    % Ça y est, j'ai trouvé quelques papiers griffoné. Il s'agit de la méthode des
    % moindres carrés avec un polynôme d'ordre 3.
    % réf.: "Smoothing and differentiation of Data by simplified Least Square Procedures"
    %       Abraham Savitzki and Marcel J. E. Golay
    % **ATTENTION, il y a beaucoup de "coquilles" dans l'article original. Autant dans les
    %              équations que dans les tableaux présentés.
    %
    % voir aussi --> http://robert.mellet.pagesperso-orange.fr/rgrs_pol/regrs_01.htm
    %
    %---
    else
      % Les choix étant 1=Lissage, 2=1ère Dérivé, 3=2ième Dérivé
      % l'ordre de la "dérivé" est donc le choix moins un.
      ordre =afaire-1;
      %
      % Les paramètres "S"
      % comme ils sont nulles pour des valeurs impaires
      % on va calculer seulement les valeurs paires.
      % Lorsque l'on travaille avec un polynome de 3ième degré,
      % seul les valeurs S0, S2, S4 et S6 sont utiles.
      % La variable Si contiendra: [S0 S2 S4 S6]
      % soit, Si(1) = S0 etc...
      %
      for i =1:4
        Si(i) =gen_s((i-1)*2,fenetre);
      end
      lamat =gen_coef(ordre,fenetre,Si);
      vecteur =ones(fenetre,vg.ess);
      for j =1:vg.ess
        vecteur(:,j) =lamat;
      end
      aaa =ones(rayon,1);
      aubout =nombre*vg.ess;
      for i =1:nombre
        Ofich.getcanal(dtchnl, Vcan(i));
        N =dtchnl.Nom;
        Ndt.Dato.N =zeros(size(dtchnl.Dato.(N)));
        if nouveau
          hdchnl.adname{Ncan(i)} =['LS' num2str(ordre) '.' deblank(hdchnl.adname{Ncan(i)})];
        end
        %------------------------------------------------------
        % Si tous les essais ont le même nombre d'échantillons,
        % on les traite en même temps.
        %----------------------------------------------------------------
        if min(hdchnl.nsmpls(Ncan(i),:)) == max(hdchnl.nsmpls(Ncan(i),:))
          lemoins =hdchnl.nsmpls(Ncan(i),1);
          norm =denomi(ordre,hdchnl.rate(Ncan(i),1),Si);
          for mu =rayon+1:lemoins-rayon
          	waitbar(mu/lemoins, hwb);
            Ndt.Dato.N(mu,:) =sum(vecteur.*dtchnl.Dato.(N)(mu-rayon:mu+rayon,:))/norm;
          end
          for j =1:vg.ess
            Ndt.Dato.N(1:rayon,j) =aaa.*Ndt.Dato.N(rayon+1,j);
            Ndt.Dato.N(lemoins-rayon+1:lemoins,j) =aaa.*Ndt.Dato.N(lemoins-rayon,j);
            vc = [hdchnl.comment{Ncan(i), j} ' ,LeastSqare,Ord=' num2str(ordre) ', Fen=' fen '//'];
            hdchnl.comment{Ncan(i), j} =vc;
            hdhcnl.max(Ncan(i),j) =max(Ndt.Dato.N(1:lemoins,j));
            hdhcnl.min(Ncan(i),j) =min(Ndt.Dato.N(1:lemoins,j));
    	    end
        else
          for j =1:vg.ess
          	waitbar(((i-1)*nombre+j)/aubout, hwb);
          	try
              lemoins =hdchnl.nsmpls(Ncan(i),j);
              norm =denomi(ordre,hdchnl.rate(Ncan(i),j),Si);
              for mu =rayon+1:lemoins-rayon
                Ndt.Dato.N(mu,j) =sum(vecteur(:,j).*dtchnl.Dato.(N)(mu-rayon:mu+rayon,j))/norm;
              end
              Ndt.Dato.N(1:rayon,j) =aaa.*Ndt.Dato.N(rayon+1,j);
              Ndt.Dato.N(lemoins-rayon+1:lemoins,j) =aaa.*Ndt.Dato.N(lemoins-rayon,j);
              vc = [hdchnl.comment{Ncan(i), j} ' ,LeastSqare,Ord=' num2str(ordre) ', Fen=' fen '//'];
              hdchnl.comment{Ncan(i), j} =vc;
              hdhcnl.max(Ncan(i),j) =max(Ndt.Dato.N(1:lemoins,j));
              hdhcnl.min(Ncan(i),j) =min(Ndt.Dato.N(1:lemoins,j));
            catch auvol
              disp(['Erreur, canal: ' num2str(Vcan(i)) ' essai: ' num2str(j)]);
              disp(auvol.message);
            end
    	    end
      	end
      	Ofich.setcanal(Ndt, Ncan(i));
      	Ndt.MaZdato();
      end
    end  % if foo
    warning on;
    delete(hwb);
    delete(findobj('Tag','FIG_MCARRE'));
    delete(dtchnl);
    delete(Ndt);
    vg.sauve =1;
    vg.valeur =0;
    if nouveau
      gaglobal('editnom');
    else
      OA.OFig.affiche();
    end
    warning(leWarn);
  %----------
  case 'fermer'
    delete(findobj('Tag','FIG_MCARRE'));
    vg.valeur =0;
  end
end

%----------------------------------------------------
% Vérification de la valeur de la fenêtre coulissante
% on doit avoir un nombre impaire
%-----------------------------
function checkFenCouliss(src, varargin)
  T =get(src, 'String');
  V =str2num(T);
  % On commence par vérifier si la valeur entrée est numérique
  if isnumeric(V) & (V > 1)
    if mod(V,2) == 0
      V =V+1;
    end
  else
    V =21;
  end
  set(src, 'String',num2str(V));
end

%------------------------------
% fonction pour générer les "S"
%
%        +m
%        ---
%   S  = \    r
%    r   /   i
%        ---
%       i=-m
%
% ou r est l'ordre
%----------------------------------
function som =gen_s(ordre,lewindow)
  rayon =floor(lewindow/2);
  j =-rayon:rayon;
  som =sum(j.^ordre);
end

%
% On génère le numérateur du coefficient. Celui-ci sera multiplié par Yi
%
%     ordre --> ordre de la dérivé
%  lewindow --> largeur de la fenêtre de travail
%        Si --> [S0 S2 S4 S6]
%
function lasomme =gen_coef(ordre,lewindow,Si)
  rayon =floor(lewindow/2);
  lasomme(lewindow) =0;
  switch(ordre)
  case 0
    for i =-rayon:rayon
      lasomme(i+rayon+1) =Si(3)-((i^2)*Si(2));
    end
  case 1
    for i =-rayon:rayon
      lasomme(i+rayon+1) =(i*Si(4))-((i^3)*Si(3));
    end
  case 2
    for i =-rayon:rayon
      lasomme(i+rayon+1) =((i^2)*Si(1))-Si(2);
    end
  case 3
    for i =-rayon:rayon
      lasomme(i+rayon+1) =((i^3)*Si(2))-(i*Si(3));
    end
  end
end

%
% On génère le dénominateur du coefficient.
%
% ordre --> ordre de la dérivé
%  rate --> fréquence d'échantillonage
%    Si --> [S0 S2 S4 S6]
%
function fraction =denomi(ordre,rate,Si)
  facto =factorial(ordre)*(rate^ordre);
  switch(ordre)
  case {0,2}
    fraction =(Si(1)*Si(3))-(Si(2)^2);
  case {1,3}
    fraction =(Si(2)*Si(4))-(Si(3)^2);
  end
  fraction =fraction/facto;
end

%
% Comme nous travaillons avec un polynome d'ordre 3, on aura 4 coefficients b à déterminer.
% Les variables S0, S2, S4 et S6 sont calculées par la fonction "gen_s" et sont gardées dans
% la variable "Si".
% "i" est l'indice pour se déplacer dans notre fenêtre de travail entre -m et +m.
% "Yi" est le i-ème échantillon du canal à traiter dans notre fenêtre de travail.
%
%        +m
%       ----
%       \           2
%        \   (S4 - i S2) Yi
%  b0  = /  -----------------
%       /                2
%      /      (S0 S4 - S2 )
%      -----
%       i=-m
%
%
%        +m
%       ----
%       \             3
%        \   (i S6 - i S4) Yi
%  b1  = /  -----------------
%       /                2
%      /      (S2 S6 - S4 )
%      -----
%       i=-m
%
%
%        +m
%       ----
%       \      2
%        \   (i S0 - S2) Yi
%  b2  = /  -----------------
%       /                2
%      /      (S0 S4 - S2 )
%      -----
%       i=-m
%
%
%        +m
%       ----
%       \      3
%        \   (i S2 - i S4) Yi
%  b3  = /  -----------------
%       /                2
%      /      (S2 S6 - S4 )
%      -----
%       i=-m
%
%
% La solution finale sera donnée par
%
%  ---     ---
% |   s       |
% |  d F(x)   |      s! bs
% | --------  | =  ---------
% |     s     |        s
% |  d x      |       T
% |           |
%  ---     --- (x=0)
% 
%    ou s est l'ordre de la dérivé
%       T la période entre deux échantillons (l'inverse de la fréquence d'échantillonage)
%
