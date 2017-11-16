# analyse
Programme d'analyse de données, initié sous Matlab vers la fin 1996. Dans le but de remplacer une suite de petites applications qui servait à faire l'analyse des données sous l'OS DOS en 16 bits. Compte tenu de cette limitation et du fait que chaque application avait ses petits caprices, le développement d'une application qui engloberait toutes les petites, fût débuté.

Le choix de développer sous Matlab fût décidé principalement parce que les usagers étaient des étudiants, professeurs ou chercheurs qui pouvait écrire des "m-file" pour faire des petits à côtés tout en utilisant l'application d'analyse développé. Je ne regrette toujours pas le choix, car beaucoup d'étudiants se sont initiés à la programmation via les m-files. Ils n'en sont que plus autonomes.

C'est maintenant le temps de passer le flambeau. Comme plusieurs utilisent encore les applications développées avec Matlab et que les subventions sont de plus en plus petites. Je trouve que pour bien des labo, Matlab devient un luxe. C'est pourquoi j'ai décidé d'apporter une dernière contribution en rendant les m-files exécutables sous Octave.

Pour les problèmes d'affichage entre les différents OS, j'y travaille. C'est non seulement entre les OS, mais c'est aussi entre les fichiers sauvegardés sous Matlab et ceux fait avec Octave...

MEK
2016-11-17



PS: Installation sous Linux/Matlab (Jean-Philippe Pialasse)

$ cd /home/userId/Documents/MATLAB
(n'oubliez pas de changer "userId" pour votre nom d'usager)

$ git clone https://github.com/ProjectMEK/analyse.git

$ git clone https://github.com/ProjectMEK/communs.git

lancer Matlab

naviguer vers /home/userId/Documents/MATLAB/analyse/install/

lancer startAnalyse.m

