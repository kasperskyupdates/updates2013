var KasperskyLabVirtualKeyboard = (function (ns) 
{

ns.SecureInputListener = function(element, keypressEmulator, isValidDomObject, tracer)
{
	this.QueryInterface = function(aIID)
	{
		if (aIID.equals(Components.interfaces.ISecureInputListener) ||
			aIID.equals(Components.interfaces.nsISupports))
		{
			return this;
		}

		throw Components.results.NS_NOINTERFACE;
	}

	this.OnProtectedKeyboardEvent = function(text, keyCode, isCtrl, isAlt, isShift, isNumpad)
	{
		try
		{
			if (
				!isValidDomObject(element)
				|| !element.ownerDocument
				|| element != element.ownerDocument.activeElement
				)
			{
				return;
			}

			keypressEmulator.emulateKeyboardEvent(element, text, keyCode, isCtrl, isAlt, isShift, isNumpad);
		}
		catch (exc)
		{
			tracer.traceError('OnProtectedKeyboardEvent. Exception: ' + exc);
		}
	}
}

return ns;
}(KasperskyLabVirtualKeyboard || {}));
