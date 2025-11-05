using System.Text.Json.Serialization;

namespace CsvGenerator;

public class SlipData
{
    [JsonPropertyName("OthersWbsElement_r")]
    public string OthersWbsElement_r { get; set; } = "";

    [JsonPropertyName("OthersWbsElement_s")]
    public string OthersWbsElement_s { get; set; } = "";

    [JsonPropertyName("VoucherDate")]
    public string VoucherDate { get; set; } = "";

    [JsonPropertyName("PostingDate")]
    public string PostingDate { get; set; } = "";

    [JsonPropertyName("Period")]
    public string Period { get; set; } = "";

    [JsonPropertyName("SlipNumber")]
    public string SlipNumber { get; set; } = "";

    [JsonPropertyName("ScreenVariant")]
    public string ScreenVariant { get; set; } = "";

    [JsonPropertyName("ReferenceVoucherNumber")]
    public string ReferenceVoucherNumber { get; set; } = "";

    [JsonPropertyName("SlipHeaderText")]
    public string SlipHeaderText { get; set; } = "";

    [JsonPropertyName("TransactionCurrency")]
    public string TransactionCurrency { get; set; } = "";

    [JsonPropertyName("Text")]
    public string Text { get; set; } = "";

    [JsonPropertyName("ManagementDomain")]
    public string ManagementDomain { get; set; } = "";

    [JsonPropertyName("CostElement")]
    public string CostElement { get; set; } = "";

    [JsonPropertyName("Amount")]
    public string Amount { get; set; } = "";

    [JsonPropertyName("Quantity")]
    public string Quantity { get; set; } = "";

    [JsonPropertyName("QuantityUom")]
    public string QuantityUom { get; set; } = "";

    [JsonPropertyName("EmployeeNo")]
    public string EmployeeNo { get; set; } = "";

    [JsonPropertyName("SenderCostCenter")]
    public string SenderCostCenter { get; set; } = "";

    [JsonPropertyName("SendersOrder")]
    public string SendersOrder { get; set; } = "";

    [JsonPropertyName("RefRegistrationInstruction_s")]
    public string RefRegistrationInstruction_s { get; set; } = "";

    [JsonPropertyName("InstForDummyCounting_s")]
    public string InstForDummyCounting_s { get; set; } = "";

    [JsonPropertyName("SenderWbsElement")]
    public string SenderWbsElement { get; set; } = "";

    [JsonPropertyName("OTHERSWbsElem_s")]
    public string OTHERSWbsElem_s { get; set; } = "";

    [JsonPropertyName("DummyAccountingWbsElement_s")]
    public string DummyAccountingWbsElement_s { get; set; } = "";

    [JsonPropertyName("SenderNetwork")]
    public string SenderNetwork { get; set; } = "";

    [JsonPropertyName("SenderOperation")]
    public string SenderOperation { get; set; } = "";

    [JsonPropertyName("ReceiverCostCenter")]
    public string ReceiverCostCenter { get; set; } = "";

    [JsonPropertyName("ReceiverInstruction")]
    public string ReceiverInstruction { get; set; } = "";

    [JsonPropertyName("RefRegistrationInstruction_r")]
    public string RefRegistrationInstruction_r { get; set; } = "";

    [JsonPropertyName("InstForDummyCounting_r")]
    public string InstForDummyCounting_r { get; set; } = "";

    [JsonPropertyName("ReceiverWbsElement")]
    public string ReceiverWbsElement { get; set; } = "";

    [JsonPropertyName("OTHERSWbsElem_r")]
    public string OTHERSWbsElem_r { get; set; } = "";

    [JsonPropertyName("DummyAccountingWbsElement_r")]
    public string DummyAccountingWbsElement_r { get; set; } = "";

    [JsonPropertyName("ReceiverNetwork")]
    public string ReceiverNetwork { get; set; } = "";

    [JsonPropertyName("ReceiverOperation")]
    public string ReceiverOperation { get; set; } = "";

    [JsonPropertyName("Requester")]
    public string Requester { get; set; } = "";

    [JsonPropertyName("ReceivablesUnderTransfer")]
    public string ReceivablesUnderTransfer { get; set; } = "";

    [JsonPropertyName("SubordinateDivision")]
    public string SubordinateDivision { get; set; } = "";
}
