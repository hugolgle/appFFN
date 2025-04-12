# Détection de Mouvement - Application d'Exercice Physique

## Auteur

- [@hugolgle](https://www.github.com/hugolgle)

## Description de l'Application

Cette application Flutter utilise les capteurs de mouvement (accéléromètre) du téléphone pour détecter les mouvements physiques pendant un exercice, comme les pompes. Elle permet de suivre en temps réel le nombre de répétitions effectuées ainsi que le temps restant pour l'exercice. L'application enregistre également les données localement et peut envoyer les résultats à un serveur une fois l'exercice terminé.

### Fonctionnalités principales :
- **Détection des mouvements** : L'application détecte les mouvements de l'utilisateur, comme la descente et la remontée lors des pompes, en analysant les données de l'accéléromètre.
- **Compte des répétitions** : À chaque remontée détectée, le nombre de pompes est incrémenté et affiché à l'utilisateur.
- **Chronomètre** : Un timer est intégré pour suivre le temps restant pendant l'exercice.
- **Sauvegarde locale** : Les données comme le nombre de pompes effectuées et le temps restant sont stockées localement.
- **Envoi des données au backend** : Les résultats de l'exercice (nombre de pompes et temps restant) sont envoyés à un serveur une fois l'exercice terminé.

## Comment fonctionne l'application

L'application utilise les capteurs d'accéléromètre et de gyroscope du téléphone pour détecter les mouvements physiques de l'utilisateur pendant les pompes. Le capteur détecte les phases de descente (lorsque l'utilisateur s'abaisse) et de remontée (lorsque l'utilisateur revient à la position initiale). À chaque remontée, le nombre de pompes est incrémenté et affiché à l'utilisateur en temps réel.

### Détails techniques :
1. **Accéléromètre** : L'application écoute les changements de valeurs sur l'axe Y pour déterminer les mouvements. Une phase descendante est détectée lorsqu'une valeur de Y dépasse un seuil, et une phase ascendante est détectée lorsque Y descend sous un certain seuil.
2. **Gyroscope** : Le gyroscope est utilisé pour obtenir des informations supplémentaires sur les rotations du téléphone. Cela permet de compléter les données de l'accéléromètre et de fournir une détection plus précise des mouvements pendant l'exercice. Les rotations sur les axes X, Y et Z sont surveillées pour affiner la détection des phases de l'exercice.
3. **Timer** : Un chronomètre de 30 secondes est lancé au début de chaque session d'exercice. Le temps restant est affiché et mis à jour à chaque seconde.
4. **Sauvegarde des données** : Les données de l'exercice (compteur de pompes et temps restant) sont sauvegardées localement à l'aide du package `shared_preferences`.
5. **Backend** : Une fois l'exercice terminé, les données sont envoyées à un serveur simulé via une requête HTTP POST.

## Comment lancer l'application

1. Clonez le projet depuis le dépôt GitHub :

   ```bash
   git clone https://github.com/hugolgle/appFFN.git
   ```

2. Allez dans le répertoire du projet :

   ```bash
   cd appffn
   ```

3. Installez les dépendances Flutter :

   ```bash
   flutter pub get
   ```

4. Lancez l'application :

   ```bash
   flutter run
   ```

L'application devrait maintenant être lancée sur votre émulateur ou appareil mobile.

## Les exercices implémentés

### Exercice des Pompes :
- **Détection de mouvement** : L'utilisateur effectue des pompes, et chaque remontée est comptabilisée comme une pompe réussie.
- **Durée de l'exercice** : Un chronomètre de 30 secondes est lancé pour chaque session d'exercice. Si l'utilisateur termine avant la fin, les données sont envoyées immédiatement.
- **Suivi** : À chaque pompe réussie, le nombre total de pompes est mis à jour à l'écran. Le temps restant est également affiché en temps réel.

---

## License

Ce projet est sous la licence MIT - consultez le fichier [LICENSE](LICENSE) pour plus de détails.