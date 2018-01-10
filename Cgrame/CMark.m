%
% classdef (Sealed)  CMark < CMarkGui
%                    Classe SINGLETON   -->  obj = CMark.getInstance()
%
% METHODS (Access =private)
%        tO =CMark            % CONSTRUCTOR
% METHODS (Static)
%      sObj =getInstance
% METHODS
%         lesPt =copieVersExtra(tO, hdchnl, ptchnl, val, can, ess, lesPt, tmps, debut)
%             v =cualEsBueno(tO, dat, hdchnl, val, can, ess, laRef, dbt, fin)
%                fncPanelAmplitude(tO, Ofich, val)
%                fncPanelBidon(tO, Ofich, val)
%                fncPanelCUSUM(obj, Ofich, val)
%                fncPanelExport(obj, Ofich, v)
%                fncPanelMinMax(tO, Ofich, val)
%                fncPanelMontee(obj, Ofich, val)
%                fncPanelTemporel(tO, Ofich, val)
%                fncPanelEmg(tO, Ofich, val)
%          ampl =getValeurDePoint(tO, dat, ptchnl, txtRef, can, ess, dbi, fni)
%                supppts(obj,OA)
%                travail(tO, varargin)
%     [t, inc] = validInterval(tO, ptchnl, debut, fin, txtr, txti, can, ess)
%  [va, vb, vc] =validTempsPoint(tO, ptchnl, debut, fin, ref, canal, essai)
%
% FONCTIONs À l'EXTÉRIEUREs DE LA CLASSE
%             V =trouveLesMontants(dato, vref, tsmpl)
%             V =trouveLesDescentes(dato, vref, tsmpl)
%
%
%    *********************************************************
%    * QUE FAIT-ON AVEC LES CAN/ESS QUI N'ONT RIEN À MARQUER *
%    * EX. ON MARQUE LE DÉBUT DE MONTÉ ET LE 3ième ESSAI N'A *
%    *     PAS DE MONTÉ, ??ce sera un point bidon? ou ...?   *
%    *                                                       *
%    * on pourrait y remédier via les préférences???         *
%    *********************************************************
%
classdef (Sealed)  CMark < CMarkGui

  methods (Access =private)

    %--------------------
    % CONSTRUCTOR
    %--------------------
    function tO = CMark()
      texto =GuiMark(tO);
      tO.initGui(texto);
      delete(texto);
    end

  end  % methods (Access =private)

  methods (Static)

    %-------------------------------------------------------
    % La seule manière de créer une instance de cette classe
    % est d'appeler la fonction CMark.getInstance(). Elle contrôlera
    % aussi le nombre d'instance en circulation (une seule).
    %-------------------------
    function sObj =getInstance
      persistent localObjM;
      if isempty(localObjM) || ~isvalid(localObjM)
        localObjM = CMark();
      else
      	OA =CAnalyse.getInstance();
        localObjM.majGui(OA);
        OA.OFig.affiche();
      end
      localObjM.afficheStatus();
      sObj =localObjM;
    end  %function
  end  %methods (Static)

  methods

    %-----------------------------------------
    % exécute le choix de marquage sélectionné
    %-----------------------------
    function travail(tO, varargin)
      try
        tO.afficheStatus(tO.potravmaw);
        OA =CAnalyse.getInstance();
        curFich =OA.findcurfich();
        s =tO.lirVarOnglet(curFich);
        tO.(s.fonc)(curFich, s);
        tO.afficheStatus(tO.potravafflon);
        delete(s);
        curFich.Vg.sauve =1;
        tO.listSetPoint(OA);
        set(findobj('Tag','LBCanalExportPt'),'value',0);
        set(findobj('Tag','LBCanalExportRemplace'),'value',0);
        OA.OFig.affiche();
        tO.afficheStatus();
      catch lalune
        parleMoiDe(lalune);
        tO.afficheStatus(lalune.message);
      end
    end

    %------------------------------------
    % SUPPRESSION DES POINTS SÉLECTIONNÉS
    %-----------------------
    function supppts(obj,OA)
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      ptchnl =Ofich.Ptchnl;
      vg =Ofich.Vg;
      oncache =get(findobj('Tag','CBcacherPts'), 'Value');
      alltri =obj.wmh.allTri;
      nombre =length(obj.wmh.canSrc);
      nombres =length(alltri);
      deltous =get(findobj('Tag','CBtodosPuntos'),'Value');
      delpts =str2num(get(findobj('Tag','EnumPts'), 'String'));
      %_______________
      % Tous est coché
      if deltous
        for ii =1:nombre
          for jj =1:nombres
            if oncache
              ptchnl.Dato(:,hdchnl.point(obj.wmh.canSrc(ii),alltri(jj)),2) =-1;
            else
              hdchnl.npoints(obj.wmh.canSrc(ii),alltri(jj)) =0;
              hdchnl.point(obj.wmh.canSrc(ii),alltri(jj)) =0;
            end
          end
        end
        set(findobj('Tag','CBtodosPuntos'), 'Value',0);
      %__________________________________________________________
      % Tous n'est pas coché, mais on a inscrit des points à supp
      elseif length(delpts)
        for k =1:nombre
          for jj =1:nombres
            for ii =length(delpts):-1:1
              if hdchnl.npoints(obj.wmh.canSrc(k),alltri(jj)) >= delpts(ii)
                if oncache
                  ptchnl.Dato(delpts(ii),hdchnl.point(obj.wmh.canSrc(k),alltri(jj)),2) =-1;
                else
                  hdchnl.npoints(obj.wmh.canSrc(k),alltri(jj)) =hdchnl.npoints(obj.wmh.canSrc(k),alltri(jj))-1;
                  ptchnl.Dato(delpts(ii):end-1,hdchnl.point(obj.wmh.canSrc(k),alltri(jj)),:) =ptchnl.Dato(delpts(ii)+1:end,hdchnl.point(obj.wmh.canSrc(k),alltri(jj)),:);
                  ptchnl.Dato(hdchnl.npoints(obj.wmh.canSrc(k),alltri(jj))+1,hdchnl.point(obj.wmh.canSrc(k),alltri(jj)),1) =0;
                end
              end
            end
          end
        end
        set(findobj('Tag','EnumPts'), 'String','')
      %___________________________________
      % On a sélectionné des points à supp
      else
        delpts =get(findobj('Tag','LBpts'),'Value');
        for k =1:nombre
          for jj =1:nombres
            for ii =length(delpts):-1:1
              if hdchnl.npoints(obj.wmh.canSrc(k),alltri(jj)) >= delpts(ii)
                if oncache
                  ptchnl.Dato(delpts(ii),hdchnl.point(obj.wmh.canSrc(k),alltri(jj)),2) =-1;
                else
                  hdchnl.npoints(obj.wmh.canSrc(k),alltri(jj)) =hdchnl.npoints(obj.wmh.canSrc(k),alltri(jj))-1;
                  ptchnl.Dato(delpts(ii):end-1,hdchnl.point(obj.wmh.canSrc(k),alltri(jj)),:) =ptchnl.Dato(delpts(ii)+1:end,hdchnl.point(obj.wmh.canSrc(k),alltri(jj)),:);
                  ptchnl.Dato(hdchnl.npoints(obj.wmh.canSrc(k),alltri(jj))+1,hdchnl.point(obj.wmh.canSrc(k),alltri(jj)),1) =0;
                end
              end
            end
          end
        end
      end
      vg.sauve =1;
    end

    %------------------------------------
    % gestion de l'exportation des points
    % v sera un objet de la classe CMarkVarCalcul
    % Ofich un objet de la classe CFichierAnalyse
    %-------------------------------------
    function fncPanelExport(obj, Ofich, v)
      hdchnl =v.hdchnl;
      ptchnl =v.ptchnl;
      np =length(v.lpts);
      ncd =length(v.cdst);
      %---------------------------------------
      % Primo, on regarde le cas ou on exporte
      % N canaux vers N canaux  (N>1)
      % canal source(i) vers canal destination(i)
      if v.p2p && (v.nombre == ncd)
        for ii =1:v.nombre
          for jj =1:np
            for kk =1:v.nombres
              if hdchnl.npoints(v.csrc(ii),v.alltri(kk)) >= v.lpts(jj)
                ecrit =v.lpts(jj)*v.remplace;
                if hdchnl.rate(v.csrc(ii),v.alltri(kk)) == hdchnl.rate(v.cdst(ii),v.alltri(kk))
                  ooo =ptchnl.Onmark(v.cdst(ii),v.alltri(kk),ecrit,ptchnl.Dato(v.lpts(jj),hdchnl.point(v.csrc(ii),v.alltri(kk)),1));
                else
                  smpl =double(ptchnl.Dato(v.lpts(jj),hdchnl.point(v.csrc(ii),v.alltri(kk)),1))/hdchnl.rate(v.csrc(ii),v.alltri(kk));
                  smpl =round(smpl*hdchnl.rate(v.cdst(ii),v.alltri(kk)));
                  ooo =ptchnl.Onmark(v.cdst(ii),v.alltri(kk),ecrit,smpl);
                end
                ptchnl.Dato(ooo,hdchnl.point(v.cdst(ii),v.alltri(kk)),2) =ptchnl.Dato(v.lpts(jj),hdchnl.point(v.csrc(ii),v.alltri(kk)),2);
              end
            end
          end
        end
      %-----------------------------------------
      % Puis, on regarde le cas ou on a Un canal
      % source vers N canaux destinations
      elseif v.nombre == 1
        for ii =1:ncd
          for jj =1:np
            for kk =1:v.nombres
              if hdchnl.npoints(v.csrc(1),v.alltri(kk)) >= v.lpts(jj)
                ecrit =v.lpts(jj)*v.remplace;
                if hdchnl.rate(v.csrc(1),v.alltri(kk)) == hdchnl.rate(v.cdst(ii),v.alltri(kk))
                  ooo =ptchnl.Onmark(v.cdst(ii),v.alltri(kk),ecrit,ptchnl.Dato(v.lpts(jj),hdchnl.point(v.csrc(1),v.alltri(kk)),1));
                else
                  smpl =double(ptchnl.Dato(v.lpts(jj),hdchnl.point(v.csrc(1),v.alltri(kk)),1))/hdchnl.rate(v.csrc(1),v.alltri(kk));
                  smpl =round(smpl*hdchnl.rate(v.cdst(ii),v.alltri(kk)));
                  ooo =ptchnl.Onmark(v.cdst(ii),v.alltri(kk),ecrit,smpl);
                end
                ptchnl.Dato(ooo,hdchnl.point(v.cdst(ii),v.alltri(kk)),2) =ptchnl.Dato(v.lpts(jj),hdchnl.point(v.csrc(1),v.alltri(kk)),2);
              end
            end
          end
        end
      else
        for ss =1:v.nombre
          for ii =1:ncd
            for jj =1:np
              for kk =1:v.nombres
                if hdchnl.npoints(v.csrc(ss),v.alltri(kk)) >= v.lpts(jj)
                  if hdchnl.rate(v.csrc(ss),v.alltri(kk)) == hdchnl.rate(v.cdst(ii),v.alltri(kk))
                    ooo =ptchnl.Onmark(v.cdst(ii),v.alltri(kk),0,ptchnl.Dato(v.lpts(jj),hdchnl.point(v.csrc(ss),v.alltri(kk)),1));
                  else
                    smpl =double(ptchnl.Dato(v.lpts(jj),hdchnl.point(v.csrc(ss),v.alltri(kk)),1))/hdchnl.rate(v.csrc(ss),v.alltri(kk));
                    smpl =round(smpl*hdchnl.rate(v.cdst(ii),v.alltri(kk)));
                    ooo =ptchnl.Onmark(v.cdst(ii),v.alltri(kk),0,smpl);
                  end
                  ptchnl.Dato(ooo,hdchnl.point(v.cdst(ii),v.alltri(kk)),2) =ptchnl.Dato(v.lpts(jj),hdchnl.point(v.csrc(ss),v.alltri(kk)),2);
                end
              end
            end
          end
        end
      end
    end

    %----------------------------------------------
    % On a des pt à marquer et on s'occupe de faire
    % les copies vers les canaux supplémentaires
    %
    % val sera un objet de la classe CMarkVarCalcul
    % can sera le canal à marquer
    % ess sera l'essai à marquer
    % lesPt seront les numéros de points à marquer
    % tmps sera le temps à marquer en fonction de l'interval choisi
    % debut sera le début de l'interval
    %------------------------------------------------------------------------------------
    function lesPt =copieVersExtra(tO, hdchnl, ptchnl, val, can, ess, lesPt, tmps, debut)
      if val.remplace && ~isempty(lesPt)
        lindiss =lesPt(1);
        lesPt(1) =[];
      else
        lindiss =0;
      end
      tmps =tmps+debut-1;
      expno =ptchnl.Onmark(val.csrc(can),val.alltri(ess),lindiss,tmps)*val.EcraseVers;
      if val.copieVers
        for uu =1:length(val.canExtra)
          if hdchnl.rate(val.csrc(can),val.alltri(ess)) ~= hdchnl.rate(val.canExtra(uu),val.alltri(ess))
            temps2 =tmps/hdchnl.rate(val.csrc(can),val.alltri(ess));
            temps2 =round(temps2*hdchnl.rate(val.canExtra(uu),val.alltri(ess)));
          else
            temps2 =tmps;
          end
          expno =ptchnl.Onmark(val.canExtra(uu),val.alltri(ess),expno,temps2);
        end
      end
    end

    %----------------------------------------------
    % LE POINT MAXIMUM ET/OU MINIMUM
    % val sera un objet de la classe CMarkVarCalcul
    % Ofich un objet de la classe CFichierAnalyse
    %----------------------------------------------
    function fncPanelMinMax(tO, Ofich, val)
      if ~(val.leMin || val.leMax)
        % on a pas sélectionné 'min' ou 'max'
        try
          me =MException('CMark:fncPanelMinMax', tO.potravchmnm);
          throw(me);
        catch ss;
          me =Oct_MException('CMark:fncPanelMinMax', tO.potravchmnm);
          rethrow(me);
        end
      end
      hdchnl =val.hdchnl;
      ptchnl =val.ptchnl;
      dt =val.dt;
      for ii =1:val.nombre  % on passe tous les canaux sélectionnés
      	Ofich.getcanal(dt, val.csrc(ii));
        for jj =1:val.nombres
          smplmax =ptchnl.valeurDePoint(val.laFin,val.csrc(ii),val.alltri(jj));
          if smplmax == 1
            smplmax =hdchnl.nsmpls(val.csrc(ii),val.alltri(jj));
          end
          esp2 =max(max(ptchnl.valeurDePoint(val.leDebut,val.csrc(ii),val.alltri(jj))), 1);
          indpt =val.lpts;
          if val.leMin
            [a,temps] =min(dt.Dato.(dt.Nom)(esp2:smplmax,val.alltri(jj)));
            indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, temps, esp2);
          end
          if val.leMax
            [a,temps] =max(dt.Dato.(dt.Nom)(esp2:smplmax,val.alltri(jj)));
            indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, temps, esp2);
          end
        end  % for jj =1:nombres
      end % for ii =1:nombre
    end

    %-------------------------------
    % DÉBUT/FIN DE (MONTÉE/DESCENTE)
    % Ajout du marquage récurrent. Afin de marquer toutes les montées...
    % En entrée on aura:  Ofich --> un objet de type CFichierAnalyse
    %                     val   --> un objet de type CMarkVarCalcul()
    %
    % À REVOIR: IF MONTÉ,    CALCUL_PEAK( X); END
    %           IF DESCENTE, CALCUL_PEAK(-X); END
    %
    %---------------------------------------
    function fncPanelMontee(tO, Ofich, val)
      if ~(val.dbtmnt || val.dbtdsc || val.finmnt || val.findsc)
        me =MException('Analyse:CMark:fncPanelMontee', tO.potravchmddm);
        throw(me);
      end
      hdchnl =val.hdchnl;
      ptchnl =val.ptchnl;
      dt =val.dt;
      deltaT =val.deltaT+1;
      %_______________________
      % barre de défilement
      %-----------------------
      totwb =val.nombre*val.nombres;
      numwb =0;
      lafrac =0.0;
      lept =0;
      lesmots =@(lecan,lesssai,lepoint) sprintf('%s, %s %i, essai %i, no.point %i', tO.potravchmontdesc, tO.potravcan,lecan, tO.potravess,lesssai, tO.potravnpt,lepoint);
      hWB =laWaitbar(lafrac, lesmots(0,0,0));
      %___________________________________________
      % On boucle autour des canaux sélectionnés
      %-------------------------------------------
      for ii =1:val.nombre
      	Ofich.getcanal(dt, val.csrc(ii));
        %_________________________________________
        % On boucle autour des essais sélectionnés
        %-----------------------------------------
        for jj =1:val.nombres
          numwb =numwb+1;
          lafrac =numwb/totwb;
          lept =0;
          waitbar(lafrac, hWB, lesmots(val.csrc(ii), val.alltri(jj),lept));
          smplmax =ptchnl.valeurDePoint(val.laFin,val.csrc(ii),val.alltri(jj));
          indpt =val.lpts;
          dbut =ptchnl.valeurDePoint(val.leDebut,val.csrc(ii),val.alltri(jj));
          if (isempty(dbut) || isempty(smplmax) || dbut == 0 || smplmax == 0)
            disp(tO.potravdfinterr);
            continue;
          end
          if smplmax == 1
            smplmax =hdchnl.nsmpls(val.csrc(ii),val.alltri(jj));
          end
          lerate =hdchnl.rate(val.csrc(ii),val.alltri(jj));
          deltaX =val.deltaX;
          if deltaX <= 0
            % On prend alors 1/4 sec
            deltaX =0.25;
          end
          deltaY =val.deltaY;
          if deltaY < 0
            %voir CMarkGui.lirVarPanelMontee(tO, s)
            % On prend alors le pourcentage de l'amplitude(max-min)
            deltaY =-(max(dt.Dato.(dt.Nom)(dbut:smplmax,val.alltri(jj)))-min(dt.Dato.(dt.Nom)(dbut:smplmax,val.alltri(jj))))*deltaY/100;
          end
          % valeur pour décrémenter le nb d'occurence à faire
          inc_occur =~val.reptout;
          %_________________________________________
          % vitesse moyenne dans l'intervalle deltaX
          deltaXsmpl =max(round(deltaX*lerate), 2);
          canVit =dt.Dato.(dt.Nom)(dbut:smplmax, val.alltri(jj));
          canVit(:) =[0; diff(canVit)];
          %__________________________
          % DÉBUT ET/OU FIN DE MONTÉE
          if val.dbtmnt | val.finmnt
            decremente =false;
            nb_occur =val.occurence;
            %POUR NE PAS RECALCULER TEST2 INUTILEMENT
            t2_fait =false;
            foo =trouveLesMontants(canVit, deltaY, deltaXsmpl);
            while ~isempty(foo) & nb_occur > 0
              smpl =foo(1);
              espp2 =dbut-1;
              %_________________________________________________________________
              % On s'assure que les montées trouvées ne sont pas les mêmes.
              % Car dans certains cas, ils peuvent être distantes de
              % seulement quelques smpl.
              % test1  contiendra les index (début, fin) de la montée
              % test2  sera comme test1 mais pour le point suivant
              %        puis, on compare test1 avec test2
              %-----------------------------------------------------------------
              if t2_fait
                test1 =test2;
              else
                test1 =val.debutFinMonte(smpl, deltaT, dt, espp2, jj, smplmax);
              end
              while length(foo) > 1
                decremente =false;
                if test1(2) > foo(2)
                  %LA FIN DE LA MONTÉE EST PLUS GRANDE QUE L'INDEX DE LA PENTE "SUIVANTE"
                  foo(2) =[];
                  continue;
                end
                %ON CALCUL DÉBUT/FIN DE LA PENTE "SUIVANTE"
                test2 =val.debutFinMonte(foo(2), deltaT, dt, espp2, jj, smplmax);
                t2_fait =true;
                %ON COMPARE LES PARAM DES DEUX PENTES
                if (test1(1) == test2(1)) | (test1(2) == test2(2)) | (test1(2) >= test2(1))
                  test1(2) =max(test1(2), test2(2));
                  foo(2) =[];
                else
                  break;
                end
              end
              smpl =test1;
              if val.dbtmnt
                if (espp2+smpl(1) > 0) & val.testDeltaY(smpl, dt, jj, espp2, deltaY)
                  indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, smpl(1), dbut);
                  decremente =true;
                  lept =lept+1;
                  waitbar(lafrac, hWB, lesmots(val.csrc(ii), val.alltri(jj),lept));
                end
              end
              if val.finmnt
                if (smpl(2) > smpl(1)) & (smpl(2) <= smplmax) & val.testDeltaY(smpl, dt, jj, espp2, deltaY)
                  indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, smpl(2), dbut);
                  decremente =true;
                  lept =lept+1;
                  waitbar(lafrac, hWB, lesmots(val.csrc(ii), val.alltri(jj),lept));
                end
              end
              foo(1) =[];
              if decremente
                nb_occur =nb_occur-inc_occur;
              end
            end
          end
          %____________________________
          % DÉBUT ET/OU FIN DE DESCENTE
          if val.dbtdsc | val.findsc
            decremente =false;
            nb_occur =val.occurence;
            % POUR NE PAS RECALCULER TEST2 INUTILEMENT
            t2_fait =false;
            foo =trouveLesDescentes(canVit, deltaY, deltaXsmpl);
            while ~isempty(foo) & nb_occur > 0
              smpl =foo(1);
              espp2 =dbut-1;
              %_______________________________________________
              % On s'assure que les descentes trouvées ne sont
              % pas les mêmes (car ils peuvent être
              % distancées de seulement quelques smpl)
              %-----------------------------------------------
              if t2_fait
                %TEST2 EST DÉJÀ CLCULÉ
                test1 =test2;
              else
                test1 =val.debutFinDescente(smpl, deltaT, dt, espp2, jj, smplmax);
              end
              while length(foo) > 1
                decremente =false;
                if test1(2) > foo(2)
                  foo(2) =[];
                  continue;
                end
                test2 =val.debutFinDescente(foo(2), deltaT, dt, espp2, jj, smplmax);
                t2_fait =true;
                if (test1(1) == test2(1)) | (test1(2) == test2(2)) | (test1(2) >= test2(1))
                  test1(2) =max(test1(2), test2(2));
                  foo(2) =[];
                else
                  break;
                end
              end
              smpl =test1;
              if val.dbtdsc
                if (smpl(1) > 0) & val.testDeltaY(smpl, dt, jj, espp2, deltaY)
                  indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, smpl(1), dbut);
                  decremente =true;
                  lept =lept+1;
                  waitbar(lafrac, hWB, lesmots(val.csrc(ii), val.alltri(jj),lept));
                end
              end
              if val.findsc
                if (smpl(2) > smpl(1)) & (smpl(2) <= smplmax) & val.testDeltaY(smpl, dt, jj, espp2, deltaY)
                  indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, smpl(2), dbut);
                  decremente =true;
                  lept =lept+1;
                  waitbar(lafrac, hWB, lesmots(val.csrc(ii), val.alltri(jj),lept));
                end
              end
              foo(1) =[];
              if decremente
                nb_occur =nb_occur-inc_occur;
              end
            end
          end
        end  % for jj =1:nombres
      end  % for ii =1:nombre
      delete(hWB);
    end

    %------------------
    % MARQUAGE TEMPOREL
    % val sera un objet de la classe CMarkVarCalcul
    % Ofich un objet de la classe CFichierAnalyse
    %----------------------------------------
    function fncPanelTemporel(tO, Ofich, val)
      hdchnl =Ofich.Hdchnl;
      ptchnl =Ofich.Ptchnl;
      for ii=1:val.nombre
        for jj=1:val.nombres
          % VALIDATION des temps ou points
          try
            [dbint, fnint, texteRef] =tO.validTempsPoint(ptchnl, val.leDebut, val.laFin, val.tmp, val.csrc(ii), val.alltri(jj));
            [TEMPS, tincr] =tO.validInterval(ptchnl, dbint, fnint, texteRef, val.int, val.csrc(ii), val.alltri(jj));
          catch e
            lesMots =sprintf('%s: %s\n%s (%s: %d)|(%s: %d)', ...
                             tO.potraverrfnc, e.identifier, e.message, ...
                             tO.potravcan,val.csrc(ii), tO.potravess,val.alltri(jj));
            disp(lesMots);
            continue;
          end
          repett =val.occurence;
          indpt =val.lpts;
