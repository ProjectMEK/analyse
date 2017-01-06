function ganaxe(lescan)
%
% Gestion de l'Affichage dans les Nouveaux AXEs
% (n'a pas été ré-introduit dans la nouvelle version depuis 2009)
%
% Les nouveaux Axes ont des "propriétés" propres à Analyse
% accessibles par: Value=getappdata(hndl,'VARNAME');
%                  et    setappdata(hndl,'VARNAME',Value);
%
% LESCAN	Canaux à ne plus afficher
%
% si on efface un ou des canaux, il faut en tenir compte
% dans chacun des nouveaux axes.
  if length(lescan)
    OA =CAnalyse.getInstance();
    Ofich =OA.Fic.hfich{OA.Fic.curfich};
    vg =Ofich.Vg;
    for U =1:length(vg.multiaff)
      canfig =getappdata(vg.multiaff(U),'LESCAN');
      trouve =1;
      jj =length(lescan);
      while jj > 0
        yenati =find(canfig == lescan(jj));
        if length(yenati)
          trouve =0;
          if length(canfig) == 1
            % on avait seulement un canal dans cette figure et on l'a effacé
            if canfig > vg.nad
              canfig =vg.nad;
            end
          else
            if length(canfig) > yenati
              canfig(yenati+1:end) =canfig(yenati+1:end)-1;
            end
            canfig(yenati) =[];
          end
        end
        if trouve
          yenati =find(canfig>lescan(jj));
          if length(yenati)
            canfig([yenati]) =canfig([yenati])-1;
          end
          trouve =0;
        end
        jj =jj-1;
      end
      setappdata(vg.multiaff(U),'LESCAN',canfig);
    end % for U
  end
end
