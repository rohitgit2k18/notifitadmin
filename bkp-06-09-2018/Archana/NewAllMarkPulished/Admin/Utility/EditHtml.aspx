<%@ Page Language="C#" Title="Edit HTML" Inherits="CommerceBuilder.UI.AbleCommercePage" EnableTheming="false" ValidateRequest="false" Theme="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Edit HTML</title>
	<script src="../../Scripts/jquery-1.10.2.min.js" type="text/javascript"></script>
</head>
<script type="text/javascript">
    function load() {
        var callerField = top.opener.document.getElementById('<%=Request.QueryString["Field"]%>');
        if (callerField) {
            $('#<%=Editor.ClientID%>').tinymce().setContent(callerField.value);
        }
        $('#<%=Editor.ClientID%>').tinymce().execCommand('mceFullScreen');
    }

    function save() {
        var callerField = top.opener.document.getElementById('<%=Request.QueryString["Field"]%>');
        if (callerField) {
            callerField.value = tinyMCE.activeEditor.getContent();
            window.close();
        }
    }
</script>
<body onload="setTimeout('load()', 1000)">
    <form id="form1" runat="server">
        <cb:HtmlEditor ID="Editor" runat="server" Height="400" Width="100%" SaveCallback="save" IgnoreStoreSettings="true"></cb:HtmlEditor>
    </form>
</body>
</html>