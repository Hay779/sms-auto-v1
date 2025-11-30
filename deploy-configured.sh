#!/bin/bash

# ═══════════════════════════════════════════════════════════════════
# SCRIPT DE DÉPLOIEMENT AUTOMATIQUE - SMS AUTOMATISATION
# Configuration pour : hay779/sms-auto-v2
# ═══════════════════════════════════════════════════════════════════

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "═══════════════════════════════════════════════════════════════════"
    echo "  $1"
    echo "═══════════════════════════════════════════════════════════════════"
    echo -e "${NC}"
}

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

clear
print_header "DÉPLOIEMENT - SMS AUTOMATISATION"

# Configuration
GITHUB_USER="hay779"
REPO_NAME="sms-auto-v2"
REPO_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo ""
print_info "Configuration détectée :"
echo "  GitHub User : $GITHUB_USER"
echo "  Repo Name   : $REPO_NAME"
echo "  Repo URL    : $REPO_URL"
echo ""

# Vérifier Git
if ! command -v git &> /dev/null; then
    print_error "Git n'est pas installé !"
    exit 1
fi
print_success "Git installé"

echo ""
print_header "ÉTAPE 1 : INITIALISATION GIT"

if [ -d ".git" ]; then
    print_info "Git déjà initialisé"
else
    git init
    print_success "Git initialisé"
fi

# Créer/Vérifier .gitignore
if [ ! -f ".gitignore" ]; then
    print_warning "Création de .gitignore..."
    cat > .gitignore << 'EOF'
node_modules/
dist/
.env
.env.local
*.log
.DS_Store
.vercel
EOF
    print_success ".gitignore créé"
fi

echo ""
print_header "ÉTAPE 2 : COMMIT DES FICHIERS"

git add .
print_success "Fichiers ajoutés"

if git commit -m "Initial commit - SMS Automatisation"; then
    print_success "Commit créé"
else
    print_warning "Rien à commiter ou commit déjà fait"
fi

echo ""
print_header "ÉTAPE 3 : CONFIGURATION DU REMOTE GITHUB"

if git remote | grep -q "origin"; then
    CURRENT_REMOTE=$(git remote get-url origin)
    print_info "Remote existant : $CURRENT_REMOTE"
    
    if [ "$CURRENT_REMOTE" != "$REPO_URL" ]; then
        git remote set-url origin "$REPO_URL"
        print_success "Remote mis à jour : $REPO_URL"
    fi
else
    git remote add origin "$REPO_URL"
    print_success "Remote ajouté : $REPO_URL"
fi

echo ""
print_header "ÉTAPE 4 : PUSH SUR GITHUB"

CURRENT_BRANCH=$(git branch --show-current)
if [ -z "$CURRENT_BRANCH" ]; then
    CURRENT_BRANCH="main"
    git branch -M main
fi

print_info "Push vers $GITHUB_USER/$REPO_NAME..."

if git push -u origin "$CURRENT_BRANCH"; then
    print_success "Code poussé sur GitHub !"
else
    print_error "Erreur lors du push"
    print_info "Assurez-vous que le repo existe sur GitHub"
    print_info "Créez-le ici : https://github.com/new"
    exit 1
fi

echo ""
print_header "ÉTAPE 5 : CONFIGURATION VERCEL"

echo ""
print_success "✅ Code déployé sur GitHub !"
echo ""
print_info "Prochaines étapes pour Vercel :"
echo ""
echo "  1. Allez sur https://vercel.com"
echo "  2. Connectez-vous avec GitHub"
echo "  3. Importez le repo : $GITHUB_USER/$REPO_NAME"
echo "  4. Ajoutez ces variables d'environnement :"
echo ""
echo "     ┌──────────────────────────────────────────────────────────┐"
echo "     │ VITE_SUPABASE_URL                                        │"
echo "     │ https://wxhrcjzgdelllrdvtdvr.supabase.co                │"
echo "     ├──────────────────────────────────────────────────────────┤"
echo "     │ VITE_SUPABASE_ANON_KEY                                   │"
echo "     │ eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBh...│"
echo "     └──────────────────────────────────────────────────────────┘"
echo ""
echo "  5. Cliquez sur Deploy"
echo "  6. Attendez 1-2 minutes"
echo "  7. Votre app sera en ligne ! 🎉"
echo ""
print_info "URL du repo : https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
print_success "Déploiement terminé !"
echo ""
