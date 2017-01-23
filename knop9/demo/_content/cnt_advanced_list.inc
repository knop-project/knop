[/* Show record listing */]
[$list -> renderhtml]

[/* Show button to create new record */]
<form action="[$nav -> url('advanced/edit', 
		-urlargs=$list -> urlargs(-except=array(-path, -keyvalue)))]" method="post">
<input type="submit" value="[$lang_ui -> createnew]" class="button">
</form>
