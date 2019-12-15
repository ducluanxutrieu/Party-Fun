import { Component, OnInit } from '@angular/core';
import { UserService } from '../../_services/user.service';

@Component({
  selector: 'app-chart-page',
  templateUrl: './chart-page.component.html',
  styleUrls: ['./chart-page.component.css']
})
export class ChartPageComponent implements OnInit {
  public barChartOptions = {
    scaleShowVerticalLines: false,
    responsive: true
  };
  public barChartLabels = ['10-11', '11-11', '12-11', '13-11', '14-11',
    '15-11', '16-11'];
  public barChartType = 'bar';
  public barChartLegend = true;
  public barChartData = [
    { data: [65, 59, 80, 81, 56, 55, 0], label: 'Total Orders' },
    { data: [28, 48, 40, 19, 86, 27, 90], label: 'Toltal Bills' }
  ];
  public barChartData2 = [
    { data: [5000000, 1200000, 700000, 150000, 1800000, 300000, 0], label: 'Total Money' },
  ];
  constructor(
    public userService: UserService,
  ) { }

  ngOnInit() {
  }
  createChart() {

  }
}
