-- ============================================
-- SCHÉMA SUPABASE - SMS AUTOMATISATION
-- ============================================
-- Exécutez ce script dans le SQL Editor de Supabase
-- https://supabase.com/dashboard/project/_/sql

-- ============================================
-- 1. TABLE COMPANIES
-- ============================================
CREATE TABLE IF NOT EXISTS companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  
  -- Détails administratifs
  siret TEXT,
  vat_number TEXT,
  address TEXT,
  phone TEXT,
  contact_name TEXT,
  notes TEXT,
  
  -- Statut
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'pending_verification')),
  verification_code TEXT,
  
  -- Abonnement
  subscription_plan TEXT NOT NULL DEFAULT 'basic' CHECK (subscription_plan IN ('basic', 'pro')),
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Configuration JSON
  settings JSONB NOT NULL DEFAULT '{}'::jsonb,
  credit_history JSONB DEFAULT '[]'::jsonb
);

-- Index pour performance
CREATE INDEX IF NOT EXISTS idx_companies_email ON companies(email);
CREATE INDEX IF NOT EXISTS idx_companies_status ON companies(status);

-- ============================================
-- 2. TABLE SMS_LOGS
-- ============================================
CREATE TABLE IF NOT EXISTS sms_logs (
  id BIGSERIAL PRIMARY KEY,
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  
  phone TEXT NOT NULL,
  message TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('sent', 'filtered', 'error')),
  reason TEXT,
  call_id TEXT,
  
  has_submission BOOLEAN DEFAULT FALSE,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour performance
CREATE INDEX IF NOT EXISTS idx_sms_logs_company ON sms_logs(company_id);
CREATE INDEX IF NOT EXISTS idx_sms_logs_created_at ON sms_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sms_logs_phone ON sms_logs(phone);

-- ============================================
-- 3. TABLE FORM_SUBMISSIONS
-- ============================================
CREATE TABLE IF NOT EXISTS form_submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_number TEXT NOT NULL UNIQUE,
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  
  phone TEXT NOT NULL,
  answers JSONB NOT NULL DEFAULT '[]'::jsonb,
  marketing_optin BOOLEAN DEFAULT FALSE,
  
  status TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'pending', 'done', 'archived')),
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour performance
CREATE INDEX IF NOT EXISTS idx_form_submissions_company ON form_submissions(company_id);
CREATE INDEX IF NOT EXISTS idx_form_submissions_ticket ON form_submissions(ticket_number);
CREATE INDEX IF NOT EXISTS idx_form_submissions_created_at ON form_submissions(created_at DESC);

-- ============================================
-- 4. TRIGGERS AUTO-UPDATE
-- ============================================

-- Trigger pour updated_at sur companies
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_companies_updated_at
  BEFORE UPDATE ON companies
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_form_submissions_updated_at
  BEFORE UPDATE ON form_submissions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 5. ROW LEVEL SECURITY (RLS)
-- ============================================

-- Activer RLS sur toutes les tables
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE sms_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE form_submissions ENABLE ROW LEVEL SECURITY;

-- Policy: Permettre l'accès public en lecture/écriture (à adapter selon vos besoins)
CREATE POLICY "Accès public companies" ON companies FOR ALL USING (true);
CREATE POLICY "Accès public sms_logs" ON sms_logs FOR ALL USING (true);
CREATE POLICY "Accès public form_submissions" ON form_submissions FOR ALL USING (true);

-- ============================================
-- 6. DONNÉES DE TEST (Optionnel)
-- ============================================

-- Insérer une entreprise de démonstration
INSERT INTO companies (name, email, subscription_plan, settings)
VALUES (
  'Entreprise Demo',
  'demo@example.com',
  'basic',
  '{
    "company_name": "Entreprise Demo",
    "company_tagline": "Votre partenaire de confiance",
    "sms_sender_id": "DEMO",
    "auto_sms_enabled": false,
    "sms_message": "Merci pour votre appel ! Nous vous recontactons rapidement.",
    "cooldown_seconds": 3600,
    "sms_credits": 500,
    "admin_email": "demo@example.com",
    "admin_password": "demo123",
    "use_custom_provider": false,
    "custom_provider_type": "ovh",
    "active_schedule": {
      "enabled": false,
      "days": [1,2,3,4,5],
      "start_time": "09:00",
      "end_time": "18:00"
    },
    "web_form": {
      "enabled": false,
      "logo_url": "",
      "page_title": "Contactez-nous",
      "company_address": "",
      "company_phone": "",
      "blocks": [],
      "enable_marketing": false,
      "marketing_text": "",
      "notify_admin_email": false,
      "admin_notification_email": "demo@example.com",
      "notify_admin_sms": false,
      "admin_notification_phone": "",
      "notify_client_email": false,
      "notify_client_sms": false
    }
  }'::jsonb
)
ON CONFLICT (email) DO NOTHING;

-- ============================================
-- 7. VÉRIFICATIONS
-- ============================================

-- Vérifier que tout est bien créé
SELECT 
  'companies' as table_name, 
  COUNT(*) as row_count 
FROM companies
UNION ALL
SELECT 
  'sms_logs', 
  COUNT(*) 
FROM sms_logs
UNION ALL
SELECT 
  'form_submissions', 
  COUNT(*) 
FROM form_submissions;

-- Afficher la structure
SELECT 
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('companies', 'sms_logs', 'form_submissions')
ORDER BY table_name, ordinal_position;
