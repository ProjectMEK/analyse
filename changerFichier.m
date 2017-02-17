%
% Appeler par le menu "Quel fichier"
% sert à changer le fichier courant.
% En entrée, src -->  handle du menu appelant
%--------------------------------
function changerFichier(src, tmp)
  F =get(src, 'userdata');            % handle de l'objet CMnuFichier
  F.quelfichier();
end
