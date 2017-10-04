%
% liste = infoActions()  Retournera la liste des actions disponibles
%
% [nom,classe] = infoActions(nom)
%                Retournera nom qui est le nom demand� s'il existe
%                et la classe associ�e, qui fera le travail de cette action.
%
function varargout = infoActions(lechoix)

  % Liste des actions impl�ment�es et la classe de l'objet qui l'ex�cutera
  Li ={'Effacer canaux', 'vide';...
       'Effacer essais', 'vide';...
       'Effacer points marqu�s', 'vide';...
       'Differ', 'CDifferBat'};

  if exist('lechoix')
    % si on a entr� un nom d'action, on le v�rifie
    qui =find(ismember(Li(:,1),lechoix));

    if isempty(qui)       % il n'existe pas
      varargout{1} =[];
      varargout{2} =[];
    else                  % il existe
      % on retourne le nom
      varargout{1} =Li{qui,1};
      % on retourne la classe
      varargout{2} =Li{qui,2};
    end

  else
    varargout{1} =Li(:,1)';
  end

end
