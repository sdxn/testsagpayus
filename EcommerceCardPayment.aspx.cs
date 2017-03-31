using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Xml.Serialization;
using System.Xml;
using System.Net;
using System.IO;
using System.Globalization;
using System.Reflection;
using System.Text;
using MySql.Data.MySqlClient;
using PayJStest;
using Newtonsoft.Json;
using sforce;

public partial class EcommerceCardPayment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        utilsClass.writetrace("income-sagepay-ecommerce-debug.txt", System.DateTime.Now.ToString("yyyy_MM_dd HH:mm:ss") + " - -------------------------------------");
        utilsClass.writetrace("income-sagepay-ecommerce-debug.txt", System.DateTime.Now.ToString("yyyy_MM_dd HH:mm:ss") + " - process Income Card payment just started");
        utilsClass.writetrace("income-sagepay-ecommerce-debug.txt", System.DateTime.Now.ToString("yyyy_MM_dd HH:mm:ss") + " - -------------------------------------");
        utilsClass.writetrace("income-sagepay-ecommerce-debug.txt", System.DateTime.Now.ToString("yyyy_MM_dd HH:mm:ss") + " - full query string = " + Request.QueryString.ToString());


    }



    public static String SerializeObject(Object objectToSerialize)
    {
        String XmlizedString = null;
        MemoryStream memoryStream = new MemoryStream();
        XmlSerializer xs = new XmlSerializer(objectToSerialize.GetType());
        XmlTextWriter xmlTextWriter = new XmlTextWriter(memoryStream, Encoding.UTF8);
        xs.Serialize(xmlTextWriter, objectToSerialize);
        memoryStream = (MemoryStream)xmlTextWriter.BaseStream;
        XmlizedString = UTF8ByteArrayToString(memoryStream.ToArray());
        return XmlizedString;
    }

    public static String UTF8ByteArrayToString(Byte[] characters)
    {
        UTF8Encoding encoding = new UTF8Encoding();
        String constructedString = encoding.GetString(characters);
        return (constructedString);
    }
}

