import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { formatDate } from "@angular/common";

//services
import { StatisticalService } from '../../_services/statistical.service';
// Models
import { MoneyStatistic, DishStatistic } from '../../_models/statistic.model';

@Component({
  selector: 'app-admin-page',
  templateUrl: './admin-page.component.html',
  styleUrls: ['./admin-page.component.css']
})
export class AdminPageComponent implements OnInit {
  money_statistics = [];
  product_statistics = [];
  // bill_statistics = [];

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

  public moneyChartLabels = [];
  public productChartLabels = [];
  public billChartLabels = [];
  public barChartType = 'bar';
  public barChartLegend = true;
  //
  public productChartData = [
    { data: [0], label: 'Total Orders' },
    { data: [0], label: 'Total Bills' }
  ];

  public moneyChartData = [{ data: [0], label: 'Total Money' }];
  // public barChartData3 = [{ data: [0], label: 'Total Bills' }];

  public isMoneyDataAvailable: boolean = false;
  public isProductDataAvailable: boolean = false;

  constructor(
    private statisticalService: StatisticalService,
    private http: HttpClient
  ) { }

  ngOnInit() {
    this.get_statistic_money();
    this.get_statistic_dish();
  }

  // Lấy Thống kê tổng hóa đơn theo 7 ngày gần nhất và tạo biểu đồ tương ứng
  get_statistic_money() {
    this.statisticalService.get_moneyStatistics().subscribe(
      res => {
        this.money_statistics = res.data as any[];
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

  // Lấy Thống kê món ăn được gọi trong 1 ngày và tạo biểu đồ tương ứng
  get_statistic_dish() {
    this.statisticalService.get_productStatistics().subscribe(
      res => {
        this.product_statistics = res.data as any[];
        this.isProductDataAvailable = true;
        setTimeout(() => {
          this.create_productChart(res.data as any[]);
        })
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      });
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
  create_productChart(productData: any[]) {
    if (productData) {
      var product_data1 = [];
      var product_data2 = [];
      for (let i = 0; i < productData.length; i++) {
        product_data1.push(productData[i].count_of_bill);
        product_data2.push(productData[i].totalorderbill);

        // this.productChartLabels = [];
        this.productChartLabels.push(productData[i].name);
      }
      this.productChartData = [
        {
          data: product_data1,
          label: 'Bill'
        },
        {
          data: product_data2,
          label: 'Order Quantity'
        }
      ]
    }
    else {
      // this.productChartLabels.push('No product has been ordered');
    }
  }
  // create_billChart(billData: any[]) {
  //   if (bill_data) {
  //     var bill_data = [];
  //     for (let i = 0; i < billData.length; i++) {
  //       bill_data.push(billData[i].totalMoney);
  //       this.billChartLabels.push(billData[i].dateDay);
  //     }
  //     this.barChartData3 = [
  //       {
  //         data: bill_data,
  //         label: 'Total bill'
  //       }
  //     ]
  //   }
  //   else {
  //     this.billChartLabels.push('No bill found!');
  //   }
  // }
}