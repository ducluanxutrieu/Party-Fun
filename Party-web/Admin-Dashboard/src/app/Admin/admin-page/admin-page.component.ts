import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../../_api/apiUrl';
import { formatDate } from "@angular/common";

interface MoneyStatisic {
  dateDay: Date;
}
//services
import { StatisticalService } from '../../_services/statistical.service';
import { UserService } from '../../_services/user.service';

@Component({
  selector: 'app-admin-page',
  templateUrl: './admin-page.component.html',
  styleUrls: ['./admin-page.component.css']
})
export class AdminPageComponent implements OnInit {
  money_statistics = [];
  // money_statistics: MoneyStatisic;
  product_statistics = [];
  bill_statistics = [];

  public barChartOptions = {
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
  public barChartOptions2 = {
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
  public barChartData = [
    { data: [0], label: 'Total Orders' },
    { data: [0], label: 'Total Bills' }
  ];
  public barChartData2 = [{ data: [0], label: 'Total Money' }];
  public barChartData3 = [{ data: [0], label: 'Total Bills' }];

  public isMoneyDataAvailable: boolean = false;
  public isProductDataAvailable: boolean = false;

  constructor(
    public userService: UserService,
    private statisticalService: StatisticalService,
    private http: HttpClient
  ) { }

  ngOnInit() {
    this.statisticalService.money_statistics.subscribe(data => {
      this.money_statistics = data;
      this.isMoneyDataAvailable = true;
      setTimeout(() => {
        this.create_moneyChart(data);
      })
    })
    this.statisticalService.product_statistics.subscribe(data => {
      this.product_statistics = data;
      this.isProductDataAvailable = true;
      setTimeout(() => {
        this.create_productChart(data);
      })
    });

    // this.bill_statistics = this.statisticalService.get_billData();
    // this.money_statistics.sort(function (a, b) {
    //   return new Date(b.dateDay.split('-').reverse().join('-')) - new Date(a.dateDay.split('-').reverse().join('-'));
    // });

    // this.create_billChart(this.bill_statistics);
  }
  create_moneyChart(moneyData: any[]) {
    var money_data = [];
    for (let i = 0; i < moneyData.length; i++) {
      money_data.push(moneyData[i].totalMoney);
      this.moneyChartLabels.push(formatDate(moneyData[i].dateDay, 'dd-MM-yyyy', 'en-US'));
    }
    this.barChartData2 = [
      {
        data: money_data,
        label: 'Total Money'
      }
    ]
  }
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
      this.barChartData = [
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