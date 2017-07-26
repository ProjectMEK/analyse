%    function stat4COP(hObj)
% -- Ce programme permet de calculer plusieurs variables dépendantes permettant d'analyser la stabilité posturale.
% --
% -- Pour le calcul de la vitesse, le programme differ.m est utilisé avec une fenetre de 11 par
% -- défaut. Un filtre butterworth d'ordre 2 avec une fréquence de coupure de 8 Hz
% -- peut-etre utilisé afin d'éliminer le bruit au niveau du COP. Ces parametres (ordre et fréquence de coupure) sont déterminés
% -- par défaut. Ces valeurs sont habituellement choisies lors de l'analyse des oscillations posturales.
% --
% -- function Stat4COP9(fileIN,fileOUT,COPcanal,recup,borne,filtre,sujet,BOS);
% -- INPUTS
% --        fileOUT  : fichier de sortie qui comprendra les résultats en format ascii (e.g., *.txt) pour importation dans Statistica
% --        COPcanal : contient les canaux CPx et CPy. Vous devez avoir utilisé soit fplatamti ou fswaypaz pour récupérer ces canaux (CPx & CPy) 
% --        recup    : bornes temporelles pour calculer un centre de pression moyen. Exemple [2 6], centre moyen entre la 2ième et la 6ième seconde.
% --        bornes   : Si vous voulez effectuer les calcules seulement entre deux
% --                   temps donnés et non sur toute la durée de l'essai. Exemple [10 20 20 30], toutes les variables sont calculées entre ces bornes.
% --        filtre   : Si vous voulez filtrer vos data, filtre = 1, sinon filtre = 0. 
% --
% -- OUTPUTS
% --        fileOUT  : table de résultats, fichier ascii pour importation immédiate dans Statistica
% --                   voir GRAME_mfile.doc pour connaitre comment faire ce
% --                   tour de magie! 
% --
% -- CALLS différent programme 
% -- Vérifiez toujours que ces programmes sont existant sur votre machine avant de crier à l'aide!
% --       differ.m     (initié par MEK somewhere in 1998), dérive le
% --                    signal en utilisant une moving window de 11
% --       butter.m     MathWorks
% --       filtfilt.m   Mathworks
% --
% -- NOTE concernant ce programme:
% --
% -- À l'occasion, certaine carte A/D (Nos National Instrument) génère un spike au début de la collect de données (Do not ask why, I do not know!)
% -- Pour cette raison, lorsque vous n'avez pas de bornes ou de bornes supérieur au 50 premier points, ceux-ci sont ignorés afin
% -- d'éviter de faire des calculs avec des spikes. 
% --
% -- EXEMPLE D'UTILISATION 
% --
% -- Exemple d'utilisation de ce m-file si vous ne voulez pas calculer le
% -- SSMy et vous ne voulez pas filtrer les données filtre = 0
% --
% -- Stat4COP('c:\scoldata\suj18cop.mat','c:\scoldata\test.txt',[8 9],[2 6],[5 10 10 15],0,1);
% -- [8 9] = CPx 9, CPy 10; [2 6] = recup entre 2 et 6 seconde, [5 10 10 15 20 25 25 30 35 40] = bornes; Filtre les data filtre = 0,
% -- numero du sujet = 1
% -- NOTE LES CPx & CPy SONT EN CM LORSQUE FPLTAMTI.M ou FSWAYPAZ.M A ÉTÉ EXÉCUTÉ!
% --
% -- Mise à jour ---%
% -- Janvier 2002 version 1.0; Mise en place du programme
% -- Avril 2002 version 1.1; Ajout du calcul de l'aire des déplacements, programme de Paul Allard (Kinésiologie, Montréal)
% -- Mai 2002 version 1.2; Correction sur l'accroissement
% -- Juin 2002 version 1.3; Modification des variables et validation
% -- Juin 2002 version 1.5; Bullet proof pour l'utilisation sans BOS et SSMy
% -- Juillet 2002 version 1.6; Correction du la variable accroissement avec borne
% -- Juillet 2002 version 1.7; Correction concernant le management des entrées, filtre, BOS et sujet
% -- Décembre 2002, version 1.8; Vérification de l'harmonisation avec FBOS
% -- Décembre 2002, version 1.9; Vérification totale & ménage du code
% -- Novembre 2003 version 1.10; ajout de la recherche des noms de catégories plutot que le nomstim du hdchnl qui devient caduque 
% -- ATTENTION pour le moment l'option catégorie n'est pas automatique voir les modifs a faire plus bas (Normand) 
% -- Janvier 2004 version 2.0; Plusieurs corrections cosmétiques sur le fprintf et ajout d'un code de numéro de sujet (Normand)
% -- Janvier 2004 version 2.1; Ajout des variables RMS qui sont la SD du déplacement
% -- Octobre 2004 version 2.2; Sfreq est maintemamt basé sur le canal COPcanal(1)...Olivier et MeK
% -- Idem a Carpenter et Maki (Normand)
% -- Juillet 2005 - version 2.3, modification de l'écriture pour satisfaire les
% -- exigeances de la nouvelle version de Statistica, Martin Simoneau
% -- Octobre 2008 - version 2.4, modification enlève le RMS lorsqu'il y a
% -- des bornes et corrections pour que le séparateur soit toujours un ;
% -- (Normand et Martin)
% -- Adaptation au format des fichiers Analyse-2009, décembre 2009 par MEK
% --
% -- Programme initié par Martin Simoneau et modifié par plusieurs collaborateurs.
% -- 
% --                             Université Laval
% --          Groupe de Recherche en Analyse du Mouvement et Ergonomie
% --                                 (GRAME)
%
function stat4COP(hObj)
  leWb =laWaitbar(0, 'Statistique des variables du centre de pression...', 'C', 'C', gcf);
  oA =CAnalyse.getInstance();
  oF =oA.findcurfich();
  hdchnl =oF.Hdchnl;
  ptchnl =oF.Ptchnl;
  catego =oF.Catego.Dato;
  vg =oF.Vg;
  sujet =hObj.getNumeroSujet;
  filtre.stat =hObj.getOnFiltre();
  if filtre.stat
    filtre.fc =hObj.getFreqCoupure();
    filtre.ord =hObj.getOrdreFiltre();
  end
  largeurFen =hObj.getFenetreDiffer();
  leCx =hObj.getCanCpx();
  leCy =hObj.getCanCpy();
  maxSmp =max([hdchnl.nsmpls(leCx,:) hdchnl.nsmpls(leCy,:)]);
  %___________________________
  %--- On récupère le CpX ---%
  hCp =CDtchnl();
  oF.getcanal(hCp, leCx);
  nCan =hCp.Nom;
  dtchnl =permute(hCp.Dato.(nCan), [1 3 2]);
  %___________________________
  %--- On récupère le CpY ---%
  oF.getcanal(hCp, leCy);
  nCan =hCp.Nom;
  [a b c] =size(hCp.Dato.(nCan));
  dtchnl(1:a, 2, 1:b) =permute(hCp.Dato.(nCan), [1 3 2]);
  if size(dtchnl) > maxSmp
    dtchnl(maxSmp+1:end, :, :) =[];
  end
  dtchnl =single(dtchnl);
  delete(hCp);
  cX =1;
  cY =2;
  %_______________________________________
  %--- Vérification des datas (? NaN) ---%
  dtchnl(isnan(dtchnl(:))) =0;
  %__________________________________________
  %--- CPdata dans une matrice distincte ---%
  CPdata =double(dtchnl);
  %--- Temps d'échantillonnage
  temps =hdchnl.sweeptime(leCx,1);
  %--- Sampling frequency ---%
  Sfreq =hdchnl.rate(leCx,1);
  %--- Dimension de la matrice de data 
  [nsmpl b c] =size(dtchnl);
  %--- Vérification des bornes pour le calcul de récup
  getrecup =hObj.getRecup();
  if getrecup
    try
      [v1, v2] =valeurDeRecup(hObj, ptchnl, vg.ess, leCx);
      bornerecup =[v1 v2];      % en échantillon
    catch e
      delete(leWb);
      rethrow(e);
    end
  end
  %--- Ici j'ai gardé le vieux code... faudrait voir avec vg.nomstim{hdchnl.numstim(leCx, b)}
  if isfield(catego, 'ncat')
    try
      nbcat =catego(1,1,1).ncat;
      nstim(vg.ess) =0;
      for i =1:nbcat
        nstim(find([catego(2,1,i).ess(:)])) =i;
      end
      for i =1:vg.ess
        nomstim(i).nom =catego(2,1,nstim(i)).nom;
      end
    catch e
      delete(leWb);
      rethrow(e);
    end
  else
    e =MException('ANALYSE:stat4COP', '###Erreur: Il faudrait peut-être rebâtir les catégorie');
    delete(leWb);
    throw(e);
  end
  %___________________________
  %--- verifie les bornes ---%
  getborne =isempty(strtrim(hObj.getBornesText));
  %--- OUTPUT: Fichier de sortie
  fid =fopen(hObj.getFichierSortie(),'w');
  %--- Programme ---%
  try
    c =find(hdchnl.nsmpls(leCx,:) > 1);
    if getborne       %--- pas de bornes donc pas de calcul selon des bornes temporelles
      fprintf(fid,'Sujet;Condition;trial;RangeX;RangeY;Accroissement;RMSVCOPx;RMSVCOPy;COPsteadymnX;PmnVCOPx;COPsteadymxX;PmxVCOPx;COPsteadymnY;PmnVCOPy;COPsteadymxY;PmxVCOPy;Speed;Surface;VarCPx;VarCPy;VarCPxy;MoyCPx;MoyCPy\n'); 
      for trial = c
        a =hdchnl.nsmpls(leCx, trial);
        renduA =trial/length(c);
        if filtre.stat
          waitbar(renduA,leWb,sprintf('Filtre les DATA & Calcule pour l''essai %i..', trial));
          %--- Filtre les DATA avec une Fc = 10 Hz et ordre 2
          Fc = filtre.fc/(Sfreq/2);
          [B,A] = butter(filtre.ord,Fc);
          B =double(B); A =double(A);
          %--- FILTRE les déplacements du COP selon les axes X et Y
          dtchnl(:,1:2,trial) = filtfilt(B,A,CPdata(:,:,trial));
        else
          waitbar(renduA,leWb,sprintf(' Calcule pour l''essai %i..', trial));
        end
        %--- RANGE et RMS pour CPx ---%
        RangeX = max(dtchnl(:,1,trial)) - min(dtchnl(:,1,trial));
        %--- RANGE et RMS pour CPy ---%
        RangeY = max(dtchnl(:,2,trial)) - min(dtchnl(:,2,trial));
        %--- Steady state COP ---%
        if getrecup   %--- Il y a des bornes pour le calcul de recup
          SteadyX = mean(dtchnl(bornerecup(trial,1):bornerecup(trial,2),1,trial));
          SteadyY = mean(dtchnl(bornerecup(trial,1):bornerecup(trial,2),2,trial));
        else          %--- getrecup ~= 1, il n'y pas de bornes pour le calcul de récup
          SteadyX = NaN;
          SteadyY = NaN;
        end
        %--- SOMMATION des déplacements sans égard à la direction (sommation des déplacements scalaires) ---%
        %--- Accroissement ---%
        Accroissement =sum(sqrt(diff(dtchnl(1:a,1,trial)).^2 + diff(dtchnl(1:a,2,trial)).^2));
        %--- Calcul du centre de pression moyen ---%
        MoyCPx = mean(dtchnl(1:a,1,trial));
        MoyCPy = mean(dtchnl(1:a,2,trial));
        %--- Calcul des variances sur la centre de pression ---%
      	VarCPx = var(dtchnl(1:a,1,trial));
        VarCPy = var(dtchnl(1:a,2,trial));
        VarCPxy = (sum(dtchnl(1:a,1,trial).*dtchnl(1:a,2,trial)) -...
            (sum(dtchnl(1:a,1,trial)).*sum(dtchnl(1:a,2,trial))))/(a*(a-1));            
        %--- Cette partie du CODE a été modifiée du CODE de Duarte et al., 2002
        V = cov(dtchnl(1:a,1,trial),dtchnl(1:a,2,trial));   
        %--- eigenvectors and eigenvalues of the covariance matrix
        [vec,val] = eig(V);   
        lesAxes = 1.96*sqrt(svd(val));           %--- axes
        Surface = pi*prod(lesAxes);              %--- area
        %--- PEAK COP velocity along both axes ---%
        %--- Get COP velocity (VCOP) using moving average, i.e., differ sur la position
        if getrecup        
          %--- VCOPx et RMSVCOPx
          VCOPx = differDtchnl(dtchnl(1:a,1,trial), largeurFen, Sfreq);
          RMSVCOPx = sqrt((sum((VCOPx - 0).^2))/nsmpl); ; 
          %--- VCOPy & RMSVCOPy
          VCOPy = differDtchnl(dtchnl(1:a,2,trial), largeurFen, Sfreq);
          RMSVCOPy = sqrt((sum((VCOPy - 0).^2))/nsmpl); 
          %--- Maximum & Minimum COP velocity (VCOPx & VCOPy) along both axes
          %--- Peak positif pour VCOP selon l'axe X
          [PmxVCOPx,Icopmxx] = max(VCOPx(:,1));  
          %--- CP position with respect to steady value at velocity max along X axis
          COPsteadymxX = SteadyX - CPdata(Icopmxx,1,trial); 
          %--- Peak négatif pour VCOP selon l'axe X
          [PmnVCOPx,Icopmnx] = min(VCOPx(:,1)); 
          %--- CP position with respect to steady value at velocity min along X axis
          COPsteadymnX = SteadyX - CPdata(Icopmnx,1,trial); 
          %--- Selon l'axe Y
          [PmxVCOPy,Icopmxy] = max(VCOPy(:,1));  
          %--- CP position with respect to steady value at velocity max along Y axis
          COPsteadymxY = SteadyY - CPdata(Icopmxy,2,trial); 
          %--- Get minimum velocity ---%
          [PmnVCOPy,Icopmny] = min(VCOPy(:,1));
          %--- CP position with respect to steady value at velocity min along Y axis
          COPsteadymnY = SteadyY - CPdata(Icopmny,2,trial); 
          %--- Max VCOP versus COP & Min VCOP versus COP
        else        %--- Il n'y pas de borne pour le calcul du recup
          %--- VCOPx et RMS
          VCOPx = differDtchnl(dtchnl(1:a,1,trial), largeurFen, Sfreq); 
          RMSVCOPx = sqrt((sum((VCOPx - 0).^2))/nsmpl); 
          %--- VCOPy et RMS
          VCOPy = differDtchnl(dtchnl(1:a,2,trial), largeurFen, Sfreq); 
          RMSVCOPy = sqrt((sum((VCOPy - 0).^2))/nsmpl); ; 
          %--- CP position with respect to steady value max along X axis
          COPsteadymxX = NaN; 
          %--- CP position with respect to steady value min along X axis
          COPsteadymnX = NaN; 
          %--- Selon l'axe Y, Antéro-postérieur (AMTI)
          %--- CP position with respect to steady value max along Y axis
          COPsteadymxY = NaN; 
          %--- CP position with respect to steady value min along Y axis
          COPsteadymnY = NaN; 
          %--- Peak positif pour VCOP selon l'axe X
          [PmxVCOPx,Icopmxx] = max(VCOPx(:,1));  
          %--- Peak négatif pour VCOP selon l'axe X
          [PmnVCOPx,Icopmnx] = min(VCOPx(:,1)); 
          %--- Peak positif pour VCOP selon l'axe Y
          [PmxVCOPy,Icopmxy] = max(VCOPy(:,1));  
          %--- Peak négatif pour VCOP selon l'axe Y
          [PmnVCOPy,Icopmny] = min(VCOPy(:,1));  
        end
        %--- Speed ---%
        Speed = Accroissement/temps;
        %--- HEADER in the output file
        %--- Write data here in data ---%
        if nargin == 8 %--- Il y a écriture des DATA pour le FSSMy
          fprintf(fid,'%s;%s;%u;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f',...
                sujet,nomstim(trial).nom,trial,RangeX,RangeY,Accroissement,RMSVCOPx,RMSVCOPy,FSSMy,COPsteadymnX,PmnVCOPx,COPsteadymxX,PmxVCOPx,COPsteadymnY,PmnVCOPy,COPsteadymxY,PmxVCOPy,Speed,Surface,VarCPx,VarCPy,VarCPxy,MoyCPx,MoyCPy);
          fprintf(fid, '\n');
        else %--- n'aura pas dans le fichier de sortie de variable FSSMy
          fprintf(fid,'%s;%s;%u;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f',...
                sujet,nomstim(trial).nom,trial,RangeX,RangeY,Accroissement,RMSVCOPx,RMSVCOPy,COPsteadymnX,PmnVCOPx,COPsteadymxX,PmxVCOPx,COPsteadymnY,PmnVCOPy,COPsteadymxY,PmxVCOPy,Speed,Surface,VarCPx,VarCPy,VarCPxy,MoyCPx,MoyCPy);
          fprintf(fid, '\n');
        end
      end
    else                 %--- Bornes présente, donc calcul des variables pour chaque borne temporelle
      %--- Transforme les bornes temporelles en itération soit index de Matlab 
      fprintf(fid,'Sujet;Condition;trial;Interval;RangeX;RangeY;Accroissement;RMSVCOPx;RMSVCOPy;COPsteadymnX;PmnVCOPx;COPsteadymxX;PmxVCOPx;COPsteadymnY;PmnVCOPy;COPsteadymxY;PmxVCOPy;Speed;Surface;VarCPx;VarCPy;VarCPxy;MoyCPx;MoyCPy\n');
      intervNUL ='0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0';
      for trial = c
        a =hdchnl.nsmpls(leCx, trial);
        renduA =trial/length(c);
        borne =valeurDeBorne(hObj, ptchnl, trial, Sfreq)
        p =length(borne);
        %--- Écriture du numéro de la borne dans le fichier résultat
        borneID = 1;
        for q = 1:2:p-1  %--- boucle pour les bornes
          if borne(1,q) == borne(1,q+1)
            fprintf(fid,'%s;%s;%u;%u;%s',sujet,nomstim(trial).nom,trial,borneID,intervNUL);
            fprintf(fid, '\n');
            borneID = borneID + 1;  
            continue;
          end
          if filtre.stat && (q == 1)
            waitbar(renduA, leWb, sprintf('Filtre les DATA & Calcule pour l''essai %i..', trial));
            %--- FILTRE les déplacements du COP selon les axes X et Y
            Fc =filtre.fc/(Sfreq/2);
            [B,A] =butter(filtre.ord, Fc);
            B =double(B); A =double(A);
            CPdata(:,1:2,trial) =filtfilt(B,A,CPdata(:,:,trial));
          elseif q == 1
            waitbar(renduA, leWb, sprintf('Calcule pour l''essai %i..', trial));
          end
          %--- RANGE pour CPx ---%
          RangeX = max(CPdata(borne(1,q):borne(1,q+1),1,trial)) - min(CPdata(borne(1,q):borne(1,q+1),1,trial));
          %--- RANGE pour CPy ---%
          RangeY = max(CPdata(borne(1,q):borne(1,q+1),2,trial)) - min(CPdata(borne(1,q):borne(1,q+1),2,trial));
          %--- Calcule steady state for COP ---%
          if getrecup
            SteadyX = mean(CPdata(bornerecup(trial,1):bornerecup(trial,2),1,trial));
            SteadyY = mean(CPdata(bornerecup(trial,1):bornerecup(trial,2),2,trial));
            %--- PEAK COP velocity along both axes ---%
            %--- Get COP velocity (VCOP) using moving average, i.e., differ sur la position fixed windows = 11
            %--- vecteur vitesse -- VCOPx
            VCOPx =differDtchnl(CPdata(borne(1,q):borne(1,q+1),1,trial), largeurFen, Sfreq); 
            RMSVCOPx = sqrt((sum((VCOPx - 0).^2))/nsmpl); 
            %--- vecteur vitesse -- VCOPy
            VCOPy =differDtchnl(CPdata(borne(1,q):borne(1,q+1),2,trial), largeurFen, Sfreq);
            RMSVCOPy = sqrt((sum((VCOPy - 0).^2))/nsmpl); 
            %--- Maximum & Minimum COP velocity (VCOPx & VCOPy) along both axes
            %--- Peak positif pour VCOP selon l'axe X
            [PmxVCOPx,Icopmxx] = max(VCOPx(:,1));  
            %--- Peak négatif pour VCOP selon l'axe X
            [PmnVCOPx,Icopmnx] = min(VCOPx(:,1));  
            %--- CP position with respect to steady value max along X axis
            COPsteadymxX = SteadyX - CPdata(Icopmxx,1,trial); 
            %--- CP position with respect to steady value min along X axis
            COPsteadymnX = SteadyX - CPdata(Icopmnx,1,trial); 
            %--- Peak positif pour VCOP selon l'axe Y
            [PmxVCOPy,Icopmxy] = max(VCOPy(:,1));  
            %--- CP position with respect to steady value max along Y axis
            COPsteadymxY = SteadyY - CPdata(Icopmxy,2,trial); 
            %--- Peak négatif pour VCOP selon l'axe Y
            [PmnVCOPy,Icopmny] = min(VCOPy(:,1));
            %--- CP position with respect to steady value max along Y axis
            COPsteadymnY = SteadyY - CPdata(Icopmny,2,trial); 
          else
            %--- Pas de recup par rapport X
            SteadyX = NaN;
            %--- Pas de recup par rapport Y
            SteadyY = NaN;
            %--- PEAK COP velocity along both axes ---%
            %--- Get COP velocity (VCOP) using moving average, i.e., differ sur la position fixed windows = 11
            %--- vecteur vitesse -- VCOPx
            VCOPx =differDtchnl(CPdata(borne(1,q):borne(1,q+1),1,trial), largeurFen, Sfreq); 
            RMSVCOPx = sqrt((sum((VCOPx - 0).^2))/nsmpl); 
            %--- vecteur vitesse -- VCOPy
            VCOPy =differDtchnl(CPdata(borne(1,q):borne(1,q+1),2,trial), largeurFen, Sfreq);
            RMSVCOPy = sqrt((sum((VCOPy - 0).^2))/nsmpl); 
            %--- Maximum & Minimum COP velocity (VCOPx & VCOPy) along both axes
            %--- Peak positif pour VCOP selon l'axe X
            [PmxVCOPx,Icopmxx] = max(VCOPx(:,1));  
            %--- Peak négatif pour VCOP selon l'axe X
            [PmnVCOPx,Icopmnx] = min(VCOPx(:,1));  
            %--- CP position with respect to steady value max along X axis
            COPsteadymxX = NaN;
            %--- CP position with respect to steady value min along X axis
            COPsteadymnX = NaN; 
            %--- Peak positif pour VCOP selon l'axe Y
            [PmxVCOPy,Icopmxy] = max(VCOPy(:,1));  
            %--- CP position with respect to steady value max along Y axis
            COPsteadymxY = NaN; 
            %--- Peak négatif pour VCOP selon l'axe Y
            [PmnVCOPy,Icopmny] = min(VCOPy(:,1));
            %--- CP position with respect to steady value max along Y axis
            COPsteadymnY = NaN; 
          end
          %--- SOMMATION des déplacements sans égard à la direction (sommation des déplacements scalaires) ---%
          %  ANCIEN SCRIPT
          %  Accroissement =0;
          %  for k =borne(1,q):borne(1,q+1)-1
          %    if k == a
          %      break                   
          %    else
          %      Accroissement =Accroissement+sqrt((CPdata(k+1,1,trial)-CPdata(k,1,trial))^2+(CPdata(k+1,2,trial)-CPdata(k,2,trial))^2);
          %    end
          %  end
          Accroissement =sum(sqrt(diff(CPdata(borne(1,q):borne(1,q+1),1,trial)).^2 + diff(CPdata(borne(1,q):borne(1,q+1),2,trial)).^2));
          %--- Calcul du centre de pression moyen ---%
          MoyCPx = mean(CPdata(borne(1,q):borne(1,q+1),1,trial));
          MoyCPy = mean(CPdata(borne(1,q):borne(1,q+1),2,trial));
          %--- Calcul des variances sur la centre de pression ---%
      	  VarCPx  = var(CPdata(borne(1,q):borne(1,q+1),1,trial));
          VarCPy  = var(CPdata(borne(1,q):borne(1,q+1),2,trial));
          VarCPxy = (sum(CPdata(borne(1,q):borne(1,q+1),1,trial).*CPdata(borne(1,q):borne(1,q+1),2,trial)) -...
          (sum(CPdata(borne(1,q):borne(1,q+1),1,trial)).*sum(CPdata(borne(1,q):borne(1,q+1),2,trial))))/(a * (a-1));            
          %--- Cette partie du CODE a été modifiée du CODE de Duarte et al., 2002
          V = cov(dtchnl(borne(1,q):borne(1,q+1),1,trial),dtchnl(borne(1,q):borne(1,q+1),2,trial));   
          %--- eigenvectors and eigenvalues of the covariance matrix
          [vec,val] = eig(V);   
          lesAxes = 1.96*sqrt(svd(val));           %--- axes
          Surface = pi*prod(lesAxes);              %--- area
          %--- Speed ---%
          %--- Note: divisé par du temps donc transforme les bornes à nouveau en temps
          Speed = Accroissement/((borne(1,q+1)-borne(1,q))/Sfreq);
          %--- Write data here ---%
          %--- n'aura pas dans le fichier de sortie de variable SSMy (23 - variables)
          fprintf(fid,'%s;%s;%u;%u;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f;%6.4f',...
                  sujet,nomstim(trial).nom,trial,borneID,RangeX,RangeY,Accroissement,RMSVCOPx,RMSVCOPy,COPsteadymnX,PmnVCOPx,COPsteadymxX,PmxVCOPx,COPsteadymnY,PmnVCOPy,COPsteadymxY,PmxVCOPy,Speed,Surface,VarCPx,VarCPy,VarCPxy,MoyCPx,MoyCPy);
          fprintf(fid, '\n');
          borneID = borneID + 1;  
        end
        borneID = 1;   %--- reset to 1, change d'essai
      end
    end
  catch e
    fclose(fid);
    delete(leWb);
    rethrow(e);
  end
  %--- Fichier de sortie ---%
  fclose(fid);
  delete(leWb);
