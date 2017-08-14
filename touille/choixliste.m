function varargout =choixliste(varargin)
  if nargout
    for ii=1:nargout
      varargout{ii}=0;
    end
  end
  if nargin == 0
    return;
  else
    elmando = varargin{1};
  end
  switch elmando
  %-------------------
  case 'BTypeEntreeSi'
    zelist ={'Sélection par fichiers';'Contenu d''un dossier';...
             'Contenu d''un dossier et ses sous-dossiers'};
  %-----------------
  case 'BTypeEntree'
    zelist ={'Sélection par fichiers';'Contenu d''un dossier';...
             'Contenu d''un dossier et ses sous-dossiers';'Fichiers résultats d''une tâche précédente'};
  %-----------------
  case 'BTypeSortie'
    zelist ={'Écraser les fichiers sources ';'Même dossier, rebaptiser les fichiers';...
             'Un nouveau dossier pour tous les fichiers';'Nouveau dossier, même arborescence'};
  %-----------------
  case 'BChoixTache'
    deplace =varargin{2};
    zelist ={'Supprimer canaux','suppcan';...
             'Supprimer essais','suppess'};
    switch deplace
    case 'nom'
      zelist =zelist(:,1);
    case 'classe'
      zelist =zelist(:,2);
    end
  end
  varargout{1} =zelist;
return