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
      % utile à long terme
      ver =1.01;
      % nombre d'espace à ajouter dans le journal "pour faire beau"
      S =0;
      % Info sur les fichiers à traiter
      Nfich =0;
      listFichIN ={'aucun fichier à traiter'};
      % Info sur les fichiers de sortie
      listFichOUT =[];
      % Info sur les actions
      % Liste des actions possibles
      listChoixActions =[];
      % liste des actions sélectionnées
      listAction =[];
      % nombre d'actions sélectionnées
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
    % création d'un nouvel objet CAction et ajout de
    % son handle dans la liste tO.listAction
    % En ENtrée: on veut le nom de l'action
    % En Sortie: on retourne le handle de l'objet créé
    %-------------------------------------------------
    function varargout = creerNouvelAction(tO,nom)
      % vérification si le nom existe et quelle classe lui est associée
      [nAct,cAct] =infoActions(nom);
      if ~isempty(nAct)
        % le nom existe alors on crée un objet CAction en lui passant le nom et la classe
        tO.listAction{end+1} =CAction(nAct,cAct);
        % on met à jour la propriété Naction
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

    % Généré la liste des actions sélectionnées
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
    % Delete une action par son numéro dans la liste
    %-----------------------------------------------
    function effaceAction(tO,N)
      if length(tO.listAction) >= N
        delete(tO.listAction{N});
        tO.listAction(N) =[];
        tO.Naction =length(tO.listAction);
      end
    end

    %--------------------------------------------------
    % Change l'ordre des actions en remontant la Nième
    % dans la listbox (si elle était 3, elle devient 2)
    %--------------------------------------------------
    function remonte(tO,N)
      if N > 1
        foo =tO.listAction{N-1};
        tO.listAction{N-1} =tO.listAction{N};
        tO.listAction{N} =foo;
      end
    end

    %--------------------------------------------------
    % Change l'ordre des actions en descendant la Nième
    % dans la listbox (si elle était 2, elle devient 3)
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
