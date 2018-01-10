%
% Texte multilingue � afficher durant la phase travail ou "apr�s-GUI"
% lors du marquage automatis�.
% On retrouve les m�mes champs dans CGuiMLMark
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
    % initialisation des propri�t�s � partir de la structure ou Objet S
    %
    function initTexto(tO, S)
      foo =CMLMark();
      CH =fieldnames(foo);
      ch =fieldnames(S);
      delete(foo);
      for U =1:length(CH)
        if ismember(CH(U),ch)
          tO.(CH{U}) =S.(CH{U});
        end
      end

    end

  end

end