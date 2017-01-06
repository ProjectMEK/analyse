%
% Traitement des messages d'erreurs (multi-lingues)
%
% voir aussi la classe: CErrMLTretcan()
%_______________________________________________________________________________
function werreur(varargin)
  if nargin < 1
    return;
  else
    hErr =varargin{1};
    commande = varargin{2};
    if nargin ==3
      laphrase = varargin{3};
    end
  end
  %
  switch(commande)
  %------------------
  % ERREUR DE SYNTAXE
  %-----
  case 1
    errordlg(hErr.case1, hErr.case1tit);
  %--------------------------------------
  % IL N'Y A QU'UNE VIRGULE DANS LASTRING
  %-----
  case 2
    errordlg(hErr.case2, hErr.case2tit);
  %---------------------
  % ERREUR DE PARAMÈTRES
  %-----
  case 3
    errordlg([laphrase hErr.case3], hErr.case3tit);
  end
end
