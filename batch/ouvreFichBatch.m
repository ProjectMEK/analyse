%
% Ouverture d'un fichier Analyse dans le mode "Batch"
%
% En entrée  fichier  --> nom complet du fichier Analyse à ouvrir
%
% En sortie       hF  --> handle du fichier analyse: C
%
function hF = ouvreFichBatch(fichier)
  try
    %-----------------------------------------------------------------------------
    % Préparation de la Création d'un instance CLiranalyse
    %-----------------------------------------------------------------------------
    FICHANALYSE =CEFich('analyse');
    %-----------------------------------------------------------------------------
    % On se fabrique un fichier "Analyse" vide qui sera passé au constructeur
    % du fichier à ouvrir.
    %-----------------------------------------------------------------------------
    hF =CLiranalyse(FICHANALYSE);
    % On ouvre un fichier au format "Analyse"
    [hF.Info.prenom,b,c] =fileparts(fichier);
    hF.Info.finame =[b c];
    hF.Vg.valeur =1;
    % on finalise l'ouverture

    OA =CAnalyse.getInstance();
    %
    % Le même WaitBar sera récupéré lors de l'ouverture d'un fichier
    %
    TextLocal =['Ouverture du fichier: ' hF.Info.finame];
    WBhnd =laWaitbar(0, TextLocal, 'C', 'C', gcf);
    set(WBhnd, 'name','WBarLecture', 'WindowStyle','modal');
    waitbar(1/1000,WBhnd);
  
    try
      foo =CEFich(1);
      test =hF.lire(foo,true);
    catch tout;
      test =false;
    end
  
    figure(WBhnd);
    waitbar(0.5, WBhnd, TextLocal);
    if test
    	hF.finlect();
    	waitbar(0.8, WBhnd, TextLocal);
    	OA.majcurfich(hF);
      waitbar(0.95, WBhnd, TextLocal);
    else
      delete(hF);
      hF =[];
    end
    delete(WBhnd);


  catch moo;
    CQueEsEsteError.dispOct(moo);
    rethrow(moo);
  end
end
