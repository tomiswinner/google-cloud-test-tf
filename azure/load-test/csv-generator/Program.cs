using System.Globalization;
using System.Text.Json;
using ClosedXML.Excel;

namespace CsvGenerator;

class Program
{
    static void Main(string[] args)
    {
        int count = 0;
        int startNumber = 0;
        string yymmdd = "";
        string outputFileName = "";

        // コマンドライン引数から取得
        if (args.Length >= 4)
        {
            if (!int.TryParse(args[0], out count) || !int.TryParse(args[1], out startNumber))
            {
                Console.WriteLine("引数が無効です。使用方法: dotnet run <件数> <開始番号> <日付(yymmdd)> <出力ファイル名>");
                return;
            }
            yymmdd = args[2];
            outputFileName = args[3];
        }
        else
        {
            // 対話的に入力
            Console.Write("生成する件数を入力してください: ");
            if (!int.TryParse(Console.ReadLine(), out count) || count <= 0)
            {
                Console.WriteLine("無効な件数です。");
                return;
            }

            Console.Write("開始番号を入力してください: ");
            if (!int.TryParse(Console.ReadLine(), out startNumber) || startNumber < 0)
            {
                Console.WriteLine("無効な開始番号です。");
                return;
            }

            Console.Write("日付を入力してください(yymmdd形式): ");
            yymmdd = Console.ReadLine() ?? "";
            
            Console.Write("出力ファイル名を入力してください: ");
            outputFileName = Console.ReadLine() ?? "";
        }

        // 日付の検証（yymmdd形式: 6桁）
        if (yymmdd.Length != 6 || !DateTime.TryParseExact($"20{yymmdd}", "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime date))
        {
            Console.WriteLine("日付の形式が無効です。yymmdd形式（6桁）で、有効な日付を入力してください。");
            return;
        }

        // 日付をyyyyMMdd形式に変換
        string yyyyMMdd = date.ToString("yyyyMMdd", CultureInfo.InvariantCulture);

        // ファイル名に.xlsx拡張子が含まれていない場合は自動付与
        if (!outputFileName.EndsWith(".xlsx", StringComparison.OrdinalIgnoreCase))
        {
            outputFileName += ".xlsx";
        }

        // データ生成
        var dataList = new List<SlipData>();
        for (int i = 0; i < count; i++)
        {
            int sequenceNumber = startNumber + i;
            string slipHeaderText = $"M01C01{yymmdd}{sequenceNumber:D3}";

            var data = new SlipData
            {
                OthersWbsElement_r = "20240908",
                OthersWbsElement_s = "20240908",
                VoucherDate = "20240908",
                PostingDate = "20240908",
                Period = "",
                SlipNumber = "",
                ScreenVariant = "",
                ReferenceVoucherNumber = "",
                SlipHeaderText = slipHeaderText,
                TransactionCurrency = "JPY",
                Text = "",
                ManagementDomain = "M01",
                CostElement = "9Y62000004",
                Amount = "595142",
                Quantity = "1",
                QuantityUom = "",
                EmployeeNo = "",
                SenderCostCenter = "",
                SendersOrder = "",
                RefRegistrationInstruction_s = "",
                InstForDummyCounting_s = "",
                SenderWbsElement = "M0152156-99100",
                OTHERSWbsElem_s = "M0152156-OTHERS",
                DummyAccountingWbsElement_s = "M01WBS-ETC",
                SenderNetwork = "",
                SenderOperation = "",
                ReceiverCostCenter = "",
                ReceiverInstruction = "",
                RefRegistrationInstruction_r = "",
                InstForDummyCounting_r = "",
                ReceiverWbsElement = "M01IMWL08-99100",
                OTHERSWbsElem_r = "M01IMWL08-OTHERS",
                DummyAccountingWbsElement_r = "M01IMWL08-ETC",
                ReceiverNetwork = "",
                ReceiverOperation = "",
                Requester = "M01C01",
                ReceivablesUnderTransfer = "AE0",
                SubordinateDivision = ""
            };

            dataList.Add(data);
        }

        // Excelファイルに出力
        var options = new JsonSerializerOptions
        {
            WriteIndented = false
        };

        using (var workbook = new XLWorkbook())
        {
            var worksheet = workbook.Worksheets.Add("Sheet1");
            
            int row = 1;
            foreach (var data in dataList)
            {
                string json = JsonSerializer.Serialize(data, options);
                worksheet.Cell(row, 1).Value = json;
                row++;
            }
            
            workbook.SaveAs(outputFileName);
        }

        Console.WriteLine($"Excelファイル '{outputFileName}' を出力しました。");
    }
}
