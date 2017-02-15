%
% Classe CMnuFichier
%
% Lorsqu'un nouveau fichier est ouvert, le menu "Quel Fichier"
% est peuplé avec un objet de la classe CMnuFichier
%
classdef CMnuFichier < handle

  properties
    HMnu =[];        % handle du sous-menu --> "Quel Fichier"
    Hfid =[];        % handle du fichier correspondant
  end

  methods

    %------------
    % CONSTRUCTOR
    %----------------------------
    function tO =CMnuFichier(fid)
      tO.Hfid =fid;
      Mobj =findobj('tag','QuelFichierMnu');
      tO.HMnu =uimenu('parent',Mobj, 'label',fid.Info.finame, 'callback',@ changerFichier, 'userdata',tO);
    end

    %-----------
    % DESTRUCTOR
    %------------------
    function delete(tO)
      if ~isempty(tO.HMnu)
        delete(tO.HMnu);
      end
    end

    %-----------------------------------------
    % fonction appelé par la fonction callback
    % lorsque l'on sélectionne un fichier dans le menu
    %-------------------------------------------------
    function quelfichier(tO)
      OA =CAnalyse.getInstance();
      lastfich =OA.Fic.curfich;
      if tO.Hfid ~= OA.Fic.hfich{lastfich}
        OA.Fic.lastfich =lastfich;
        OA.AuSuivant();
      end
      OA.majcurfich(tO.Hfid);
      fid =OA.findcurfich();
      OA.OFig.chfichpref(fid);
      test =tO.Hfid.ModeXY.YetiLa();
      if ~test
        OA.OFig.affiche();
      end
    end

  end % methods
end % classdef
