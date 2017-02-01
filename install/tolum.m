%
% tolum.m
%
% test d'affichage des caract�res accentu�s dans Matlab et Octave.
%
% Dans ULtra-�dit j'ai converti le fichier de UTF-8 � ASCII
% et voil� que les deux environnements ouvrent et affichent
% correctement les caract�res accentu�s de ce mfile.
%
function tolum(test)

  % petit test tout b�te pour afficher les caract�res accentu�s.
  if nargin == 0
    test ='abcd���';
  end

  disp(test);

  % petit test tout b�te pour afficher les caract�res accentu�s venant d'un fichier ".mat".
  s.nom='B�langer';
  s.prenom='�lo�se';
  s.adresse='22 rue C�ut�k';

  % Voil�, en format '-v6' �a passe partout pour les caract�res accentu�s.
  save('momo.mat','s', '-v6');

end
