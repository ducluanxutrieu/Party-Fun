import { Component, OnInit } from '@angular/core';
import { formatDate } from '@angular/common';
import { ToastrService } from 'ngx-toastr';

// services
import { StatisticalService } from '../../_services/statistical.service';
// Models
import { MoneyStatistic, DishStatistic, CustomerStatistic, StaffStatistic } from '../../_models/statistic.model';
import { NewUpdateModel } from '../../_models/statistic.model';
declare var $: any;

@Component({
  selector: 'app-admin-page',
  templateUrl: './admin-page.component.html',
  styleUrls: ['./admin-page.component.css']
})
export class AdminPageComponent implements OnInit {
  new_updates: NewUpdateModel;
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
    // maintainAspectRatio: false
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
            beginAtZero: true,
            userCallback: function (value, index, values) {
              // Convert the number to a string and splite the string every 3 charaters from the end
              value = value.toString();
              value = value.split(/(?=(?:...)*$)/);

              // Convert the array to a string and format the output
              value = value.join('.');
              return value;
            }
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
            beginAtZero: true,
            callback: function (value) { if (value % 1 === 0) { return value; } },
          },
          position: 'left',
          gridLines: {
            display: false
          }
        },
        {
          id: 'y-axis-1',
          ticks: {
            beginAtZero: true,
            userCallback: function (value, index, values) {
              // Convert the number to a string and splite the string every 3 charaters from the end
              value = value.toString();
              value = value.split(/(?=(?:...)*$)/);

              // Convert the array to a string and format the output
              value = value.join('.');
              return value;
            }
          },
          position: 'right',
          gridLines: {
            display: false
          }
        }
      ]
    },
  };

  public moneyChartLabels = [];
  public productChartLabels = [];
  public customerChartLabels = [];
  public staffChartLabels = [];
  public barChartType = 'bar';
  public pieChartType = 'pie';
  public lineChartType = 'line';
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
  ];
  public staffChartData = [
    { data: [0], label: 'Total Money', yAxisID: '' },
    { data: [0], label: 'Bill count', yAxisID: '' }
  ];

  // Biến kiểm tra xem data cho biểu đồ có hay chưa
  public isMoneyDataAvailable = false;
  public isProductDataAvailable = false;
  public isCustomerDataAvailable = false;
  public isStaffDataAvailable = false;

  constructor(
    private statisticalService: StatisticalService,
    private toastr: ToastrService
  ) { }

  ngOnInit() {
    this.get_statistic_money();

    this.product_range_changed('day');
    this.customer_range_changed('day');
    this.staff_range_changed('day');
    this.get_newUpdate();
  }

  // Lấy Thống kê tổng hóa đơn theo 7 ngày gần nhất và tạo biểu đồ tương ứng
  get_statistic_money() {
    this.statisticalService.get_moneyStatistics().subscribe(
      res => {
        this.isMoneyDataAvailable = true;
        setTimeout(() => {
          this.create_moneyChart(res.data as MoneyStatistic[]);
        });
      },
      err => {
        console.error("Error: " + err.error.message);
        this.toastr.error("Error while getting money statistic!");
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
    ];
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
      ];
    } else {
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
          yAxisID: 'y-axis-1',
        }
      ];
    }
  }

  create_staffChart(staffData: StaffStatistic[]) {
    if (staffData) {
      this.staffChartLabels = [];
      let staff_bills_count: number[] = [];
      let staff_totalmoney: number[] = [];
      for (let i = 0; i < staffData.length; i++) {
        staff_bills_count.push(staffData[i].count_bill);
        staff_totalmoney.push(staffData[i].total_money);
        this.staffChartLabels.push(staffData[i]._id);
      }
      ////
      this.staffChartData = [
        {
          data: staff_bills_count,
          label: 'Bills count',
          yAxisID: 'y-axis-0'
        },
        {
          data: staff_totalmoney,
          label: 'Total money',
          yAxisID: 'y-axis-1',
        }
      ];
    }
  }

  // Khi thay đổi phạm vi thống kê món ăn
  product_range_changed(value: string, date?: string) {
    $('#productBtn > .chart-btn').on('click', function () {
      $('#productBtn > .chart-btn').removeClass('active');
      $(this).addClass('active');
      $('#productCustom').collapse('hide');
    });
    this.statisticalService.get_productStatistics(value, date).subscribe(
      res => {
        if (res.data.length > 0) {
          this.isProductDataAvailable = true;
        } else {
          this.isProductDataAvailable = false;
        }
        setTimeout(() => {
          this.create_productChart(res.data as DishStatistic[]);
        });
      },
      err => {
        console.error("Error: " + err.error.message);
        this.toastr.error("Error while getting product statistic!");
      }
    );
  }

  // Khi thay đổi phạm vi thống kê khách hàng
  customer_range_changed(value: string, date?: string) {
    $('#customerBtn > .chart-btn').on('click', function () {
      $('#customerBtn > .chart-btn').removeClass('active');
      $(this).addClass('active');
      $('#customerCustom').collapse('hide');
    });
    this.statisticalService.get_customerStatistics(value, null, date).subscribe(
      res => {
        if (res.data.length > 0) {
          this.isCustomerDataAvailable = true;
        } else {
          this.isCustomerDataAvailable = false;
        }
        setTimeout(() => {
          this.create_customerChart(res.data as CustomerStatistic[]);
        });
      },
      err => {
        console.error("Error: " + err.error.message);
        this.toastr.error("Error while getting customer statistic!");
      }
    );
  }

  // Khi thay đổi phạm vi thống kê nhân viên
  staff_range_changed(value: string, date?: string) {
    $('#staffBtn > .chart-btn').on('click', function () {
      $('#staffBtn > .chart-btn').removeClass('active');
      $(this).addClass("active");
      $('#employeeCustom').collapse('hide');
    });
    this.statisticalService.get_staffStatistics(value, date).subscribe(
      res => {
        if (res.data.length > 0) {
          this.isStaffDataAvailable = true;
        } else {
          this.isStaffDataAvailable = false;
        }
        setTimeout(() => {
          this.create_staffChart(res.data as StaffStatistic[]);
        });
      },
      err => {
        console.error("Error: " + err.error.message);
        this.toastr.error("Error while getting staff statistic!");
      }
    );
  }

  // Lấy các update mới
  get_newUpdate() {
    this.statisticalService.get_newUpdate().subscribe(
      res => {
        this.new_updates = res.data as NewUpdateModel;
      }
    )
  }
}
