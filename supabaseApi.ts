import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { Settings, SmsLog, DashboardStats, FormSubmission } from '../types';

// Configuration Supabase
const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL || '';
const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY || '';

if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
  console.error('❌ Variables Supabase manquantes! Vérifiez VITE_SUPABASE_URL et VITE_SUPABASE_ANON_KEY');
}

// Créer le client Supabase
export const supabase: SupabaseClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

export class ApiService {
  
  // ====== AUTHENTICATION ======
  
  static async login(email: string, password: string): Promise<{ role: string; companyId?: string }> {
    try {
      // Vérifier si c'est le super admin
      if (email === 'admin@system.com' && password === 'admin123') {
        return { role: 'SUPER_ADMIN' };
      }

      // Rechercher dans la table companies
      const { data: company, error } = await supabase
        .from('companies')
        .select('id, settings')
        .eq('email', email)
        .single();

      if (error || !company) {
        throw new Error('Email ou mot de passe incorrect');
      }

      // Vérifier le mot de passe (stocké dans settings)
      const settings = company.settings as Settings;
      if (settings.admin_password !== password) {
        throw new Error('Email ou mot de passe incorrect');
      }

      return { 
        role: 'CLIENT', 
        companyId: company.id 
      };
      
    } catch (error) {
      console.error('Erreur login:', error);
      throw error;
    }
  }

  static async register(
    email: string, 
    password: string, 
    companyName: string
  ): Promise<{ role: string; companyId: string }> {
    try {
      // Vérifier si l'email existe déjà
      const { data: existing } = await supabase
        .from('companies')
        .select('id')
        .eq('email', email)
        .single();

      if (existing) {
        throw new Error('Cet email est déjà utilisé');
      }

      // Créer les settings par défaut
      const defaultSettings: Settings = {
        company_name: companyName,
        company_tagline: '',
        sms_sender_id: companyName.substring(0, 11),
        auto_sms_enabled: false,
        sms_message: 'Merci pour votre appel ! Nous vous recontactons rapidement.',
        cooldown_seconds: 3600,
        sms_credits: 100, // Crédits de démarrage
        admin_email: email,
        admin_password: password,
        use_custom_provider: false,
        custom_provider_type: 'ovh',
        active_schedule: {
          enabled: false,
          days: [1, 2, 3, 4, 5],
          start_time: '09:00',
          end_time: '18:00'
        },
        web_form: {
          enabled: false,
          logo_url: '',
          page_title: 'Contactez-nous',
          company_address: '',
          company_phone: '',
          blocks: [],
          enable_marketing: false,
          marketing_text: '',
          notify_admin_email: false,
          admin_notification_email: email,
          notify_admin_sms: false,
          admin_notification_phone: '',
          notify_client_email: false,
          notify_client_sms: false
        }
      };

      // Créer la nouvelle entreprise
      const { data: newCompany, error } = await supabase
        .from('companies')
        .insert({
          name: companyName,
          email: email,
          status: 'active',
          subscription_plan: 'basic',
          settings: defaultSettings,
          credit_history: []
        })
        .select()
        .single();

      if (error) throw error;

      return { 
        role: 'CLIENT', 
        companyId: newCompany.id 
      };
      
    } catch (error) {
      console.error('Erreur registration:', error);
      throw error;
    }
  }

  // ====== SETTINGS ======
  
  static async getSettings(companyId: string): Promise<Settings> {
    try {
      const { data, error } = await supabase
        .from('companies')
        .select('settings')
        .eq('id', companyId)
        .single();

      if (error) throw error;
      return data.settings as Settings;
      
    } catch (error) {
      console.error('Erreur getSettings:', error);
      throw error;
    }
  }

  static async updateSettings(settings: Settings): Promise<Settings> {
    try {
      // Trouver la company via admin_email
      const { data: company } = await supabase
        .from('companies')
        .select('id')
        .eq('email', settings.admin_email)
        .single();

      if (!company) throw new Error('Entreprise introuvable');

      const { error } = await supabase
        .from('companies')
        .update({ settings: settings })
        .eq('id', company.id);

      if (error) throw error;
      return settings;
      
    } catch (error) {
      console.error('Erreur updateSettings:', error);
      throw error;
    }
  }

  // ====== LOGS ======
  
  static async getLogs(companyId: string): Promise<SmsLog[]> {
    try {
      const { data, error } = await supabase
        .from('sms_logs')
        .select('*')
        .eq('company_id', companyId)
        .order('created_at', { ascending: false })
        .limit(100);

      if (error) throw error;
      return data || [];
      
    } catch (error) {
      console.error('Erreur getLogs:', error);
      return [];
    }
  }

  static async addLog(log: Partial<SmsLog>): Promise<void> {
    try {
      const { error } = await supabase
        .from('sms_logs')
        .insert(log);

      if (error) throw error;
      
    } catch (error) {
      console.error('Erreur addLog:', error);
      throw error;
    }
  }

  // ====== STATS ======
  
  static async getStats(companyId: string): Promise<DashboardStats> {
    try {
      const { data: logs } = await supabase
        .from('sms_logs')
        .select('status')
        .eq('company_id', companyId);

      const stats: DashboardStats = {
        sms_sent: 0,
        calls_filtered: 0,
        errors: 0
      };

      if (logs) {
        logs.forEach(log => {
          if (log.status === 'sent') stats.sms_sent++;
          else if (log.status === 'filtered') stats.calls_filtered++;
          else if (log.status === 'error') stats.errors++;
        });
      }

      return stats;
      
    } catch (error) {
      console.error('Erreur getStats:', error);
      return { sms_sent: 0, calls_filtered: 0, errors: 0 };
    }
  }

  // ====== FORM SUBMISSIONS ======
  
  static async getFormSubmissions(companyId: string): Promise<FormSubmission[]> {
    try {
      const { data, error } = await supabase
        .from('form_submissions')
        .select('*')
        .eq('company_id', companyId)
        .order('created_at', { ascending: false });

      if (error) throw error;
      return data || [];
      
    } catch (error) {
      console.error('Erreur getFormSubmissions:', error);
      return [];
    }
  }

  static async addFormSubmission(submission: Partial<FormSubmission>): Promise<void> {
    try {
      const { error } = await supabase
        .from('form_submissions')
        .insert(submission);

      if (error) throw error;
      
    } catch (error) {
      console.error('Erreur addFormSubmission:', error);
      throw error;
    }
  }

  static async updateFormSubmissionStatus(
    submissionId: string, 
    status: FormSubmission['status']
  ): Promise<void> {
    try {
      const { error } = await supabase
        .from('form_submissions')
        .update({ status })
        .eq('id', submissionId);

      if (error) throw error;
      
    } catch (error) {
      console.error('Erreur updateFormSubmissionStatus:', error);
      throw error;
    }
  }

  // ====== SUPER ADMIN ======
  
  static async getAllCompanies() {
    try {
      const { data, error } = await supabase
        .from('companies')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      return data || [];
      
    } catch (error) {
      console.error('Erreur getAllCompanies:', error);
      return [];
    }
  }
}
