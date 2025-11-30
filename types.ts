export enum LogStatus {
  SENT = 'sent',
  FILTERED = 'filtered',
  ERROR = 'error'
}

export type UserRole = 'SUPER_ADMIN' | 'CLIENT';
export type SmsProvider = 'ovh' | 'twilio' | 'capitole';

export interface SmsLog {
  id: number;
  company_id: string;
  phone: string;
  message: string;
  status: LogStatus;
  reason: string;
  call_id: string;
  created_at: string;
  has_submission?: boolean;
}

export interface ScheduleConfig {
  enabled: boolean;
  days: number[];
  start_time: string;
  end_time: string;
}

export type BlockType = 'header' | 'paragraph' | 'text' | 'textarea' | 'photo' | 'video' | 'checkbox' | 'separator' | 'contact_info';

export interface FormBlock {
  id: string;
  type: BlockType;
  label: string;
  required: boolean;
  placeholder?: string;
}

export interface WebFormConfig {
  enabled: boolean;
  logo_url: string;
  page_title: string;
  company_address: string;
  company_phone: string;
  blocks: FormBlock[];
  enable_marketing: boolean;
  marketing_text: string;
  custom_options?: string[];
  notify_admin_email: boolean;
  admin_notification_email: string;
  admin_email_subject?: string;
  admin_email_body?: string;
  notify_admin_sms: boolean;
  admin_notification_phone: string;
  admin_sms_message?: string;
  notify_client_email: boolean;
  client_email_subject?: string;
  client_email_body?: string;
  notify_client_sms: boolean;
  client_sms_message?: string;
}

export interface FormSubmission {
  id: string;
  ticket_number: string;
  company_id: string;
  phone: string;
  created_at: string;
  answers: { blockId: string; label: string; value: string | boolean | object }[];
  marketing_optin: boolean;
  status: 'new' | 'pending' | 'done' | 'archived';
}

export interface Settings {
  company_name: string;
  company_tagline: string;
  sms_sender_id: string;
  auto_sms_enabled: boolean;
  sms_message: string;
  cooldown_seconds: number;
  web_form: WebFormConfig;
  sms_credits: number;
  active_schedule: ScheduleConfig;
  admin_email: string;
  admin_password: string;
  use_custom_provider: boolean;
  custom_provider_type: SmsProvider;
  ovh_app_key?: string;
  ovh_app_secret?: string;
  ovh_consumer_key?: string;
  ovh_service_name?: string;
  twilio_account_sid?: string;
  twilio_auth_token?: string;
  twilio_from_number?: string;
  capitole_api_key?: string;
}

export interface DashboardStats {
  sms_sent: number;
  calls_filtered: number;
  errors: number;
}

export interface Company {
  id: string;
  name: string;
  email: string;
  siret?: string;
  vat_number?: string;
  address?: string;
  phone?: string;
  contact_name?: string;
  notes?: string;
  status: 'active' | 'inactive' | 'pending_verification';
  verification_code?: string;
  subscription_plan: 'basic' | 'pro';
  created_at: string;
  settings: Settings;
  credit_history: CreditTransaction[];
}

export interface CreditTransaction {
  id: string;
  date: string;
  amount_credits: number;
  amount_paid: number;
  reference: string;
  type: 'credit' | 'debit' | 'adjustment';
}

export interface CompanyStats extends DashboardStats {
  company_id: string;
  company_name: string;
  subscription_plan: 'basic' | 'pro';
  sms_credits: number;
  use_custom_provider: boolean;
  last_activity: string | null;
  email: string;
}
