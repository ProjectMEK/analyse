%
% Appeler par le menu "Quel fichier"
% sert à changer le fichier courant.
%
function changerFichier(varargin)
  H =varargin{2};                   % lire le handle du menu appelant
  F =get(H, 'userdat');             % handle de l'objet CMnuFichier
  F.quelfichier();
end
