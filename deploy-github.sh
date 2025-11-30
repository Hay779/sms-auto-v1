#!/bin/bash

# ═══════════════════════════════════════════════════════════════════
# SCRIPT DE DÉPLOIEMENT AUTOMATIQUE - GITHUB
# ═══════════════════════════════════════════════════════════════════

set -e

# Couleurs
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

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Début
clear
print_header "DÉPLOIEMENT GITHUB - SMS AUTOMATISATION"

# Vérifier Git
print_info "Vérification de Git..."
if ! command -v git &> /dev/null; then
    print_error "Git n'est pas installé !"
    echo "Installez Git depuis https://git-scm.com"
    exit 1
fi
GIT_VERSION=$(git --version)
print_success "$GIT_VERSION détecté"

echo ""
print_header "ÉTAPE 1 : INITIALISATION GIT"

# Vérifier si Git est déjà initialisé
if [ -d ".git" ]; then
    print_info "Git est déjà initialisé"
else
    git init
    print_success "Git initialisé"
fi

# Créer .gitignore si nécessaire
if [ ! -f ".gitignore" ]; then
    print_warning ".gitignore manquant"
    read -p "Voulez-vous créer un .gitignore standard ? (Y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
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
else
    print_info ".gitignore existe déjà"
fi

# Afficher le statut
echo ""
print_info "Fichiers à commiter :"
git status --short

echo ""
print_header "ÉTAPE 2 : COMMIT DES CHANGEMENTS"

# Demander le message de commit
echo -e "${YELLOW}Entrez le message de commit (ou laissez vide pour 'Update'):${NC}"
read -r COMMIT_MESSAGE
if [ -z "$COMMIT_MESSAGE" ]; then
    COMMIT_MESSAGE="Update"
fi

# Ajouter tous les fichiers
git add .
print_success "Fichiers ajoutés"

# Commiter
git commit -m "$COMMIT_MESSAGE"
print_success "Commit créé : $COMMIT_MESSAGE"

echo ""
print_header "ÉTAPE 3 : CONFIGURATION DU REPO DISTANT"

# Vérifier si un remote existe
if git remote | grep -q "origin"; then
    CURRENT_REMOTE=$(git remote get-url origin)
    print_info "Remote existant : $CURRENT_REMOTE"
    
    read -p "Voulez-vous changer le remote ? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Entrez l'URL du nouveau repo GitHub :${NC}"
        echo "Format : https://github.com/USERNAME/REPO.git"
        read -r REPO_URL
        git remote set-url origin "$REPO_URL"
        print_success "Remote mis à jour"
    fi
else
    print_warning "Aucun remote configuré"
    echo ""
    echo -e "${YELLOW}Pour créer un repo GitHub :${NC}"
    echo "1. Allez sur https://github.com"
    echo "2. Cliquez sur '+' → New repository"
    echo "3. Nommez-le 'sms-automatisation'"
    echo "4. NE cochez PAS 'Initialize with README'"
    echo "5. Créez le repo et copiez l'URL"
    echo ""
    echo -e "${YELLOW}Entrez l'URL de votre repo GitHub :${NC}"
    echo "Format : https://github.com/USERNAME/REPO.git"
    read -r REPO_URL
    
    if [ -z "$REPO_URL" ]; then
        print_error "URL vide, abandon"
        exit 1
    fi
    
    git remote add origin "$REPO_URL"
    print_success "Remote ajouté : $REPO_URL"
fi

echo ""
print_header "ÉTAPE 4 : PUSH SUR GITHUB"

# Vérifier la branche actuelle
CURRENT_BRANCH=$(git branch --show-current)
if [ -z "$CURRENT_BRANCH" ]; then
    CURRENT_BRANCH="main"
    git branch -M main
    print_info "Branche renommée en 'main'"
fi

print_info "Branche actuelle : $CURRENT_BRANCH"

# Push
print_info "Push en cours..."
if git push -u origin "$CURRENT_BRANCH"; then
    print_success "Code poussé sur GitHub avec succès !"
else
    print_error "Erreur lors du push"
    print_warning "Si c'est votre premier push, vous devrez peut-être configurer vos credentials Git"
    exit 1
fi

echo ""
print_header "ÉTAPE 5 : PROCHAINES ÉTAPES"

echo ""
print_success "✅ Code déployé sur GitHub !"
echo ""
print_info "Pour déployer sur Vercel :"
echo "  1. Allez sur https://vercel.com"
echo "  2. Connectez-vous avec GitHub"
echo "  3. Importez le repo que vous venez de créer"
echo "  4. Ajoutez les variables d'environnement :"
echo "     • VITE_SUPABASE_URL"
echo "     • VITE_SUPABASE_ANON_KEY"
echo "  5. Cliquez sur Deploy"
echo ""
print_info "Pour les mises à jour futures :"
echo "  Exécutez simplement ce script à nouveau !"
echo "  Ou utilisez : git add . && git commit -m 'Update' && git push"
echo ""

REPO_URL=$(git remote get-url origin)
REPO_URL_WEB=${REPO_URL//.git/}
REPO_URL_WEB=${REPO_URL_WEB//git@github.com:/https://github.com/}

print_success "Votre repo : $REPO_URL_WEB"
echo ""