%          vincr =round(abs(tincr)*hdchnl.rate(val.csrc(ii),val.alltri(jj)))*sign(tincr);
          vincr =tincr*hdchnl.rate(val.csrc(ii),val.alltri(jj));
          cuanto =1;
          temps =TEMPS+round(cuanto*vincr);
          if (temps >= dbint) && (temps <= fnint)
            indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, temps, 1);
          end
          if ~val.reptout
            repett =repett-1;
          end
          cuanto =cuanto+1;
          temps =TEMPS+round(cuanto*vincr);
          while (repett > 0) && (temps >= dbint) && (temps <= fnint)
            indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, temps, 1);
            if (~val.reptout) || (vincr == 0)
              repett =repett-1;
            end
            cuanto =cuanto+1;
            temps =TEMPS+round(cuanto*vincr);
          end % while
        end  % for jj
      end    % for ii
    end

    %-------------
    % MARQUAGE EMG
    % val sera un objet de la classe CMarkVarCalcul
    % Ofich un objet de la classe CFichierAnalyse
    %-----------------------------------
    function fncPanelEmg(tO, Ofich, val)
      hdchnl =Ofich.Hdchnl;
      ptchnl =Ofich.Ptchnl;
      dt =val.dt;
      totwb =val.nombre*val.nombres;
      numwb =0;
      lafrac =0.0;
      lesmots =@(lecan,lesssai) sprintf('%s %s %i -- %s %i', tO.potravemgrech, tO.potravcan, lecan, tO.potravess,lesssai);
      hWB =laWaitbarModal(lafrac, lesmots(0,0));
      for ii=1:val.nombre
        Ofich.getcanal(dt, val.csrc(ii));
        for jj=1:val.nombres
          numwb =numwb+1;
          lafrac =numwb/totwb;
          waitbar(lafrac, hWB, lesmots(val.csrc(ii), val.alltri(jj)));
          % VALIDATION des temps ou points de l'interval de travail
          fnint =ptchnl.valeurDePoint(val.laFin,val.csrc(ii),val.alltri(jj));
          dbint =ptchnl.valeurDePoint(val.leDebut,val.csrc(ii),val.alltri(jj));
          if (isempty(dbint) || isempty(fnint) || dbint == 0 || fnint == 0 || fnint <= dbint)
            mmot =fprints('%s: %s(%i), %s(%i)', tO.potravdfinterr, tO.potravcan,ii, tO.potravess,jj);
            disp(mmot);
            continue;
          end
          if fnint == 1
            fnint =hdchnl.nsmpls(val.csrc(ii),val.alltri(jj));
          end
          indpt =val.lpts;
          %_________________________________
          % lecture des datas à travailler
          %---------------------------------
          datos =dt.Dato.(dt.Nom)(dbint:fnint, val.alltri(jj));
          % lance le travail
          [chtimes, ampl] =detectemg(datos, val);
          % préparation du marquage, les datas nous arrive dans
          %   chtimes: nous donne chaque changement "d'état" en commençant
          %            par le premier échantillon de l'interval
          %   ampl:    nous donne le niveau correspondant
          %   donc pour chtimes(u:u+1) l'amplitude associée est ampl(u)
          chtimes(end+1) =length(datos);
          chtimes =chtimes+dbint-1;
          ampl =(ampl-1);
          indpt =val.lpts;
          step1 =true;
          aumoinsun =false;
          for U =1:length(ampl)
            % on recherche un début de Onset
            if step1 & ampl(U)
              indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, chtimes(U), 1);
              step1 =false;
              aumoinsun =true;
            elseif step1
              continue;
            end
            % on recherche une fin de Onset
            if ~step1 & ~ampl(U)
              indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, chtimes(U), 1);
              step1 =true;
            end
          end
          % il faut corriger pour les fois ou on finit avec un onset jusqu'au bout
          if aumoinsun & ~step1
            indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, chtimes(end), 1);
          end
        end  % for jj
      end    % for ii
      delete(hWB);
    end

    %----------------------------------------------------------
    % on vérifie les valeurs entrées pour l'interval de travail
    %------------------------------------------------------------------------------
    function [t, inc] = validInterval(tO, ptchnl, debut, fin, txtr, txti, can, ess)
      t =ptchnl.valeurDePoint(txtr, can, ess);  % en échantillon
      if isempty(t) || (t < debut) || (t > fin)
        me =MException('ANALYSE:CMark:validInterval', tO.potravetmperr);
        throw(me);
      end
      inc =ptchnl.valeurDeTemps(txti, can, ess);  % en sec
      if isempty(inc)
        me =MException('ANALYSE:CMark:validInterval', tO.potraveincerr);
        throw(me);
      end
    end

    %---------------------
    % MARQUAGE D'AMPLITUDE
    % val sera un objet de la classe CMarkVarCalcul
    % Ofich un objet de la classe CFichierAnalyse
    %----------------------------------------------
    function fncPanelAmplitude(tO, Ofich, val)
      hdchnl =Ofich.Hdchnl;
      ptchnl =Ofich.Ptchnl;
      dt =val.dt;
      % ON PASSE LES CANAUX CHOISIS
      for ii =1:val.nombre
      	Ofich.getcanal(dt, val.csrc(ii));
      	% ON PASSE LES ESSAIS CHOISIS
        for jj =1:val.nombres
          % VALIDATION des temps ou points
          try
            [dbint, fnint, texteRef] =tO.validTempsPoint(ptchnl, val.leDebut, val.laFin, val.ampRef, val.csrc(ii), val.alltri(jj));
            ampref =tO.getValeurDePoint(dt, ptchnl, texteRef, val.csrc(ii), val.alltri(jj), dbint, fnint)*val.pCent;
          catch e
            lesMots =sprintf('%s: %s\n%s (%s: %d) -- (%s: %d)', tO.potraverrfnc, ...
                             e.identifier, e.message, tO.potravcan,val.csrc(ii), ...
                             tO.potravess,val.alltri(jj));
            disp(lesMots);
            continue;
          end
          markle =tO.cualEsBueno(dt, hdchnl, val, ii, jj, ampref, dbint, fnint);
          if isempty(markle)
            continue;
          end
          repett =1:val.occurence;
          indpt =val.lpts;
          while ~isempty(repett) && (repett(1) <= length(markle))
            if val.direction
              temps =markle(repett(1));
            else
              temps =markle(end-repett(1)+1);
            end
            if ~(temps < dbint) || (temps > fnint)
              indpt =tO.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, temps, 1);
              if val.reptout
                repett(1) =repett(1)+1;
              else
                repett(1) =[];
              end
            else
              if val.direction
                markle(repett(1)) =[];
              else
                markle(end-repett(1)+1) =[];
              end
            end
          end  % while
        end    % for jj
      end      % for ii
    end

    %------------------------------------------------------
    % on retourne la valeur de l'amplitude du point demandé
    %----------------------------------------------------------------------------
    function ampl = getValeurDePoint(tO, dat, ptchnl, txtRef, can, ess, dbi, fni)
      ampl =str2num(txtRef);
      if ~isempty(ampl)
        % la valeur lue était déjà une amplitude
        return;
      end
      % la valeur lue était probablement en format texte, du genre Pi, P3...
      ampl =ptchnl.valeurDePoint(txtRef, can, ess);
      % VALIDATION de l'amplitude
      if isempty(ampl) || (ampl < dbi) || (ampl > fni)
        me =MException('ANALYSE:CMark:getValeurDePoint', '%s: %s, %d, %s %d, %s', ...
                       tO.potravexpr, txtRef, dbi, tO.po_ou, fni, tO.potravnvalid);
        throw(me);
      end
      ampl =dat.Dato.(dat.Nom)(ampl, ess);
    end

    %---------------------------------------------------
    % On retourne v: en fonction du premier échantillon,
    %                et non pas relatif à debut:fin
    %-----------------------------------------------------------------------
    function v =cualEsBueno(tO, dat, hdchnl, val, can, ess, laRef, dbt, fin)
      % on rebase le signal en fonction de laRef
      % et on travaille avec le signe --> +1, -1, 0
      tmp =sign(dat.Dato.(dat.Nom)(dbt:fin, val.alltri(ess))-laRef);
      % on multiplie Xi avec Xi+1
      foo =tmp(1:end-1).*tmp(2:end);
      % si on traverse 0, foo = -1 ou 0
      % on travaille donc seulement sur ces endroits
      v =find(foo < 1);
      s =1;
      while s < length(v)
        if (foo(v(s)) == -1) || (foo(v(s)) ==  0 & tmp(v(s)) == 0)
          s =s+1;
        else
          v(s) =[];
        end
      end
      %
      % ON GARDE celui qui est le plus près de laRef
      vv =round(hdchnl.rate(val.csrc(can),val.alltri(ess))*val.delai)+dbt-1;
      m =v;
      v =v+vv;
      K =length(v);
      for s =K:-1:1
        if (foo(m(s)) < 0)
          test =abs(dat.Dato.(dat.Nom)([v(s) v(s)+1], val.alltri(ess))-laRef);
          if test(2) < test(1)
            v(s) =v(s)+1;
          end
        end
      end
      % éliminons les points identiques
      if ~isempty(v) && length(v) > 1
        vTest =find(v(2:end)-v(1:end-1) == 0);
        if ~isempty(vTest)
          if val.direction
            v(vTest+1) =[];
          else
            v(vTest) =[];
          end
        end
      end
      % éliminons les points consécutifs inutils
      if ~isempty(v) && length(v) > 1
        m =v-vv;
        vTest =find( (diff(v) == 1) & ( foo(m(1:end-1)) == 0 ) );
        if ~isempty(vTest)
          if val.direction
            v(vTest+1) =[];
          else
            v(vTest) =[];
          end
        end
      end
    end

    %----------------------------------------------------------
    % validation des valeurs entrées pour l'interval de travail
    % va et vb --> valeur en échantillon
    % vc       --> chaîne de caractères reformattée
    %--------------------------------------------------------------------------------
    function [va, vb, vc] = validTempsPoint(tO, ptchnl, debut, fin, ref, canal, essai)
      va =ptchnl.valeurDePoint(debut, canal, essai);     % retourne une valeur en échantillon
      vb =ptchnl.valeurDePoint(fin, canal, essai);
      % ORDRE de l'interval de travail
      if isempty(va) || isempty(vb) || (va >= vb)
        me =MException('ANALYSE:CMark:validTempsPoint', '%s (%s: %d) %s (%s: %d) %s', ...
                       tO.potravexpr, tO.po_debut,va, tO.po_ou, tO.po_fin,vb, tO.potravnvalid);
        throw(me);
      end
      texteDeb =regexprep(debut, 'p0' , 'pi', 'ignorecase');
      lesMots =['(' texteDeb  ')'];
      vc =regexprep(ref, 'p0' , 'pi', 'ignorecase');
      vc =regexprep(vc, 'pi' , lesMots, 'ignorecase');
      lesMots =['(' fin  ')'];
      vc =regexprep(vc, 'pf' , lesMots, 'ignorecase');
    end

    %----------------------
    % INSERTION POINT BIDON
    % val sera un objet de la classe CMarkVarCalcul
    % Ofich un objet de la classe CFichierAnalyse
    %-------------------------------------
    function fncPanelBidon(tO, Ofich, val)
      hdchnl =Ofich.Hdchnl;
      ptchnl =Ofich.Ptchnl;
      for ii =1:val.nombre
        for jj =1:val.nombres
        	ptchnl.inserepoint(val.csrc(ii),val.alltri(jj),val.ptbidon,0,-1);
        end    % for jj
      end      % for ii
    end

    %----------------------------------
    % DÉTECTION DES CHANGEMENTS (CUSUM)
    % val sera un objet de la classe CMarkVarCalcul
    % Ofich un objet de la classe CFichierAnalyse
    %--------------------------------------
    function fncPanelCUSUM(obj, Ofich, val)
      if ~(val.gpls || val.gmns)
        me =MException('Analyse:CMark:fncPanelCUSUM', tO.potravchmd);
        throw(me);
      end
      if (val.seuil <= 0) & (val.derive <= 0)
        me =MException('Analyse:CMark:fncPanelCUSUM', tO.potravsderiv);
        throw(me);
      end
      hdchnl =val.hdchnl;
      ptchnl =val.ptchnl;
      dt =val.dt;
      %_______________________
      % barre de défilement
      %-----------------------
      totwb =val.nombre*val.nombres;
      numwb =0;
      hWB =laWaitbar(0, tO.potravcusumrech);
      %___________________________________________
      % On boucle autour des canaux sélectionnés
      %-------------------------------------------
      for ii =1:val.nombre
      	Ofich.getcanal(dt, val.csrc(ii));
        %_________________________________________
        % On boucle autour des essais sélectionnés
        %-----------------------------------------
        for jj =1:val.nombres
          numwb =numwb+1;
          waitbar(numwb/totwb, hWB);
          smplmax =ptchnl.valeurDePoint(val.laFin,val.csrc(ii),val.alltri(jj));
          if smplmax == 1
            smplmax =hdchnl.nsmpls(val.csrc(ii),val.alltri(jj));
          end
          indpt =val.lpts;
          debut =ptchnl.valeurDePoint(val.leDebut,val.csrc(ii),val.alltri(jj));
          if (isempty(debut) || isempty(smplmax) || debut == 0 || smplmax < 2)
            break;
          end
          lerate =hdchnl.rate(val.csrc(ii),val.alltri(jj));
          %______________________________________________________
          % valeur pour décrémenter le nb d'occurence à faire
          %------------------------------------------------------
          inc_occur =~val.reptout;
          %__________________________________
          % lecture des datas à travailler
          %----------------------------------
          dato =dt.Dato.(dt.Nom)(debut:smplmax, val.alltri(jj));
          N =length(dato);
          dato(2:N) =diff(dato);
          gpls =dato*0;
          gmns =gpls;
          %________________________
          % Début de la recherche
          %------------------------
          nb_occur_pls =val.occurence;
          nb_occur_mns =val.occurence;
          smpl =2;
          letop =smplmax-debut+1;
          while smpl < letop & ((nb_occur_pls > 0 & val.gpls) | (nb_occur_mns > 0 & val.gmns))
            gpls(smpl) =max(gpls(smpl-1)+dato(smpl)-val.derive, 0);
            gmns(smpl) =max(gmns(smpl-1)-dato(smpl)-val.derive, 0);
            %______________________
            % On marque les g+
            %----------------------
            if gpls(smpl) > val.seuil & nb_occur_pls > 0 & val.gpls
              indpt =obj.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, smpl, debut);
              gpls(smpl) =0;
              gmns(smpl) =0;
              nb_occur_pls =nb_occur_pls-inc_occur;
            end
            %______________________
            % On marque les g-
            %----------------------
            if gmns(smpl) > val.seuil & nb_occur_mns > 0 & val.gmns
              indpt =obj.copieVersExtra(hdchnl, ptchnl, val, ii, jj, indpt, smpl, debut);
              gpls(smpl) =0;
              gmns(smpl) =0;
              nb_occur_mns =nb_occur_mns-inc_occur;
            end
            smpl =smpl+1;
          end
        end  % for jj =1:nombres
      end  % for ii =1:nombre
      delete(hWB);
    end

  end  % methods
end % classdef
