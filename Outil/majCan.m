%
% Fonction pour faire une mise � jour des param�tres qui pourraient
% avoir �t� n�glig� par certaines vieilles fonctions.
%   Pour chacun des canaux s�lectionn�s
%   - On refait le calcul des min et max.
%
function majCan(varargin)
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  vg =Ofich.Vg;
  Ofich.majMinMax(vg.can);
end