%
% fonction mnouvre2(F, eltypo, T)
%
%                   F      --> handle d'un objet CLiranalyse
%                   eltypo --> handle d'un objet CEFich
%                   T      --> handle d'un objet CGuiMLLire
%
% Laboratoire GRAME
% MEK, mai 2011, et ça continue...
%
function mnouvre2(F, eltypo, T)
  try
    OA =CAnalyse.getInstance();
    Camino =pwd();
    if nargin < 3
        T.txtwbar ='Ouverture du fichier: ';
    end
    %
    % Le même WaitBar sera récupéré lors de l'ouverture d'un fichier
    %
    TextLocal =[T.txtwbar F.Info.finame];
    WBhnd =laWaitbar(0, TextLocal, 'C', 'C', OA.OFig.fig);
    set(WBhnd, 'name','WBarLecture', 'WindowStyle','modal');
    waitbar(1/1000,WBhnd);
  
    try
      foo =CEFich(eltypo);
      test =F.lire(foo);
    catch tout;
      test =false;
    end
  
    figure(WBhnd);
    waitbar(0.5, WBhnd, TextLocal);
    if test
    	F.finlect();
    	waitbar(0.8, WBhnd, TextLocal);
    	OA.majcurfich(F);
    	OA.OFig.chfichpref(F);
    	waitbar(0.85, WBhnd, TextLocal);
      OA.fichrecent();
      OA.OFig.chonpan();
      if F.Vg.xy == 0
      	OA.OFig.affiche();
      end
      waitbar(0.95, WBhnd, TextLocal);
      if F.Vg.niveau & ~isempty(F.Vg.lescats)
      	set(findobj('tag','IpTextCats'),'visible','on');
    	  OA.OFig.nivo.updateprop({'visible';'on'});
        set(findobj('tag','IpCatsPermute'), 'visible','on');
      end
      OA.OFig.chonmenu();
      F.initxy();
      %
      % SI ON A OUVERT UN FICHIER AUTRE, IL FAUT EFFACER LE FICHIER TEMPORAIRE
      if ~(CEFich('analyse') == foo)
        leFich =fullfile(F.Info.prenom, F.Info.finame);
        delete(leFich);
        cd(Camino);
      end
  
    else
      delete(F);
      F =[];
    end
    delete(WBhnd);
  catch moo;
    CQueEsEsteError.dispOct(moo);
    rethrow(moo);
  end
end
