% 
% 
% Ci-joint, la fonction permettant d�estimer la position du centre de gravit� � partir des
% donn�es de plateforme de force. Tu verras que les entr�es de la fonction sont un vecteur
% temps, la force ant�ro-post�rieur (Fy), la position du centre de pression selon l�axe
% ant�ro-post�rieur (COPy) et la masse du participant.
% 
% �a serait super si nous pouvions appliquer cette fonction pour les donn�es selon
% l�axe ant�ro-post�rieur et l�axe m�dio-lat�rale. Ainsi, nous aurions une estimation
% de la position du centre de gravit� selon chaque axe.
% 
% Selon chaque axe, nous pourrions calculer l��cart entre le COPy � COGy et le COPx � COGx,
% nous obtenons deux nouveaux canaux repr�sentant l�acc�l�ration selon l�axe Y et X
% respectivement. 
% 
% Ensuite, dans Stat4COP, nous pourrions calculer la valeur RMS de l�acc�l�ration selon
% chaque axe.
% 
% Je sais qu�il y a � deux pi�ges �. Le premier concerne les unit�s du COP alors que le
% deuxi�me est la direction de la force. Donc, en fonction des donn�es pass�es, je
% multipliais la force par -1 et les donn�es du d�placement du COP par 10 et divisais le
% tout par 10 !
% 
%% Lecture du fichier de donn�es
[hdchnl,ptchnl,tpchnl,catego,vg,autre] = lireAnalyse(fichDATA);

 
%% R�cup�ration des donn�es
% Force horizontal selon l'axe ant�ro-post�rieur
Fap = double(getcanal(fichDATA,canal(1,1))); 
% Force verticale, permet de d�terminer la masse de la personne
FGrav = double(getcanal(fichDATA,canal(1,2))); 
% CPy (position du centre de pression selon l'axe ant�ro-post�rieur)
CPap = double(getcanal(fichDATA,canal(1,3)));

%% Calcule de la position du centre de masse 
% Poids de la personne : moyenne de la force verticale (N)
FGrav = mean(FGrav(FGrav(:)~=0));
% Masse du participant (kg)
Masse = FGrav/9.8;
% Cr�ation d'un vecteur temps (s) : 
temps = [1:hdchnl.sweeptime(1,1)]'/hdchnl.rate(1,1);
% code pour calcule la position du centre de gravit�, projection dans la
% base de support de la position du centre de masse
for ess = 1:size(CPap,2)
    COGap(:,ess)= GLINE(temps, Fap(:,ess).*-1, CPap(:,ess).*10, Masse)./10;
end
