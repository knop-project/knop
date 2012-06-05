[if: $s_user -> auth]
	<p>[$lang_ui -> loggedinas(-replace=array($s_user -> firstname, $s_user -> lastname))]</p>
	<p><a href="[$nav -> url(-urlargs='-action=logout')]">[$lang_ui -> logout]</a></p>
[else]
	[$loginform -> renderform]
[/if]

[iterate($lang_ui -> languages, var('language'))]
	<a href="[$nav -> url(-urlargs='setlanguage=' + $language)]">[$lang_ui -> languagename(-language=$language)]</a>
[/iterate]