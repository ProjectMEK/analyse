%
% classdef CBasePourFigureAnalyse < CBasePourFigure
%
% METHODS
%       terminus(tO, src, event)
%
classdef CBasePourFigureAnalyse < CBasePourFigure

  methods

    %-------
    function terminus(tO, src, event)
      if ~isempty(tO.fig)
        oA =CAnalyse.getInstance();
        oA.delFigTravailFini(tO);
      end
    end

  end % methods
end
