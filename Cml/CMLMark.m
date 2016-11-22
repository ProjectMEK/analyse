%
% Texte multilingue à afficher durant la phase travail ou "après-GUI"
% lors du marquage automatisé.
% On retrouve les mêmes champs dans CGuiMLMark
%
classdef CMLMark < handle
  properties (SetAccess=private)
    po_ou =[];
    po_et =[];
    po_debut =[];
    po_fin =[];
    potravchmnm =[];
    potravchmddm =[];
    potravchmd =[];
    potravchmontdesc =[];
    potravcan =[];
    potravess =[];
    potravnpt =[];
    potravdfinterr =[];
    potraverrfnc =[];
    potravemgrech =[];
    potravafflon =[];
    potravetmperr =[];
    potraveincerr =[];
    potravexpr =[];
    potravnvalid =[];
    potravsderiv =[];
    potravcusumrech =[];
    potravfermer =[];
    potravmaw =[];
    barstatus =[];
    
  end
  methods
    %
    % initialisation des propriétés à partir de la structure S
    %
    function initTexto(tO, S)
      foo =CMLMark();
      ch =properties(foo);
      delete(foo);
      for U =1:length(ch)
        if isfield(S, ch{U}) || isprop(S, ch{U})
          tO.(ch{U}) =S.(ch{U});
        end
      end
    end
  end
end