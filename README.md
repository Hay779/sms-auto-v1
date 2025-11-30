# 📱 SMS Automatisation

Plateforme SaaS de gestion automatique des SMS après appel et formulaires de qualification client.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🚀 Démo en ligne

- **URL Production** : [Déployé sur Vercel](https://votre-app.vercel.app)
- **Compte Démo** : `demo@example.com` / `demo123`
- **Super Admin** : `admin@system.com` / `admin123`

## ✨ Fonctionnalités

- ✅ **Envoi automatique de SMS** après réception d'appel
- ✅ **Formulaires web personnalisables** pour qualification client
- ✅ **Dashboard en temps réel** avec statistiques
- ✅ **Gestion multi-entreprises** avec système de crédits
- ✅ **Notifications multi-canaux** (Email + SMS)
- ✅ **Interface Super Admin** pour gestion globale
- ✅ **Planification horaire** pour envoi SMS
- ✅ **Support multi-fournisseurs** SMS (OVH, Twilio, Capitole)

## 🛠️ Stack Technique

- **Frontend** : React 18 + TypeScript + Vite
- **UI** : Tailwind CSS + Lucide Icons
- **Base de données** : Supabase (PostgreSQL)
- **Déploiement** : Vercel
- **Charts** : Recharts

## 📋 Prérequis

- Node.js 18+ 
- npm ou yarn
- Compte Supabase (gratuit)
- Compte Vercel (gratuit)

## 🚀 Installation Locale

### 1. Cloner le repo

```bash
git clone https://github.com/VOTRE_USERNAME/sms-automatisation.git
cd sms-automatisation
```

### 2. Installer les dépendances

```bash
npm install
```

### 3. Configurer Supabase

1. Créez un projet sur [Supabase](https://supabase.com)
2. Dans le SQL Editor, exécutez le script `supabase-schema.sql`
3. Notez votre Project URL et Anon Key

### 4. Configurer les variables d'environnement

Créez un fichier `.env.local` :

```env
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 5. Lancer l'application

```bash
npm run dev
```

L'application sera accessible sur http://localhost:3000

## 🌐 Déploiement sur Vercel

### Méthode automatique (recommandée)

```bash
chmod +x deploy-github.sh
./deploy-github.sh
```

### Méthode manuelle

1. Poussez le code sur GitHub
2. Connectez-vous sur [Vercel](https://vercel.com)
3. Importez le repo GitHub
4. Ajoutez les variables d'environnement :
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
5. Déployez !

## 📁 Structure du Projet

```
sms-automatisation/
├── components/           # Composants React
├── services/            # Services API (Supabase)
├── types.ts             # Types TypeScript
├── App.tsx              # Composant principal
├── supabase-schema.sql  # Schéma base de données
├── vite.config.ts       # Configuration Vite
└── package.json         # Dépendances
```

## 🔐 Comptes de Test

### Super Admin
```
Email: admin@system.com
Mot de passe: admin123
```

### Compte Démo
```
Email: demo@example.com
Mot de passe: demo123
```

## 📊 Architecture

### Base de Données (Supabase)

- **companies** : Entreprises et paramètres
- **sms_logs** : Historique des SMS
- **form_submissions** : Soumissions de formulaires

### Services API

- **Authentication** : Login/Register
- **Settings** : CRUD paramètres
- **SMS Logs** : Historique et statistiques
- **Form Submissions** : Gestion formulaires

## 🔧 Configuration

### Providers SMS supportés

- **OVH** : API OVH SMS
- **Twilio** : API Twilio
- **Capitole** : API Capitole Mobile

### Planification

- Jours de la semaine configurables
- Plages horaires personnalisables
- Cooldown entre SMS

## 🐛 Dépannage

### Problème de connexion

1. Vérifiez que le schéma SQL est exécuté dans Supabase
2. Vérifiez les variables d'environnement
3. Consultez les logs dans la console (F12)

### Erreur de build

```bash
# Supprimer node_modules et réinstaller
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Page blanche

1. Vérifiez la console navigateur (F12)
2. Vérifiez que Supabase est accessible
3. Vérifiez les variables d'environnement

## 📚 Documentation

- [Guide de déploiement complet](DEPLOIEMENT-GITHUB-VERCEL.md)
- [Guide de configuration](GUIDE-CONFIGURATION.md)
- [Démarrage rapide](DEMARRAGE-RAPIDE.txt)

## 🤝 Contribution

Les contributions sont les bienvenues !

1. Fork le projet
2. Créez une branche (`git checkout -b feature/AmazingFeature`)
3. Committez (`git commit -m 'Add AmazingFeature'`)
4. Poussez (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📝 Changelog

### Version 1.0.0 (2024)
- ✨ Première version publique
- 🎨 Interface complète
- 🔐 Authentification multi-rôles
- 📊 Dashboard temps réel
- 📱 Formulaires personnalisables

## 📄 License

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Auteurs

- **Votre Nom** - *Développeur principal*

## 🙏 Remerciements

- [Supabase](https://supabase.com) - Backend as a Service
- [Vercel](https://vercel.com) - Hébergement
- [Tailwind CSS](https://tailwindcss.com) - Framework CSS
- [Lucide](https://lucide.dev) - Icônes

## 📞 Support

Pour toute question ou problème :
- 📧 Email : support@example.com
- 💬 Issues : [GitHub Issues](https://github.com/VOTRE_USERNAME/sms-automatisation/issues)

---

**Développé avec ❤️ - Prêt pour la production ! 🚀**
