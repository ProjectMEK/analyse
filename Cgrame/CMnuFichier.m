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
    function tO =CMnuFichier(hF)
      try

        %------------------------------------------------------
        % On initialise les propriétés et on conserve le handle
        % de l'instance dans la propriété "userdata" du menu
        %--------------------
        tO.Hfid =hF;
        Mobj =findobj('tag','QuelFichierMnu');
        tO.HMnu =uimenu('parent',Mobj, 'label',hF.Info.finame, 'callback',@ changerFichier, 'userdata',tO);

      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end

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
    % lorsque l'on effectue un changement de fichier dans le menu
    %------------------------------------------------------------
    function quelfichier(tO, varargin)
      try
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

      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end
    end

  end % methods
end % classdef
