%
% classdef CParamBatchEditExec < handle
%
% METHODS
%         varargout = creerNouvelAction(tO)
%                 L = genereListAction(tO)
%                     effaceTouteAction(tO)
%                     effaceAction(tO,N)
%
classdef CParamBatchEditExec < handle

  properties
      % utile � long terme
      ver =1.01;
      % nombre d'espace � ajouter dans le journal "pour faire beau"
      S =0;
      % Info sur les fichiers � traiter
      Nfich =0;
      listFichIN ={'aucun fichier � traiter'};
      % Info sur les fichiers de sortie
      listFichOUT =[];
      % Info sur les actions
      % Liste des actions possibles
      listChoixActions =[];
      % liste des actions s�lectionn�es
      listAction =[];
      % nombre d'actions s�lectionn�es
      Naction =0;
      % liste de fichier virtuel
      listFichVirt =[];


      % handle du fichier virtuel (contient les param nb can, nb ess, etc..)
      fiVirt =[];
      %
      status =0;
      erreur =0;
      Path =pwd;
      ChoixEntree =1;
      ChoixSortie =4;
      isFichierIn =0;
      isFichierOut =0;
      exten ='.mat';
      tot =0;
      elno =0;
      tacfic =1;
      tach =[];
  end  %properties

  methods

    %-------------------------------------------------
    % cr�ation d'un nouvel objet CAction et ajout de
    % son handle dans la liste tO.listAction
    % En ENtr�e: on veut le nom de l'action
    % En Sortie: on retourne le handle de l'objet cr��
    %-------------------------------------------------
    function varargout = creerNouvelAction(tO,nom)
      % v�rification si le nom existe et quelle classe lui est associ�e
      [nAct,cAct] =infoActions(nom);
      if ~isempty(nAct)
        % le nom existe alors on cr�e un objet CAction en lui passant le nom et la classe
        tO.listAction{end+1} =CAction(nAct,cAct);
        % on met � jour la propri�t� Naction
        tO.Naction =length(tO.listAction);
        if nargout > 0
          varargout{1} =tO.listAction{end};
        end
      else
        for U =1:nargout
          varargout{U} =[];
        end
      end
    end

    % G�n�r� la liste des actions s�lectionn�es
    %------------------------------------------
    function L = genereListAction(tO)
      L ={' '};
      for U =1:length(tO.listAction)
        L{U} =tO.listAction{U}.description;
      end
    end

    %-----------------------------
    % Delete toutes les actions
    %-----------------------------
    function effaceTouteAction(tO)
      if ~isempty(tO.listAction)
        N =length(tO.listAction);
        for U =N:-1:1
          tO.effaceAction(U);
        end
      end
    end

    %-----------------------------------------------
    % Delete une action par son num�ro dans la liste
    %-----------------------------------------------
    function effaceAction(tO,N)
      if length(tO.listAction) >= N
        delete(tO.listAction{N});
        tO.listAction(N) =[];
        tO.Naction =length(tO.listAction);
      end
    end

    %--------------------------------------------------
    % Change l'ordre des actions en remontant la Ni�me
    % dans la listbox (si elle �tait 3, elle devient 2)
    %--------------------------------------------------
    function remonte(tO,N)
      if N > 1
        foo =tO.listAction{N-1};
        tO.listAction{N-1} =tO.listAction{N};
        tO.listAction{N} =foo;
      end
    end

    %--------------------------------------------------
    % Change l'ordre des actions en descendant la Ni�me
    % dans la listbox (si elle �tait 2, elle devient 3)
    %--------------------------------------------------
    function redescend(tO,N)
      if N < tO.Naction
        foo =tO.listAction{N+1};
        tO.listAction{N+1} =tO.listAction{N};
        tO.listAction{N} =foo;
      end
    end
  end  % methods

end
