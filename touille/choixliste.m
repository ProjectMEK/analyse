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
    zelist ={'S�lection par fichiers';'Contenu d''un dossier';...
             'Contenu d''un dossier et ses sous-dossiers'};
  %-----------------
  case 'BTypeEntree'
    zelist ={'S�lection par fichiers';'Contenu d''un dossier';...
             'Contenu d''un dossier et ses sous-dossiers';'Fichiers r�sultats d''une t�che pr�c�dente'};
  %-----------------
  case 'BTypeSortie'
    zelist ={'�craser les fichiers sources ';'M�me dossier, rebaptiser les fichiers';...
             'Un nouveau dossier pour tous les fichiers';'Nouveau dossier, m�me arborescence'};
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