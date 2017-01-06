%
% Classe CWoper
%
% MEK - juillet 2009
% Effectue les opérations de Traitement de Canal
%
% LA pile contient uniquement les éléments pour une opération, après quoi
% la réponse de l'opération est retourné dans la "case 1" de la pile et peut
% ainsi ête ré-utilisé pour une autre opération.
%
classdef CWoper < handle

  properties
    tc;        % handle de CTretcan
  end

  methods

    %------------
    % CONSTRUCTOR
    % param  --> handle de CTretcan
    %--------------------------
    function obj =CWoper(param)
      obj.init(param);
    end

    %------------------------------------------------
    % Initialisation et appel de l'opération demandée
    %-----------------------
    function init(obj,param)
      obj.tc =param;
      switch(param.operation)
      case 1  % addition
        if param.index < 2; werreur(obj.tc.hErr, 3, [obj.hErrm07 obj.hErr.case3m06]); param.erreur =1; return; end
        obj.check_sortie(2);
        if ~param.erreur
          obj.additionn();
        end
      case 2  % soustraction
        if param.index < 2; werreur(obj.tc.hErr, 3, [obj.hErrm08 obj.hErr.case3m06]); param.erreur =1; return; end
        obj.check_sortie(2);
        if param.erreur == 0
          obj.soustraitt();
        end
      case 3  % multiplication
        if param.index < 2; werreur(obj.tc.hErr, 3, [obj.hErrm09 obj.hErr.case3m06]); param.erreur =1; return; end
        obj.check_sortie(2);
        if param.erreur == 0
          obj.multiplicc();
        end
      case 4  % division
        if param.index < 2; werreur(obj.tc.hErr, 3, [obj.hErrm10 obj.hErr.case3m06]); param.erreur =1; return; end
        obj.check_sortie(2);
        if param.erreur == 0
          obj.divisionn();
        end
      case 5  % racine carrée
        if param.index < 1; werreur(obj.tc.hErr, 3, [obj.hErr.case3m15 obj.hErr.case3m11]); param.erreur =1; return; end
        obj.racinn();
      case 6  % Y EXPOSANT X
        if param.index < 2; werreur(obj.tc.hErr, 3, [obj.hErr.case3m16 obj.hErr.case3m06]); param.erreur =1; return; end
        obj.check_sortie(2);
        if param.erreur == 0
          obj.puissann();
        end
      case 7  % DISTANCE 1D
        if param.index < 2; werreur(obj.tc.hErr, 3, [obj.hErr.case3m17 obj.hErr.case3m06 ' (X1 X2)']); param.erreur =1; return; end
        obj.check_sortie(2);
        if param.erreur==0
          obj.distanc1d();
        end
      case 8  % DISTANCE 2D
        if param.index < 4; werreur(obj.tc.hErr, 3, 'Pour calculer la distance en 2D, j''ai besoin de 4 variables (X1 Y1 X2 Y2)'); param.erreur =1; return; end
        obj.check_sortie(4);
        if param.erreur == 0
          obj.distanc2d();
        end
      case 9  % DISTANCE 3D
        if param.index < 6; werreur(obj.tc.hErr, 3, 'Pour calculer la distance en 3D, j''ai besoin de 6 variables (X1 Y1 Z1 X2 Y2 Z2)'); param.erreur =1; return; end
        obj.check_sortie(6);
        if param.erreur == 0
          obj.distanc3d();
        end
      case 10  % sinus
        if param.index < 1; werreur(obj.tc.hErr,3, 'Pour exécuter la fonction sinus, j''ai besoin de 1 variable'); param.erreur =1; return; end
        obj.lesin();
      case 11  % arc sinus
        if param.index < 1; werreur(obj.tc.hErr,3, 'Pour exécuter la fonction arc sinus, j''ai besoin de 1 variable'); param.erreur =1; return; end
        obj.larcsin();
      case 12  % cosinus
        if param.index < 1; werreur(obj.tc.hErr,3, 'Pour exécuter la fonction cosinus, j''ai besoin de 1 variable'); param.erreur =1; return; end
        obj.lecos();
      case 13  % arc cosinus
        if param.index < 1; werreur(obj.tc.hErr,3, 'Pour exécuter la fonction arc cosinus, j''ai besoin de 1 variable'); param.erreur =1; return; end
        obj.larccos();
      case 14  % tangeante
        if param.index < 1; werreur(obj.tc.hErr,3, 'Pour exécuter la fonction tangeante, j''ai besoin de 1 variable'); param.erreur =1; return; end
        obj.latang();
      case 15  % arc tangeante
        if param.index < 1; werreur(obj.tc.hErr,3, 'Pour exécuter la fonction arc tangeante, j''ai besoin de 1 variable'); param.erreur =1; return; end
        obj.arctang();
      case 16  % abs
        if param.index < 1; werreur(obj.tc.hErr,3, 'Pour exécuter la fonction abs, j''ai besoin de 1 variable'); param.erreur =1; return; end
        obj.Vabs();
      case 17  % longueur
        if param.index < 3; werreur(obj.tc.hErr,3, 'Pour calculer la longueur du vecteur, j''ai besoin de 3 variables (X Y Z)'); param.erreur =1; return; end
        obj.check_sortie(3);
        if param.erreur == 0
          obj.longueur();
        end
      case 18  % diff
        if param.index < 1; werreur(obj.tc.hErr,3, 'Pour exécuter la fonction diff, j''ai besoin de 1 variable'); param.erreur =1; return; end
        obj.Diff();
      case 19  % csum
        if param.index < 1; werreur(obj.tc.hErr,3, 'Pour exécuter la fonction csum, j''ai besoin de 1 variable'); param.erreur =1; return; end
        obj.CumSum();
      end
    end

    %-------------------------------------------------------------------
    % Vérification de la fréquence d'acquisition des canaux dans la PILE
    % Si les fréquences ne sont pas identiques, on décime à la plus basse.
    %-------------------------------
    function check_sortie(obj,posit)
      tc =obj.tc;
      nonreel =0;
      for U =tc.index-posit+1:tc.index
      	if tc.matriss(1,U)
      		nonreel =nonreel+1;
      	end
      end
      if nonreel > 1
        for U =1:length(tc.lestri)
          %________________________________________________________
          % On commence par trouver le rate minimum pour l'essai U
          %--------------------------------------------------------
          minf =1000000;
          for ii =0:posit-1
            if tc.hdr.rate(tc.index-ii,U) == 0
              continue;
            elseif tc.hdr.rate(tc.index-ii,U) < minf
              minf =tc.hdr.rate(tc.index-ii,U);
            end
          end
          for ii =(tc.index-posit+1):tc.index
            if (tc.matriss(1,ii) == 0) || (tc.hdr.rate(ii,U) == minf)
              continue;
            end
            vdecim =tc.hdr.rate(ii,U)/minf;
            if vdecim == floor(vdecim)
              pilI =tc.lapil{ii};
              if tc.hdr.nsmpls(ii,U) < vdecim
                donnees =pilI.Dato.(pilI.Nom)(tc.hdr.nsmpls(ii,U),U);
              else
                donnees =pilI.Dato.(pilI.Nom)(vdecim:vdecim:tc.hdr.nsmpls(ii,U),U);
              end
              tc.hdr.nsmpls(ii,U) =size(donnees,1);
              tc.hdr.rate(ii,U) =minf;
              pilI.Dato.(pilI.Nom)(1:tc.hdr.nsmpls(ii,U),U) =donnees;
            else
              werreur(obj.tc.hErr,3, 'Les fréquences d''acquisition des canaux se doivent d''être des multiples entiers l''un de l''autre');
              tc.erreur =1;
              return;
            end
          end
        end
      end
    end

                              % **********************************************
                              % CI-DESSOUS, toutes les fonctions "opération" *
                              % tel que addition, soustraction etc...        *
                              % **********************************************

    %------------------------------------------------
    % ADDITION can+can, can+réel, réel+can, réel+réel
    %----------------------
    function additionn(obj)
      tc =obj.tc;
      ind1 =min(tc.hdr.nsmpls(tc.index-1,:)) == max(tc.hdr.nsmpls(tc.index-1,:));
      ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
      pilM =tc.lapil{tc.index-1};
      pilP =tc.lapil{tc.index};
      if tc.matriss(1,tc.index) ==0 && tc.matriss(1,tc.index-1) ==0
        %______________
        % RÉEL -- RÉEL
        %--------------
        tc.matriss(2,tc.index-1) = tc.matriss(2,tc.index-1)+tc.matriss(2,tc.index);
      elseif tc.matriss(1,tc.index) == 0
        %_______________
        % CANAL -- RÉEL
        %---------------
        if ind1
          nsmpl =tc.hdr.nsmpls(tc.index-1,1);
          pilM.Dato.(pilM.Nom)(1:nsmpl,:) =pilM.Dato.(pilM.Nom)(1:nsmpl,:)+tc.matriss(2,tc.index);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index-1,U);
            pilM.Dato.(pilM.Nom)(1:nsmpl,U) =pilM.Dato.(pilM.Nom)(1:nsmpl,U)+tc.matriss(2,tc.index);
          end
        end
      elseif tc.matriss(1,tc.index-1)==0
        %_______________
        % RÉEL -- CANAL
        %---------------
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =pilP.Dato.(pilP.Nom)(1:nsmpl,:)+tc.matriss(2,tc.index-1);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =pilP.Dato.(pilP.Nom)(1:nsmpl,U)+tc.matriss(2,tc.index-1);
          end
        end
        tc.matriss(:,tc.index-1) =tc.matriss(:,tc.index);
        tc.hdr.rate(tc.index-1,:) =tc.hdr.rate(tc.index,:);
        tc.hdr.nsmpls(tc.index-1,:) =tc.hdr.nsmpls(tc.index,:);
        tc.lapil(tc.index-1) =[];
      else
        %________________
        % CANAL -- CANAL
        %----------------
        if ind1 && ind2
          nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],1));
          pilM.Dato.(pilM.Nom)(1:nsmpl,:) =pilM.Dato.(pilM.Nom)(1:nsmpl,:)+pilP.Dato.(pilP.Nom)(1:nsmpl,:);
          tc.hdr.nsmpls(tc.index-1,:) =nsmpl;
        else
          for U =1:length(tc.lestri)
            nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],U));
            pilM.Dato.(pilM.Nom)(1:nsmpl,U) =pilM.Dato.(pilM.Nom)(1:nsmpl,U)+pilP.Dato.(pilP.Nom)(1:nsmpl,U);
            tc.hdr.nsmpls(tc.index-1,U) = nsmpl;
          end
        end
      end
      tc.matriss(:,tc.index) =[];
      tc.hdr.rate(tc.index,:) =[];
      tc.hdr.nsmpls(tc.index,:) =[];
      tc.index =tc.index - 1;
    end

    %----------------------------------------------------
    % SOUSTRACTION can-can, can-réel, réel-can, réel-réel
    %-----------------------
    function soustraitt(obj)
      tc =obj.tc;
      ind1 =min(tc.hdr.nsmpls(tc.index-1,:)) == max(tc.hdr.nsmpls(tc.index-1,:));
      ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
      pilM =tc.lapil{tc.index-1};
      pilP =tc.lapil{tc.index};
      if tc.matriss(1,tc.index) == 0 && tc.matriss(1,tc.index-1) == 0  % RÉEL -- RÉEL
        tc.matriss(2,tc.index-1) =tc.matriss(2,tc.index-1)-tc.matriss(2,tc.index);
      elseif tc.matriss(1,tc.index) == 0   % CANAL -- RÉEL
        if ind1
          nsmpl =tc.hdr.nsmpls(tc.index-1,1);
          pilM.Dato.(pilM.Nom)(1:nsmpl,:) =pilM.Dato.(pilM.Nom)(1:nsmpl,:)-tc.matriss(2,tc.index);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index-1,U);
            pilM.Dato.(pilM.Nom)(1:nsmpl,U) =pilM.Dato.(pilM.Nom)(1:nsmpl,U)-tc.matriss(2,tc.index);
          end
        end
      elseif tc.matriss(1,tc.index-1) == 0   % RÉEL -- CANAL
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =tc.matriss(2,tc.index-1)-pilP.Dato.(pilP.Nom)(1:nsmpl,:);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =tc.matriss(2,tc.index-1)-pilP.Dato.(pilP.Nom)(1:nsmpl,U);
          end
        end
        tc.matriss(:,tc.index-1) =tc.matriss(:,tc.index);
        tc.hdr.rate(tc.index-1,:) =tc.hdr.rate(tc.index,:);
        tc.hdr.nsmpls(tc.index-1,:) =tc.hdr.nsmpls(tc.index,:);
        tc.lapil(tc.index-1) =[];
      else  % CANAL -- CANAL
        if ind1 && ind2
          nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],1));
          pilM.Dato.(pilM.Nom)(1:nsmpl,:) =pilM.Dato.(pilM.Nom)(1:nsmpl,:)-pilP.Dato.(pilP.Nom)(1:nsmpl,:);
          tc.hdr.nsmpls(tc.index-1,:) =nsmpl;
        else
          for U =1:length(tc.lestri)
            nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],U));
            pilM.Dato.(pilM.Nom)(1:nsmpl,U) =pilM.Dato.(pilM.Nom)(1:nsmpl,U)-pilP.Dato.(pilP.Nom)(1:nsmpl,U);
            tc.hdr.nsmpls(tc.index-1,U) =nsmpl;
          end
        end
      end
      tc.matriss(:,tc.index) =[];
      tc.hdr.rate(tc.index,:) =[];
      tc.hdr.nsmpls(tc.index,:) =[];
      tc.index =tc.index-1;
    end

    %------------------------------------------------------
    % MULTIPLICATION can+can, can+réel, réel+can, réel+réel
    %-----------------------
    function multiplicc(obj)
      tc =obj.tc;
      ind1 =min(tc.hdr.nsmpls(tc.index-1,:)) == max(tc.hdr.nsmpls(tc.index-1,:));
      ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
      pilM =tc.lapil{tc.index-1};
      pilP =tc.lapil{tc.index};
      %
      if tc.matriss(1,tc.index) == 0 && tc.matriss(1,tc.index-1) == 0  % RÉEL -- RÉEL
        tc.matriss(2,tc.index-1) =tc.matriss(2,tc.index-1)*tc.matriss(2,tc.index);
      elseif tc.matriss(1,tc.index) == 0   % CANAL -- RÉEL
        if ind1
          nsmpl =tc.hdr.nsmpls(tc.index-1,1);
          pilM.Dato.(pilM.Nom)(1:nsmpl,:) =pilM.Dato.(pilM.Nom)(1:nsmpl,:)*tc.matriss(2,tc.index);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index-1,U);
            pilM.Dato.(pilM.Nom)(1:nsmpl,U) =pilM.Dato.(pilM.Nom)(1:nsmpl,U)*tc.matriss(2,tc.index);
          end
        end
      elseif tc.matriss(1,tc.index-1) == 0   % RÉEL -- CANAL
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =tc.matriss(2,tc.index-1)*pilP.Dato.(pilP.Nom)(1:nsmpl,:);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =tc.matriss(2,tc.index-1)*pilP.Dato.(pilP.Nom)(1:nsmpl,U);
          end
        end
        tc.matriss(:,tc.index-1) =tc.matriss(:,tc.index);
        tc.hdr.rate(tc.index-1,:) =tc.hdr.rate(tc.index,:);
        tc.hdr.nsmpls(tc.index-1,:) =tc.hdr.nsmpls(tc.index,:);
        tc.lapil(tc.index-1) =[];
      else  % CANAL -- CANAL
        if ind1 && ind2
          nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],1));
          pilM.Dato.(pilM.Nom)(1:nsmpl,:) =pilM.Dato.(pilM.Nom)(1:nsmpl,:).*pilP.Dato.(pilP.Nom)(1:nsmpl,:);
          tc.hdr.nsmpls(tc.index-1,:) =nsmpl;
        else
          for U =1:length(tc.lestri)
            nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],U));
            pilM.Dato.(pilM.Nom)(1:nsmpl,U) =pilM.Dato.(pilM.Nom)(1:nsmpl,U).*pilP.Dato.(pilP.Nom)(1:nsmpl,U);
            tc.hdr.nsmpls(tc.index-1,U) =nsmpl;
          end
        end
      end
      tc.matriss(:,tc.index) =[];
      tc.hdr.rate(tc.index,:) =[];
      tc.hdr.nsmpls(tc.index,:) =[];
      tc.index =tc.index-1;
    end

    %------------------------------------------------
    % DIVISION can+can, can+réel, réel+can, réel+réel
    %----------------------
    function divisionn(obj)
      tc =obj.tc;
      ind1 =min(tc.hdr.nsmpls(tc.index-1,:)) == max(tc.hdr.nsmpls(tc.index-1,:));
      ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
      pilM =tc.lapil{tc.index-1};
      pilP =tc.lapil{tc.index};
      %
      if tc.matriss(1,tc.index) == 0 && tc.matriss(1,tc.index-1) == 0  % RÉEL -- RÉEL
        tc.matriss(2,tc.index-1) =tc.matriss(2,tc.index-1)/tc.matriss(2,tc.index);
      elseif tc.matriss(1,tc.index) == 0   % CANAL -- RÉEL
        if ind1
          nsmpl =tc.hdr.nsmpls(tc.index-1,1);
          pilM.Dato.(pilM.Nom)(1:nsmpl,:) =pilM.Dato.(pilM.Nom)(1:nsmpl,:)/tc.matriss(2,tc.index);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index-1,U);
            pilM.Dato.(pilM.Nom)(1:nsmpl,U) =pilM.Dato.(pilM.Nom)(1:nsmpl,U)/tc.matriss(2,tc.index);
          end
        end
      elseif tc.matriss(1,tc.index-1)==0   % RÉEL -- CANAL
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =tc.matriss(2,tc.index-1)./pilP.Dato.(pilP.Nom)(1:nsmpl,:);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =tc.matriss(2,tc.index-1)./pilP.Dato.(pilP.Nom)(1:nsmpl,U);
          end
        end
        tc.matriss(:,tc.index-1) =tc.matriss(:,tc.index);
        tc.hdr.rate(tc.index-1,:) =tc.hdr.rate(tc.index,:);
        tc.hdr.nsmpls(tc.index-1,:) =tc.hdr.nsmpls(tc.index,:);
        tc.lapil(tc.index-1) =[];
      else  % CANAL -- CANAL
        if ind1 && ind2
          nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],1));
          pilM.Dato.(pilM.Nom)(1:nsmpl,:) =pilM.Dato.(pilM.Nom)(1:nsmpl,:)./pilP.Dato.(pilP.Nom)(1:nsmpl,:);
          tc.hdr.nsmpls(tc.index-1,:) =nsmpl;
        else
          for U =1:length(tc.lestri)
            nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],U));
            pilM.Dato.(pilM.Nom)(1:nsmpl,U) =pilM.Dato.(pilM.Nom)(1:nsmpl,U)./pilP.Dato.(pilP.Nom)(1:nsmpl,U);
            tc.hdr.nsmpls(tc.index-1,U) =nsmpl;
          end
        end
      end
      tc.matriss(:,tc.index) =[];
      tc.hdr.rate(tc.index,:) =[];
      tc.hdr.nsmpls(tc.index,:) =[];
      tc.index =tc.index-1;
    end

    %------------------------
    % RACINE CARRÉE can, réel
    %-------------------
    function racinn(obj)
      tc =obj.tc;
      if tc.matriss(1,tc.index) == 0   % on a une valeur Réelle
        tc.matriss(2,tc.index) =sqrt(tc.matriss(2,tc.index));
      else
        pilP =tc.lapil{tc.index};
        ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =sqrt(pilP.Dato.(pilP.Nom)(1:nsmpl,:));
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =sqrt(pilP.Dato.(pilP.Nom)(1:nsmpl,U));
          end
        end
      end
    end

    %------------------------------------------------
    % EXPOSANT can^can, can^réel, réel^can, réel^réel
    %---------------------
    function puissann(obj)
      tc =obj.tc;
      ind1 =min(tc.hdr.nsmpls(tc.index-1,:)) == max(tc.hdr.nsmpls(tc.index-1,:));
      ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
      pilM =tc.lapil{tc.index-1};
      pilP =tc.lapil{tc.index};
      %
      if tc.matriss(1,tc.index) == 0 && tc.matriss(1,tc.index-1) == 0
        % RÉEL -- RÉEL
        tc.matriss(2,tc.index-1) =tc.matriss(2,tc.index-1)^tc.matriss(2,tc.index);
      elseif tc.matriss(1,tc.index) == 0
        % CANAL -- RÉEL
        if ind1
          nsmpl =tc.hdr.nsmpls(tc.index-1,1);
          pilM.Dato.(pilM.Nom)(1:nsmpl,:) =pilM.Dato.(pilM.Nom)(1:nsmpl,:).^tc.matriss(2,tc.index);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index-1,U);
            pilM.Dato.(pilM.Nom)(1:nsmpl,U) =pilM.Dato.(pilM.Nom)(1:nsmpl,U).^tc.matriss(2,tc.index);
          end
        end
      elseif tc.matriss(1,tc.index-1) == 0   % RÉEL -- CANAL
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =tc.matriss(2,tc.index-1).^pilP.Dato.(pilP.Nom)(1:nsmpl,:);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =tc.matriss(2,tc.index-1).^pilP.Dato.(pilP.Nom)(1:nsmpl,U);
          end
        end
        tc.matriss(:,tc.index-1) =tc.matriss(:,tc.index);
        tc.hdr.rate(tc.index-1,:) =tc.hdr.rate(tc.index,:);
        tc.hdr.nsmpls(tc.index-1,:) =tc.hdr.nsmpls(tc.index,:);
        tc.lapil(tc.index-1) =[];
      else  % CANAL -- CANAL
        if ind1 && ind2
          nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],1));
          pilM.Dato.(pilM.Nom)(1:nsmpl,:) =pilM.Dato.(pilM.Nom)(1:nsmpl,:).^pilP.Dato.(pilP.Nom)(1:nsmpl,:);
          tc.hdr.nsmpls(tc.index-1,:) =nsmpl;
        else
          for U =1:length(tc.lestri)
            nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],U));
            pilM.Dato.(pilM.Nom)(1:nsmpl,U) =pilM.Dato.(pilM.Nom)(1:nsmpl,U).^pilP.Dato.(pilP.Nom)(1:nsmpl,U);
            tc.hdr.nsmpls(tc.index-1,U) = nsmpl;
          end
        end
      end
      tc.matriss(:,tc.index) =[];
      tc.hdr.rate(tc.index,:) =[];
      tc.hdr.nsmpls(tc.index,:) =[];
      tc.index =tc.index-1;
    end

    %-------------
    %  DISTANCE 1D
    %----------------------
    function distanc1d(obj)
      tc =obj.tc;
      if tc.matriss(1,tc.index) == 0 || tc.matriss(1,tc.index-1) == 0  % on a 1 ou 2 nombre Réel
        werreur(obj.tc.hErr,3, '2 canaux sont nécessaires pour le calcul de la distance (X1 X2)');
        tc.erreur =1;
        return;
      else
        ind1 =min(tc.hdr.nsmpls(tc.index-1,:)) == max(tc.hdr.nsmpls(tc.index-1,:));
        ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        pilM =tc.lapil{tc.index-1};
        pilP =tc.lapil{tc.index};
        if ind1 && ind2
          nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],1));
          pilM.Dato.(pilM.Nom)(1:nsmpl,:) =abs(pilM.Dato.(pilM.Nom)(1:nsmpl,:)-pilP.Dato.(pilP.Nom)(1:nsmpl,:));
          tc.hdr.nsmpls(tc.index-1,:) =nsmpl;
        else
          for U =1:length(tc.lestri)
            nsmpl =min(tc.hdr.nsmpls([tc.index-1 tc.index],U));
            pilM.Dato.(pilM.Nom)(1:nsmpl,U) =abs(pilM.Dato.(pilM.Nom)(1:nsmpl,U)-pilM.Dato.(pilM.Nom)(1:nsmpl,U));
            tc.hdr.nsmpls(tc.index-1,U) = nsmpl;
          end
        end
        tc.matriss(:,tc.index) = [];
        tc.hdr.rate(tc.index,:) =[];
        tc.hdr.nsmpls(tc.index,:) =[];
        tc.index =tc.index-1;
      end
    end

    %-------------
    %  DISTANCE 2D
    %----------------------
    function distanc2d(obj)
      tc =obj.tc;
      if tc.matriss(1,tc.index) == 0 || tc.matriss(1,tc.index-1) == 0||...
         tc.matriss(1,tc.index-2) == 0 || tc.matriss(1,tc.index-3) == 0  % on a 1 ou 2 ou 3 ou 4 nombres Réels
        werreur(obj.tc.hErr,3, '4 canaux sont nécessaires pour le calcul de la distance (X1 Y1 X2 Y2)');
        tc.erreur =1;
        return;
      else
        ind1 =min(tc.hdr.nsmpls(tc.index-3,:)) == max(tc.hdr.nsmpls(tc.index-3,:));
        ind2 =min(tc.hdr.nsmpls(tc.index-2,:)) == max(tc.hdr.nsmpls(tc.index-2,:));
        ind3 =min(tc.hdr.nsmpls(tc.index-1,:)) == max(tc.hdr.nsmpls(tc.index-1,:));
        ind4 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        pil3 =tc.lapil{tc.index-3};
        pil2 =tc.lapil{tc.index-2};
        pilM =tc.lapil{tc.index-1};
        pilP =tc.lapil{tc.index};
        if ind1 && ind2 && ind3 && ind4
          nsmpl =min(tc.hdr.nsmpls(tc.index-3:tc.index,1));
          pil3.Dato.(pil3.Nom)(1:nsmpl,:) =sqrt(...
            ((pil3.Dato.(pil3.Nom)(1:nsmpl,:)-pilM.Dato.(pilM.Nom)(1:nsmpl,:)).^2)+ ...
            ((pil2.Dato.(pil2.Nom)(1:nsmpl,:)-pilP.Dato.(pilP.Nom)(1:nsmpl,:)).^2) );
          tc.hdr.nsmpls(tc.index-3,:) =nsmpl;
        else
          for U =1:length(tc.lestri)
            nsmpl =min(tc.hdr.nsmpls(tc.index-3:tc.index,U));
            pil3.Dato.(pil3.Nom)(1:nsmpl,U) =sqrt(...
              ((pil3.Dato.(pil3.Nom)(1:nsmpl,U)-pilM.Dato.(pilM.Nom)(1:nsmpl,U)).^2)+ ...
              ((pil2.Dato.(pil2.Nom)(1:nsmpl,U)-pilP.Dato.(pilP.Nom)(1:nsmpl,U)).^2) );
            tc.hdr.nsmpls(tc.index-3,U) =nsmpl;
          end
        end
        tc.matriss(:,tc.index-2:tc.index) = [];
        tc.hdr.rate(tc.index-2:tc.index,:) =[];
        tc.hdr.nsmpls(tc.index-2:tc.index,:) =[];
        tc.index =tc.index-3;
      end
    end

    %-------------
    %  DISTANCE 3D
    %----------------------
    function distanc3d(obj)
      tc =obj.tc;
      if tc.matriss(1,tc.index) == 0 || tc.matriss(1,tc.index-1) == 0||...
         tc.matriss(1,tc.index-2) == 0 || tc.matriss(1,tc.index-3) == 0|| ...
         tc.matriss(1,tc.index-4) == 0 || tc.matriss(1,tc.index-5) == 0  % on a 1 ou 2 ou ... 6 nombres Réels
        werreur(obj.tc.hErr,3, '6 canaux sont nécessaires pour le calcul de la distance (X1 Y1 Z1 X2 Y2 Z2)');
        tc.erreur =1;
        return
      else
        ind1 =min(tc.hdr.nsmpls(tc.index-5,:)) == max(tc.hdr.nsmpls(tc.index-5,:));
        ind2 =min(tc.hdr.nsmpls(tc.index-4,:)) == max(tc.hdr.nsmpls(tc.index-4,:));
        ind3 =min(tc.hdr.nsmpls(tc.index-3,:)) == max(tc.hdr.nsmpls(tc.index-3,:));
        ind4 =min(tc.hdr.nsmpls(tc.index-2,:)) == max(tc.hdr.nsmpls(tc.index-2,:));
        ind5 =min(tc.hdr.nsmpls(tc.index-1,:)) == max(tc.hdr.nsmpls(tc.index-1,:));
        ind6 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        pil5 =tc.lapil{tc.index-5};
        pil4 =tc.lapil{tc.index-4};
        pil3 =tc.lapil{tc.index-3};
        pil2 =tc.lapil{tc.index-2};
        pilM =tc.lapil{tc.index-1};
        pilP =tc.lapil{tc.index};
        if ind1 && ind2 && ind3 && ind4 && ind5 && ind6
          nsmpl =min(tc.hdr.nsmpls(tc.index-5:tc.index,1));
          pil5.Dato.(pil5.Nom)(1:nsmpl,:) =sqrt(...
            ((pil5.Dato.(pil5.Nom)(1:nsmpl,:)-pil2.Dato.(pil2.Nom)(1:nsmpl,:)).^2)+ ...
            ((pil4.Dato.(pil4.Nom)(1:nsmpl,:)-pilM.Dato.(pilM.Nom)(1:nsmpl,:)).^2)+ ...
            ((pil3.Dato.(pil3.Nom)(1:nsmpl,:)-pilP.Dato.(pilP.Nom)(1:nsmpl,:)).^2) );
          tc.hdr.nsmpls(tc.index-5,:) =nsmpl;
        else
          for U =1:length(tc.lestri)
            nsmpl =min(tc.hdr.nsmpls(tc.index-5:tc.index,U));
            pil5.Dato.(pil5.Nom)(1:nsmpl,u) =sqrt(...
              ((pil5.Dato.(pil5.Nom)(1:nsmpl,U)-pil2.Dato.(pil2.Nom)(1:nsmpl,U)).^2)+ ...
              ((pil4.Dato.(pil4.Nom)(1:nsmpl,U)-pilM.Dato.(pilM.Nom)(1:nsmpl,U)).^2)+ ...
              ((pil3.Dato.(pil3.Nom)(1:nsmpl,U)-pilP.Dato.(pilP.Nom)(1:nsmpl,U)).^2) );
            tc.hdr.nsmpls(tc.index-5,U) =nsmpl;
          end
        end
        tc.matriss(:,tc.index-4:tc.index) =[];
        tc.hdr.rate(tc.index-4:tc.index,:) =[];
        tc.hdr.nsmpls(tc.index-4:tc.index,:) =[];
        tc.index =tc.index-5;
      end
    end

    %----------------
    % SINUS can, réel
    %------------------
    function lesin(obj)
      tc =obj.tc;
      degre =(get(findobj('tag','TraitCanDegre'),'value'))*pi/180;
      if degre == 0
        degre =1;
      end
      if tc.matriss(1,tc.index) == 0   % on a une valeur Réelle
        tc.matriss(2,tc.index) =sin(tc.matriss(2,tc.index)*degre);
      else  % on a un canal
        ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        pilP =tc.lapil{tc.index};
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =sin(pilP.Dato.(pilP.Nom)(1:nsmpl,:)*degre);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =sin(pilP.Dato.(pilP.Nom)(1:nsmpl,U)*degre);
          end
        end
      end
    end

    %--------------------
    % ARC SINUS can, réel
    %--------------------
    function larcsin(obj)
      tc =obj.tc;
      degre =(get(findobj('tag','TraitCanDegre'),'value'))*180/pi;
      if degre == 0
        degre =1;
      end
      if tc.matriss(1,tc.index) == 0   % on a une valeur Réelle
        tc.matriss(2,tc.index) =asin(tc.matriss(2,tc.index))*degre;
      else  % on a un canal
        pilP =tc.lapil{tc.index};
        ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =asin(pilP.Dato.(pilP.Nom)(1:nsmpl,:))*degre;
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =asin(pilP.Dato.(pilP.Nom)(1:nsmpl,U))*degre;
          end
        end
      end
    end

    %------------------
    % COSINUS can, réel
    %------------------
    function lecos(obj)
      tc =obj.tc;
      degre =(get(findobj('tag','TraitCanDegre'),'value'))*pi/180;
      if degre == 0
        degre =1;
      end
      if tc.matriss(1,tc.index) == 0   % on a une valeur Réelle
        tc.matriss(2,tc.index) =cos(tc.matriss(2,tc.index)*degre);
      else  % on a un canal
        ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        pilP =tc.lapil{tc.index};
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =cos(pilP.Dato.(pilP.Nom)(1:nsmpl,:)*degre);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =cos(pilP.Dato.(pilP.Nom)(1:nsmpl,U)*degre);
          end
        end
      end
    end

    %----------------------
    % ARC COSINUS can, réel
    %--------------------
    function larccos(obj)
      tc =obj.tc;
      degre =(get(findobj('tag','TraitCanDegre'),'value'))*180/pi;
      if degre == 0
        degre =1;
      end
      if tc.matriss(1,tc.index) == 0   % on a une valeur Réelle
        tc.matriss(2,tc.index) =acos(tc.matriss(2,tc.index))*degre;
      else  % on a un canal
        ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        pilP =tc.lapil{tc.index};
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =acos(pilP.Dato.(pilP.Nom)(1:nsmpl,:))*degre;
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =acos(pilP.Dato.(pilP.Nom)(1:nsmpl,U))*degre;
          end
        end
      end
    end

    %--------------------
    % TANGEANTE can, réel
    %-------------------
    function latang(obj)
      tc =obj.tc;
      degre =(get(findobj('tag','TraitCanDegre'),'value'))*pi/180;
      if degre == 0
        degre =1;
      end
      if tc.matriss(1,tc.index) == 0   % on a une valeur Réelle
        tc.matriss(2,tc.index) =tan(tc.matriss(2,tc.index)*degre);
      else  % on a un canal
        ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        pilP =tc.lapil{tc.index};
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =tan(pilP.Dato.(pilP.Nom)(1:nsmpl,:)*degre);
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =tan(pilP.Dato.(pilP.Nom)(1:nsmpl,U)*degre);
          end
        end
      end
    end

    %------------------------
    % ARC TANGEANTE can, réel
    %---------------------
    function larctang(obj)
      tc =obj.tc;
      degre =(get(findobj('tag','TraitCanDegre'),'value'))*180/pi;
      if degre == 0
        degre =1;
      end
      if tc.matriss(1,tc.index) == 0   % on a une valeur Réelle
        tc.matriss(2,tc.index) =atan(tc.matriss(2,tc.index))*degre;
      else  % on a un canal
        ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        pilP =tc.lapil{tc.index};
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =atan(pilP.Dato.(pilP.Nom)(1:nsmpl,:))*degre;
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =atan(pilP.Dato.(pilP.Nom)(1:nsmpl,U))*degre;
          end
        end
      end
    end

    %-------------------------
    % VALEUR ABSOLUE can, réel
    %-----------------
    function Vabs(obj)
      tc =obj.tc;
      if tc.matriss(1,tc.index) == 0   % on a une valeur Réelle
        tc.matriss(2,tc.index) =abs(tc.matriss(2,tc.index));
      else
        pilP =tc.lapil{tc.index};
        ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        if ind2
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =abs(pilP.Dato.(pilP.Nom)(1:nsmpl,:));
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =abs(pilP.Dato.(pilP.Nom)(1:nsmpl,U));
          end
        end
      end
    end

    %---------------
    % Diff can, réel
    % En sortie on aura
    %    can  -->  [OUT(1) = 0  OUT(i) = IN(i) - IN(i-1)]  ou  i = 2:end
    %    réel -->  0, car la dérivé d'une constante est null.
    %---------------------------------------------------------------------------
    function Diff(obj)
      tc =obj.tc;
      if tc.matriss(1,tc.index) == 0   % on a une valeur Réelle
        tc.matriss(2,tc.index) =0;
      else
        pilP =tc.lapil{tc.index};
        ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        if ind2
          %ON A LE MÊME NOMBRE D'ÉCHANTILLON DANS TOUS LES ESSAIS
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(2:nsmpl,:) =diff(pilP.Dato.(pilP.Nom)(1:nsmpl,:));
          pilP.Dato.(pilP.Nom)(1,:) =0;
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =[0; diff(pilP.Dato.(pilP.Nom)(1:nsmpl,U))];
          end
        end
      end
    end

    %---------------------------
    % Somme Cumulative can, réel
    %-------------------
    function CumSum(obj)
      tc =obj.tc;
      if tc.matriss(1,tc.index) == 0   % on a une valeur Réelle
        tc.matriss(2,tc.index) =tc.matriss(2,tc.index);
      else
        pilP =tc.lapil{tc.index};
        ind2 =min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        if ind2
          %ON A LE MÊME NOMBRE D'ÉCHANTILLON DANS TOUS LES ESSAIS
          nsmpl =tc.hdr.nsmpls(tc.index,1);
          pilP.Dato.(pilP.Nom)(1:nsmpl,:) =cumsum(pilP.Dato.(pilP.Nom)(1:nsmpl,:));
        else
          for U =1:length(tc.lestri)
            nsmpl =tc.hdr.nsmpls(tc.index,U);
            pilP.Dato.(pilP.Nom)(1:nsmpl,U) =cumsum(pilP.Dato.(pilP.Nom)(1:nsmpl,U));
          end
        end
      end
    end

    %--------------------
    %  LONGUEUR VECTORIEL
    %  Calculé à partir du point (0 0 0)
    %---------------------
    function longueur(obj)
      tc =obj.tc;
      if tc.matriss(1,tc.index) == 0 || tc.matriss(1,tc.index-1) == 0||...
         tc.matriss(1,tc.index-2) == 0   % on a 1 ou 2 ou 3 nombres Réels
        werreur(obj.tc.hErr,3, '3 canaux sont nécessaires pour le calcul de la longueur (X Y Z)');
        tc.erreur =1;
        return
      else
        ind1 =min(tc.hdr.nsmpls(tc.index-2,:)) == max(tc.hdr.nsmpls(tc.index-2,:));
        ind2 =min(tc.hdr.nsmpls(tc.index-1,:)) == max(tc.hdr.nsmpls(tc.index-1,:));
        ind3=min(tc.hdr.nsmpls(tc.index,:)) == max(tc.hdr.nsmpls(tc.index,:));
        pil2 =tc.lapil{tc.index-2};
        pilM =tc.lapil{tc.index-1};
        pilP =tc.lapil{tc.index};
        if ind1 && ind2 && ind3
          nsmpl =min(tc.hdr.nsmpls(tc.index-2:tc.index,1));
          pil2.Dato.(pil2.Nom)(1:nsmpl,:) =sqrt(...
            ((pil2.Dato.(pil2.Nom)(1:nsmpl,:)).^2)+ ...
            ((pilM.Dato.(pilM.Nom)(1:nsmpl,:)).^2)+ ...
            ((pilP.Dato.(pilP.Nom)(1:nsmpl,:)).^2) );
          tc.hdr.nsmpls(tc.index-2,:) =nsmpl;
        else
          for U =1:length(tc.lestri)
            nsmpl =min(tc.hdr.nsmpls(tc.index-2:tc.index,U));
            pil2.Dato.(pil2.Nom)(1:nsmpl,U) =sqrt(...
              ((pil2.Dato.(pil2.Nom)(1:nsmpl,U)).^2)+ ...
              ((pilM.Dato.(pilM.Nom)(1:nsmpl,U)).^2)+ ...
              ((pilP.Dato.(pilP.Nom)(1:nsmpl,U)).^2) );
            tc.hdr.nsmpls(tc.index-2,U) =nsmpl;
          end
        end
        tc.matriss(:,tc.index-1:tc.index) =[];
        tc.hdr.rate(tc.index-1:tc.index,:) =[];
        tc.hdr.nsmpls(tc.index-1:tc.index,:) =[];
        tc.index =tc.index-2;
      end
    end

  end  % methods
end % classdef
