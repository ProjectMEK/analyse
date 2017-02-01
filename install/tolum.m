%
% tolum.m
%
% test d'affichage des caractères accentués dans Matlab et Octave.
%
% Dans ULtra-Édit j'ai converti le fichier de UTF-8 à ASCII
% et voilà que les deux environnements ouvrent et affichent
% correctement les caractères accentués de ce mfile.
%
function tolum(test)

  % petit test tout bête pour afficher les caractères accentués.
  if nargin == 0
    test ='abcdàéû';
  end

  disp(test);

  % petit test tout bête pour afficher les caractères accentués venant d'un fichier ".mat".
  s.nom='Bélanger';
  s.prenom='Éloïse';
  s.adresse='22 rue Càutèk';

  % Voilà, en format '-v6' ça passe partout pour les caractères accentués.
  save('momo.mat','s', '-v6');

end
