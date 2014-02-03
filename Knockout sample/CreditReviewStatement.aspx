<%@ Page Language="C#" MasterPageFile="~/DFXWeb.Master" AutoEventWireup="true" CodeBehind="CreditReviewStatement.aspx.cs"
Inherits="DFXWeb.Packages.CreditCard.CreditReviewStatement" %>


<%@ Register Src="~/Common/Controls/Error.ascx" TagName="Error" TagPrefix="uc1" %>
<%@ Register TagPrefix="uc1" Namespace="DFXWeb.Common.Controls" Assembly="DFXWeb" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script src="<%=Page.ResolveUrl("~/Assets/Scripts/jquery.tablesorter.pager.js") %>" type="text/javascript"></script>
<script src="<%=Page.ResolveUrl("~/Assets/Scripts/jquery.tablesorter.min.js")%>" type="text/javascript"></script>
<script src="<%=Page.ResolveUrl("~/Assets/Scripts/knockout-2.2.1.js")%>" type="text/javascript" charset="utf-8"></script>
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Assets/Styles/tableSorter.css")%>"
        type="text/css" media="screen" /> 

    <div class="serverError" data-bind="visible: error() !== ''">
        <ul>
            <li data-bind="text: error"></li>
        </ul>
    </div>
    <div class="main">
        <div class="pageTitle">
            Credit Cards</div>       
        <div id="tabs">
            <ul>
                <li><a href="#tabs-1">Review Statement</a></li>
            </ul>
            <div id="tabs-1" class="detailsInset">
                <!-- Filter -->
                <table width="100%">
								<tr>
								<td class="searchInset">
										<div class="status">
											<img class="statusIcon" src="/dfX/Assets/Images/IconImageStatus.jpg" title="Image Association" />
                                            <a id="MainContent_lnkImageAssociation" data-bind="attr: { href: imageLinkHref() ? imageLinkHref() : '#', target: imageLinkTarget }, text: imageLinkText() ? imageLinkText() : 'No Image', anchorenable: imageLinkText()"></a>
										</div>
										<div style="width:50%;float:left;">
											<label>Credit Card:</label>
                                            <select id="creditcard" data-bind="options: creditCards, optionsText: 'Value', optionsValue: 'Key', value: creditCard, dfxDisable: statementLoaded() && !saveSuccess(), hasfocus: focusedElement() == 'ddCreditCard'" class="validate[required]" type="select-one"></select>
										</div>
										<div style="width:40%;float:left;">
											<label>Filter:</label>
                                            <select data-bind="options: filterOptions, optionsText: 'Value', optionsValue: 'Key', value: filter, dfxDisable: statementLoaded() && !saveSuccess()"></select>
                                       <div id="MainContent_divFilter" class="searchBtn" data-bind="click: onFilter, dfxDisable: statementLoaded() && !saveSuccess()">
                                       <a href="#">F</a>ilter</div>
								</td>
								</tr>
								</table>
								<!-- Filter end -->	
								<!-- advance start -->
										<br/>
										<div id="MainContent_divContent" data-bind="visible: statementLoaded() && !saveSuccess()">
											<div style="float: right;" id="search">
												<div id="toggle" class="searchBtn" onclick="filterToggle();">
                                                  +/-</div>
											</div>
											<div style="width:50%;float:left;">	
												<label>Invoice:</label>
                                                <select id="invoices" type="select-one" data-bind="options: invoices, optionsText: 'Value', value: ddInvoiceNumber, optionsValue: 'Key', event: { change: onInvoiceChanged }, hasfocus: focusedElement() == 'ddInvoice', dfxDisable: !splitsSupported(), enableRequiredFieldValidation: ddInvoiceRequired"></select>
											</div>
											<div style="width:40%;float:left;">
											<div id="MainContent_divDefaultInvoice" style="display:inline-block;" data-bind="visible: !enterInvoiceMode()">
                                               <label>Default Invoice #:</label><span id="MainContent_spanDefaultInvoice" class="nonEdit" data-bind="text: defaultInvoiceNumber"></span>
                                               </div>
                                               <div id="MainContent_divEnterInvoice" style="display:none" data-bind="visible: enterInvoiceMode">
                                                <label>Invoice #:</label><input name="ctl00$MainContent$txtInvoiceNumber" type="text" id="MainContent_txtInvoiceNumber" onchange="DetectImageForInvoice(this.id,&#39;defineValue&#39;);" data-bind="value: definedInvoiceNumber, hasfocus: focusedElement() == 'txtInvoiceNumber'" />
                                                <input type="submit" name="ctl00$MainContent$btnDetectImageForInvoice" value="" id="MainContent_btnDetectImageForInvoice" style="display:none" />
                                               </div>    
                                            </div>
                                            <p style="clear:both;">
										</div>
										<div id="divAdvance" data-bind="visible: statementLoaded() && !saveSuccess()">
											<div style="width:50%;float:left;">
												<label>Invoice Date:</label><input name="ctl00$MainContent$txtInvoiceDate" type="text" id="txtInvoiceDate" size="15" class="validate[custom[date]]" onchange="PopulateYear(this.id);" data-bind="value: invoiceDate" /><br />
                                                <label>Check Date:</label><input name="ctl00$MainContent$txtCheckDate" type="text" id="txtCheckDate" size="15" class="validate[custom[date]]" onchange="PopulateYear(this.id);" data-bind="value: checkDate" /><br />
												<label>Due Date:</label><input name="ctl00$MainContent$txtDueDate" type="text" id="txtDueDate" size="15" class="validate[custom[date]]" onchange="PopulateYear(this.id);" data-bind="value: dueDate, dfxDisable: !splitsSupported()" /><br />
											</div>
                                            <div style="width:40%;float:left;">	
												<label>Vendor:</label><span id="MainContent_spanVendor" class="nonEdit" data-bind="text: vendor"></span><br />
                                                <input name="ctl00$MainContent$hdnVendorID" type="hidden" id="MainContent_hdnVendorID" value="CITI" />
												<label>Bank:</label><select id="ddBank" type="select-one" data-bind="options: banks, value: paymentBank, optionsText: 'Value', optionsValue: 'Key', hasfocus: focusedElement() == 'ddBank', dfxDisable: !splitsSupported(), enableRequiredFieldValidation: ddBankRequired" style="width:150px;">
		<option value="">--Select A Bank</option>
		<option value="2">2 -- CASH IN CHECKING (CHASE) (2704)</option>

	</select>
											</div>											
											<p style="clear:both;">
										</div>
                <!-- Filter end -->				
                <br/>

