# 1. Cloner le dépôt
cd DevSecOps

# 2. Installer actionlint globalement
npm install -g actionlint

# 3. Installer les dépendances du projet
npm install

# 4. Installer le pre-commit hook
bash scripts/install-hooks.sh

# 5. Valider les workflows
actionlint .github/workflows/ci.yml

# 6. Tester les tests de l'application
npm test