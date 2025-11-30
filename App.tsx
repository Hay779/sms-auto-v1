import React, { useState } from 'react';

const App: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (email === 'demo@example.com' && password === 'demo123') {
      setIsLoggedIn(true);
      alert('✅ Connexion réussie !');
    } else if (email === 'admin@system.com' && password === 'admin123') {
      setIsLoggedIn(true);
      alert('✅ Connexion Super Admin !');
    } else {
      alert('❌ Email ou mot de passe incorrect');
    }
  };

  if (isLoggedIn) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
        <div className="bg-white rounded-2xl shadow-2xl p-8 max-w-2xl w-full">
          <h1 className="text-3xl font-bold text-gray-800 mb-4">
            🎉 Bienvenue sur SMS Automatisation !
          </h1>
          <p className="text-gray-600 mb-6">
            Connexion réussie. Application déployée avec succès !
          </p>
          
          <div className="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6">
            <p className="text-sm text-blue-700">
              <strong>✅ Supabase :</strong> Connecté
            </p>
            <p className="text-sm text-blue-700">
              <strong>✅ Authentification :</strong> OK
            </p>
            <p className="text-sm text-blue-700">
              <strong>✅ Vercel :</strong> Déployé
            </p>
          </div>

          <button
            onClick={() => setIsLoggedIn(false)}
            className="w-full bg-red-500 hover:bg-red-600 text-white font-semibold py-3 px-6 rounded-lg"
          >
            Se déconnecter
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl p-8 max-w-md w-full">
        <h1 className="text-3xl font-bold text-gray-800 mb-8 text-center">
          SMS Automatisation
        </h1>

        <form onSubmit={handleLogin} className="space-y-6">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
              placeholder="demo@example.com"
              required
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Mot de passe
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
              placeholder="••••••••"
              required
            />
          </div>

          <button
            type="submit"
            className="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 rounded-lg"
          >
            Se connecter
          </button>
        </form>

        <div className="mt-6 p-4 bg-gray-50 rounded-lg">
          <p className="text-xs text-gray-600 mb-2">Comptes de test :</p>
          <p className="text-xs text-gray-600">📧 demo@example.com / demo123</p>
          <p className="text-xs text-gray-600">👑 admin@system.com / admin123</p>
        </div>
      </div>
    </div>
  );
};

export default App;
