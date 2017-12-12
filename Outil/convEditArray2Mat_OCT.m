%
% Convertir un tableau de uicontrol('edit') qui contient des chiffres du format
% texte vers une matrice numérique. À cause d'Octave qui ne supporte pas les uitables.
% En entrée, U sera le handle du uipanel qui contient les uicontrol('edit')
function V =convEditArray2Mat_OCT(U)
  % lecture des infos utiles du uipanel
  hedt =findobj('parent',U,'style','edit');
  format =get(U,'userdata');
  % nombre de colonne
  Nc =length(format);
  % nombre de uicontrol à lire
  Nu =length(hedt);
  % nombre de rang à lire
  Nr =Nu/Nc;
  % initialisation de la matrice de sortie
  V =zeros(Nr,Nc);
  for a =1:Nu
    indx =get(hedt(a),'userdata');
    mot =get(hedt(a),'string');
    V(indx(1),indx(2)) =str2num(mot);
  end
end
