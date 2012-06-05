<?LassoScript


// Configure language strings

// Separate strings into two lang objects for better organization
var: 'lang_ui'=(knop_lang: -default='en', -fallback);
var: 'lang_buttons'=(knop_lang: -default='en', -fallback);



// English strings (default language)


$lang_ui -> addlanguage(-language='en', -strings=map(
	'languagename'='English',
	
	'authfailed'='Authentication failed',
	'createnew'='Create new', 
	'createnewcustomer'='Create New Customer',
	'customerlist'='Customer List',
	'editcustomer'='Edit Customer',
	'settings'='Settings',
	'customerssimple'='Customers Simple',
	'customersadvanced'='Customers Advanced', 
	'articles'='Articles',
	'sitemap'='Sitemap',
	'mypage'='My page',
	'login'='Log in',
	'logout'='Log out',
	'booking'='Booking',
	'unsavedwarning'='There are unsaved changes. Continue without saving?',
	
	'firstname'='First Name',
	'specifyaname'='specify a name',
	'name'='Name',
	'lastname'='Last Name',
	'username'='Username',
	'password'='Password',
	
	'loggedinas'='You are logged in as #1# #2#.',
	'youhaveloggedout'='You have logged out',
	'languagechanged'='Language changed to #1#.',
	
	'email'='E-mail', 
	'active'='Active',
	'yes'='Yes',
	'dateformat_short'='%m-%d',
	'mailcheck'='Mailcheck', 
	'chooseone'='choose one...',
	
	'confirmdeletecustomer'='Do you really want to delete this customer?', 
	'confirmresetform'='Do you want to reset the form? Any changes will be lost.', 
	'somethings'='somethings',
	'option1'='a thing',
	'option2'='another thing',
	'option3'='third'
	
	));


$lang_buttons -> addlanguage(-language='en', -strings=map(
	'save'='Save', 
	'delete'='Delete',
	'cancel'='Cancel',
	'create'='Create',
	'reset'='Reset form'
	));



// Swedish strings


$lang_ui -> addlanguage(-language='sv', -strings=map(
	'languagename'='Svenska',

	'authfailed'='Inloggningen misslyckades',
	'createnew'='Skapa ny', 
	'createnewcustomer'='Skapa ny kund',
	'customerlist'='Kundlista',
	'editcustomer'='Redigera kund',
	'settings'='Inställningar',
	'customerssimple'='Kunder enkel',
	'customersadvanced'='Kunder avancerad', 
	'articles'='Artiklar',
	'sitemap'='Sitemap',
	'mypage'='Min sida',
	'login'='Logga in',
	'logout'='Logga ut',
	'booking'='Bokning',
	'unsavedwarning'='Det finns ändringar som inte sparats. Vill du fortsätta utan att spara?',
	
	'firstname'='Förnamn',
	'specifyaname'='ange ett namn',
	'name'='Namn',
	'lastname'='Efternamn',
	'username'='Användarnamn',
	'password'='Lösenord',

	'loggedinas'='Du är inloggad som #1# #2#.',
	'youhaveloggedout'='Du har loggat ut',
	'languagechanged'='Språk ändrat till #1#.',
	
	'email'='E-post', 
	'active'='Aktiv',
	'yes'='Ja',
	'dateformat_short'='%-d/%-m',
	'mailcheck'='Mailkoll', 
	'chooseone'='välj...',
	
	'confirmdeletecustomer'='Vill du verkligen radera denna kund?', 
	'confirmresetform'='Vill du verkligen återställa formuläret? Alla ändringar förloras.', 
	'somethings'='några saker',
	'option1'='en sak',
	'option2'='en annan sak',
	'option3'='tredje'

	));

$lang_buttons -> addlanguage(-language='sv', -strings=map(
	'save'='Spara', 
	'delete'='Radera',
	'cancel'='Avbryt',
	'create'='Skapa',
	'reset'='Återställ'
	));




// switch language?

if(action_param('setlanguage') && $lang_ui -> validlanguage(action_param('setlanguage')));
	// save the new language in the session
	$s_lang = string(action_param('setlanguage'));
	// change language - this only needs to be done for one of the defined language objects. 
	$lang_ui -> setlanguage($s_lang);
	$message -> insert($lang_ui -> languagechanged(-replace=$lang_ui -> languagename));

else(string($s_lang) -> size > 0);
	// set explicit language on every page load - this only needs to be done for one of the defined language objects. 
	$lang_ui -> setlanguage($s_lang);

else;
	// no specific language has been chosen, use the visitor's preferred language acording to the browser's request header
/if;



?>


