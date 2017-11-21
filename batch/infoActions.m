%
% liste = infoActions()  Retournera la liste des actions disponibles
%
% [nom,classe] = infoActions(critère)
%                En entrée, on peut passer un des paramètres de la liste:
%                           son nom, sa classe ou son numéro.
%
%                On Retournera nom qui est le nom demandé s'il existe
%                et la classe associée, qui fera le travail de cette action.
%                Optionnellement on peut ajouter en sortie le numéro de l'action.
%
function varargout = infoActions(lechoix)

  % Liste des actions implémentées et la classe de l'objet qui l'exécutera
  % Observation, je place les noms de fonction en ordre alphabétique. Les numéros ne
  % seront donc pas en ordre d'une ligne à l'autre.
  Li ={'ButterWorth','CFiltreBWBat', 3;...
       'Calcul COP "Amti"','CCalculCOPamtiBat', 5;...
       'Calcul COP "Optima"','CCalculCOPoptimaBat', 4;...
       'Differ', 'CDifferBat', 1;...
       'Supprimer canaux', 'CSuppCanBat', 2};  %  {Le prochain numéro: 6 }

  if exist('lechoix')
    qui =[];
    if isnumeric(lechoix)
      % si on a entré un numéro d'action, on le vérifie
      qui =find(cell2mat(Li(:,3))==lechoix);
    else
      % si on a entré un nom d'action, on le vérifie
      qui =find(ismember(Li(:,1),lechoix));
      % et si on avait entré le nom de la classe à la place!!!
      if isempty(qui)
        qui =find(ismember(Li(:,2),lechoix));
      end
    end

    if isempty(qui)       % il n'existe pas
      varargout{1} =[];
      varargout{2} =[];
    else                  % il existe
      % on retourne le nom
      varargout{1} =Li{qui,1};
      % on retourne la classe
      varargout{2} =Li{qui,2};
      if nargout == 3
        % on retourne le numéro
        varargout{3} =Li{qui,3};
      end
    end

  else
    varargout{1} =Li(:,1)';
  end

end
