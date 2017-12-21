%
% Convertir un tableau de uicontrol('edit') qui contient des chiffres (format texte)
% vers une matrice numérique. À cause d'Octave qui ne supporte pas les uitables.
% En entrée, U sera le handle du uipanel qui contient les uicontrol('edit')
function V =convEditArray2Mat_OCT(U)
  % lecture des infos utiles du uipanel
  S =get(U,'userdata');
  % recherche des uicontrol(edit) à lire
  hedt =findobj('parent',U,'style','edit');
  % nombre de uicontrol à lire
  Nu =length(hedt);
  % initialisation de la matrice de sortie
  V =zeros(S.nrow,S.ncol);
  for a =1:Nu
    indx =get(hedt(a),'userdata');
    mot =get(hedt(a),'string');
    V(indx(1),indx(2)) =str2num(mot);
  end
end