end

function [vi, vf] =valeurDeRecup(tO, pt, ess, cX)
  vi(ess,1) =0;
  vf =vi;
  iText =tO.getRecupDebutText;
  fText =tO.getRecupFinText;
  for u =1:ess;
    a =pt.valeurDePoint(iText, cX, u);
    b =pt.valeurDePoint(fText, cX, u);
    if isempty(a) || isempty(b) || (a == b)
      me =MException('ANALYSE:stat4COP:valeurDeRecup', 'Les début/fin de RECUP ne sont pas valides');
      throw(me);
    end
    if a > b
      s =a;
      a =b;
      b =s;
    end
    vi(u) =a;
    vf(u) =b;
  end
end

function v =valeurDeBorne(tO, pt, ess, f)
  texto =strtrim(tO.getBornesText());
  mots =regexp(texto,'\s+','split');
  v =[];
  if strncmpi(texto, 'i', 1)
    deb =pt.valeurDePoint(mots{2}, tO.getCanCpx, ess);
    fin =pt.valeurDePoint(mots{3}, tO.getCanCpx, ess);
    inc =pt.valeurDeTemps(mots{4}, tO.getCanCpx, ess)*f;
    ovl =pt.valeurDeTemps(mots{5}, tO.getCanCpx, ess)*f;
    while (deb+inc <= fin)
      v(end+1) =deb;
      v(end+1) =deb+inc;
      deb =deb+inc+ovl;
    end
  else
    if mod(length(mots), 2) == 1
      mots(end) =[];
    end
    v(length(mots)) =0;
    for u =1:length(v)
      v(u) =pt.valeurDePoint(mots{u}, tO.getCanCpx, ess); 
    end
  end
end
