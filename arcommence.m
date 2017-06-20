% 
% 
% Ci-joint, la fonction permettant d’estimer la position du centre de gravité à partir des
% données de plateforme de force. Tu verras que les entrées de la fonction sont un vecteur
% temps, la force antéro-postérieur (Fy), la position du centre de pression selon l’axe
% antéro-postérieur (COPy) et la masse du participant.
% 
% Ça serait super si nous pouvions appliquer cette fonction pour les données selon
% l’axe antéro-postérieur et l’axe médio-latérale. Ainsi, nous aurions une estimation
% de la position du centre de gravité selon chaque axe.
% 
% Selon chaque axe, nous pourrions calculer l’écart entre le COPy – COGy et le COPx – COGx,
% nous obtenons deux nouveaux canaux représentant l’accélération selon l’axe Y et X
% respectivement. 
% 
% Ensuite, dans Stat4COP, nous pourrions calculer la valeur RMS de l’accélération selon
% chaque axe.
% 
% Je sais qu’il y a « deux pièges ». Le premier concerne les unités du COP alors que le
% deuxième est la direction de la force. Donc, en fonction des données passées, je
% multipliais la force par -1 et les données du déplacement du COP par 10 et divisais le
% tout par 10 !
% 
%% Lecture du fichier de données
[hdchnl,ptchnl,tpchnl,catego,vg,autre] = lireAnalyse(fichDATA);

 
%% Récupération des données
% Force horizontal selon l'axe antéro-postérieur
Fap = double(getcanal(fichDATA,canal(1,1))); 
% Force verticale, permet de déterminer la masse de la personne
FGrav = double(getcanal(fichDATA,canal(1,2))); 
% CPy (position du centre de pression selon l'axe antéro-postérieur)
CPap = double(getcanal(fichDATA,canal(1,3)));

%% Calcule de la position du centre de masse 
% Poids de la personne : moyenne de la force verticale (N)
FGrav = mean(FGrav(FGrav(:)~=0));
% Masse du participant (kg)
Masse = FGrav/9.8;
% Création d'un vecteur temps (s) : 
temps = [1:hdchnl.sweeptime(1,1)]'/hdchnl.rate(1,1);
% code pour calcule la position du centre de gravité, projection dans la
% base de support de la position du centre de masse
for ess = 1:size(CPap,2)
    COGap(:,ess)= GLINE(temps, Fap(:,ess).*-1, CPap(:,ess).*10, Masse)./10;
end
