%
% Classe qui regrouppe toutes les variables utiles
% pour marquer lorsque l'on appuie sur "Au travail"
%
% METHODS
%            checkAGLR(tO, Ofich, val)
%            checkCUSUM(tO, Ofich, val)
%         t =CMarkVarCalcul(fich)           % CONSTRUCTOR
%            initialise(t)
%      smpl =debutDescente(tO, s, deltaT, dt, espp2, ess)
%         V =debutFinDescente(tO, lesmpl, ledeltaT, ledt, lespp2, less, dernier)
%         V =debutFinMonte(tO, lesmpl, ledeltaT, ledt, ptdbt, less, ptfin)
%      smpl =debutMonte(tO, smp, deltaT, dt, debut, ess)
%      smpl =finDescente(tO, s, deltaT, dt, espp2, ess, dernier)
%      smpl =finMonte(tO, smp, deltaT, dt, debut, ess, dernier)
%        OK =testDeltaY(tO, s, hdt, ess, esp, DY)
%
%
classdef CMarkVarCalcul < handle

  properties
    hdchnl =[];
    ptchnl =[];
    dt =[];
    alltri =1;
    ampRef =0;
    canExtra =1;
    cdst =1;
    copieVers =1;
    csrc =1;
    dbtdsc =0;               % début desc.
    dbtmnt =0;               % début montée
    delai =0;
    deltaX =0;               % Delta X
    deltaY =0;
    deltaT =0;               % Delta T
    derive =0;               % dérive, drift (CUSUM)
    direction =true;
    EcraseVers =1;
    findsc =0;               % fin desc.
    finmnt =0;               % fin montée
    fonc =[];                % pointeur de fonction
    gmns =1;                 % on marque les g-  (CUSUM)
    gpls =1;                 % on marque les g+  (CUSUM)
    int =0;
    laFin =0;
    leDebut =0;
    leMax =0;
    leMin =0;
    lpts =1;                 % points à copier
    nombre =[];              % nb de canaux source à utiliser
    nombres =[];             % nb d'essai à utiliser
    occur =1;
    occurence =[];
    p2p =0;
    pCent =1;
    ptbidon =1;
    remplace =false;
    reptout =false;
    seuil =1;                % seuil, threshold (CUSUM)
    tmp =0;
    varh =0;                 % param calcul Emg onset
    varl =0;                 % param calcul Emg onset
    vard =0;                 % param calcul Emg onset
  end

  methods

    %-------------------------------------------
    % CONSTRUCTOR
    % en entrée on veut un objet CFichierAnalyse
    %-------------------------------
    function t =CMarkVarCalcul(fich)
      t.hdchnl =fich.Hdchnl;
      t.ptchnl =fich.Ptchnl;
      t.dt =CDtchnl();
    end

    %---------------------------------------
    % Initialisation de certaines propriétés
    %---------------------
    function initialise(t)
      t.nombre =length(t.csrc);                % Nombre de canaux sélectionnés
      t.nombres =length(t.alltri);             % Nombre d'essais sélectionnés
      if (t.deltaT == 0) || isempty(t.deltaT)
        t.deltaT =3;
      end
      if t.reptout
        t.occurence =1;
      else
        t.occurence =t.occur;
      end
    end

    %-------------------------------------------------
    % On a trouvé une montée, on finalise la recherche
    % pour trouvé le début et/ou la fin
    % PARAM
    %         tO  thisObject, pointeur sur l'objet courant
    %     lesmpl  l'index du point réputé être dans une montée
    %   ledeltaT  nombre de sample toléré pour s'assurer que la montée/desc.
    %             est bien fini.
    %       ledt  pointeur sur les datas du canal à travailler
    %      ptdbt  indice du début de l'espace de travail
    %       less  essai sur lequel on travaille
    %      ptfin  indice du dernier sample de l'espace de travail
    %------------------------------------------------------------------------
    function V =debutFinMonte(tO, lesmpl, ledeltaT, ledt, ptdbt, less, ptfin)
      V =[0.0 0.0];
      V(1) =tO.debutMonte(lesmpl, ledeltaT, ledt, ptdbt, less);
      V(2) =tO.finMonte(lesmpl, ledeltaT, ledt, ptdbt, less, ptfin);
    end

    %--------------------------------------------------
    % Ici on recule dans les datas jusqu'à ce que ça ne
    % descende plus sur une longueur de deltaT
    % PARAM
    %         tO  thisObject, pointeur sur l'objet courant
    %        smp  l'index du point réputé être dans une montée
    %     deltaT  nombre de sample toléré pour s'assurer que le début de la
    %             montée est bien atteint.
    %         dt  pointeur sur les datas du canal à travailler
    %      debut  indice du début de l'espace de travail
    %        ess  essai sur lequel on travaille
    %---------------------------------------------------------
    function smpl =debutMonte(tO, smp, deltaT, dt, debut, ess)
      smpl =smp;
      otro =1;
      while (debut+smpl-otro > 0) & (otro < deltaT)
        %
        % Si le sample précédent est plus petit
        if dt.Dato.(dt.Nom)(debut+smpl, tO.alltri(ess)) > dt.Dato.(dt.Nom)(debut+smpl-otro, tO.alltri(ess))
          %
          % on recule
          smpl =smpl-1;
        else
          %
          % On va voir "1 échantillon" plus avant
          otro =otro+1;
          %
          % on reboucle en faisant attention
          % de ne pas être sous zéro
          while (debut+smpl-otro > 0)
            %
            % Double condition, a t-on dépassé la limite?  ET
            % est-ce que le sample précédent est plus grand ou égal
            if (otro < deltaT) && (dt.Dato.(dt.Nom)(debut+smpl, tO.alltri(ess)) <= ...
                                  dt.Dato.(dt.Nom)(debut+smpl-otro, tO.alltri(ess)))
              %
              % Oui alors on va voir "1 échantillon" plus avant
              otro =otro+1;
            %
            % Non, a t-on dépassé la limite?
            elseif (otro < deltaT)
              %
              %  la limite n'étant pas dépassé, on ré-initialise l'index cherché
              smpl =smpl-otro;
              otro =1;
            %
            %  Autrement, on sort de cette boucle
            else
              break;
            end
          end
        end
      end
    end

    %----------------------------------------------
    % Ici on avance dans les datas jusqu'à ce ça ne
    % monte plus sur une longueur de deltaT
    % PARAM
    %         tO  thisObject, pointeur sur l'objet courant
    %        smp  l'index du point réputé être dans une montée
    %     deltaT  nombre de sample toléré pour s'assurer que la fin de lamontée
    %             est bien atteinte.
    %         dt  pointeur sur les datas du canal à travailler
    %      debut  indice du début de l'espace de travail
    %        ess  essai sur lequel on travaille
    %    dernier  indice du dernier sample de l'espace de travail
    %----------------------------------------------------------------
    function smpl =finMonte(tO, smp, deltaT, dt, debut, ess, dernier)
      smpl =smp;
      otro =1;
      while (smpl+debut+otro <= dernier) & (otro < deltaT)
        if dt.Dato.(dt.Nom)(debut+smpl+otro, tO.alltri(ess)) > ...
           dt.Dato.(dt.Nom)(debut+smpl, tO.alltri(ess))
          smpl =smpl+otro;
        else
          otro =otro+1;
          while (smpl+debut+otro <= dernier)
            if (otro < deltaT) && (dt.Dato.(dt.Nom)(debut+smpl+otro, tO.alltri(ess)) <= ...
                             dt.Dato.(dt.Nom)(debut+smpl, tO.alltri(ess)))
              otro =otro+1;
            elseif (otro < deltaT)
              smpl =smpl+otro;
              otro =1;
            else
              break;
            end
          end
        end
      end
    end

    %-------------------------------------------
    % On vérifie si la différence d'amplitude de
    % ces 2 points est supérieure à DY
    %------------------------------------------------
    function OK =testDeltaY(tO, s, hdt, ess, esp, DY)
      deb =hdt.Dato.(hdt.Nom)(esp+s(1), tO.alltri(ess));
      fin =hdt.Dato.(hdt.Nom)(esp+s(2), tO.alltri(ess));
      OK =abs(fin-deb) >= DY;
    end

    %---------------------------------------------------
    % On a trouvé une Descente, on finalise la recherche
    % pour trouvé le début et/ou la fin
    %------------------------------------------------------------------------------
    function V =debutFinDescente(tO, lesmpl, ledeltaT, ledt, lespp2, less, dernier)
      V =[];
      V(end+1) =tO.debutDescente(lesmpl, ledeltaT, ledt, lespp2, less);
      V(end+1) =tO.finDescente(lesmpl, ledeltaT, ledt, lespp2, less, dernier);
    end

    %----------------------------------------------
    % Ici on recule dans les datas jusqu'à ce ça ne
    % descende plus pour une longueur de deltaT
    %----------------------------------------------------------
    function smpl =debutDescente(tO, s, deltaT, dt, espp2, ess)
      smpl =s;
      otro =1;
      while (smpl-otro > 0) & (otro < deltaT)
        if dt.Dato.(dt.Nom)(espp2+smpl,tO.alltri(ess)) < ...
           dt.Dato.(dt.Nom)(espp2+smpl-otro,tO.alltri(ess))
          smpl =smpl-1;
        else
          otro =otro+1;
          while (smpl-otro > 0)
            if (otro < deltaT) && (dt.Dato.(dt.Nom)(espp2+smpl,tO.alltri(ess)) >= ...
                             dt.Dato.(dt.Nom)(espp2+smpl-otro,tO.alltri(ess)))
              otro =otro+1;
            elseif (otro < deltaT)
              smpl =smpl-otro;
              otro =1;
            else
              break;
            end
          end
        end
      end
    end                                       

    %----------------------------------------------
    % Ici on avance dans les datas jusqu'à ce ça ne
    % montee plus pour une longueur de deltaT
    %-----------------------------------------------------------------
    function smpl =finDescente(tO, s, deltaT, dt, espp2, ess, dernier)
      smpl =s;
      otro =1;
      while (smpl+otro < dernier) & (otro < deltaT)
        if dt.Dato.(dt.Nom)(espp2+smpl+otro,tO.alltri(ess)) < ...
           dt.Dato.(dt.Nom)(espp2+smpl,tO.alltri(ess))
          smpl =smpl+1;
        else
          otro =otro+1;
          while (smpl+otro < dernier)
            if (otro < deltaT) && (dt.Dato.(dt.Nom)(espp2+smpl+otro,tO.alltri(ess)) >= ...
                             dt.Dato.(dt.Nom)(espp2+smpl,tO.alltri(ess)))
              otro =otro+1;
            elseif (otro < deltaT)
              smpl =smpl+otro;
              otro =1;
            else
              break;
            end
          end
        end
      end
    end

    %-------------------------------------------------------------
    % Pour les détails de cette fonction, voir le package de mfile
    % du groupe de gerhard.staude.
    % Ici on va faire les calculs sur la premier canal/essai
    % et on va afficher le résultat superposé au courbe originale.
    %---------------------------------
    function checkAGLR(tO, Ofich, val)
      hd =tO.hdchnl;
      pt =tO.ptchnl;
      dt =tO.dt;
      % on va utiliser les datas du premier canal sélectionné
      K =1;
     	Ofich.getcanal(dt, tO.csrc(K));
     	% calcul des bornes de travail début et fin.
      smplmax =pt.valeurDePoint(tO.laFin,tO.csrc(K),tO.alltri);
      if smplmax == 1
        smplmax =hd.nsmpls(tO.csrc(K),tO.alltri);
      end
      debut =pt.valeurDePoint(tO.leDebut,tO.csrc(K),tO.alltri);
      if (isempty(debut) || isempty(smplmax) || debut == 0 || smplmax < 2)
        return;
      end
      %_________________________________
      % lecture des datas à travailler
      %---------------------------------
      datos =dt.Dato.(dt.Nom)(debut:smplmax, tO.alltri);
      % lance le travail
      [chtimes, ampl]=detectemg(datos, tO);

      % préparation de l'affichage
      % les datas nous arrive dans
      %   chtimes: nous donne chaque changement "d'état" en commençant par 1
      %   ampl:    nous donne le niveau correspondant
      %   donc de chtimes(u:u+1) l'amplitude est ampl(u)
      chtimes(end+1) =length(datos);
      fract =max(ampl)-1;
      ampl =(ampl-1)*max(datos)/fract;
      for U =1:length(ampl)
        datos(chtimes(U):chtimes(U+1)) =ampl(U);
      end
      lerate =hd.rate(tO.csrc(K),tO.alltri);
      temps =([debut:smplmax]/lerate)+hd.frontcut(tO.csrc(K),tO.alltri);
      hold on;
      plot(temps, datos, 'r');
    end

    %--------------------------------------------------------------------------------------
    % http://nbviewer.ipython.org/github/demotu/BMC/blob/master/notebooks/DetectCUSUM.ipynb
    % affichage des CUSUM g+ et g-
    %----------------------------------
    function checkCUSUM(tO, Ofich, val)
      hd =tO.hdchnl;
      pt =tO.ptchnl;
      dt =tO.dt;
      ii =1;
     	Ofich.getcanal(dt, tO.csrc(ii));
      smplmax =pt.valeurDePoint(tO.laFin,tO.csrc(ii),tO.alltri);
      if smplmax == 1
        smplmax =hd.nsmpls(tO.csrc(ii),tO.alltri);
      end
      debut =pt.valeurDePoint(tO.leDebut,tO.csrc(ii),tO.alltri);
      if (isempty(debut) || isempty(smplmax) || debut == 0 || smplmax < 2)
        return;
      end
      %_________________________________
      % lecture des datas à travailler
      %---------------------------------
      datos =dt.Dato.(dt.Nom)(debut:smplmax, tO.alltri);
      N =length(datos);
      dato =[0; diff(datos)];
      gpls =dato*0;
      gmns =gpls;
      for U =2:N
        gpls(U) =max(gpls(U-1)+dato(U)-tO.derive, 0);
        gmns(U) =max(gmns(U-1)-dato(U)-tO.derive, 0);
        if gpls(U) > tO.seuil | gmns(U) > tO.seuil
          gpls(U) =0;
          gmns(U) =0;
        end
      end
      lerate =hd.rate(tO.csrc(ii),tO.alltri);
      temps =([debut:smplmax]/lerate)+hd.frontcut(tO.csrc(ii),tO.alltri);
      hold on;
      if tO.gpls
        plot(temps, gpls, 'r');
      end
      if tO.gmns
        plot(temps, gmns, 'g');
      end
      gpls(:) =tO.seuil;
      plot(temps, gpls, 'k');
    end

  end % methods
end % classdef
