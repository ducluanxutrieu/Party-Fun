import { Component, OnInit } from '@angular/core';
import { api } from '../../../_api/apiUrl';
import { HttpClient, HttpHeaders } from '@angular/common/http';

export interface DishItem {
  name: string;
  number: number;
  type: number;
  price: string;
}

@Component({
  selector: 'app-dishlist',
  templateUrl: './dishlist.component.html',
  styleUrls: ['./dishlist.component.css']
})
export class DishlistComponent implements OnInit {

  constructor(
    private http: HttpClient
  ) { }

  dish_data: DishItem[] = [];
  displayedColumns: string[] = ['number', 'name', 'type', 'price'];
  dataSource;

  getDishList() {
    let headers = new HttpHeaders({
      'Authorization': localStorage.getItem('token')
    })
    var dishesData;
    this.http.get(api.getdishlist, { headers: headers, observe: 'response' }).subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
        dishesData = JSON.parse(sessionStorage.getItem('response_body'));
        var temp: DishItem;
        for (var i = 0; i < dishesData.lishDishs.length; i++) {
          temp = {
            number: i + 1,
            name: dishesData.lishDishs[i].name,
            type: dishesData.lishDishs[i].type,
            price: dishesData.lishDishs[i].price,
          }
          this.dish_data.push(temp);
        }
        //console.log("dish_data \n" + this.dish_data);
        //console.log(ELEMENT_DATA);
        //console.log(dishesData.lishDishs);
        this.dataSource = this.dish_data;
        console.log(res_data.body);
      },
      err => {
        alert("Lỗi: " + err.status + " " + err.statusText);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    );
  }

  ngOnInit() {
    this.getDishList();
  }

}
