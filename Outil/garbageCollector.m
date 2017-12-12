%
% GARBAGE COLLECTOR
%
% fonction pour nettoyer les Objets qui ont
% fini leur travail et sont d�sormais inutiles.
% Sera appel� via la figure principale avec
%  set(tO.OFig.fig, 'WindowButtonMotionFcn',{@garbageCollector, thatObj});
%-------------------------------------------------------------------------
function garbageCollector(src, event, thatObj)
  set(src, 'WindowButtonMotionFcn','');
  pause(0.2);
  delete(thatObj);
end
