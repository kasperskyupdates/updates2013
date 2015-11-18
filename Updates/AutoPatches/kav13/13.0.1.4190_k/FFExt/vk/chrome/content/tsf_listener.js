var KasperskyLabVirtualKeyboard = (function (ns) 
{

ns.TsfListener = function(element, window, isValidDomObject, tracer)
{
	var m_tsfEditor = 0;

	this.QueryInterface = function(aIID)
	{
		if (aIID.equals(Components.interfaces.ITsfListener) ||
			aIID.equals(Components.interfaces.nsISupports))
		{
			return this;
		}

		throw Components.results.NS_NOINTERFACE;
	}

	this.CreateTsfEditor = function(tsfEditorEventsSink)
	{
		try
		{
			destroyTsfEditor();

			var viewFactory = function(element, window, document)
			{
				return new KasperskyLabVirtualKeyboard.TsfCompositionView(element, window, document);
			}
			var sinkAdapter = new TsfEditorEventsSinkAdapter(tsfEditorEventsSink, window);
			m_tsfEditor = new KasperskyLabVirtualKeyboard.TsfEditor(element, window, element.ownerDocument, sinkAdapter, viewFactory);
		}
		catch (e)
		{
			tracer.traceError('CreateTsfEditor exception: ' + e);
		}
	}

	this.DestroyTsfEditor = function()
	{
		try
		{
			destroyTsfEditor();
		}
		catch (e)
		{
			tracer.traceError('DestroyTsfEditor exception: ' + e);
		}
	}

	function destroyTsfEditor()
	{
		if (m_tsfEditor)
		{
			m_tsfEditor.destroy();
			m_tsfEditor = null;
		}
	}

	this.InsertText = function(text)
	{
		try
		{
			check(!!m_tsfEditor, 'No TSF editor is avaliable');
			m_tsfEditor.insertText(text);
		}
		catch (e)
		{
			tracer.traceError('InsertText exception: ' + e);
		}
	}

	this.SetComposition = function(text, selectionStart, selectionEnd, textDecorations)
	{
		try
		{
			check(!!m_tsfEditor, 'No TSF editor is avaliable');
			m_tsfEditor.setComposition({
				text: text,
				selectionStart: selectionStart,
				selectionEnd: selectionEnd,
				textDecorations: JSON.parse(textDecorations)
				});
		}
		catch (e)
		{
			tracer.traceError('SetComposition exception: ' + e);
		}
	}
}

function TsfEditorEventsSinkAdapter(tsfEditorEventsSink, window)
{
	this.onCompositionLayoutChange = function(compositionLayout, _ /*browserWindowLayout*/)
	{
		if (compositionLayout.isVisible)
		{
			var scaleFactor = getScaleFactor();
			var compositionTextRect = convertToScreenCoordinates(compositionLayout.compositionTextRect, scaleFactor);
			var selectedTextRect = convertToScreenCoordinates(compositionLayout.selectedTextRect, scaleFactor);
			tsfEditorEventsSink.OnCompositionLayoutChange(
				compositionLayout.isVisible,
				compositionTextRect.left, compositionTextRect.top, compositionTextRect.right, compositionTextRect.bottom,
				selectedTextRect.left, selectedTextRect.top, selectedTextRect.right, selectedTextRect.bottom
				);
		}
		else
		{
			tsfEditorEventsSink.OnCompositionLayoutChange(
				compositionLayout.isVisible,
				0, 0, 0, 0,
				0, 0, 0, 0
				);
		}
	}

	function convertToScreenCoordinates(rect, scaleFactor)
	{
		var x = window.top.mozInnerScreenX;
		var y = window.top.mozInnerScreenY;
		return {
			left: (x + rect.left)*scaleFactor,
			top: (y + rect.top)*scaleFactor,
			right: (x + rect.right)*scaleFactor,
			bottom: (y + rect.bottom)*scaleFactor
			};
	}

	function getScaleFactor()
	{
		var domWindowUtils = window.QueryInterface(Components.interfaces.nsIInterfaceRequestor)
			.getInterface(Components.interfaces.nsIDOMWindowUtils);
		return domWindowUtils.screenPixelsPerCSSPixel;
	}
}

function check(condition, message)
{
	if (!condition)
	{
		throw new Error(message ? message : 'Requirement failure');
	}
}

return ns;
}(KasperskyLabVirtualKeyboard || {}));
