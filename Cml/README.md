Dossier Cml

C --> Classe<br/>
m --> multi<br/>
l --> Lingue<br/>

<H2>Introduction<H2/>
Analyse est devenu multilingue au début 2015. Suite aux demandes des étudiants du monde anglophone qui retournaient y travailler comme professeur après avoir fait un Bac/maîtrise ou doc  en kinésiologie.
Ce fichier de documentation s’adresse au programmeur et non à l’utilisateur. Car ce dernier n’a pas à se soucier de la façon dont est gérée le multilinguisme, il doit seulement savoir qu’on peut changer la langue via le GUI des préférences.
<Méthode pédagogique>
Pour expliquer comment procéder, je me servirai du GUI pour la lecture des fichiers au format  Keithley. En suivant les étapes, vous verrez qu’il y a de la redondance dans la manière de faire. Mais, elle n’est pas inutile. De sorte que si la BD des chaînes de caractère est perdue par mégarde, on peut encore fonctionner dans la langue native d’Analye : le français.
À la base, lorsque je code un GUI, je n’écris pas de texte directement. J’utilise plutôt des variables qui peuvent être changées via une BD. Par exemple,
uicontrol('Position', [x y L H], 'Style', 'text', 'String', 'Appuyez pour sauvegarder');
est changé pour
lesMots =  'Appuyez pour sauvegarder';
uicontrol('Position', [x y L H], 'Style', 'text', 'String', lesMots);


On retrouvera ici les classes utiles pour avoir les strings par défaut (en français).
Dans le dossier Lang, on trouvera des mfile pour fabriquer les fichiers de string dans différentes langues.

ex.  en français,  ../lang/langue_fr.m
