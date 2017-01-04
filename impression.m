%
% Laboratoire GRAME
% MEK, août 2000, et ça continue...
%
% Permet d'imprimer l'interface au complet sur l'imprimante par
% défaut de l'ordinateur. Ou bien, de le sauvegarder en format
% JPEG ou encore de faire un copier/coller en format Bitmap.
%
% Le format Bitmap peut être récupéré à partir d'un logiciel comme
% PaintBrush par exemple avec les touches Ctrl-V, ce qui vous permet
% de ré-éditer le graphique. ou avec Word en allant dans le menu
% "Edit/collage spécial", vous pouvez l'insérer dans un texte...
%
function impression(varargin)
  if nargin == 0
     return;
  else
     commande = varargin{1};
  end
  Fig =gcf;
  A =gca;
  switch(commande)
  %-----------
  case 'copcol'
    print(Fig, '-dbitmap');
  %------------
  case 'jpeg'
    [fname,pname] = uiputfile('*.*','Sauvegarde en format JPEG');
    if ~isequal(fname, 0) && ~isequal(pname, 0)
      jpgname = fullfile(pname,fname);
      print(Fig, '-djpeg99',jpgname);
    end
  %-------------
  case 'imprimer'
    print(Fig, '-dwin');
  end
  axes(A);
end
