var KasperskyLabVirtualKeyboard = (function (ns) 
{

ns.VirtualKeyboardExtension = function(tracer)
{
	const HideInplaceIconTimeout = 500;
	var m_protectableElementDetector = new KasperskyLabVirtualKeyboard.ProtectableElementDetector();
	var m_keypressEmulator = new KasperskyLabVirtualKeyboard.KeypressEmulator(new KasperskyLabVirtualKeyboard.KeypressEmulatorFirefoxImpl());

	this.DomElementCid = "@kaspersky.com/virtual_keyboard/DomElement;1";
	this.VirtualKeyboardCid = "@kaspersky.com/virtual_keyboard/VirtualKeyboard;1";
	this.StartDeepParentsGathering = 0;

	this.m_activeElement = null;
	this.m_virtualInputActivated = false;
	this.m_tracer = tracer;
	this.m_icon = null;
	this.m_iconInjector = new KasperskyLabVirtualKeyboard.VirtualKeyboardIconInjector(window, KasperskyLabVirtualKeyboard.Resources.KeyboardIcon);
	this.m_lastFocusedElement = null;
	this.m_hideInplaceIconTimer = null;

	var thisObject = this;

	var virtualKeyboard = Components.classes[this.VirtualKeyboardCid].createInstance();
	this.m_virtualKeyboard = virtualKeyboard.QueryInterface(Components.interfaces.IVirtualKeyboard);

	KasperskyLabVirtualKeyboard.GetBrowserAccess().addProgressListener(new KasperskyLabVirtualKeyboard.ProgressListener(tracer,
		function(window) { thisObject.OnPageTransitionStart(window); },
		function(window) { thisObject.OnPageTransitionStop(window); }
	));

	var strings = document.getElementById('virtual_keyboard_strings').stringBundle;
	this.m_tooltip = new KasperskyLabVirtualKeyboard.OnceTimedTooltip(window, strings.GetStringFromName('inputFieldTooltip'));
	this.m_tracer.trace('Virtual keyboard extension created');


	this.FinalRelease = function()
	{
		this.m_virtualKeyboard = null;
	}

	this.OnPageTransitionStart = function(window)
	{
		try
		{
			this.m_tracer.trace('Page transition started');
			this.GenerateBlurEvent(window.document);
		}
		catch (exc)
		{
			this.m_tracer.traceError('OnPageTransitionStart. Exception: ' + exc);
		}
	}

	this.OnPageTransitionStop = function(window)
	{
		try
		{
			this.m_tracer.trace('Page transition stop');
			this.SetEventListenersToWindow(window);
			this.GenerateFocusEvent(window.document);
		}
		catch (exc)
		{
			this.m_tracer.traceError('OnPageTransitionStop. Exception: ' + exc);
		}
	}

	this.SetEventListenersToElements = function(elements)
	{
		for (var i = 0; i < elements.length; ++i)
		{
			var element = elements[i];
			if (m_protectableElementDetector.test(element))
				this.AddEventListeners(element);
		}
	}

	this.SetEventListenersToDocument = function(document)
	{
		this.SetEventListenersToElements(document.getElementsByTagName('input'));
	}

	this.SetEventListenersToWindow = function(window)
	{
		this.SetEventListenersToDocument(window.document);
		for (var i = 0; i < window.frames.length; ++i)
			this.SetEventListenersToWindow(window.frames[i]);
	}

	function GetFocusedElementOrNull(document)
	{
		var element = document.activeElement;
		if (!element)
			return null;
		if (element.tagName.toLowerCase() == 'iframe')
			return GetFocusedElementOrNull(element.contentDocument);
		return document.hasFocus() ? element : null;
	}

	function IsDocumentInsideDocument(possiblyNestedDocument, possiblyParentDocument)
	{
		if (!(possiblyNestedDocument instanceof HTMLDocument) || !(possiblyParentDocument instanceof HTMLDocument))
			return false;
		var document = possiblyNestedDocument;
		while (document.defaultView && document.defaultView.frameElement)
		{
			document = document.defaultView.frameElement.ownerDocument;
			if (document === possiblyParentDocument)
				return true;
		}
		return false;
	}

	function IsElementInsideDocument(element, document)
	{
		if (!element || !document)
			return false;
		var elementDocument = element.ownerDocument;
		if (elementDocument === document)
			return true;
		return IsDocumentInsideDocument(elementDocument, document);
	}

	this.GenerateBlurEvent = function(document)
	{
		if (this.m_activeElement && IsElementInsideDocument(this.m_activeElement, document))
		{
			this.m_tracer.trace('Generating blur');
			this.OnElementBlur(this.m_activeElement);
		}
	}

	this.GenerateFocusEvent = function(document)
	{
		var element = GetFocusedElementOrNull(document);
		if (this.m_activeElement === element)
			return;
		this.GenerateBlurEvent(document);
		if (!element)
			return;
		var tagName = element.tagName.toLowerCase();
		if (m_protectableElementDetector.test(element))
		{
			this.m_tracer.trace('Generating focus event for ' + tagName);
			this.OnElementFocus(element);
		}
	}

	this.AddEventListeners = function(element)
	{
		var secureInputValue = element.attributes.getNamedItem(KasperskyLabVirtualKeyboard.Resources.SecureInputAttributeName);
		if (secureInputValue != null && secureInputValue.value == KasperskyLabVirtualKeyboard.Resources.SecureInputAttributeValueOn)
		{
			return;
		}

		element.setAttribute(KasperskyLabVirtualKeyboard.Resources.SecureInputAttributeName, KasperskyLabVirtualKeyboard.Resources.SecureInputAttributeValueOn);
		var thisObject = this;
		element.addEventListener('focus', function(event) { thisObject.OnElementFocus(event.target); }, false);
		element.addEventListener('blur', function(event) { thisObject.OnElementBlur(event.target); }, false);
	}

	function GetElementPropertyAsString(element, propertyName)
	{
		var property = element[propertyName];
		return property ? String(property) : '';
	}

	function CreateParentsTree(element, requiredDeep)
	{
		var parents = Components.classes["@mozilla.org/array;1"].createInstance(Components.interfaces.nsIMutableArray);

		for (deep=0; deep < requiredDeep; deep++)
		{
			if (!element.parentNode) break;

			var domElement = Components.classes[this.DomElementCid].createInstance().QueryInterface(Components.interfaces.IDomElement);
			domElement.SetName(element.parentNode.nodeName);
			domElement.SetType(GetElementPropertyAsString(element.parentNode, 'type'));
			parents.appendElement(domElement, false);

			element = element.parentNode;
		}

		return parents;
	}

	function getWindowFromElement(element)
	{
		var document = element.ownerDocument;
		return document.defaultView || document.parentWindow;
	}

	this.OnElementFocus = function(element)
	{
		try
		{
			if (this.m_hideInplaceIconTimer)
			{
				clearTimeout(this.m_hideInplaceIconTimer);
				this.m_hideInplaceIconTimer = null;
			}
			
			this.m_activeElement = null;

			this.RemoveKeyboardIcon();
			this.m_tooltip.hide();

			this.m_activeElement = element;

			var secureInputListener = new KasperskyLabVirtualKeyboard.SecureInputListener(
				element, m_keypressEmulator, isValidDomObject, this.m_tracer
				);
			var tsfListener = new KasperskyLabVirtualKeyboard.TsfListener(
				element, getWindowFromElement(element), isValidDomObject, this.m_tracer
				);

			var inputFieldInfo = this.GetInputFieldInfo(element);
			var secureInputEnabled = {};
			this.m_virtualKeyboard.ActivateVirtualInput(
				inputFieldInfo.secureInputApplied,
				element.type,
				secureInputListener,
				tsfListener,
				secureInputEnabled
				);
			this.m_virtualInputActivated = true;

			if (inputFieldInfo.hasInplaceIcon)
			{
				this.AddKeyboardIcon(element);
			}

			if (inputFieldInfo.hasTooltip && secureInputEnabled.value)
			{
				this.m_tooltip.show(element);
			}

			this.m_tracer.trace('Virtual input activated (secure=' + secureInputEnabled.value + ')');
		}
		catch (exc)
		{
			this.m_tracer.traceError('OnElementFocus. Exception: ' + exc);
		}
	}

	this.OnElementBlur = function(element)
	{
		try
		{
			var pThis = this;
			this.m_hideInplaceIconTimer = setTimeout(function() { pThis.RemoveKeyboardIcon(); }, HideInplaceIconTimeout);
			
			this.m_tooltip.hide();

			if (this.m_virtualInputActivated == true)
			{
				this.m_tracer.trace('Deactivating virtual input');
				this.m_lastFocusedElement = element;
				this.m_virtualKeyboard.DeactivateVirtualInput();
				this.m_virtualInputActivated = false;
			}

			this.m_activeElement = null;
		}
		catch (exc)
		{
			this.m_tracer.traceError('OnElementBlur. Exception: ' + exc);
		}
	}

	this.RemoveKeyboardIcon = function()
	{
		this.m_iconInjector.hideIcon(this.m_icon);
		this.m_icon = null;
	}

	this.AddKeyboardIcon = function(element)
	{
		var thisObject = this;
		var url = element.ownerDocument.URL;
		this.m_icon = this.m_iconInjector.showIcon(element, 
			function(){ thisObject.OnShowVirtualKeyboardWidget(url); } );
	}

	this.GetInputFieldInfo = function(element)
	{
		var currentElement = Components.classes[this.DomElementCid].createInstance().QueryInterface(Components.interfaces.IDomElement);
		currentElement.SetName(element.name);
		currentElement.SetType(GetElementPropertyAsString(element, 'type'));

		var inputFieldInfo =
			{
				hasTooltip: false,
				hasInplaceIcon: false,
				secureInputApplied: false
			};

		var deep = this.StartDeepParentsGathering;
		while(1)
		{
			var parents = CreateParentsTree(element, deep);
			if (parents.length != deep && deep != this.StartDeepParentsGathering)
			{
				return inputFieldInfo;
			}

			var hasTooltip = {};
			var hasInplaceIcon = {};
			var needMoreParentContext = {};
			var secureInputApplied = {};

			this.m_virtualKeyboard.TestInputField(element.ownerDocument.URL, currentElement, parents, hasTooltip, hasInplaceIcon, needMoreParentContext,
				secureInputApplied);

			if (needMoreParentContext.value)
			{
				deep = deep + 1;
				continue;
			}

			inputFieldInfo.hasTooltip = hasTooltip.value;
			inputFieldInfo.hasInplaceIcon = hasInplaceIcon.value;
			inputFieldInfo.secureInputApplied = secureInputApplied.value;
			break;
		}

		return inputFieldInfo;
	}

	function classof(object)
	{
		if (object === null) return "Null";
		if (object === undefined) return "Undefined";
		return Object.prototype.toString.call(object).slice(8,-1);
	}

	function isValidDomObject(object)
	{
		return object && classof(object) != 'DeadObject';
	}

	this.OnShowVirtualKeyboardWidget = function(url)
	{
		try
		{
			if (this.m_lastFocusedElement)
			{
				this.m_lastFocusedElement.focus();
			}
			
			this.m_virtualKeyboard.ShowVirtualKeyboardWidget(url);
		}
		catch (exc)
		{
			this.m_tracer.traceError('OnShowVirtualKeyboardWidget. Exception: ' + exc);
		}
	}
}

return ns;
}(KasperskyLabVirtualKeyboard || {}));
