Documentation test WeSave

Niveau 1 

L’objectif du niveau 1 est de mettre en place un endpoint API permettant de retourner les portefeuilles et placements stockés en base de données (données seedées) au format JSON.


Endpoint implémenté :
- Requête HTTP : GET
- Url : /level1/portfolios

Cet endpoint interroge la base de données et retourne les portefeuilles et leurs placements associés au format JSON.

Exemple :
{
  "contracts": [
    {
      "label": "Portefeuille d'actions",
      "type": "CTO",
      "amount": 15000,
      "lines": [
        {
          "type": "stock",
          "isin": "FR0000120172",
          "label": "Apple Inc.",
          "price": 150,
          "share": 0.2,
          "amount": 15000,
          "srri": 6
        }

Instructions pour lancer l’application :
Dans le terminal : 
- bundle install
- rails db:create
- rails db:migrate
- rails db:seed
- rails s

L’application est disponible avec : http://localhost:3000

Tests :
- Démarrage du serveur : - Commande rails s
                            - Résultat attendu : démarrage sans erreur
- Accès à l’endpoint : - Requête GET
                        - Résultat attendu : code HTTP 200, aucune modification des données

Conclusion :
Le niveau 1 est validé par la mise en place d’une requête GET qui retourne les données issues de la base de données, seedées au démarrage de l’application.


Niveau 2 

L’objectif est d’exposer une API qui permet de modifier ses placements au sein d’un portefeuille, dépôt, retrait et transfert.

Endpoint implementé :
- PATCH /level2/placements

Il reçoit une action à effectuer sur les placements stockés en base de données pour un portefeuille donné.

Paramètres : 
Champ	Type	Description
action_type	string	Type d’opération
portfolio_label	string	Nom du portefeuille ciblé
isin		Identifiant du placement
amount	number	Montant à ajouter/retirer/transférer
from_isin		isin de la source
to_isin		isin de la destination


Instructions pour lancer l’application :
Dans le terminal :
- rails s

L’application est disponible avec : http://localhost:3000

Tests :
(Verification après chaque test : curl "http://localhost:3000/level1/portfolios », lecture de l’état courant en base de données)

Test 1 - Dépôt (requête)
On ajoute 10 unités monétaires au placement identifié par FR0000120172 :

curl -X PATCH "http://localhost:3000/level2/placements" \
  -H "Content-Type: application/json" \
  -d @- <<'JSON'
{
  "action_type": "deposit",
  "portfolio_label": "Portefeuille d'actions",
  "isin": "FR0000120172",
  "amount": 10
}
JSON

Test 2 - Retrait (requête)
On retire 10 unités monétaires du placement ciblé :

curl -X PATCH "http://localhost:3000/level2/placements" \
  -H "Content-Type: application/json" \
  -d @- <<'JSON'
{
  "action_type": "withdraw",
  "portfolio_label": "Portefeuille d'actions",
  "isin": "FR0004567890",
  "amount": 10
}
JSON

Test 3 - Transfert (requête)
10 unités sont retirées du placement source, 10 unités sont ajoutées au placement destination :

curl -X PATCH "http://localhost:3000/level2/placements" \
  -H "Content-Type: application/json" \
  -d @- <<'JSON'
{
  "action_type": "transfer",
  "portfolio_label": "Portefeuille d'actions",
  "from_isin": "FR0004567890",
  "to_isin": "FR0000120172",
  "amount": 10
}
JSON

Conclusion : 
L’API implémentée pour le niveau 2 permet de modifier des placements existants stockés en base de données et garantit la cohérence des montants après chaque opération.
