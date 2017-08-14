%
% Le nom de la classe correspond au nom du fichier appelé
% pour traiter ce cas.
%
function cc =initparam(laclasse,cc,elno,eltot)
  cc =fabric(laclasse,cc,eltot);
  cc(eltot).ChoixEntree =1;
  cc(eltot).ChoixSortie =4;
  cc(eltot).isFichierIn =0;
  cc(eltot).isFichierOut =0;
  cc(eltot).ListeFentree ={'aucun fichier à traiter'};
  cc(eltot).ListeFsortie ={'Fichier de sortie à déterminer'};
  cc(eltot).PathEntree ='.';
  cc(eltot).PathSortie ='.';
  cc(eltot).prefixe =1;
  cc(eltot).prenom =[];
  cc(eltot).exten ='.mat';
  cc(eltot).NbFTraiter =0;
  cc(eltot).FichierLien =0;
  cc(eltot).elno =elno;
return

function vv =fabric(LaClasse,vv,lindex)
  vv(lindex).status =0;
  vv(lindex).erreur =0;
  vv(lindex).laclasse =LaClasse;
  switch LaClasse
  %-------------
  case 'suppcan'
    vv(lindex).descr =['Supprimer Canaux()'];
    vv(lindex).intro =['Supprimer Canaux('];
    vv(lindex).listcan =[];
  end
return
