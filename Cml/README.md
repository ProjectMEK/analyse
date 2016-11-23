Dossier Cml

C --> Classe<br/>
m --> multi<br/>
l --> Lingue<br/>

<H2>Introduction</H2>
Analyse est devenu multilingue au début 2015. Suite aux demandes des étudiants du monde anglophone qui retournaient y travailler comme professeur après avoir fait un Bac/maîtrise ou doc  en kinésiologie.
Ce fichier de documentation s’adresse au programmeur et non à l’utilisateur. Car ce dernier n’a pas à se soucier de la façon dont est gérée le multilinguisme, il doit seulement savoir qu’on peut changer la langue via le GUI des préférences.
<H2>Méthode pédagogique</H2>
Pour expliquer comment procéder, je me servirai du GUI pour la lecture des fichiers au format  Keithley. En suivant les étapes, vous verrez qu’il y a de la redondance dans la manière de faire. Mais, elle n’est pas inutile. De sorte que si la BD des chaînes de caractère est perdue par mégarde, on peut encore fonctionner dans la langue native d’Analye : le français.
À la base, lorsque je code un GUI, je n’écris pas de texte directement. J’utilise plutôt des variables qui peuvent être changées via une BD. Par exemple,
uicontrol('Position', [x y L H], 'Style', 'text', 'String', 'Appuyez pour sauvegarder');
est changé pour
lesMots =  'Appuyez pour sauvegarder';
uicontrol('Position', [x y L H], 'Style', 'text', 'String', lesMots);
<H2>Fichiers utiles</H2>
Comme je l’ai mentionné plus haut, je vais partir du développement de la lecture d’un fichier Keithley pour expliquer la démarche.

<table cellspacing="0" cellpadding="4" border="0" width="80%">
<th>Nom du mfile</th><th>Description</th>
  <tr valign="top">
    <td width="20%">
      <p><center>
         CLirKeithley.m
      </center></p>
    </td>
    <td>
      <p>
      	Code de la classe CLirKeithley. Gère tout le travail pour mener à bien la lecture du fichier (classe principale).<br/>
      </p>
    </td>
  </tr>
  <tr valign="top">
    <td width="20%">
      <p><center>
         CLirOutils.m
      </center></p>
    </td>
    <td>
      <p>
      	Code de la classe CLirOutils. (La classe CLirKeithley en hérite). Contient des outils utilisés par tous les types de lecteur de fichier.<br/>
      </p>
    </td>
  </tr>
  <tr valign="top">
    <td width="20%">
      <p><center>
         GUILirKeithley.m
      </center></p>
    </td>
    <td>
      <p>
      	Code du GUI utile pour la lecture.<br/>
      </p>
    </td>
  </tr>
  <tr valign="top">
    <td width="20%">
      <p><center>
         Cml\CGUIMLLire.m
      </center></p>
    </td>
    <td>
      <p>
      	Code de la classe CGuiMLLire. On se sert de ses propriétés pour stocker le texte à afficher dans le GUI.<br/>
      </p>
    </td>
  </tr>
  <tr valign="top">
    <td width="20%">
      <p><center>
         CBaseStringGUI.m
      </center></p>
    </td>
    <td>
      <p>
      	Code de la classe CBaseStringGUI. (Toutes les classes CGuiML… en héritent). Contient des outils pour gérer la récupération des strings.<br/>
      </p>
    </td>
  </tr>
  <tr valign="top">
    <td width="20%">
      <p><center>
         Lang\langue_fr.m
      </center></p>
    </td>
    <td>
      <p>
      	Fonction pour créer la BD (doc\fr.mat) qui sera lu par Analyse, version française et contenant les chaînes de caractères utiles au GUI.<br/>
      </p>
    </td>
  </tr>
  <tr valign="top">
    <td width="20%">
      <p><center>
         Lang\langue_en.m
      </center></p>
    </td>
    <td>
      <p>
      	Fonction pour créer la BD (doc\en.mat) qui sera lu par Analyse, version anglaise et contenant les chaînes de caractères utiles au GUI.<br/>
      </p>
    </td>
  </tr>
</table>

Lorsque l’on bâti le GUI, ici GUILirKeithley.m, les chaînes de caractères doivent être définies dans une classe, ici CGUIMLLire.m (dans le dossier Cml). Les propriétés de cette classe contiendront les chaînes de caractères, version française. Toutes les classes CGUIML…
-	Hériteront de CBaseStringGUI
-	Leur constructeur doit lancer :  Obj.init(‘nom_struct’) 
La méthode init appartient à CBaseStringGUI. Elle s’occupera de
-	Récupérer la structure « nom_struct » .
-	Modifier les propriétés en vue de l’affichage dans le GUI.
