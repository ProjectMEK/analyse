%
% Dans le menu "trajectoire", il reste quelques options qui n'ont pas
% �t� impl�ment�. On en voit encore la trace ici. �ventuellement, on pourra soit
% les impl�menter si il y a de l'int�r�t ou les enlenver.
%
function traitraject(varargin)      %fct qui renvoie a toutes les fct du menu Trajectoire
  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
  end
  %--------------
  switch commande
  %---------------
  case 'ouverture'
  %-----------
  case 'ecart'					%
    essecart;				    % --> Ecart
  %----------------
  case 'difference'				%
    essdiffe;					% --> Diff�rence d'ampli et de tps entre 2 pts
  %--------------
  case 'amplimvt'					%
    essamplimvt;					% --> Amplitude de mouvement (en fonction du temps)
  %---------------
  case 'direction'				%
    essdirec;					% --> Direction (en fonction du temps)
  %-------------
  case 'courbur'					%
    esscourbu;					% --> Courbure (en fonction du temps)
  %---------------
  case 'moy-ecart'				%
    esstat;					% --> Moyenne & Ecart-type d'un point marqu� (pour chaque stimulus)
  %------------
  case 'export'					%
    essexpor;					% --> Exportation (des donn�es d'une courbe ds un fichier texte)
  %--
  end
return