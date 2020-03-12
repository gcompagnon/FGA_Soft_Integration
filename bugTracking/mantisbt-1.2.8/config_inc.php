<?php
# MantisBT - a php based bugtracking system

# MantisBT is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# MantisBT is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MantisBT.  If not, see <http://www.gnu.org/licenses/>.

/**
 * @package MantisBT
 * @copyright Copyright (C) 2000 - 2002  Kenzaburo Ito - kenito@300baud.org
 * @copyright Copyright (C) 2002 - 2011  MantisBT Team - mantisbt-dev@lists.sourceforge.net
 * @link http://www.mantisbt.org
 */

# This sample file contains the essential files that you MUST
# configure to your specific settings.  You may override settings
# from config_defaults_inc.php by assigning new values in this file

# Rename this file to config_inc.php after configuration.

# In general the value OFF means the feature is disabled and ON means the
# feature is enabled.  Any other cases will have an explanation.

# Look in http://www.mantisbt.org/docs/ or config_defaults_inc.php for more
# detailed comments.

# --- Database Configuration ---

#--- configuration avec source de données ODBC
#$g_hostname      = 'FGA_INTEGRATION_DATABASE';
#$g_db_type       = 'odbc_mssql';

#--- configuration avec le driver sqldrv
#$g_hostname      = 'localhost';
#$g_db_type       = 'ado_mssql';
#$g_db_type       = 'pdo_mssql';

#--- configuration avec le driver sqldrv (MS SQL server driver for PHP)
$g_hostname      = 'FX007119M\SQLEXPRESS';
$g_db_type       = 'mssqlnative';
$g_db_username   = 'mantis';
$g_db_password   = 'mantis';
$g_database_name = 'bugtracker';

#---   Debug ----
$g_db_log_queries = OFF;
$g_show_detailed_errors	= ON;

# --- Configuration de l authentification ---
$g_login_method = 'PLAIN'; # mettre LDAP (serveur LDAP à config) ou MD5 (mot de passe stocké sous forme de clé MD5)
# --- LANGUE ---
$g_default_language = 'french';
$g_language_choices_arr = array('french', 'english');

#Pour commander le patch (core/date_api.php, config_defaults_inc.php, gpc_api.php) 
#pour utiliser un composant js date picker à la place des 3 combobox hideuses
# cf http://www.mantisbt.org/bugs/view.php?id=8957
$g_use_date_picker_javascript = ON;

#desactiver les verifications affichées sur la page de login
$g_admin_checks = OFF;

# pour la roadmap / calendrier des versions
# configurer chaque projet de façon individuel pour creer les versions
#$g_use_jpgraph = ON;
#$g_jpgraph_path = "C:\FGA_SOFT_INTEGRATION\bugTracking\mantisbt-1.2.8\library\jpgraph\src/";
$g_system_font_path = "C:\WINNT\Fonts/";
#DEFINE("TTF_DIR","c:\WINNT\Fonts/");

# --- Anonymous Access / Signup ---
$g_allow_signup				= ON;
$g_allow_anonymous_login	= OFF;
$g_anonymous_account		= '';

#desactiver le filtrage par les custom fields, champs personnalisées car bug avec les caractères accentués
$g_filter_by_custom_fields = OFF;

# --- Email Configuration ---
$g_enable_email_notification = OFF;
$g_phpMailer_method		= PHPMAILER_METHOD_MAIL; # or PHPMAILER_METHOD_SMTP, PHPMAILER_METHOD_SENDMAIL
$g_smtp_host			= 'localhost';			# used with PHPMAILER_METHOD_SMTP
$g_smtp_username		= '';					# used with PHPMAILER_METHOD_SMTP
$g_smtp_password		= '';					# used with PHPMAILER_METHOD_SMTP
$g_administrator_email  = 'gcompagnon@federisga.fr';
$g_webmaster_email      = 'gcompagnon@federisga.fr';
$g_from_name			= 'Mantis Bug Tracker';
$g_from_email           = 'gcompagnon@federisga.fr';	# the "From: " field in emails
$g_return_path_email    = 'gcompagnon@federisga.fr';	# the return address for bounced mail
$g_email_receive_own	= OFF;
$g_email_send_using_cronjob = OFF;
$g_validate_email = OFF;
$g_send_reset_password = OFF;
$g_allow_signup = OFF;


# --- Attachments / File Uploads ---
$g_allow_file_upload	= ON;
$g_file_upload_method	= DATABASE; # DATABASE or DISK
$g_absolute_path_default_upload_folder = 'C:\FGA_SOFT_INTEGRATION\uploadFiles/'; # used with DISK, must contain trailing \ or /.
$g_max_file_size		= 5000000;	# in bytes
$g_preview_attachments_inline_max_size = 256 * 1024;
$g_allowed_files		= '';		# extensions comma separated, e.g. 'php,html,java,exe,pl'
$g_disallowed_files		= '';		# extensions comma separated

# --- Branding ---
$g_window_title			= 'FGA Soft MantisBT';
$g_logo_image			= 'images/LOGO_FEDERISGA.png';
$g_favicon_image		= 'images/favicon.ico';

# --- Real names ---
$g_show_realname = ON;
$g_show_user_realname_threshold = NOBODY;	# Set to access level (e.g. VIEWER, REPORTER, DEVELOPER, MANAGER, etc)

# --- Others ---
$g_default_home_page = 'my_view_page.php';	# Set to name of page to go to after login

?>