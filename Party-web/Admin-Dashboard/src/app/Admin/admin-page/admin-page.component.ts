import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../../_api/apiUrl';

//services
import { StatisticalService } from '../../_services/statistical.service';
import { UserService } from '../../_services/user.service';
import { async, delay } from 'q';

@Component({
  selector: 'app-admin-page',
  templateUrl: './admin-page.component.html',
  styleUrls: ['./admin-page.component.css']
})
export class AdminPageComponent implements OnInit {
  money_statistics = [];
  product_statistics = [];
  public barChartOptions = {
    scaleShowVerticalLines: false,
    responsive: true,
    scales: {
      yAxes: [
        {
          ticks: {
            beginAtZero: true
          }
        }
      ]
    }
  };
  public barChartLabels = ['10-11', '11-11', '12-11', '13-11', '14-11', '15-11', '16-11'];
  public moneyChartLabels = [];
  public productChartLabels = [];
  public barChartType = 'bar';
  public barChartLegend = true;
  public barChartData = [
    { data: [0], label: 'Total Orders' },
    { data: [0], label: 'Total Bills' }
  ];
  public barChartData2 = [];
  constructor(
    public userService: UserService,
    private statisticalService: StatisticalService,
    private http: HttpClient
  ) { }
  // changeProduct() {
  //   this.barChartData = [
  //     { data: [25, 49, 30, 61, 16, 35, 4], label: 'Total Orders' },
  //     { data: [40, 25, 10, 39, 16, 87, 60], label: 'Total Bills' }
  //   ];
  // }
  ngOnInit() {
    // this.get_moneyStatistics();
    this.money_statistics = this.statisticalService.get_moneyData();
    this.product_statistics = this.statisticalService.get_productData();
    this.create_moneyChart(this.money_statistics);
    this.create_productChart(this.product_statistics);
    // this.statisticalService.product_statistics.subscribe(data => this.product_statistics = data);
  }
  create_moneyChart(moneyData: any[]) {
    var money_data = [];
    for (let i = 0; i < moneyData.length; i++) {
      money_data.push(moneyData[i].totalMoney);
      this.moneyChartLabels.push(moneyData[i].dateDay);
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
    else{
      this.productChartLabels.push('No product has been ordered');
    }
  }
}