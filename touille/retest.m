%
% on test ici l'écriture et l'affichage dans les GUIs avec les caractères accentués.
%
function retest()
  fig =figure('position',[150 150 400 500]);
  uicontrol('parent',fig,'position',[15 15 300 50],'callback',@papanou,...
            'string','test édition à la prochaîne senor');
end

function papanou(varargin)
  hJ =CJournal.getInstance();
  hJ.ajouter('test édition à la prochaîne senor',4);
end
