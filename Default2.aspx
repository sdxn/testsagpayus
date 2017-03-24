<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="https://www.sagepayments.net/pay/1.0.1/js/pay.min.js"></script>
    <script type="text/javascript">
        function getQueryParam(param) {
            var result = window.location.search.match(
                new RegExp("(\\?|&)" + param + "(\\[\\])?=([^&]*)")
            );

            return result ? result[3] : false;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <div class="wrapper text-center">
    <div id="customFormWrapper" class="static">
        <form class="form" id="myCustomForm">
            <h1>Checkout Now</h1>
            <div class="form-group billing" id="name-group">
                <label class="control-label">Name</label>
                <input type="text" class="form-control" id="billing_name" value="" placeholder="">
                <span class="help-block"></span>
            </div>
            <div class="form-group billing" id="address-group">
                <label class="control-label">Street Address</label>
                <input type="text" class="form-control" id="billing_street" value="" placeholder="">
                <span class="help-block"></span>
            </div>
            <div class="form-group billing" id="city-group">
                <label class="control-label">City</label>
                <input type="text" class="form-control" id="billing_city" value="" placeholder="">
                <span class="help-block"></span>
            </div>
            <div class="form-group billing" id="state-group">
                <label class="control-label">State</label>
                <input type="text" class="form-control" id="billing_state" value="" placeholder="">
                <span class="help-block"></span>
            </div>
            <div class="form-group billing" id="zip-group">
                <label class="control-label">Zip</label>
                <input type="text" class="form-control" id="billing_zip" value="" placeholder="">
                <span class="help-block"></span>
            </div>
            <div class="form-group cc" id="cc-group">
                <label class="control-label">Credit Card Number</label>
                <input type="text" class="form-control" id="cc_number" value="" placeholder="">
                <span class="help-block"></span>
            </div>
            <div class="form-group cc" id="exp-group">
                <label class="control-label">Expiration Date</label>
                <input type="text" class="form-control" id="cc_expiration" value="" placeholder="">
                <span class="help-block"></span>
            </div>
            <div class="form-group cc" id="cvv-group">
                <label class="control-label">CVV</label>
                <input type="text" class="form-control" id="cc_cvv" value="" placeholder="">
                <span class="help-block"></span>
            </div>

            <button class="btn btn-primary" id="paymentButton">Pay Now</button>
        </form>
        <!--<br /><br />-->
        <!--<h5>Results:</h5>-->
        <!--<p style="width:100%"><pre><code id="paymentResponse">The response will appear here as JSON, and in your browser console as a JavaScript object.</code></pre></p>-->
    </div>
    <div id="paymentResponse" class="alert alert-success" role="alert"></div>
</div>
    </div>
        <script type="text/javascript">
            PayJS(['jquery', 'PayJS/Core', 'PayJS/Request', 'PayJS/Response', 'PayJS/Formatting', 'PayJS/Validation'],
            function($, $CORE, $REQUEST, $RESPONSE, $FORMATTING, $VALIDATION) {

                $("#paymentButton").prop('disabled', true);

                var isValidCC = false,
                    isValidExp = false,
                    isValidCVV = false;

        // when using REQUEST library, initialize via CORE instead of UI
        $CORE.Initialize({
            clientId: getQueryParam("clientID"),
            postbackUrl: getQueryParam("postbackUrl"),
            merchantId: getQueryParam("MerchantID"),
            authKey: getQueryParam("AuthKey"),
            salt: getQueryParam("salt"),
            requestType: "payment",
            orderNumber: getQueryParam("orderNumber"),
            amount: getQueryParam("amount"),
            environment: "cert",
            debug: true
        });

        $("#paymentButton").click(function() {
            $(this).prop('disabled', true).removeClass("not-disabled");
            $("#myCustomForm :input").prop('disabled', true);

            $("#customFormWrapper").addClass("animated").removeClass("static");
            $("#customFormWrapper").fadeTo(2000, 0.1);

            // we'll add on the billing data that we collected
            $CORE.setBilling({
                name: $("#billing_name").val(),
                address: $("#billing_street").val(),
                city: $("#billing_city").val(),
                state: $("#billing_state").val(),
                postalCode: $("#billing_zip").val()
            });

            var cc = $("#cc_number").val();
            var exp = $("#cc_expiration").val();
            var cvv = $("#cc_cvv").val();

            // run the payment
            $REQUEST.doPayment(cc, exp, cvv, function(resp) {
                // if you want to use the RESPONSE module with REQUEST, run the ajax response through tryParse...
                //$RESPONSE.getRawResponse(resp);
               $RESPONSE.tryParse(resp);
                // ... which will initialize the RESPONSE module's getters
               console.log('$RESPONSE.getResponse()');
                console.log($RESPONSE.getResponse());
                $("#paymentResponse").text(
                    $RESPONSE.getTransactionSuccess() ? "APPROVED" : "DECLINED"
                )
                $("#customFormWrapper").hide();
                $("#paymentResponse").fadeTo(1000, 1);

            })

            //$REQUEST.doPayment(cc, exp, cvv, function () {
            //    // if you want to use the RESPONSE module with REQUEST, run the ajax response through tryParse...
            //    //$RESPONSE.getRawResponse(resp);
            //   // $RESPONSE.tryParse(resp);
            //    // ... which will initialize the RESPONSE module's getters
            //    //console.log($RESPONSE.getResponse());
            //   // $("#paymentResponse").text(
            //      //  $RESPONSE.getTransactionSuccess() ? "APPROVED" : "DECLINED"
            //   // )
            //   // $("#customFormWrapper").hide();
            //   // $("#paymentResponse").fadeTo(1000, 1);
            //})
        })

        $(".billing .form-control").blur(function(){
            toggleClasses($(this).val().length > 0, $(this).parent());
            checkForCompleteAndValidForm();
        })

        $("#cc_number").blur(function() {
            var cc = $("#cc_number").val();
            // we'll format the credit card number with dashes
            cc = $FORMATTING.formatCardNumberInput(cc, '-');
            $("#cc_number").val(cc);
            // and then check it for validity
            isValidCC = $VALIDATION.isValidCreditCard(cc);
            toggleClasses(isValidCC, $("#cc-group"));
            checkForCompleteAndValidForm();
        })


        $("#cc_expiration").blur(function() {
            var exp = $("#cc_expiration").val();
            exp = $FORMATTING.formatExpirationDateInput(exp, '/');
            $("#cc_expiration").val(exp);
            isValidExp = $VALIDATION.isValidExpirationDate(exp);
            toggleClasses(isValidExp, $("#exp-group"));
            checkForCompleteAndValidForm();
        })

        $("#cc_cvv").blur(function() {
            var cvv = $("#cc_cvv").val();
            cvv = cvv.replace(/\D/g,'');
            $("#cc_cvv").val(cvv);
            isValidCVV = $VALIDATION.isValidCvv(cvv, $("#cc_number").val()[0]);
            toggleClasses(isValidCVV, $("#cvv-group"));
            checkForCompleteAndValidForm();
        })

        function toggleClasses(isValid, obj) {
            if (isValid) {
                obj.addClass("has-success").removeClass("has-error");
                obj.children(".help-block").text("Valid");
            } else {
                obj.removeClass("has-success").addClass("has-error");
                obj.children(".help-block").text("Invalid");
            }
        }

        function checkForCompleteAndValidForm() {
            var isValidBilling = true;
            $.each($(".billing"), function(){ isValidBilling = isValidBilling && $(this).hasClass("has-success") });

            // assuming most people fill out the form from top-to-bottom,
            // checking it from bottom-to-top takes advantage of short-circuiting
            if (isValidCVV && isValidExp && isValidCC && isValidBilling) {
                $("#paymentButton").prop('disabled', false).addClass("not-disabled");
            }
        }
    });
</script>
    </form>
</body>
</html>
