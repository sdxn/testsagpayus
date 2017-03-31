using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PayJStest;
using Newtonsoft.Json;

public partial class _Default : System.Web.UI.Page
{
    private string jsonReq
    {
        set { Session["jsonReq"] = value; }
        get { return (string)Session["jsonReq"]; }
    }

    private string AuthKey
    {
        set { Session["AuthKey"] = value; }
        get { return (string)Session["AuthKey"]; }
    }
    Nonces Nonces = Shared.GetNonces();
    protected void Page_Load(object sender, EventArgs e)
    {
        var request = new
        {
            merchantId = Shared.MerchantID,
            merchantKey = Shared.MerchantKEY, // don't include the Merchant Key in the JavaScript initialization!
            requestType = "payment",
            orderNumber = Shared.Orderno,
            amount = Shared.Amount,
            salt = Nonces.Salt,
            postbackUrl = Shared.PostbackUrl,
            preAuth = Shared.PreAuth
        };

        jsonReq = JsonConvert.SerializeObject(request);
        AuthKey = Shared.GetAuthKey(jsonReq, Shared.DeveloperKEY, Nonces.IV, Nonces.Salt);

    }

    protected void paymentButton_Click(object sender, EventArgs e)
    {
        string url = "Default2.aspx?MerchantID=" + Shared.MerchantID + "&Merchantkey=" + Shared.MerchantKEY + "&AuthKey=" + AuthKey
                    + "&amount=" + Shared.Amount + "&salt=" + Nonces.Salt + "&postbackUrl=" + Shared.PostbackUrl + "&preAuth=" + Shared.PreAuth
                    + "&clientID=" + Shared.DeveloperID + "&orderNumber=" + Shared.Orderno;
        Response.Redirect(url);
    }
}