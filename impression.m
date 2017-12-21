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
  if nargin > 0
    commande = varargin{1};
    OA =CAnalyse.getInstance();
    Fig =gcf;
    Fig =OA.OFig.fig;
    A =gca;
    switch(commande)
    %-----------
    case 'copcol'
      try
        print(Fig, '-dbitmap');
      catch ss;
        % Pour Octave
        aviser();
      end
    %------------
    case 'jpeg'
      [fname,pname] = uiputfile('*.jpg','Sauvegarde en format JPEG');
      if ~isequal(fname, 0) && ~isequal(pname, 0)
        jpgname = fullfile(pname,fname);
        try
          % Pour Matlab
          print(Fig, '-djpeg99',jpgname);
        catch ss;
          % Pour Octave
          aviser();
        end
      end
    %-------------
    case 'imprimer'
      try
        print(Fig, '-dwin');
      catch ss;
        aviser();
      end
    end
    axes(A);
  end
end

%
% Avertissement pour Octave
% Pas de fonction d'impression pour l'instant
% Analyse contient un axes, dans un uipanel
% Octave(print) cherche les axes avec l'option ("-depth", 1)
%
function aviser()
  Oj =CJournal.getInstance();
  mots ='Les fonctions d''impression ne sont pas disponibles actuellement sous Octave';
  Oj.ajouter(mots,2);
end