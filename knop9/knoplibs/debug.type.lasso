<?lassoscript

//============================================================================
//
//		L-Debug for Lasso 9 — Free to use 	 
//
//......All rights reserved — K Carlton 2012..................................		


define ldebug => type {
	parent array	
	
	data	
		var           = '_l_debug',		
		isActive      = false,
		opened        = list,
		lastTime      = integer,
		since         = integer,
		starttime     = integer,
		pageStartTime = integer,
		pageEndTime   = integer,
		class         = 'debug',
		src_jquery = 'http://code.jquery.com/jquery-1.4.4.min.js',
		src_js     = 'https://rawgit.com/zeroloop/l-debug/master/debug.js',
		src_chili  = 'https://rawgit.com/zeroloop/l-debug/master/chili-L.js',
		src_css    = 'https://rawgit.com/zeroloop/l-debug/master/debug.css',
		style      = ''

	data	
		//	Error handling
		errors = array,
		error_msg,
		error_code,

		//	Overall Timers
		timers	= array,	
		
		variables = array,

		//	Custom Types / Blocks
		types	= array (
						'   Lasso Code' = 'lasso',
						'  JS Code' 	= 'js',
						'  CSS Code' 	= 'css', 
						'Client Headers'= 'clientheaders',
						'Render Code' 	= 'renderCode',
						'Variables'		= 'variables'
					),

		settings = map(
					'sql'			= true,
					'xml'			= true,
					'html'			= true,
					'errors'  		= true,
					'variables' 	= false,
					'clientheaders' = false,
					'renderCode' 	= true,
					'timers' 		= true,
					'labels'  		= true,
					'more'			= false,
					'types'  		= true,
					'lasso'  		= true,
					'css'  			= true,
					'js'  			= true 
				)

	public oncreate => {

		//!	var(.'var')->isA(::ldebug)
		//?	var(.'var') = self

		//	Page Start time
		!	.'pageStartTime' 
		?	.'pageStartTime' = micros
			
		//	Block Start time
		!	.'startTime' 
		?	.'startTime' = micros
			
		//	Set initial start time
		.'since' = micros
		
		if(web_request)=>{
		
			.loadSettings()
			.time('L-Debug initialised')
		
			//	Define injection
			define_atEnd({
				.'pageEndTime' = micros
				debug->injectHTML
			})
		
		}	
	
	}	

	public this(
				p::any,
				-time=false,
				-open=false,
				-close=false
			) => {
		
		// Param handler
		#p ? .trace(#p)
		
		return self
	}	

	public invoke(p::any,...)=>{
		with p in params do {
			.trace(#p)
		}
		return self
	}

//============================================================================
//
//		->	Open block tracking
//
//............................................................................		

	public hasOpen() => .'opened'->size > 0
	public lastOpenedText() => .hasOpen ? .'opened'->first->name
	public lastOpenedTime() => .hasOpen ? .'opened'->first->value | .'pageStartTime'
		
//============================================================================
//
//		->	Core trace methods
//
//............................................................................	

	public trace(what::string) => {		
		.insert('<p>'+encode_html(#what)+'</p>')	
		return self	
	}

	public trace(what::any) => {		
		.insert('<p>'+encode_html(string(#what))+'</p>')	
		return self	
	}

	public trace(what::pair) => {		
		.insert(.render(#what))	
		return self	
	}

	public trace(what::string,mode::string) => {		
		.insert('<code class="' + #mode + '">' +encode_html(#what) + '</code>')
		return self	
	}

	public trace(object::trait_forEach) => {
		// Render iteratable
		.insert(.render(#object))
		return self
	}

	public traceParams(p::trait_forEach) => {
		// Render iteratable
		with i in #p do {
			.insert(.render(#i))
		}
		return self
	}
	
	public insert(p::any) => {
		if(error_code && .'error_msg'!=error_msg)=>{
			.error
		} 
		.'isActive'	? ..insert(#p)
	}


//============================================================================
//
//		->	Object rendering
//
//............................................................................



	public render(object::trait_forEach,output=string) => {
		
		#output->append('<span class="type"><header>' + #object->type + '</header>')
		
		if(#object) => {
			#output->append('<ul>')
		
			if(#object->isA(::map)) => {
				#object->forEachPair => {
					#output->append('<li>' + .render(#1) + '</li>')
				}		
			else
				with i in #object do {
					#output->append('<li>' + .render(#i) + '</li>')
				}					
			}

			#output->append('</ul>')
		}
		
		#output->append('</span>')
		
		return #output

	}
	
	
	

	public render(pair::pair) => {
		return '<span class="pair"><label>' + #pair->name + ':</label>' + .render(#pair->value)+'</span>'
	}

	public render(keyword::keyword) => {
		return '<span class="pair"><label>-' + #keyword->name + '=</label>' + .render(#keyword->value)+'</span>'
	}
	
	public render(what::any) => {
		return '<span class="string">' + encode_html(string(#what)) + '</span>'
	}

	public render(what::ldebug) => {
		return '<div>' + #what->content + '<div class="close"/></div>'
	}


//============================================================================
//
//		->	Custom tracers
//
//............................................................................	

	public header(what::string) => {	
		.insert('<header class="section">'+#what+'</header>')
		return self	
	}

	public header(what::string,p::boolean) => {	
		.insert('<header>'+#what+'</header>')
		return self	
	}

	public title(what::string) => .header(#what)
		
	public error() => {
		.'error_msg' == error_msg ? return
		
		
		local(i=lasso_uniqueid)
		.'error_code' = error_code
		.'error_msg' = error_msg
		.'errors'->insert(staticarray(error_code,error_msg,(error_code== 1064 ? action_statement | error_stack),#i))
		..insert('<div class="error">'+error_msg+'<div>'+(error_code== 1064 ? action_statement | error_stack)+'</div></div><a name="'+#i+'"></a>')
	}

	public error(what::string) => ..insert('<div class="error">'+#what+'</div>')

	public xml(xml::bytes)	=> .xml(#xml->exportString('UTF-8'))
	public xml(xml::xml) 	=> .xml(#xml->exportString('UTF-8'))
	public xml(xml::string)	=> {
		.trace(#xml,'xml')
		return self	
	}

	public found() => {
		.trace('Found '+found_count+' rows')
	}
		
	public found(what::string) => {
		.trace('Found '+found_count+' '+#what)
	}
	
	public sql() => {
		.insert('<code class="sql">' + string(action_statement)->replace('\t','   ')& + '</code>')
		return self	
	}
	
	public sql(statement::string) => {
		.insert('<code class="sql">' + #statement->replace('\t','  ')& + '</code>')	
		return self	
	}
	
	public css(what::string) => {
		.trace(#what,'css')
		return self	
	}
	
	public lasso(what::string) => {
		.trace(#what,'lasso')
		return self	
	}
	
	public html(what::string) => {
		.trace(#what,'html')
		return self	
	}
	
	public js(what::string) => {
		.trace(#what,'js')
		return self	
	}
	
	public time(when::integer=0) => {
		.insert('<span class="time">'+.since(#when)+'</span>')
		return self	
	}


	
	public time(what::string,when::integer=0) => {	
		.timer(#what)
		.trace(#what)
		.time(#when)
		return self	
	}
	
	public timer(what::string) => {		
		.'timers'->insert(#what=micros)
		return self	
	}

	public timer(i::integer) => {
		.open('timer x'+#i,'',' ')// style="display:inline-block"
		.traceParams(timer(#i) => givenblock)
		.close
	}

	public timer(i::integer,what::string) => {
		
		.open(#what+' x'+#i,'','')
		.traceParams(timer(#i) => givenblock)
		.close
	}
	
	public open(keyword::keyword) => { // ->open(-type = myblock)
		match(#keyword->name) => {
			case('type')
					.open(#keyword->value,#keyword->value)				
		}
		return self	
	}
	
	public protected(what::string='')=>{
		protect => {
			handle_error => .error
			return givenblock()
		}
		
	}
	
	//	debug->open(.type,method_name)
	public open(t::tag,m::tag,p::array=staticarray)=>{
		.open(#t->asstring+' > '+#m->asstring)
		.traceParams(#p)
	}
	
	public open(m::tag,p::staticarray=staticarray)=>{
		.open(#m->asstring)
		.traceParams(#p)
	
	}

	public block(what::string='') => {
		local(c=givenblock,method)

		if(#c->isa(::capture))=>{
			match(true)=>{
				case(#what)
					.open(#what)
				case(#c->self->isA(::void))
					.open(#c->self->type->asString+' > '+#c->methodname->asstring)
				case
					#method = (#c->self->hasMethod(::_unknowntag) ? 'Disabled (due to _unknown)' | #c->methodname->asstring)

					.open(#c->self->type->asString+' > '+#method)
					
			}

			handle => .close

			return #c()

		}
	}
	

	public block(params::staticarray) => {
		local(c=givenblock,method)
		if(#c->isa(::capture))=>{
			


			match(true)=>{
				case(#c->self->isA(::void))
					.open(#c->self->type->asString+' > '+#c->methodname->asstring)
				case
					#method = (#c->self->hasMethod(::_unknowntag) ? 'Disabled (due to _unknown)' | #c->methodname->asstring)
					.open(#c->self->type->asString+' > '+#method)	
			}

			.traceParams(#params)

			handle=>.close

			return #c()

		}
	}



	public open(c::capture,p::staticarray=staticarray)=>{

		#c->self->isA(::void)
		? .open(#c->methodname)
		| .open(#c->self->type->asString+' > '+(#c->self->hasMethod(::_unknowntag) ? 'Disabled (due to _unknown)' | #c->methodname->asstring))
		
		.traceParams(#p)
	}

	public open(what::string='',class::string='',style::string='') => {
		#class->size
		? .insert('<div class="' + .safeCSS(#class) + '">')
		| .insert('<div '+#style+'>')
		
		.'opened'->insertFirst(#what = micros)
		.'timers'->insert(-openblock = pair(#what = micros))
		.header(#what,false)
		return self
			
	}
	public close(what::string)=>{
		.trace(#what)
		.close
	}
	
	public close(p::any)=>{
		.trace(#p)
		.close
	}
	
	public close(-time=false) => {
		if(.hasOpen) => {
			.'timers'->insert(-closeblock = micros)	
			.insert('<span class="time block">' + .since(.lastOpenedTime) + '</span>')
			.insert('</div>')
			.'opened'->removeFirst
		
		}
		return self	
	}



//============================================================================
//
//		->	Timer - Renders external timer
//
//............................................................................
		
		public timers => {

			local(
				timers		= .'timers',
				start		= .'pageStartTime',
				total		= .'pageEndTime' - #start,
				avg			= #total / #timers->size,

				timer		= null,
				last 		= #start,
				time		= 0,
				closetime  	= 0,
				
				closes		= array,
				opens		= array,
				lookup 		= map,

				sinceStart = 0,
				
				what 		= null,
				title 		= string,
				output 		= string,
				class		= string,
				perc	 	= 0.00,
				left 		= 0,
				
				blocktime 	= 0,
				blockwidth 	= 0,
				skip		= false
				
			)
			
			
			
			with timer in #timers do {
				if(#timer->isa(::keyword) && #timer->name == 'openblock')=>{
					#opens->insert(#timer->value->value)
				}
				if(#timer->isa(::keyword) && #timer->name == 'closeblock')=>{
					#lookup->insert(#opens->last = #timer->value)
					#opens->removelast
				}
			}
			
			
			with timer in #timers do{
				if(#timer->isa(::keyword) && #timer->name == 'openblock')=>{
					#closes->insert(#lookup->find(#timer->value->value))
				}
			}	

			#output->append('<table cellspacing=0>')
			#output->append('<tr><th>Time</th><th>Name</th><th></th><th width=20></hr></tr>')
			
			with timer in #timers do {
				#skip = false
				#left = (#last - #start > 0 ? 100.0 * (#last - #start)/ #total)
				
				if(#timer->isa(::keyword) && #timer->name=='openblock')
					#what 	= #timer->value->name
					#time 	= #timer->value->value
					#closetime 	= #closes->first
							
					//	Note start time
					#sinceStart = #time - #start

					//	Set chart width
					#blocktime = #closetime - #time
					#blockwidth = (#blocktime > 0 ? 100.0 *(#blocktime->asdecimal / #total) | 0)

					//	Set new left position
					#left = 100.0 * (#time - #start)/ #total

					//	Set last time
					#last = #time

					#closes->removefirst
					

				else(#timer->isa(::keyword) && #timer->name=='closeblock')

					//	Set last time
					#last = #timer->value
					#skip = true
				
								
				else
					#what = #timer->name
					#time = #timer->value

					#sinceStart = #time - #start
					
					#blocktime = #time - #last
					#blockwidth = (#blocktime > 0 ? 100.0 *(#blocktime->asdecimal / #total) | 0)
					#last = #time


				/if
				
				if(!#skip) => {
					
					match(true)=>{
						case(#blocktime / #avg > 5)
							#class = 'red'
						case(#blocktime / #avg > 2.5)
							#class = 'orange'
						case(#blocktime / #avg > 1)
							#class = 'yellow'
						case
							#class = ''
							
					}
	
					#perc = #blockwidth
					#title = #what+': '+.microsecond(#blocktime)+' seconds'
					
					#output->append(
						'<tr title="'+#title+'" '+(#class?' class="'+#class+'"')+'><td>'+.millisecond(#blocktime)+'</td>
						<td nowrap class="what">'+#what+'</td><td class="perc"><div style="width:'+#perc+'%;margin-left:'+#left+'%">&nbsp</div></td>
						<td>'+#perc->asString('\'','1','f')+'%</td></tr>'
					)
				}
			}

			#output->append('</table>')

			return #output
						
		}
//============================================================================
//
//		->	Timer - Renders external timer
//
//............................................................................
		
		public timers => {

			local(
				timers		= .'timers',
				start		= .'pageStartTime',
				total		= .'pageEndTime' - #start,
				avg			= #total / #timers->size,

				timer		= null,
				last 		= #start,
				time		= 0,
				closetime  	= 0,
				
				closes		= array,
				opens		= array,
				lookup 		= map,

				sinceStart = 0,
				
				what 		= null,
				title 		= string,
				output 		= string,
				class		= string,
				perc	 	= 0.00,
				left 		= 0,
				
				blocktime 	= 0,
				blockwidth 	= 0,
				skip		= false
				
			)
			
			
			
			with timer in #timers do {
				if(#timer->isa(::keyword) && #timer->name == 'openblock')=>{
					#opens->insert(#timer->value->value)
				}
				if(#timer->isa(::keyword) && #timer->name == 'closeblock')=>{
					#lookup->insert(#opens->last = #timer->value)
					#opens->removelast
				}
			}
			
			
			with timer in #timers do{
				if(#timer->isa(::keyword) && #timer->name == 'openblock')=>{
					#closes->insert(#lookup->find(#timer->value->value))
				}
			}	

			#output->append('<table cellspacing=0>')
			#output->append('<tr><th>Time</th><th>Name</th><th></th><th width=20></hr></tr>')
			
			with timer in #timers do {
				#skip = false
				#left = (#last - #start > 0 ? 100.0 * (#last - #start)/ #total)
				
				if(#timer->isa(::keyword) && #timer->name=='openblock')
					#what 	= #timer->value->name
					#time 	= #timer->value->value
					#closetime 	= #closes->first
							
					//	Note start time
					#sinceStart = #time - #start

					//	Set chart width
					#blocktime = #closetime - #time
					#blockwidth = (#blocktime > 0 ? 100.0 *(#blocktime->asdecimal / #total) | 0)

					//	Set new left position
					#left = 100.0 * (#time - #start)/ #total

					//	Set last time
					#last = #time

					#closes->removefirst
					

				else(#timer->isa(::keyword) && #timer->name=='closeblock')

					//	Set last time
					#last = #timer->value
					#skip = true
				
								
				else
					#what = #timer->name
					#time = #timer->value

					#sinceStart = #time - #start
					
					#blocktime = #time - #last
					#blockwidth = (#blocktime > 0 ? 100.0 *(#blocktime->asdecimal / #total) | 0)
					#last = #time


				/if
				
				if(!#skip) => {
					
					match(true)=>{
						case(#blocktime / #avg > 5)
							#class = 'red'
						case(#blocktime / #avg > 2.5)
							#class = 'orange'
						case(#blocktime / #avg > 1)
							#class = 'yellow'
						case
							#class = ''
							
					}
	
					#perc = #blockwidth
					#title = #what+': '+.microsecond(#blocktime)+' seconds'
					
					#output->append(
						'<tr title="'+#title+'" '+(#class?' class="'+#class+'"')+'><td>'+.millisecond(#blocktime)+'</td>
						<td nowrap class="what">'+#what+'</td><td class="perc"><div style="width:'+#perc+'%;margin-left:'+#left+'%">&nbsp</div></td>
						<td>'+#perc->asString('\'','1','f')+'%</td></tr>'
					)
				}
			}

			#output->append('</table>')

			return #output
						
		}	



//============================================================================
//
//		->	Status Tags
//
//............................................................................		
			
		public isAjax() => {
			return client_headers >> 'XMLHttpRequest'
		}
		
		public isActive() => {
			return .'isActive'->invoke
		}

		public activate => {.'isActive' = true}
			
		public activate(mode::string) => {
			match(#mode)=>{
				case('console')
					var(.'var') = ldebug_console
				case
					var(.'var') = ldebug
			}
			
			var(.'var')->activate
		}
		
		public activate(...) => {
			.'isActive' = true
			.'variables'->insertFrom(vars->keys)
		
			//	Set locals
			local('js')->isA('string') 		? .'src_js' 	= #js
			local('css')->isA('string') 	? .'src_css' 	= #css
			local('style')->isA('style') 	? .'src_style' 	= #style
			local('jquery')->isA('string') 	? .'src_jquery' = #jquery
			local('mode')->isA('string') 	? .setMode(#mode)
		}

		public reset => {
			var(.'var') = null
		}
	
		public setActive() => {
			.'isActive' = local('isActive')		
		}

		public deActivate() => {
			.'isActive' = false	
		}

		public mode() => {
			return .'mode'
		}

		public setMode(mode::string) => {
			.'mode' = #mode
		}
			

//============================================================================
//
//		->	Setting handlers
//
//............................................................................	
	
		public setting(what::string) => {
			return .'settings'->find(#what)
		}
		
		public checked(what::string) => {
			return .setting(#what) ? 'checked'|''
		}
		
		public loadSettings() => {
			
			local(
				settings = .'settings',
				setting = null,
				name=string,
				value=string
			)

			//	Process cookie
			if(web_request)=>{
				
			
				with setting in decode_url(cookie('L-Debug','/'))->split(';') do {
					
					if(#setting >> ':') => {
						#name = #setting->split(':')->first
						#value =  #setting->split(':')->last
						
						// Convert booleans
						array('true','false') >> #value
						?	#value = (#value == 'true')
		
						// Save setting
						#settings->insert(#name=#value)
					}
	
				}
			
			}
			
		}


//============================================================================
//
//		->	Timer handling
//
//............................................................................
	
	public since(since::integer=0) => {
		//	Simple microsecond timer
						
		local(now = micros)

		! #since
		? #since = .'since'

		.'since' = #now

		return((#now - #since)->asDecimal/1000000.0000000)

	}




		
//============================================================================
//
//		->	asHTML - Outputs debug stack as HTML
//
//............................................................................		

		public asHTML() => {
			
			//
			
			.'pageEndTime' == 0 
			? .'pageEndTime' = micros
			
			if(.isActive)
				local(output = string)
			
				#output->append('<div class="' + .'class' + '">')
				#output->append(.content)
				#output->append('</div>'	)
				
				return #output				
			else
				return string
			/if
		}


		//	Return nothing...
		public asString() => {
			return string
		}

//============================================================================
//
//		->	HTML Output
//
//............................................................................


		public content() => {
			
			local(output=string)
	
	
			#output->append(
					'<form class="filter">
						<table cellspacing=0>
						<tr>
							<td rowspan="2">
								<h1>L-Debug</h1>
							<td>
							<td>
								<label><input type="checkbox" name="headers" ' + .checked('headers') + ' />Headers</label>
								<label><input type="checkbox" name="labels" ' + .checked('labels') + ' />Labels</label>
								<label><input type="checkbox" name="types" ' + .checked('types') + ' />Types</label>
							</td>
							<td>
								<label><input type="checkbox" name="HTML" ' + .checked('HTML') + ' />HTML</label>
								<label><input type="checkbox" name="SQL" ' + .checked('SQL') + ' />SQL</label>
								<label><input type="checkbox" name="XML" ' + .checked('XML') + ' />XML</label>
							</td>
							<td>
								<label><input type="checkbox" name="timers" ' + .checked('timers')+' />Timers</label>
								<label><input type="checkbox" name="errors" ' + .checked('errors')+' />Errors</label>
								<label><input type="checkbox" name="more" ' + .checked('more') + ' />More...</label>
							</td>
								<td valign=bottom class="search">
								<pre>' + .pageProcessTime + ' secs - '+date->format('%H:%M:%S')+'</pre>
								<span>Filter <i>(Case sensitive)</i><br/>
								<input type="text" name="search" value="'+.setting('search')+'"></span>
							</td>
						</tr>
						</table>
						
							<div class="more">' + .extraTypes + '</div>
						
					</form>'
			)
			
				#output->append('<div class="clientheaders">'+encode_html(client_headers)+'</div>')
				#output->append('<div class="variables">'+.variables+'</div>')
				#output->append('<div class="timers">'+.timers+'</div>')
				#output->append('<div class="errorstack">'+.errorstack+'</div>')
				#output->append('<div class="results">' + .join(string) + '</div>')
				return #output
		}

//============================================================================
//
//		->	injectHTML - Inserts self into current page
//
//............................................................................
		
		
		// Content type fix
		private content_type => content_header >> 'Content-Type' 
		? content_header->find('Content-Type')->first->value 

		private injectHTML => {
			.'pageEndTime' = micros
			
			//	Only do something when active...
			!.'isActive' ? return

			//	Only modify text/html
			.content_type !>> 'text/html' && .content_type ? return 
				
			//	Inject resources
			.injectResources
			
			// Make sure content body is not null
			! content_body ? content_body = '' 
							
			//	Update existing debug stack - assumes debug.js exists				
			if(.isAjax) 
				content_body->append(
					'<script>
						$("div.debug:last").html(unescape("'+encode_strictURL(.content)+'"));
						setTimeout(setupDebug,100)
					</script>'
				)
			
			//	Insert into existing div
			else(content_body >> '<div class="debug">')
				content_body->append(
					'<script>
						$("div.debug:last").html(unescape("'+encode_strictURL(.content)+'"))
					</script>'
				)

			//	Insert cleanly into html body
			else(content_body >> '</body>')
				content_body->replace('</body>',.asHTML+'</body>')

			//	Tack onto end of output
			else
				content_body->append(.asHTML)
			/if
		
		}

		
//============================================================================
//
//		External resources - these tags include links to external dependics if they do not exist on the current page.
//
//............................................................................
	

		private injectResources => {

			// Do nothing if ajax request
			.isAjax ? return

			local(resources=array,out=string)
	
			//	Only modify text/html
			.content_type !>> 'text/html' && .content_type ? return 
			
			// Make sure content body is not null
			! content_body ? content_body = '' 
			
			//	JQuery
			if(content_body !>> 'google.load("jquery' && !string_findRegExp(content_body,-find= 'jquery.*?\\.js')->size) => {
				#resources->insert(.tag_js(.'src_jquery'))
			}
	
			//	Chili
			.setting('rendercode') && content_body !>> 'chili-L' ? #resources->insert(.tag_js(.'src_chili'))
		
			//	JS
			content_body !>> 'debug.js' ? #resources->insert(.tag_js(.'src_js'))
	
			//	CSS
			content_body !>> 'debug.css' ? #resources->insert(.tag_css(.'src_css'))
			
			if(#resources->size) => {
				content_body >> '</body>' 
				?	content_body->replace('</body>',#resources->join('\n')+'</body>')
				|	content_body->append(#resources->join('\n'))
			}

		}

		private tag_js(js::string) =>{
			return '<script type="text/javascript" src="'+#js+'"></script>'	
		}
		
		private tag_css(css::string) =>{
			return '<link rel="stylesheet" href="'+#css+'" type="text/css"/>'	
		}
		
//============================================================================
//
//		Time rendering
//
//............................................................................


		public milliSecond(msec::integer)=>{
			return (decimal(#msec)*0.000001)->asString('\'','3','f')
		}

		public microSecond(msec::integer)=>	{
			local(f=(decimal(#msec)*0.000001)->asString('\'','6','f'))
			return(#f->merge(#f->size-2,',')&)

		}

		public pageProcessTime() => {
			return .milliSecond(.'pageEndTime' - .'pageStartTime')
		}


//============================================================================
//
//		->	Variables - Returns variables created after -> activate
//
//............................................................................

		public variables() => {

			local(
				output 	= string,
				variables = .'variables',
				name	= null,
				v		= null,
				c 		= 1
			)
			
			#output->append(
				'<table cellspacing=0><tr><th>Variable Name</th><th>Type</th><th>Size</th></tr>'
			)
			
			with name in vars->keys do {
				#v = vars->values->get(#c++)
				#output->append(
					'<tr'+(#variables >> #name?' class="dull"')+'>
						<td>'+#name+'</td>
						<td>'+#v->type+'</td>
						<td>'+(#v->hasmethod(::size) ? #v->size|'-')+'</td>
					  </tr>'
				)					
			}

			#output->append(
				'</table>'
			)

			return #output
			
		}


	
	public errorstack => {
		local(
			output=string,
			errors=.'errors'
		)
	
		with error in #errors do {
			#output->append(
				'<div><header><a href="#'+#error->get(4)+'">
				<small>&#9664;</small> '+#error->get(2)+'</a><i>'+#error->get(1)+'</i></header>
				<footer>'+#error->get(3)+'</footer></div>'
			)
		}
		return #output
	}
	
	
	



	
//============================================================================
//
//		->	extraTypes - Custom / Extra checkboxes
//
//............................................................................		
		
		public extraTypes() => {
			local(
				output = string,
				pair = pair,
				types = .'types',				
				every = math_floor(math_max(3,#types->size/4.0)),
				c = 0
			)
		
			if(#types->size) => {
			
				#types->sort
				
				#output->append('<table>')
				#output->append('<tr valign="top"><td>')



				with pair in #types do {
					local(
						name = #pair->name,
						value = #pair->value
					)
					
					#c++;

					#output->append(
						'<label><input type="checkbox" name="' + #value + '" ' + .checked(#value) + '>' + #name + '</label>'
					)
								
					! (#c % #every) && #c != 1 
					? #output->append('</td><td>')
					
				}

				#output->append('</td><td colspan="99"></td></tr></table>')
				
				return #output
			}
									
		}
		
		public safeCSS(label::string='') =>	#label->replace(' ','')&replace('.','')&

}




//============================================================================
//
//		->	CONSOLE MODE
//
//............................................................................
	

define ldebug_console => type {
	parent ldebug

	public oncreate => {
		!	var(.'var')->isA(::ldebug)
		?	var(.'var') = self	
	}
	
	public asHTML => ''


	public trace(what::any) => {		
		.insert(#what)	
		return self	
	}
	
	public trace(what::string) => {		
		.insert(.text(#what))
		return self	
	}

	public trace(what::pair) => {		
		.insert(.render(#what))	
		return self	
	}

	public trace(what::string,mode::string) => {		
		.insert(.dim+.text('// '+(#mode->uppercase&)+.white+'\n'+#what))
		return self	
	}

	public trace(object::trait_forEach) => {
		// Render iteratable
		.insert(.render(#object))
		return self
	}

	public traceParams(p::trait_forEach) => {
		// Render iteratable
		with i in #p do {
			.insert(.render(#i))
		}
		return self
	}



//============================================================================
//
//		->	Output to stack
//
//............................................................................


	
	
	public insert(p::any) => {
		if(error_code && .'error_msg'!=error_msg)=>{
			.error
		} 
		
		
		.'isActive'	? stdoutnl(.tabs+string(#p)) 
	}


	private error() => {
		.'error_msg' == error_msg ? return

		local(i=lasso_uniqueid)
		
		.'error_code' = error_code
		.'error_msg' = error_msg
		.'errors'->insert(staticarray(error_code,error_msg,error_stack,#i))
		.'isActive'	? stdoutnl(.tabs + .red + ' ERROR: '+.white +.bold +' '+error_msg + .white)
	}	

//============================================================================
//
//		->	Console tweaks
//
//............................................................................
	
	private red => .esc+'[1;37;41m'
	private white => .esc+'[0;39;49m'
	private dim => .esc+'[2;37;49m'
	private bold => .esc+'[1;39;49m'
	
	private esc => decode_base64('Gw==')
	private tabs => '|\t'*(.'opened'->size)
	//private spaces => ' '*'[2011-01-23 22:29:45] '->size
	private spaces => ''
	private text(what::string) => {
		local(out=string)
		
		
		#what->	replace('\r\n','\n')
			&	replace('\r','\n')
			&	replace('\t','  ')
			&	replace('\n','\n'+.spaces+.tabs)
	
		return #what
	
	}
	
	private pad(p::string='') => 50 - (#p->size + 2 + (.'opened'->size * 9)) 

//============================================================================
//
//		->	Object rendering
//
//............................................................................



	public render(object::trait_forEach,output=string) => {

		#output->append('> '+#object->type+'\n')
		
		local(c=1)

		with i in #object do{
			#output->append( .spaces + .tabs + ' ' + (#c++) + '. ' + .render(#i) + '\n')
		}		

		#output->removetrailing('\n')
		
		return #output
	}

	public render(pair::pair) => {
		return #pair->name + ': ' + .render(#pair->value)
	}

	public render(keyword::keyword) => {
		return '-'+#keyword->name + ': ' + .render(#keyword->value)
	}


	public render(what::integer) => string(#what)
	public render(what::decimal) => string(#what)
	public render(what::string) => {
		return #what
	}
	
	public render(what::any) => {
		return string(#what->type) + ': ' + string(#what)
	}

	public render(what::ldebug) => {
		return ''
	}

	public header(what::string) => {	
		.insert('') & insert(.bold+#what->uppercase&+.white)
		return self	
	}

	public header(what::string,p::boolean) => {	
		.header(#what->uppercase)
		return self	
	}
	
	
	public open(what::string='',class::string='',style::string='') => {
		.'timers'->insert(-openblock = pair(#what = micros))
		
		.insert('')
		
		#class->size
		? .insert('┌──── '+#class+' '+('─' * .pad(#class))+.dim+'─┐'+.white)
		| .insert('┌──── '+#what+' '+('─' * .pad(#what))+.dim+'─┐'+.white)	

		.'opened'->insertFirst(#what = micros)
	
		
//		.header(#what,false)
		return self
			
	}
	
	public close(-time=false) => {
		if(.hasOpen) => {
			.'timers'->insert(-closeblock = micros)	
			.insert(.since(.lastOpenedTime))
			.'opened'->removeLast
		
		}
		.insert('└──────'+('─' * .pad)+.dim+'─┘'+.white)
		
		return self	
	}



//============================================================================
//
//		->	Specific types
//
//............................................................................




	public xml(xml::string)	=> {
		.trace(#xml,'xml')
		return self
	}	
	
	public css(what::string) => {
		.trace(#what,'css')
		return self	
	}
	
	public lasso(what::string) => {
		.trace(#what,'lasso')
		return self	
	}
	
	public html(what::string) => {
		.trace(#what,'html')
		return self	
	}
	
	public js(what::string) => {
		.trace(#what,'js')
		return self	
	}
	
	public time() => {
		.insert('<span class="time">'+.since+'</span>')
		return self 	
	}

	public time(what::string) => {	
		.timer(#what)
		.trace(#what)
		.time
		return self	
	}

	public timer(what::string) => {		
		//.'timers'->insert(#what=micros)
		return self	
	}

	
	public sql() => {
		.trace(action_statement,'sql')
		return self	
	}
	
	public sql(statement::string) => {
		.trace(#statement,'sql')
		return self	
	}
		
	

}



//	Updated to handle given blocks
define debug => {

	var(_l_debug)->isnota(::ldebug) ? $_l_debug = ldebug
	
	givenblock ? return ($_l_debug->block => givenblock)

	return $_l_debug

}



//	Public signatures
define debug(p::string) 			=> debug->trace(#p)
define debug(p::string,h::boolean) 	=> debug->trace(#p)
//define debug(p::string) 			=> givenblock ? (debug->block(#p) => givenblock) | debug->trace(#p)

define debug(p::string) 			=> {
	if(givenblock) => {
		return debug->block(#p) => givenblock
	else
		return debug->trace(#p)
	}
}

define debug(p::staticarray) 		=> {
	return givenblock ? (debug->block(#p) => givenblock) | debug->trace(#p)
} 


define debug(p::trait_forEach) 	=> debug->trace(#p) & block => givenblock

define debug(p::xml) => debug->xml(#p)

// Catch all signature
define debug(
	p::any,
	-mode 	= 'text',
	-open	= false,
	-close	= false,
	-error	= false,
	-sql	= false,
	-html	= false,
	-xml	= false,
	-lasso	= false,
	-code	= false,
	-timer	= false,
	-time	= false,
	-header	= false,
	-title	= false,
	-async	= false,
	-withErrors = false,
	-d 	= debug
) => {

	#open ? #d->open

	match(true) => {
		case(#error)
			#d->error(#p)

		case(#sql)			
			#d->sql(#p)
	
		case(#xml)			
			#d->xml(#p)
	
		case(#html)			
			#d->html(#p)
	
		case(#lasso)			
			#d->lasso(#p)

		case(#code)			
			#d->code(#p)

		case(#time)			
			#d->time(#p)

		case(#timer)			
			#d->timer(#p)

		case(#title)			
			#d->title(#p)

		case(#header)			
			#d->header(#p)
			
		case
		
		
			#d->trace(#p)
	}

	#close ? #d->close
	
	givenblock ? return (#d->block => givenblock)

	return #d

};

?>