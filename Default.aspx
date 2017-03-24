<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="https://www.sagepayments.net/pay/1.0.1/js/pay.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
<asp:Button ID="paymentButton1" runat="server" class="btn btn-primary" Text="Pay Now" OnClick="paymentButton_Click" />
  
    </form>
</body>
</html>