<!-- main content -->
                <div id="MainContent_divItemTable" data-bind="visible: statementLoaded() && !saveSuccess()">
                    <table id="grid" class="tablesorter" border="0" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr><th width="8%">#</th><th width="10%">Amount</th><th width="10%">Date</th><th width="25%">Transaction Desc.</th><th width="10%">GL Account</th><th>Description</th><th width="8%">Action</th></tr>
                        </thead>
                        <tbody data-bind="foreach: lines">
                            <tr id="tr_1">
                                <td data-bind="text: sequenceNumber"></td>
                                <td class="right" data-bind="text: amount"></td>
                                <td data-bind="text: transactionDate"></td>
                                <td><input type="text" size="40" data-bind="value: description" /></td>
                                <td><input id="glCode" type="text" class="validate[required]" type="text" data-bind="value: glCode,
                                                                                                                     koautocomplete: { source: $parent.getGLAccounts },
                                                                                                                     dfxDisable: isIgnore,
                                                                                                                     hasfocus: editing"/><a tabindex="-1" href="#"><img class="EnbedIcon" id="img_1" src="/dfX/Assets/Images/EnbedIconEdit2.png" data-bind="click: $parent.launchChartOfAccounts" /></a></td>
                                <td id="GLDesc_1" data-bind="text: glDescription"></td>
                                <td><input type="button" tabindex="-1" id="Split_1" class="BRicons split" title="Split" data-bind="click: openSplitWindow, visible: $parent.splitsSupported, dfxDisable: isIgnore || glCode.toLowerCase() == 'ignore'"/><input type="button" tabindex="-1" id="Ignore_1" class="BRicons ignore" title="Ignore" data-bind="click: setIgnore"/></td>
                            </tr>
                        </tbody>
                    </table>
                </div> 
                <br /> 
                <div id="MainContent_divStatementTotal" data-bind="visible: statementLoaded() && !saveSuccess()">
                <b>Statement Total : </b><div id="MainContent_spanStatementTotal" style="display:inline-block;" data-bind="text: statementTotal"></div>
                </div>  
            </div>                
        </div>
        <br/>
        <div id="MainContent_divStatus" style="color:Green;" data-bind="text: status"></div>      
        <br />
        <div id="MainContent_divSubmit" class="Btn" data-bind="click: submit, visible: statementLoaded() && !saveSuccess()">
            <a href="#">S</a>ubmit</div>
            <input type="submit" name="ctl00$MainContent$btnSubmit" value="" id="MainContent_btnSubmit" style="display: none" />
        <div id="MainContent_divSave" class="Btn" style="display:inline-block;" data-bind="click: save, visible: statementLoaded() && !saveSuccess()">
            <a href="#">S</a>ave</div>
        <input type="submit" name="ctl00$MainContent$btnSave" value="" id="MainContent_btnSave" style="display: none" />
        <div class="Btn" style="float: right;" data-bind="click: cancel">
            <a href="#">C</a>ancel</div>
        <input type="submit" name="ctl00$MainContent$btnCancel" value="" id="MainContent_btnCancel" style="display: none" />
        <div class="Btn" style="float: right;" data-bind="click: reset">
            <a href="#">R</a>eset</div>
        <input type="submit" name="ctl00$MainContent$btnReset" value="" id="MainContent_btnReset" style="display: none" />
        <div id="MainContent_divReplaceImage" class="Btn" style="float: right;display:none" onclick="OnReplaceImage();">
            <a href="#">R</a>eplace Image</div>     
        <input type="submit" name="ctl00$MainContent$btnReplaceImage" value="" id="MainContent_btnReplaceImage" style="display: none" />       
        <div id="MainContent_divDetectImage" class="Btn" style="float: right;display:none" onclick="OnDetectImage();">
            <a href="#">D</a>etect Image</div>
        <input type="submit" name="ctl00$MainContent$btnDetectImage" value="" id="MainContent_btnDetectImage" style="display: none" />
        <input type="submit" name="ctl00$MainContent$btnUpdateBO" value="" id="MainContent_btnUpdateBO" style="display: none" />
        <input type="submit" name="ctl00$MainContent$btnUndoSplit" value="" id="MainContent_btnUndoSplit" style="display: none" />
        <input type="submit" name="ctl00$MainContent$btnFilter" value="" id="MainContent_btnFilter" style="display:none" />
        <input type="submit" name="ctl00$MainContent$btnCancelReverse" value="" id="MainContent_btnCancelReverse" style="display:none" />
        <input type="submit" name="ctl00$MainContent$btnSubmitWithoutReplaceImage" value="" id="MainContent_btnSubmitWithoutReplaceImage" style="display: none" />
        <br/>  
        <br />
        <input name="ctl00$MainContent$hdnUndoSplitStatus" type="hidden" id="MainContent_hdnUndoSplitStatus" />
        <input name="ctl00$MainContent$hdnID" type="hidden" id="MainContent_hdnID" />
        <input name="ctl00$MainContent$hdnDesc" type="hidden" id="MainContent_hdnDesc" />           
        <input name="ctl00$MainContent$hdnGL" type="hidden" id="MainContent_hdnGL" />  
        <input name="ctl00$MainContent$hdnGLDesc" type="hidden" id="MainContent_hdnGLDesc" />  
        <input name="ctl00$MainContent$hdnIgnore" type="hidden" id="MainContent_hdnIgnore" /> 
        <input name="ctl00$MainContent$hdnItemToFocus" type="hidden" id="MainContent_hdnItemToFocus" />  
        <input name="ctl00$MainContent$hdnParam" type="hidden" id="MainContent_hdnParam" />
        <input name="ctl00$MainContent$hdnPopUp" type="hidden" id="MainContent_hdnPopUp" />      
        <input name="ctl00$MainContent$hdnDetectImage" type="hidden" id="MainContent_hdnDetectImage" /> 
        <input name="ctl00$MainContent$hdnCurrentID" type="hidden" id="MainContent_hdnCurrentID" /> 
        <input name="ctl00$MainContent$hdnSplitController" type="hidden" id="MainContent_hdnSplitController" />
        <input name="ctl00$MainContent$hdnCurrentClient" type="hidden" id="MainContent_hdnCurrentClient" value="JULIE-CASH" />

        <input id="hdnClientId" type="hidden" runat="server" />
        <input id="hdnCCData" type="hidden" runat="server" />
        <input id="hdnFilterData" type="hidden" runat="server" />
    </div>

    <div id="dialog_NoImageDetected" title="No Image Detected" style="display: none">
                <p>
                    <span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>
                    You must have an image in order to generate the invoice. What would you like to do ?</p>
    </div>
    <div id="dialog_ReplaceImage" title="Replace Image" style="display: none">
                <p>
                    <span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>
                    Please replace image in order to generate the invoice</p>
    </div>
    <div id="dialog_ReviewStatementWarning" title="Warning" style="display: none">
                <p>
                    <span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>
                    <span id="spanWarning" data-bind="text: warning"></span></p>
    </div>

    <div id="dialog_ImageReplacement" title="Replace Image ?" style="display: none">
                <p>
                    <span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>
                    Would you like to replace the existing image with the one from the invoice ?</p>
    </div>

    <div id="validateResults" data-bind="jqDialog: { autoOpen: false, resizable: true, height: 600, width : 600, modal: true,
                            buttons: [
                                {
                                    id : 'Button_Create_New',
                                    text : 'New',
                                    click : function()
                                    {
                                        $(this).dialog('close');
                                        if (funcName != undefined)
                                            funcName();
                                    }
                                } 
                            ] },
    template: { name: 'validateResults-template', data: validateResults }, openDialog: validateResults().length > 0"></div>

    <script id="validateResults-template" type="text/html">
        <table class="tablesorter" border="0" cellpadding="0" cellspacing="0">
            <thead><tr><th>ID#</th><th>Name</th></tr></thead>
            <tbody data-bind="template: { name: 'validateResults-template-row', foreach: $parent.validateResults, as: 'result' } ">
            </tbody>
        </table>
    </script>

    <script id="validateResults-template-row" type="text/html">
        <tr>
            <td><a href="#" data-bind="text: result.label, click: $root.onValidateResultsSelect"></a></td>
            <td data-bind="text: result.value"></td>
        </tr>
    </script>

    <script type="text/javascript">
        //initialize data objects and view model
        var creditCards = $.parseJSON($('#MainContent_hdnCCData').val());
        var filterOptions = $.parseJSON($('#MainContent_hdnFilterData').val());
        var clientId = $('#MainContent_hdnClientId').val();

        var viewModel;

        $(document).ready(function(){
            $('form').validationEngine('attach', {promptPosition:"topRight", scroll:true});

            //initialize date pickers
            $('#txtInvoiceDate').datepicker({
                showOn: "button",
                buttonImage: "<%=Page.ResolveUrl("~/Assets/Images/EnbedIconCal.png")%>",
                buttonImageOnly: true
            });

            $('#txtInvoiceDate').datepicker().change(function() 
                {     
                if(!$("form").validationEngine('validateField', '#txtInvoiceDate','custom[date]'))
                    $("#txtInvoiceDate").focus();
            });

            $('#txtCheckDate').datepicker({
                showOn: "button",
                buttonImage: "<%=Page.ResolveUrl("~/Assets/Images/EnbedIconCal.png")%>",
                buttonImageOnly: true
            });

            $('#txtCheckDate').datepicker().change(function() 
                {     
                if(!$("form").validationEngine('validateField', '#txtCheckDate','custom[date]'))
                    $("#txtCheckDate").focus();
            });

            $('#txtDueDate').datepicker({
                showOn: "button",
                buttonImage: "<%=Page.ResolveUrl("~/Assets/Images/EnbedIconCal.png")%>",
                buttonImageOnly: true
            });

            $('#txtDueDate').datepicker().change(function() 
                {     
                if(!$("form").validationEngine('validateField', '#txtDueDate','custom[date]'))
                    $("#txtDueDate").focus();
            });
	
            $( "#tabs" ).tabs();
		
            viewModel = new reviewStatementViewModel(clientId);

            ko.applyBindings(viewModel);
        });

        filterToggle = function(){
            $('#divAdvance').toggle('blind','slow');
            return false;
        }

        $('.ignore').click(function(){
			$(this).toggleClass('ON');
		});	

        function OnCancel() {
            $('form').validationEngine('hideAll');
            $('form').validationEngine('detach', { promptPosition: "topRight", scroll: true });
            showReportWaitingScreen();
            //call cancel method
        }

        function OnReset() {
            $('form').validationEngine('hideAll');
            $('form').validationEngine('detach', { promptPosition: "topRight", scroll: true });
            showReportWaitingScreen();
            //call reset method
        }

        function pageLoad(object,args)
        {
            var EmptySplitAccountHolder = '<%=EmptySplitAccountHolder %>';

            if(EmptySplitAccountHolder != "") 
            {
                var splitVal = EmptySplitAccountHolder.split(',');
                for(var i=0; i < splitVal.length; i++) 
                {
                    $("#Split_" + splitVal[i] + "").validationEngine('showPrompt', 'Missing GL Account found in the split', 'error', 'topRight', true);
                }
            }

            //showReportWaitingScreen();
        }
    </script>

    <script>
        var reviewStatementLineItem = function (index, transaction, parentViewModel) {
            var self = this;
            self.index = index;
            self.isIgnore = ko.observable(transaction.IsIgnore);
            self.isCoded = $.trim(transaction.GLCode) != '' ? true : false;
            self.sequenceNumber = ko.observable(transaction.SequenceNumber);
            self.amount = formatCurrency(transaction.Amount);
            self.transactionDate = new Date(parseInt(transaction.TransactionDate.substr(6))).format('MM/dd/yyyy');
            self.description = ko.observable(transaction.DescriptionOrMerchant);
            self.glCode = transaction.IsIgnore ? ko.observable('IGNORE') : ko.observable(transaction.GLCode);
            self.glDescription = transaction.IsIgnore ? ko.observable('IGNORE') : ko.observable(transaction.GLDescription);
            self.splitItemList = transaction.SplitItemList;
            self.isGLCodeValidated = ko.observable(true);
            self.parentViewModel = parentViewModel;
            self.editing = ko.observable(false);

            //operations
            self.onValidateManualGLAccountForCCComplete = function (validateResult) {
                self.isGLCodeValidated(validateResult);
                self.isCoded = true;
            }

            self.validateManualGLAccountForCC = function (onCompleteCallback) {
                //set selected transaction line
                self.parentViewModel.focusedTransactionLine(self);

                $.ajaxSetup({ cache: false });

                $('form').validationEngine('hideAll');
                var varType = "POST";
                var varURL = "/dfx/Common/PredictiveSearchLookup.asmx/GetGLAccountsForClientWithProtoCheck";
                var varContentType = "application/json; charset=utf-8";
                var varDataType = "json";

                $.ajax({
                    type: varType,
                    url: varURL,
                    data: "{'prefixText':'" + self.glCode() + "','client':'" + parentViewModel.clientId + "'}",
                    contentType: varContentType,
                    dataType: varDataType,
                    success: function (result) {
                        if (result.d.Success) {
                            if (result.d.List.length > 0) {
                                if (result.d.List.length == 1) {
                                    var splitItem = result.d.List[0].Value.split('--');
                                    var glItem = $.trim(splitItem[0]);
                                    var glDescItem = $.trim(splitItem[1]);

                                    var validateResult = true;

                                    onCompleteCallback(validateResult);

                                    if (result.d.IsProto) {
                                        if (result.d.List[0].Value.indexOf('*') != -1) {
                                            var ui = new Object;
                                            ui.item = new Object;
                                            ui.item.label = new Object;
                                            ui.item.value = new Object;
                                            ui.item.label = glItem + ' -- ' + glItemDesc;
                                            ui.item.value = glItem;

                                            var event = new Object;
                                            event.target = new Object;
                                            event.target.id = new Object;
                                            event.target.id = controlID;
                                            CheckProto(event, ui);
                                        }
                                    }
                                }
                                else {
                                    //initialize validateResults model
                                    var results = $.map(result.d.List, function(item) {
                                        var splitItem = item.Value.split('--');
                                        var glCode = $.trim(splitItem[0]);
                                        var glDesc = $.trim(splitItem[1]);

                                        return { label: glCode, value: glDesc };
                                    });

                                    parentViewModel.validateResults(results);
                                    $('#validateResults').tablesorter({ widthFixed: false, widgets: ['zebra'] });

                                    $('form').validationEngine('hideAll');
                                }
                            }
                            else {
                                if (strVal.indexOf(".") != -1 && result.d.dummyList.length > 0) {
                                    result.d.dummyList[0] = result.d.dummyList[0].replace('*', ''); // Allows to launch GL window if you define a division with a proto account
                                    var retResult = ValidateAccountForDivision(strVal, result.d.dummyList);
                                    if (retResult) {
                                        if (!ComingFromMainPage) {
                                            $('form').validationEngine('hideAll');
                                            // launch modal window                                        
                                            var ui = new Object;
                                            ui.item = new Object;
                                            ui.item.label = new Object;
                                            ui.item.value = new Object;
                                            ui.item.label = strVal;
                                            ui.item.value = "*" + strVal; // appended value with dummy asterix to work with existing code
                                            var event = new Object;
                                            event.target = new Object;
                                            event.target.id = new Object;
                                            event.target.id = controlID;
                                            CheckProto(event, ui);
                                        }
                                        else if (javascriptFuncToCall != undefined)
                                            javascriptFuncToCall(glItem, glItemDesc, undefined, controlID);
                                    }
                                    else {
                                        //EnableAllGLFieldsInStatements();
                                        $("#" + controlID + "").focus();
                                        $("#" + controlID + "").validationEngine('showPrompt', 'Not A Valid GL Account', 'error', 'topRight', true);
                                    }
                                }
                                else if (ComingFromMainPage) {
                                    javascriptFuncToCall(glItem, glItemDesc, undefined, controlID);
                                }
                                else {
                                    //EnableAllGLFieldsInStatements();
                                    $("#" + controlID + "").focus();
                                    $("#" + controlID + "").validationEngine('showPrompt', 'Not A Valid GL Account', 'error', 'topRight', true);
                                }
                            }
                        }
                        else {
                            //EnableAllGLFieldsInStatements();
                            $("#" + controlID + "").focus();
                            $("#" + controlID + "").validationEngine('showPrompt', 'Not A Valid GL Account', 'error', 'topRight', true);
                        }
                    },
                    error: function (result) {
                        alert('Unable to perform GL Lookup.');
                    }
                });
            }

            self.setIgnore = function() {
                self.isIgnore(!self.isIgnore());
            }

            self.isIgnore.subscribe(function() {
                self.glCode(self.isIgnore() ? 'IGNORE' : '');
                self.glDescription(self.isIgnore() ? 'IGNORE' : '');
            });

            self.openSplitWindow = function () {
                //** only pass the glCode if the transaction has been coded
                var glCode = self.isCoded ? self.glCode() : '';

                var modalResultVal = LaunchModalDialog("<%=Page.ResolveClientUrl("~/Packages/CC/CCSplitCharges.aspx?M=Window")%>&idVal=" + escape(self.sequenceNumber()) + "&amtVal=" + escape(self.amount) + "&dateVal=" + escape(self.transactionDate) + "&TdescVal=" + escape(self.description()) + "&glVal=" + escape(glCode) + "&descVal=" + escape(self.glDescription()) + "&CreditCardVal=" + self.parentViewModel.creditCard() + "&CurrentVendor=" + self.parentViewModel.vendor() + "", "1120px", "600px");

                //on return, set transaction line to split
                if (modalResultVal != undefined && modalResultVal.Status == 'S') {
                    self.glCode('SPLIT');
                    self.glDescription('');

                    //set focus to next transaction - find next non-ignore transaction line
                    var nextLine = ko.utils.arrayFirst(self.parentViewModel.lines(), function(line) {
                        return !line.isIgnore() && line.index > self.index;
                    });

                    if (typeof nextLine !== 'undefined' && nextLine)
                        nextLine.editing(true);
                }
            }
        }

        //custom toJSON function needed to avoid circular reference error on serialization
        reviewStatementLineItem.prototype.toJSON = function() {
            var copy = ko.toJS(this);
            delete copy.parentViewModel;
            return copy;
        }

        var reviewStatementViewModel = function (clientId) {
            var self = this;
            self.clientId = clientId;
            self.creditCard = ko.observable();
            self.filter = ko.observable();
            self.ddInvoiceNumber = ko.observable();
            self.defaultInvoiceNumber = ko.observable();
            self.definedInvoiceNumber = ko.observable();

            self.invoiceNumber = ko.computed(function() {
                var invoiceNumber = 0;

                if (self.ddInvoiceNumber() == '1')
                    invoiceNumber = self.defaultInvoiceNumber();
                else if (self.ddInvoiceNumber() == '2')
                    invoiceNumber = self.definedInvoiceNumber();
                else
                    invoiceNumber = self.ddInvoiceNumber();

                return invoiceNumber;
            });

            self.lines = ko.observableArray();
            self.invoices = ko.observableArray();
            self.paymentBank = ko.observable();
            self.vendor = ko.observable();
            self.invoiceDate = ko.observable();
            self.checkDate = ko.observable();
            self.dueDate = ko.observable();
            self.imageLinkHref = ko.observable();
            self.imageLinkText = ko.observable('');
            self.imageLinkTarget = ko.observable();
            self.banks = ko.observableArray();
            self.isCreateInvoice = false;
            self.isReplaceImage = false;
            self.focusedElement = ko.observable('ddCreditCard');
            self.splitsSupported = ko.observable(true);
            self.ddInvoiceRequired = ko.observable();
            self.ddBankRequired = ko.observable();
            self.validateResults = ko.observableArray();
            self.focusedTransactionLine = ko.observable();

            //flags to determine visibility of UI elements
            self.statementLoaded = ko.computed(function() {
                return self.lines().length > 0;
            });

            self.saveSuccess = ko.observable(false);

            self.enterInvoiceMode = ko.computed(function() {
                return self.ddInvoiceNumber() == '2';
            });

            self.statementTotal = ko.computed(function() {
                var total = 0;

                ko.utils.arrayForEach(self.lines(), function(item) {
                    if (!item.isIgnore()) {
                        var amount = parseFloat(item.amount);
                        total += Math.round(amount * Math.pow(10, 2)) / Math.pow(10, 2);
                    }
                });

                total =  Math.round(total * Math.pow(10, 2)) / Math.pow(10, 2);
                
                return formatCurrency(total);
            });

            self.status = ko.observable('');
            self.error = ko.observable('');
            self.warning = ko.observable('');

            //** events
            self.onValidateResultsSelect = function(selectedResult) {
                self.onGLAccountSelection(self.focusedTransactionLine(), selectedResult);

                //close dialog
                $('#validateResults').dialog('close');
            }

            self.onInvoiceChanged = function() {
                //get image data for invoice
                $.ajax({
                    type: 'post',
                    data: '{ invoiceId: "' + self.ddInvoiceNumber() + '" }',
                    contentType: 'application/json; charset=utf-8',
                    url: '<%=Page.ResolveUrl("~/Packages/CC/CreditReviewStatement.asmx/OnInvoiceChanged") %>'
                })
                    .done(function(data) {
                        var data = JSON.parse(data.d);

                        if(data.success) {
                            if (data.imageData && data.imageData.href) {
                                var imageData = data.imageData;
                                self.imageLinkHref(imageData.href);
                                self.imageLinkTarget(imageData.target);
                                self.imageLinkText(imageData.innerText ? imageData.innerText : '');
                            }
                        }
                        else
                            self.error(data.status);
                    });
            }

            self.onDetectImage = function() {
                $.ajax({
                    type: 'post',
                    data: '{ invoiceId: "' + self.ddInvoiceNumber() + '" }',
                    contentType: 'application/json; charset=utf-8',
                    url: '<%=Page.ResolveUrl("~/Packages/CC/CreditReviewStatement.asmx/OnDetectImage") %>'
                })
                    .done(function(data) {
                        var data = JSON.parse(data.d);

                        self.imageLinkHref(data.href);
                        self.imageLinkTarget(data.target);
                        self.imageLinkText(data.innerText);
                    });
            }

            self.onFilter = function () {
                self.error('');
                self.saveSuccess(false);
                self.status('');
                self.focusedElement('ddInvoice');

                $.ajax({
                    type: 'post',
                    data: '{ filterType : "' + self.filter() + '", creditCard : "' + self.creditCard() + '" }',
                    contentType: 'application/json; charset=utf-8',
                    url: '<%=Page.ResolveUrl("~/Packages/CC/CreditReviewStatement.asmx/GetTransactions") %>'
                })
                    .done(function (data) {
                        //parse the data
                        var dataJSON = JSON.parse(data.d);
                        var transactions = JSON.parse(dataJSON.detailItems);
                        var invoices = JSON.parse(dataJSON.invoiceList);
                        var banks = JSON.parse(dataJSON.bankList);

                        //if success, show the transaction lines
                        if (dataJSON.success) {
                            self.onGetTransactionsComplete( {
                                                                transactions: transactions,
                                                                vendor: dataJSON.vendorName,
                                                                paymentBank : dataJSON.paymentBank,
                                                                invoices: invoices,
                                                                journalType: dataJSON.journalType,
                                                                dueDate: dataJSON.dueDate,
                                                                checkDate: dataJSON.checkDate,
                                                                invoiceDate: dataJSON.invoiceDate,
                                                                banks: banks,
                                                                invoiceNumber: dataJSON.invoiceNumber,
                                                                splitsSupported: dataJSON.splitsSupported,
                                                                ddInvoiceRequired: dataJSON.ddInvoiceRequired,
                                                                ddBankRequired: dataJSON.ddBankRequired
                                                            } );
                        }
                        else {
                            //check if need to display popup
                            var popupType = typeof dataJSON.popupType !== 'undefined' ? dataJSON.popupType : undefined;

                            if (typeof popupType !== 'undefined') {
                                self.warning(dataJSON.status);

                                self.openReviewStatementWarningPopUp(dataJSON);
                            }
                            else
                                //just show the error
                                self.error(dataJSON.status);
                        }
                    });

/*                var fakeData = JSON.stringify({"false":true,"detailItems":"[{\"IsNewItem\":false,\"ID\":null,\"SequenceNumber\":1,\"TransactionDate\":\"\\/Date(1088319600000)\\/\",\"Amount\":13.85,\"DescriptionOrMerchant\":\"trans changed\",\"GLCode\":\"5050-001\",\"IsIgnore\":false,\"Asterisk\":\"\",\"SplitItemList\":[],\"GLJob\":\"\",\"Is1099\":false,\"VendorFor1099\":\"\",\"CodeFor1099\":\"\",\"GLDescription\":\"ALIMONY TEST\",\"Split\":null},{\"IsNewItem\":false,\"ID\":null,\"SequenceNumber\":2,\"TransactionDate\":\"\\/Date(1088233200000)\\/\",\"Amount\":39.67,\"DescriptionOrMerchant\":\"BAJA FRESH MIRCLEMILE 104 LOS AB\",\"GLCode\":\"5000-001\",\"IsIgnore\":false,\"Asterisk\":\"\",\"SplitItemList\":[],\"GLJob\":\"\",\"Is1099\":false,\"VendorFor1099\":\"\",\"CodeFor1099\":\"\",\"GLDescription\":\"SALARY OFFICERS\",\"Split\":null},{\"IsNewItem\":false,\"ID\":null,\"SequenceNumber\":3,\"TransactionDate\":\"\\/Date(1088233200000)\\/\",\"Amount\":12.95,\"DescriptionOrMerchant\":\"AD RX PHARMACY LOS ANGELES\",\"GLCode\":\"SPLIT\",\"IsIgnore\":false,\"Asterisk\":\"\",\"SplitItemList\":[{\"SplitClientCode\":\"JULIE-CASH\",\"SplitAccount\":\"7125-001\",\"SplitAccountDescription\":\"CONTRIBUTIONS-POLITICAL\",\"SplitAmount\":3.24,\"SplitWIP\":\"\",\"Split1099Vendor\":\"\",\"Split1099Code\":\"\",\"SplitBank\":\"1\",\"SplitPercentageDistribution\":25,\"Split1099ClientCode\":null},{\"SplitClientCode\":\"JMOULDER\",\"SplitAccount\":\"7125-002\",\"SplitAccountDescription\":\"CONTRIBUTIONS-POLITICAL\",\"SplitAmount\":9.71,\"SplitWIP\":\"\",\"Split1099Vendor\":\"\",\"Split1099Code\":\"\",\"SplitBank\":\"1\",\"SplitPercentageDistribution\":75,\"Split1099ClientCode\":null}],\"GLJob\":\"\",\"Is1099\":false,\"VendorFor1099\":\"\",\"CodeFor1099\":\"\",\"GLDescription\":\"SPLIT\",\"Split\":null},{\"IsNewItem\":false,\"ID\":null,\"SequenceNumber\":4,\"TransactionDate\":\"\\/Date(1088233200000)\\/\",\"Amount\":59.3,\"DescriptionOrMerchant\":\"RITE AID CORP 06211 LOS ANGELES\",\"GLCode\":\"5000-005\",\"IsIgnore\":false,\"Asterisk\":\"\",\"SplitItemList\":[],\"GLJob\":\"\",\"Is1099\":false,\"VendorFor1099\":\"\",\"CodeFor1099\":\"\",\"GLDescription\":\"SALARY OFFICERS\",\"Split\":null}]","vendorName":"City National Bank","bankList":"[{\"Key\":\"\",\"Value\":\"--Select A Bank\"},{\"Key\":\"1\",\"Value\":\"1 -- Bank Description (3061)\"},{\"Key\":\"2\",\"Value\":\"2 -- CASH IN CHECKING (CHASE) (2704)\"},{\"Key\":\"01\",\"Value\":\"01 -- TEST 01 (1521)\"},{\"Key\":\"10\",\"Value\":\"10 -- FRB SAVINGS (3448)\"},{\"Key\":\"3\",\"Value\":\"3 -- PERSONAL CHECKING (0343)\"},{\"Key\":\"8\",\"Value\":\"8 -- CNS MMA ACCT (7301)\"},{\"Key\":\"4\",\"Value\":\"4 -- GENERAL CHECKING (5444)\"},{\"Key\":\"056\",\"Value\":\"056 -- COMERICA BANK 056 (2227)\"},{\"Key\":\"98\",\"Value\":\"98 -- CNB TEST ACCT (6789)\"},{\"Key\":\"30\",\"Value\":\"30 -- Pvt Bank of Cali #30 (1541)\"},{\"Key\":\"31\",\"Value\":\"31 -- PVT BANK OF CALI. #31 (1940)\"},{\"Key\":\"97\",\"Value\":\"97 -- CNB BANK ACCT #97 (0343)\"},{\"Key\":\"9\",\"Value\":\"9 -- DFT.BR,BANK.ACCOUNT (3184)\"},{\"Key\":\"33\",\"Value\":\"33 -- Pvt Bank od Cali #33 (1541)\"}]","invoiceDate":"12/01/2012","checkDate":"","dueDate":"","journalType":0,"invoiceList":"[{\"Key\":\"\",\"Value\":\"--Select An Invoice\"},{\"Key\":\"1\",\"Value\":\"Default Invoice\"},{\"Key\":\"2\",\"Value\":\"Define Invoice\"},{\"Key\":\"2359-012013.CNB\",\"Value\":\"2359-012013.CNB-01-20-13-0.01\"},{\"Key\":\"2358-012513.CNB\",\"Value\":\"2358-012513.CNB-01-25-13-0.01\"}]","invoiceNumber":"2358-012513","statementTotal":null,"imageData":{"href":"","target":"","disabled":true,"innerText":"No Image"},"paymentBank":"1","totalAmount":"","popupType":"REPROCESS_REMOVE_PRIOR_UPDATES", "status": "Reprocessing a statement will..."});
                var data = JSON.parse(fakeData);

                var transactions = JSON.parse(data.detailItems);
                var invoices = JSON.parse(data.invoiceList);
                var banks = JSON.parse(data.bankList);
                
                self.onGetTransactionsComplete(transactions, data.vendorName, data.paymentBank, data.totalAmount, invoices, data.journalType, data.dueDate, data.checkDate, data.invoiceDate, banks, data.invoiceNumber);*/
            }

            self.onGetTransactionsComplete = function (data) {
                //initialize data fields
                self.vendor(data.vendor);
                self.invoiceDate(data.invoiceDate);
                self.splitsSupported(data.splitsSupported);
                self.ddInvoiceRequired(data.ddInvoiceRequired);
                self.ddBankRequired(data.ddBankRequired);
                self.dueDate(data.dueDate);
                self.checkDate(data.checkDate);

                ko.utils.arrayForEach(data.invoices, function(invoice) {
                    self.invoices.push(invoice);
                });

                ko.utils.arrayForEach(data.banks, function(bank) {
                    self.banks.push(bank);
                });

                self.defaultInvoiceNumber(data.invoiceNumber);

                //initialize review statement lines

                //synchronously load the first 150 rows
//                for(var x = 0; x <= 200; x++) {
//                    self.lines.push(new reviewStatementLineItem(transactions[x], self));
//                }

                //load the remaining rows async
//                setTimeout(function() {
//                    addLineRecursive(201);
//                }, 5000);

//                var addLineRecursive = function(index) {
//                    if (index == transactions.length - 1)
//                        return;
//                    else {
//                        var lineItem = transactions[index];

//                        //add line
//                        self.lines.push(new reviewStatementLineItem(lineItem, self));

//                        setTimeout(function() {
//                            addLineRecursive(++index);
//                        }, 1);
//                    }
//                };

                var index = 0;

                ko.utils.arrayForEach(data.transactions, function (transaction) {
                    self.lines.push(new reviewStatementLineItem(index, transaction, self));
                    index++;
                });

                if(self.defaultInvoiceNumber)
                    self.ddInvoiceNumber(1);

                self.paymentBank(data.paymentBank);

                //initialize validation and tablesorter
                $('form').validationEngine('attach', {promptPosition:"topRight", scroll:true});

                $('#grid').tablesorter({widthFixed: false, widgets: ['zebra'],headers: {4: { sorter: false}}});
            }

            self.onReplaceImage = function() {
                $('form').validationEngine('detach', { promptPosition: "topRight", scroll: true });
                //showReportWaitingScreen();

                $.ajax({
                    type: 'post',
                    contentType: 'application/json; charset=utf-8',
                    url: '<%=Page.ResolveUrl("~/Packages/CC/CreditReviewStatement.asmx/OnReplaceImage") %>'
                })
                    .done(function (data) {
                        var data = JSON.parse(data.d);

                        if (data.success)
                            self.setFocus();
                        else
                            self.error(data.status);
                    });
            }

            self.onGLAccountSelection = function(curItem, selectedItem) {
                curItem.glCode(selectedItem.label);
                curItem.glDescription(selectedItem.value);
                curItem.isCoded = true;

                //** 2. check if account is proto
                var protoAccount = curItem.glCode().indexOf('*') != -1 ? true : false;

                if(protoAccount) curItem.glCode(curItem.glCode().replace('*', ''));

                //2. remove error

                //3. update transactions with same description to have same gl code
                self.updateTransactionGLCodesOnAccountSelection(curItem);

                //TODO: implement LaunchChartOfAccounts
                //4. if proto account, launch chart of accounts
                //if (protoAccount)
                //    self.LaunchChartOfAccounts();
            }
            //end events

            //operations
            self.updateTransactionGLCodesOnAccountSelection = function(selectedLine) {
                //get the transactions with the same description as the current transaction
                var matchingTransactions = ko.utils.arrayFilter(self.lines(), function(line) {
                    return (line.description() == selectedLine.description() && line.sequenceNumber() != selectedLine.sequenceNumber() && $.trim(line.glCode()) == '');
                });

                ko.utils.arrayForEach(matchingTransactions, function(line) {
                    line.glCode(selectedLine.glCode());
                    line.glDescription(selectedLine.glDescription());
                    line.isCoded = true;
                });
            }

            self.setFocus = function() {
                if (ddInvoiceNumber == '1')
                    self.focusedElement('ddBank');
                else if (ddInvoiceNumber == '2')
                    self.focusedElement('txtInvoiceNumber');
                else
                    self.focusedElement('ddBank');
            }

            self.getGLAccounts = function (request, response) {

                $.ajaxSetup({ cache: false });

                var val = request.term;
                var dto = { prefixText: val };
                var varType = "POST";
                var varURL = '<%=Page.ResolveUrl("~/Common/PredictiveSearchLookup.asmx") %>' + '/GetGLAccounts';
                var varContentType = "application/json; charset=utf-8";
                var varDataType = "json";
                var varData = JSON.stringify(dto);

                $.ajax({
                    type: varType,
                    url: varURL,
                    data: varData,
                    contentType: varContentType,
                    dataType: varDataType,
                    success: function (result) {
                        var a = new Array();
                        if (result.d.length > 0) {
                            for (var i = 0; i < result.d.length; i++) {
                                var b = result.d[i];
                                var label = result.d[i];
                                var value = $.trim(b);

                                var choice = {
                                    label: label,
                                    value: value
                                };
                                a.push(choice);
                            }
                        }
                        response($.map(a, function (item) {
                            return {
                                label: item.label,
                                value: $.trim(item.value)
                            };
                        }));
                    },
                    error: function (result) {
                        alert('Unable to perform GL Lookup.');
                    }
                });
            }

            self.submit = function() {
                $('form').validationEngine('hideAll');

                if ($('form').validationEngine('validate')) {
                    self.isCreateInvoice = true;
                    self.save();
                }
            }

            self.save = function() {
                $('form').validationEngine('hideAll');

                if ($('form').validationEngine('validate')) {
                    showReportWaitingScreen();

                    var data = {
                        isCreateInvoice: self.isCreateInvoice,
                        replaceImage: self.replaceImage,
                        transactionLines: self.lines(),
                        paymentBank: self.paymentBank(),
                        invoiceNumber: self.invoiceNumber(),
                        invoiceDate: self.invoiceDate(),
                        checkDate: self.checkDate(),
                        dueDate: self.dueDate()
                    };

                    $.ajax({
                        type: 'post',
                        data: ko.toJSON({ reviewStatementJSON: data }),
                        contentType: 'application/json; charset=utf-8',
                        url: '<%=Page.ResolveUrl("~/Packages/CC/CreditReviewStatement.asmx/Save") %>'
                    })
                        .done(function(data) {
                            hideReportWaitingScreen();
                            var data = JSON.parse(data.d);

                            self.status(data.status);

                            if (data.success) {
                                self.saveSuccess(true);

                                //clear view model
                                viewModel.lines.removeAll();
                                viewModel.banks.removeAll();
                                viewModel.invoices.removeAll();
                            } else {
                                switch (data.status) {
                                case "IMAGING_ERROR_IMAGE_REQUIRED":
                                    self.openNoImageDetectedPopUp();
                                    break;
                                case "IMAGING_ERROR_IMAGE_REPLACEMENT_REQUIRED":
                                    self.openReplacementImageDetectedPopUp();
                                    break;
                                case "REPROCESS_REMOVE_PRIOR_UPDATES":
                                    self.openReviewStatementWarningPopUp();
                                    break;
                                }
                            }
                        });
                }
            }

            self.cancel = function() {
                $('form').validationEngine('hideAll');
                $('form').validationEngine('detach', { promptPosition: "topRight", scroll: true });
                showReportWaitingScreen();

                location.reload();
            }

            self.reset = function() {
                $('form').validationEngine('hideAll');
                $('form').validationEngine('detach', { promptPosition: "topRight", scroll: true });
                showReportWaitingScreen();

                location.reload();
            }

            self.openNoImageDetectedPopUp = function()
            {
                $("#dialog:ui-dialog").dialog("destroy");

                $("#dialog_NoImageDetected").dialog({
                    resizable: false,
                    height:120,
                    width:470,
                    modal: true,
                    buttons: {
                        "Detect": function () 
                        {                            
                            $(this).dialog("close"); 
                            showReportWaitingScreen();
                            //ajax call to OnDetectImage
                            self.onDetectImage();
                        },
                        "Save": function () 
                        {
                            $(this).dialog("close"); 
                            $('form').validationEngine('hideAll');
                            //SetValues(true);

                            if ($('form').validationEngine('validate'))
                            {
                                showReportWaitingScreen();
                                self.save();
                            }
                        },
                        "Cancel": function () 
                        {
                            $(this).dialog("close"); 
                        }
                    }
                });
            }

            self.openReplacementImageDetectedPopUp = function()
            {
                $("#dialog:ui-dialog").dialog("destroy");

                $("#dialog_ReplaceImage").dialog({
                    resizable: false,
                    height:120,
                    width:470,
                    modal: true,
                    buttons: 
                        {
                            "Replace": function () 
                            {                            
                                $(this).dialog("close");
                                self.onReplaceImage();
                            },                      
                            "Submit Without Replacing Image": function () 
                            {                            
                                $(this).dialog("close");    

                                if ($('form').validationEngine('validate'))
                                {  
                                    //showReportWaitingScreen();
                                    //ajax submit without replace image btnSubmitWithoutReplaceImage
                                    self.save();
                                }
                            },
                            "Cancel": function () 
                            {
                                $(this).dialog("close"); 
                            }
                        }
                });
            }

            self.openReviewStatementWarningPopUp = function(transactionData)
            {
                $("#dialog:ui-dialog").dialog("destroy");

                $("#dialog_ReviewStatementWarning").dialog({
                    resizable: false,
                    height:120,
                    width:470,
                    modal: true,
                    buttons: {
                        "Cancel": function () 
                        {                            
                            $(this).dialog("close");  
                            //showReportWaitingScreen();
                            // btncancelreverse click
                        },
                        "Continue" : function()
                        {
                            $(this).dialog("close"); 
                            //showReportWaitingScreen();

                            //rollback the transactions
                            self.rollbackTransactions(self.onRollBackTransactionsComplete, transactionData);
                        }
                    }
                });
            }

            self.rollbackTransactions = function(onRollBackTransactionsComplete, transactionData) {
                    $.ajax({
                        type: 'post',
                        contentType: 'application/json; charset=utf-8',
                        url: '<%=Page.ResolveUrl("~/Packages/CC/CreditReviewStatement.asmx/ProcessSubmitRollback") %>'
                    })
                        .done(function(processSubmitRollbackResult) {
                            onRollBackTransactionsComplete(processSubmitRollbackResult, transactionData);
                        });
            }

            //** processSubmitRollbackResult - return data from server call to rollback
            //** data - transaction data returned from filter call
            self.onRollBackTransactionsComplete = function(processSubmitRollbackResult, transactionData) {
                var result = JSON.parse(processSubmitRollbackResult.d);

                if (result.success) {

                    //show the transactions
                    if (typeof transactionData !== 'undefined') {

                        /*TODO: refactor - duplicate code*/
                        var transactions = JSON.parse(transactionData.detailItems);
                        var invoices = JSON.parse(transactionData.invoiceList);
                        var banks = JSON.parse(transactionData.bankList);

                        self.onGetTransactionsComplete({
                                                            transactions: transactions,
                                                            vendor: transactionData.vendorName,
                                                            paymentBank : transactionData.paymentBank,
                                                            invoices: invoices,
                                                            journalType: transactionData.journalType,
                                                            dueDate: transactionData.dueDate,
                                                            checkDate: transactionData.checkDate,
                                                            invoiceDate: transactionData.invoiceDate,
                                                            banks: banks,
                                                            invoiceNumber: transactionData.invoiceNumber,
                                                            splitsSupported: transactionData.splitsSupported,
                                                            ddInvoiceRequired: transactionData.ddInvoiceRequired,
                                                            ddBankRequired: transactionData.ddBankRequired
                                                       });
                    }
                }
                else
                    self.error(result.status);
            };

            self.launchChartOfAccounts = function(item) {
                var glCode = item.glCode().replace('*', '');

                var modalResultVal = LaunchModalDialog("<%=Page.ResolveClientUrl("~/Packages/GL/ChartOfAccounts/ChartOfAccounts.aspx?M=Window")%>&selectVal=" + glCode + "", "1120px", "600px");

                if (modalResultVal != undefined) {
                    item.glCode(modalResultVal.GLAccount);
                    item.glDescription(modalResultVal.GLAccountDesc);
                }
            }
        }

        //knockout bindinghandlers

        ko.bindingHandlers.koautocomplete = {
            init: function (element, params, allBindingsAccessor, viewModel) {

                $(element).autocomplete({

                    source: params().source,

                    //TODO: refactor - move this to reviewStatementViewModel
                    change: function () {
                        var data = $.data(this); //Get plugin data for 'this'

                        //** user typed in a GL Account instead of selecting a GL from autocomplete, so it's either a split or
                        //** we need to validate the gl account
                        if (typeof data.autocomplete !== 'undefined' && data.autocomplete.selectedItem == null) {

                            var glCode = $.trim(viewModel.glCode());
                            
                            if (glCode != '') {
                                if (glCode.toLowerCase() == 'split')
                                    viewModel.openSplitWindow();
                                else
                                    viewModel.validateManualGLAccountForCC(viewModel.onValidateManualGLAccountForCCComplete);
                            }
                        }

                            //** user selected a gl account from autocomplete
                        else {
                            var itemData = data.autocomplete.selectedItem.value.split('--');
                            var dto = { label: itemData[0], value: itemData[1] };

                            viewModel.parentViewModel.onGLAccountSelection(viewModel, dto);
                        }
                    }
                });
            }
        }
        
        ko.bindingHandlers.dfxDisable = {
            update: function(element, valueAccessor) {
                var value = ko.utils.unwrapObservable(valueAccessor());
                
                if (value)
                    element.setAttribute('disabled', 'disabled');
                else
                    element.removeAttribute('disabled');

                ko.bindingHandlers.disable.update(element, valueAccessor);
            }
        }

        ko.bindingHandlers.enableRequiredFieldValidation = {
            update: function(element, valueAccessor) {
                var value = ko.utils.unwrapObservable(valueAccessor());

                //if observed flag is true, validate the element
                if (value) {
                    if(element.getAttribute('class') != 'validate[required]')
                        element.setAttribute('class', 'validate[required]');
                }
                else
                    element.removeAttribute('class');
            }
        }

        ko.bindingHandlers.anchorenable = {
            update: function (element, valueAccessor) {
                var value = ko.utils.unwrapObservable(valueAccessor());
                if (value && element.disabled) {
                    element.disabled = false;
                    element.removeAttribute('disabled');
                    var hrefBackObject = element.getAttribute('href_back');
                    if (hrefBackObject && hrefBackObject != '') {
                        element.setAttribute('href', hrefBackObject);
                        element.removeAttribute('href_back');
                    }
                }
                else if ((!value) && (!element.disabled)) {
                    element.disabled = true;
                    element.setAttribute("disabled", true);
                    var hrefObject = element.getAttribute('href');
                    if (hrefObject && hrefObject != '') {
                        element.setAttribute('href_back', hrefObject);
                    }
                    element.removeAttribute("href");
                }
            }
        };

        ko.bindingHandlers.jqDialog = {
            init: function(element, valueAccessor) {
                var options = ko.utils.unwrapObservable(valueAccessor()) || {};
        
                //handle disposal
                ko.utils.domNodeDisposal.addDisposeCallback(element, function() {
                    $(element).dialog("destroy");
                }); 
        
                $(element).dialog(options);  
            }
        };
        ko.bindingHandlers.openDialog = {
            update: function(element, valueAccessor) {
                var value = ko.utils.unwrapObservable(valueAccessor());
                if (value) {
                    $(element).dialog("open");
                } else {
                    $(element).dialog("close");
                }
            }
        }
    </script>

</asp:Content>