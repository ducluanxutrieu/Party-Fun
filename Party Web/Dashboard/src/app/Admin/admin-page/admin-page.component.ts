import { Component, OnInit } from '@angular/core';
import { formatDate } from "@angular/common";

//services
import { StatisticalService } from '../../_services/statistical.service';
// Models
import { MoneyStatistic, DishStatistic, CustomerStatistic } from '../../_models/statistic.model';

@Component({
  selector: 'app-admin-page',
  templateUrl: './admin-page.component.html',
  styleUrls: ['./admin-page.component.css']
})
export class AdminPageComponent implements OnInit {
  dishes_statistics: DishStatistic[] = [];

  // Option cho biểu đồ thống kê món ăn
  public productChartOptions = {
    scaleShowVerticalLines: false,
    responsive: true,
    scales: {
      xAxes: [{
        barPercentage: 0.9,
        maxBarThickness: 50
      }],
      yAxes: [
        {
          ticks: {
            beginAtZero: true,
            callback: function (value) { if (value % 1 === 0) { return value; } }
          }
        }
      ]
    },
    maintainAspectRatio: false
  };

  // Option cho biểu đồ thống kê doanh thu
  public moneyChartOptions = {
    scaleShowVerticalLines: false,
    responsive: true,
    scales: {
      xAxes: [{
        barPercentage: 0.4,
        maxBarThickness: 50,
      }],
      yAxes: [
        {
          ticks: {
            beginAtZero: true
          }
        }
      ]
    }
  };

  // Option cho biểu đồ thống kê tiền khách hàng thanh toán
  public customerChartOptions = {
    scaleShowVerticalLines: false,
    responsive: true,
    scales: {
      xAxes: [{
        barPercentage: 0.4,
        maxBarThickness: 50,
      }],
      yAxes: [
        {
          id: 'y-axis-0',
          ticks: {
            beginAtZero: true
          },
          position: 'left'
        },
        {
          id: 'y-axis-1',
          ticks: {
            beginAtZero: true
          },
          position: 'right'
        }
      ]
    }
  };

  public moneyChartLabels = [];
  public productChartLabels = [];
  public customerChartLabels = [];
  public barChartType = 'bar';
  public barChartLegend = true;

  // Data cho biểu đồ món ăn
  public productChartData = [
    { data: [0], label: 'Total Orders' },
    { data: [0], label: 'Total Bills' }
  ];

  // Data cho biểu đồ doanh thu
  public moneyChartData = [{ data: [0], label: 'Total Money' }];
  // Data cho biểu đồ khách hàng
  public customerChartData = [
    { data: [0], label: 'Total Money', yAxisID: '' },
    { data: [0], label: 'Bill count', yAxisID: '' }
  ]

  // Biến kiểm tra xem data cho biểu đồ có hay chưa
  public isMoneyDataAvailable: boolean = false;
  public isProductDataAvailable: boolean = false;
  public isCustomerDataAvailable: boolean = false;

  constructor(
    private statisticalService: StatisticalService,
  ) { }

  ngOnInit() {
    this.get_statistic_money();
  }

  // Lấy Thống kê tổng hóa đơn theo 7 ngày gần nhất và tạo biểu đồ tương ứng
  get_statistic_money() {
    this.statisticalService.get_moneyStatistics().subscribe(
      res => {
        this.isMoneyDataAvailable = true;
        setTimeout(() => {
          this.create_moneyChart(res.data as MoneyStatistic[]);
        })
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }

  // Tạo biểu đồ từ Thống kê tổng hóa đơn theo 7 ngày gần nhất
  create_moneyChart(moneyData: MoneyStatistic[]) {
    var money_data = [];
    for (let i = 0; i < moneyData.length; i++) {
      money_data.push(moneyData[i].total);
      this.moneyChartLabels.push(formatDate(moneyData[i]._id, 'dd-MM-yyyy', 'en-US'));
    }
    this.moneyChartData = [
      {
        data: money_data,
        label: 'Total Money'
      }
    ]
  }

  // Tạo biểu đồ từ Thống kê món ăn được gọi trong 1 ngày
  create_productChart(productData: DishStatistic[]) {
    if (productData) {
      this.productChartLabels = [];
      var product_data1 = [];
      var product_data2 = [];
      for (let i = 0; i < productData.length; i++) {
        product_data1.push(productData[i].count);
        product_data2.push(productData[i].total_plate);

        // this.productChartLabels = [];
        this.productChartLabels.push(productData[i].name);
      }
      this.productChartData = [
        {
          data: product_data1,
          label: 'in Bill'  // Số đơn có chứa
        },
        {
          data: product_data2,
          label: 'Total Quantity'  // Tổng số được gọi (Trong tất cả các đơn) (số lượng x bàn)
        }
      ]
    }
    else {
      // this.productChartLabels.push('No product has been ordered');
    }
  }

  // Tạo biểu đồ thống kê khách hàng
  create_customerChart(customerData: CustomerStatistic[]) {
    if (customerData) {
      this.customerChartLabels = [];
      let customer_bills_count: number[] = [];
      let customer_totalmoney: number[] = [];
      for (let i = 0; i < customerData.length; i++) {
        customer_bills_count.push(customerData[i].count_bill);  // Đẩy bill count vào 1 mảng
        customer_totalmoney.push(customerData[i].total_money);  // Đẩy total money vào 1 mảng
        this.customerChartLabels.push(customerData[i]._id);     // Đẩy tên khách hàng vào mảng label
      }
      // Đẩy hết 3 mảng trên vào chart data
      this.customerChartData = [
        {
          data: customer_bills_count,
          label: 'Bills count',
          yAxisID: 'y-axis-0'
        },
        {
          data: customer_totalmoney,
          label: 'Total money',
          yAxisID: 'y-axis-1'
        }
      ]
    }
  }

  // Khi thay đổi phạm vi thống kê món ăn
  product_rangeChanged(data: {
    range: string;
  }) {
    this.statisticalService.get_productStatistics(data.range).subscribe(
      res => {
        if (res.data.length > 0) {
          this.isProductDataAvailable = true;
        }
        else {
          this.isProductDataAvailable = false;
        }
        setTimeout(() => {
          this.create_productChart(res.data as DishStatistic[]);
        })
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }

  // Khi thay đổi phạm vi thống kê khách hàng
  customer_rangeChanged(data: {
    range: string;
    payment_status: number;
  }) {
    this.statisticalService.get_customerStatistics(data.range, data.payment_status).subscribe(
      res => {
        if (res.data.length > 0) {
          this.isCustomerDataAvailable = true;
        }
        else {
          this.isCustomerDataAvailable = false;
        }
        setTimeout(() => {
          this.create_customerChart(res.data as CustomerStatistic[]);
        })
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }
}