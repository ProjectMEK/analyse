%
% Avec la compatibilité Matlab/Octave, on a dû ajouter cette fonction
% pour Matlab. Ce dernier accepte la commande "properties", mais pas Octave.
%
%
function P = getProp(C)
  P =properties(C);
end
