%
% on test ici l'�criture et l'affichage dans les GUIs avec les caract�res accentu�s.
%
function retest()
  fig =figure('position',[150 150 400 500]);
  uicontrol('parent',fig,'position',[15 15 300 50],'callback',@papanou,...
            'string','test �dition � la procha�ne senor');
end

function papanou(varargin)
  hJ =CJournal.getInstance();
  hJ.ajouter('test �dition � la procha�ne senor',4);
end
