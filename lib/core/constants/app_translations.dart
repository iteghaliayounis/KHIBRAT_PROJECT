import 'package:get/get.dart';

/// Central translation map used with GetX's built-in localization.
/// Keys are referenced in the UI via `'key'.tr`.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar_SY': _ar,
        'en_US': _en,
      };

  static const Map<String, String> _ar = {
    // Splash
    'app_name': 'KHUBRAT',
    'app_tagline': 'HR SAAS PLATFORM',
    'app_description': 'شريك التمكين والحلول الإدارية المتكاملة لموظفي الشركات.',
    'start_now': 'ابدأ الآن',

    // Onboarding welcome
    'onboard_title': 'كل ما يخص وظيفتك في مكان واحد',
    'onboard_subtitle':
        'تتبع دوامك، قدّم إجازاتك، راجع كشف راتبك وتواصل مع الـ HR والمدير المباشر بضغطة زر واحدة.',

    // Language selection
    'choose_language': 'اختر لغة التطبيق',
    'choose_language_desc': 'Please select your preferred application language',
    'arabic': 'اللغة العربية',
    'english': 'English Language',
    'continue_btn': 'متابعة',

    // Login
    'login': 'تسجيل الدخول',
    'welcome_back': '!أهلاً بك مجدداً ',
    'login_subtitle': 'الرجاء تسجيل الدخول للمتابعة واستخدام جميع المزايا',
    'email_address': 'البريد الإلكتروني الوظيفي',
    'enter_email': 'example@company.com',
    'password': 'كلمة المرور',
    'enter_password': 'أدخل كلمة المرور',
    'forgot_password': 'نسيت كلمة المرور؟',
    'secure_login': 'تسجيل الدخول ',
'forgot_password_title': 'استعادة كلمة المرور',
'send_code': 'إرسال الرمز',
    // Validation
    'email_required': 'البريد الإلكتروني مطلوب',
    'email_invalid': 'صيغة البريد الإلكتروني غير صحيحة',
    'password_required': 'كلمة المرور مطلوبة',
    'password_min': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
    'password_confirm_required': 'تأكيد كلمة المرور مطلوب',
    'password_mismatch': 'كلمتا المرور غير متطابقتين',

    // Errors
    'invalid_credentials': 'بيانات الدخول غير صحيحة',
    'account_inactive': 'الحساب غير نشط',
    'generic_error': 'حدث خطأ ما، يرجى المحاولة مرة أخرى',
    'network_error': 'تعذّر الاتصال بالخادم، تحقق من اتصالك بالإنترنت',

    // First login / change password
    'first_login_title': 'تعيين كلمة مرور جديدة',
    'first_login_subtitle':
        'لأول مرة تسجّل بها الدخول، يجب عليك تعيين كلمة مرور جديدة وآمنة قبل المتابعة',
    'new_password': 'كلمة المرور الجديدة',
    'enter_new_password': 'أدخل كلمة المرور الجديدة',
    'confirm_password': 'تأكيد كلمة المرور',
    'enter_confirm_password': 'أعد إدخال كلمة المرور',
    'save_and_continue': 'حفظ ومتابعة',
    'password_changed_success': 'تم تحديث كلمة المرور بنجاح، أهلاً بك في Khubrat',
    'logout': 'تسجيل الخروج',


    'verify_code_title': 'رمز التحقق',
'enter_verification_code': 'أدخل رمز التحقق',
'code_sent_to': 'تم إرسال رمز التحقق إلى',
'confirm_code': 'تأكيد الرمز',
'didnt_receive_code': 'لم تستلم الرمز؟',
'resend_code': 'إعادة الإرسال',
'resend_code_in': 'إعادة الإرسال خلال',
'enter_complete_code': 'يرجى إدخال كافة أرقام الرمز',
'invalid_code': 'رمز التحقق غير صحيح',
'code_resent_success': 'تم إعادة إرسال الرمز بنجاح',
'failed_resend_code': 'فشل إرسال الرمز مرة أخرى',
'reset_password_title': 'تعيين كلمة المرور',
'create_new_password': 'إنشاء كلمة مرور جديدة',
'enter_new_password_sub': 'أدخل كلمة المرور الجديدة لتتمكن من تسجيل الدخول',
'confirm_new_password': 'تأكيد كلمة المرور الجديدة',
'confirm_new_password_hint': 'أعد كتابة كلمة المرور',
'save_password': 'حفظ كلمة المرور',
'password_too_short': 'كلمة المرور يجب أن لا تقل عن 6 أحرف',
'passwords_dont_match': 'كلمتا المرور غير متطابقتين',
'password_reset_success': 'تم تغيير كلمة المرور بنجاح',
'failed_reset_password': 'حدث خطأ أثناء تغيير كلمة المرور',
'success': 'نجاح',
'error': 'خطأ',

// في القاموس العربي _ar:
'attendance_tracking': 'تسجيل الحضور والدوام',
'attendance_subtitle': 'الرمز الجغرافي والـ QR',
'company_policies': 'سياسات وعطلات الشركة',
'policies_subtitle': 'التأخير، التقويم، الإجازات',
'my_annual_leaves': 'إجازاتي السنوية',
'leaves_subtitle': 'تقديم الإجازة وملفات الإثبات',
'permission_overtime': 'طلب إذن / عمل إضافي',
'overtime_subtitle': 'ساعات أو أيام تعويضية',
'payroll_loans': 'كشف الرواتب والسلف',
'payroll_subtitle': 'تحصيل، مستندات، وطلب سلفة',
'company_hr_info': 'معلومات الشركة والـ HR',
'hr_info_subtitle': 'لمحة، تواصل مباشر، شات',
'ai_buddy': 'المساعد الذكي AI Buddy',
'ai_buddy_subtitle': 'تواصل مباشر واستفسارات قانونية',
'evaluations': 'التقييمات',
'evaluations_subtitle': 'متابعة تقييم الأداء والملاحظات',

// Navigation Bar
'nav_home': 'الرئيسية',
'nav_account': 'حسابي',
'nav_company': 'الشركة',
'nav_settings': 'الإعدادات',

// My Evaluations
'evaluation': 'التقييم',
'my_evaluations': 'تقييماتي',
'my_evaluations_subtitle': 'مسار أدائك الوظيفي',
'evaluation_progress_title': 'تقدّم تقييمك',
'pending': 'قيد الانتظار',
'completed': 'مكتمل',
'no_pending_evaluations': 'لا توجد تقييمات قيد الانتظار حالياً',
'no_completed_evaluations': 'لا توجد تقييمات مكتملة بعد',
'retry': 'إعادة المحاولة',
'evaluation_default_title': 'تقييم',
'for_label': 'لـ:',
'evaluating_label': 'أنت تقيّم:',
'overdue': 'متأخر',
'due': 'الاستحقاق',
'completed_on': 'اكتمل في',
'start': 'ابدأ',
'ready_to_submit': 'هل أنت جاهز للإرسال؟',
'submit_warning': 'لن تتمكن من تعديل إجاباتك بعد الإرسال.',
'submit_review': 'إرسال التقييم',
'cancel': 'إلغاء',
'self_reflection_subtitle': 'انعكاس أدائك الوظيفي',
'evaluating_someone_subtitle': 'أنت بصدد تقييم @name',
'questions_count': '@count أسئلة',
'about_to_evaluate_self': 'أنت على وشك تقييم أدائك.',
'about_to_evaluate_other': 'أنت على وشك تقييم أداء @name.',
'start_evaluation': 'ابدأ التقييم',
'no_questions_available': 'لا توجد أسئلة متاحة لهذا التقييم بعد',
'question_of': 'سؤال @current من @total',
'back': 'رجوع',
'next': 'التالي',
'submit': 'إرسال',
'write_your_answer': 'اكتب إجابتك...',
'evaluation_completed_title': 'تم إكمال التقييم!',
'evaluation_completed_subtitle': 'تم إرسال تقييمك بنجاح.',
'thank_you_name': 'شكراً لك، @name!',
'feedback_recorded': 'تم تسجيل ملاحظاتك بنجاح.',
'done': 'تم',

  };

  static const Map<String, String> _en = {
    // Splash
    'app_name': 'KHUBRAT',
    'app_tagline': 'HR SAAS PLATFORM',
    'app_description':
        'Your enablement partner and integrated management solutions for company employees.',
    'start_now': 'Get Started',

    // Onboarding welcome
    'onboard_title': 'Everything About Your Job in One Place',
    'onboard_subtitle':
        'Track your attendance, apply for leaves, review your payslip, and reach HR or your direct manager — all in a single tap.',

    // Language selection
    'choose_language': 'Choose App Language',
    'choose_language_desc': 'Please select your preferred application language',
    'arabic': 'Arabic Language',
    'english': 'English Language',
    'continue_btn': 'Continue',

    // Login
    'login': 'Login',
    'welcome_back': 'Welcome Back!',
    'login_subtitle': 'Please sign in to continue and access all features',
    'email_address': 'Work Email Address',
    'enter_email': 'example@company.com',
    'password': 'Password',
    'enter_password': 'Enter your password',
    'forgot_password': 'Forgot Password?',
    'secure_login': 'Login',
'forgot_password_title': 'Forgot Password',
'send_code': 'Send Code',
    // Validation
    'email_required': 'Email is required',
    'email_invalid': 'Please enter a valid email address',
    'password_required': 'Password is required',
    'password_min': 'Password must be at least 6 characters',
    'password_confirm_required': 'Please confirm your password',
    'password_mismatch': 'Passwords do not match',

    // Errors
    'invalid_credentials': 'Invalid login credentials',
    'account_inactive': 'This account is not active',
    'generic_error': 'Something went wrong, please try again',
    'network_error': 'Could not connect to the server, check your internet connection',

    // First login / change password
    'first_login_title': 'Set a New Password',
    'first_login_subtitle':
        'This is your first login. Please set a new, secure password before continuing.',
    'new_password': 'New Password',
    'enter_new_password': 'Enter your new password',
    'confirm_password': 'Confirm Password',
    'enter_confirm_password': 'Re-enter your password',
    'save_and_continue': 'Save & Continue',
    'password_changed_success': 'Password updated successfully. Welcome to Khubrat!',
    'logout': 'Logout',

    'verify_code_title': 'Verification Code',
'enter_verification_code': 'Enter Verification Code',
'code_sent_to': 'Verification code sent to',
'confirm_code': 'Confirm Code',
'didnt_receive_code': "Didn't receive the code?",
'resend_code': 'Resend',
'resend_code_in': 'Resend code in',
'enter_complete_code': 'Please enter full code',
'invalid_code': 'Invalid verification code',
'code_resent_success': 'Code resent successfully',
'failed_resend_code': 'Failed to resend code',
'reset_password_title': 'Reset Password',
'create_new_password': 'Create New Password',
'enter_new_password_sub': 'Enter your new password to log in',
'confirm_new_password': 'Confirm New Password',
'confirm_new_password_hint': 'Re-enter new password',
'save_password': 'Save Password',
'password_too_short': 'Password must be at least 6 characters',
'passwords_dont_match': 'Passwords do not match',
'password_reset_success': 'Password reset successfully',
'failed_reset_password': 'Failed to reset password',
'success': 'Success',
'error': 'Error',



'attendance_tracking': 'Attendance Tracking',
'attendance_subtitle': 'Geo-Location & QR Code',
'company_policies': 'Company Policies & Holidays',
'policies_subtitle': 'Delays, Calendar, Leaves',
'my_annual_leaves': 'My Annual Leaves',
'leaves_subtitle': 'Leave Requests & Proof Documents',
'permission_overtime': 'Permission & Overtime',
'overtime_subtitle': 'Compensatory Hours / Days',
'payroll_loans': 'Payroll & Advances',
'payroll_subtitle': 'Payslips, Documents & Loan Request',
'company_hr_info': 'Company Info & HR',
'hr_info_subtitle': 'Overview, Direct Contact, Chat',
'ai_buddy': 'AI Buddy Assistant',
'ai_buddy_subtitle': 'Direct Contact & Legal Inquiries',
'evaluations': 'Evaluations',
'evaluations_subtitle': 'Performance & Feedback Track',

// Navigation Bar
'nav_home': 'Home',
'nav_account': 'My Account',
'nav_company': 'Company',
'nav_settings': 'Settings',

// My Evaluations
'evaluation': 'Evaluation',
'my_evaluations': 'My Evaluations',
'my_evaluations_subtitle': 'Your performance journey',
'evaluation_progress_title': 'Your Evaluation Progress',
'pending': 'Pending',
'completed': 'Completed',
'no_pending_evaluations': 'No pending evaluations right now',
'no_completed_evaluations': 'No completed evaluations yet',
'retry': 'Retry',
'evaluation_default_title': 'Evaluation',
'for_label': 'For:',
'evaluating_label': "You're evaluating:",
'overdue': 'Overdue',
'due': 'Due',
'completed_on': 'Completed on',
'start': 'Start',
'ready_to_submit': 'Ready to submit?',
'submit_warning': "You won't be able to edit your answers after submitting.",
'submit_review': 'Submit Review',
'cancel': 'Cancel',
'self_reflection_subtitle': 'Your performance reflection',
'evaluating_someone_subtitle': "You're evaluating @name",
'questions_count': '@count Questions',
'about_to_evaluate_self': "You're about to evaluate your performance.",
'about_to_evaluate_other': "You're about to evaluate @name's performance.",
'start_evaluation': 'Start Evaluation',
'no_questions_available': 'No questions are available for this evaluation yet',
'question_of': 'Question @current of @total',
'back': 'Back',
'next': 'Next',
'submit': 'Submit',
'write_your_answer': 'Write your answer...',
'evaluation_completed_title': 'Evaluation Completed!',
'evaluation_completed_subtitle': 'Your evaluation has been successfully submitted.',
'thank_you_name': 'Thank you, @name!',
'feedback_recorded': 'Your feedback has been recorded successfully.',
'done': 'Done',
  };
}
