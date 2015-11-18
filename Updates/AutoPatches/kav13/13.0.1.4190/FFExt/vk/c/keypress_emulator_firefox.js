var KasperskyLabVirtualKeyboard = (function (ns)
{

ns.KeypressEmulatorFirefoxImpl = function()
{
	this.generateInputEvents = function()
	{
		return true;
	}

	this.createEvent = function(document)
	{
		return document.createEvent('Event');
	}

	this.createKeyboardEvent = function(document)
	{
		return document.createEvent('KeyboardEvent');
	}

	this.initEvent = function(event, eventType)
	{
		event.initEvent(eventType, true, true);
	}

	this.initKeyboardEvent = function(document, event, eventType, charCode, keyCode, isCtrl, isAlt, isShift, keyLocation)
	{
		if ('location' in event)
		{
			Object.defineProperty(event, "location", { value: keyLocation, enumerable: true });
		}

		event.initKeyEvent(eventType, true, true, document.defaultView,
			isCtrl,
			isAlt,
			isShift,
			false, // Meta
			getFirefoxKeyCode(keyCode),
			charCode
			);
	}

	this.fireEvent = function(event, _ /* eventType */, element)
	{
		return element.dispatchEvent(event);
	}

	this.insertCharacter = function(element, char)
	{
		require(element.ownerDocument && element.ownerDocument.activeElement === element, 'Element should be in document and should be active');
		require(typeof char === 'string' && char.length === 1, 'Invalid parameter');

		// TODO: this is legacy code, it needs refactoring
		var selStart = element.selectionStart;
		var selEnd = element.selectionEnd;

		var valueLength = element.value.length;
		var beforeSelection = element.value.substr(0, selStart);
		var afterSelection = element.value.substr(selEnd, valueLength);

		element.value = beforeSelection + char + afterSelection;

		var diffLen = element.value.length - valueLength;
		var selLength = selEnd - selStart;
		var pos = selStart + diffLen + selLength;

		element.setSelectionRange(pos, pos);
	}

	var m_firefoxVersion = getFirefoxVersion();

	function getFirefoxKeyCode(keyCode)
	{
		if (keyCode === 186) // ';'
			return 59;
		if (m_firefoxVersion <= 9)	// This version number was chosen just to make tests green.
										// TODO: Find in what FF version these key codes were changed.
		{
			if (keyCode === 187) // '='
				return 107;
			if (keyCode === 189) // '-'
				return 109;
		}
		else
		{
			if (keyCode === 187) // '='
				return 61;
			if (keyCode === 189) // '-'
				return 173;
		}
		return keyCode;
	}

	function getFirefoxVersion()
	{
		var version = /Firefox\/(\d+\.\d+)/.exec(navigator.userAgent);
		if (!version || version.length !== 2)
			return NaN;
		return parseInt(version[1]);
	}
}

// TODO: move this function to a common place
function require(condition, message)
{
	if (!condition)
	{
		throw new Error(message ? message : 'Requirement failure');
	}
}

return ns;
}(KasperskyLabVirtualKeyboard || {}));
