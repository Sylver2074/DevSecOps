#!/bin/bash

# Script d'installation des pre-commit hooks
# À exécuter après le clonage du dépôt: bash scripts/install-hooks.sh

set -e

HOOKS_DIR=".git/hooks"
PRE_COMMIT_FILE="$HOOKS_DIR/pre-commit"

echo "📋 Installation des pre-commit hooks..."

# Créer le dossier hooks s'il n'existe pas
mkdir -p "$HOOKS_DIR"

# Créer le fichier pre-commit
cat > "$PRE_COMMIT_FILE" << 'EOF'
#!/bin/bash

# Git pre-commit hook pour valider les workflows GitHub Actions
# Ce script empêche un commit si les fichiers YAML de workflow contiennent des erreurs

set -e

# Vérifier si actionlint est disponible
if ! command -v actionlint &> /dev/null; then
  echo "❌ actionlint n'est pas installé"
  echo "Installation requise: npm install -g actionlint"
  exit 1
fi

# Valider tous les fichiers YAML dans .github/workflows
if [ -d ".github/workflows" ]; then
  echo "🔍 Validation des workflows GitHub Actions..."
  if actionlint .github/workflows/*.yml 2>&1; then
    echo "✅ Tous les workflows sont valides"
    exit 0
  else
    echo "❌ Des erreurs de validation ont été détectées dans les workflows"
    echo "Corrigez les erreurs et relancez le commit"
    exit 1
  fi
else
  echo "⚠️  Dossier .github/workflows non trouvé"
  exit 0
fi
EOF

# Attribuer les droits d'exécution
chmod +x "$PRE_COMMIT_FILE"

echo "✅ Pre-commit hook installé avec succès"
echo "🔐 Le hook validera les workflows GitHub Actions avant chaque commit"
