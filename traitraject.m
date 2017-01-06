%
% Dans le menu "trajectoire", il reste quelques options qui n'ont pas
% été implémenté. On en voit encore la trace ici. Éventuellement, on pourra soit
% les implémenter si il y a de l'intérêt ou les enlenver.
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
    essdiffe;					% --> Différence d'ampli et de tps entre 2 pts
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
    esstat;					% --> Moyenne & Ecart-type d'un point marqué (pour chaque stimulus)
  %------------
  case 'export'					%
    essexpor;					% --> Exportation (des données d'une courbe ds un fichier texte)
  %--
  end
return