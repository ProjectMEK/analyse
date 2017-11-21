%
% liste = infoActions()  Retournera la liste des actions disponibles
%
% [nom,classe] = infoActions(crit�re)
%                En entr�e, on peut passer un des param�tres de la liste:
%                           son nom, sa classe ou son num�ro.
%
%                On Retournera nom qui est le nom demand� s'il existe
%                et la classe associ�e, qui fera le travail de cette action.
%                Optionnellement on peut ajouter en sortie le num�ro de l'action.
%
function varargout = infoActions(lechoix)

  % Liste des actions impl�ment�es et la classe de l'objet qui l'ex�cutera
  % Observation, je place les noms de fonction en ordre alphab�tique. Les num�ros ne
  % seront donc pas en ordre d'une ligne � l'autre.
  Li ={'ButterWorth','CFiltreBWBat', 3;...
       'Calcul COP "Amti"','CCalculCOPamtiBat', 5;...
       'Calcul COP "Optima"','CCalculCOPoptimaBat', 4;...
       'Differ', 'CDifferBat', 1;...
       'Supprimer canaux', 'CSuppCanBat', 2};  %  {Le prochain num�ro: 6 }

  if exist('lechoix')
    qui =[];
    if isnumeric(lechoix)
      % si on a entr� un num�ro d'action, on le v�rifie
      qui =find(cell2mat(Li(:,3))==lechoix);
    else
      % si on a entr� un nom d'action, on le v�rifie
      qui =find(ismember(Li(:,1),lechoix));
      % et si on avait entr� le nom de la classe � la place!!!
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
        % on retourne le num�ro
        varargout{3} =Li{qui,3};
      end
    end

  else
    varargout{1} =Li(:,1)';
  end

end
