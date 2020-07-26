import { Component, OnInit, Input } from '@angular/core';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { api } from '../../../_api/apiUrl';
//Models
import { Rating } from '../../../_models/rating.model';
//Services
import { AuthenticationService } from '../../../_services/authentication.service';
import { ToastrService } from 'ngx-toastr';
import { ProductService } from '../../../_services/product.service';

declare var $: any;

interface Dish_rating {
  start: number;
  end: number;
  total_page: number;
  count_rate: number;
  avg_rate: number;
  list_rate: Rating[];
}
interface rateOverall {
  one: number;
  two: number;
  three: number;
  four: number;
  five: number;
}

@Component({
  selector: 'app-product-rating',
  templateUrl: './product-rating.component.html',
  styleUrls: ['./product-rating.component.css']
})
export class ProductRatingComponent implements OnInit {
  @Input() productId: string;
  @Input() productRating: Dish_rating;
  @Input('data') list_rate: Rating[] = [];
  page: number = 1;
  total_pages: number;

  current_user_id: string;  // Để so xác nhận comment nào là của mình
  // product_rating: any;
  reviewOverall: rateOverall = {
    one: 0,
    two: 0,
    three: 0,
    four: 0,
    five: 0
  }
  rate = 0;

  edit_trigger = false;
  edit_id: string;
  edit_rating = 0;
  edit_review: string;

  constructor(
    private http: HttpClient,
    public authenticationService: AuthenticationService,
    private toastr: ToastrService,
    private productService: ProductService,
  ) { }
  ngOnInit() {
    this.loaddata();
  }

  loaddata() {
    if (localStorage.getItem('userinfo')) {
      this.current_user_id = JSON.parse(localStorage.getItem('userinfo')).username;
    }
    this.load_review();
    if (!this.authenticationService.loggedIn()) {
      $('#reviewbtn').text('Login to write review');
    }

    this.get_rating_page(1);
  }

  // Xác nhận comment
  ratingSubmit(data: {
    comment: string,
    rating: number
  }) {
    if (this.authenticationService.loggedIn()) {
      let headers = new HttpHeaders({
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization': localStorage.getItem('token')
      });
      let body = `id=${this.productId}&score=${data.rating}&comment=${data.comment}`;
      this.http.post(api.product_rate, body, { headers: headers, observe: 'response' }).subscribe(
        res => {
          this.toastr.success("Posted review successfully!");
          this.loaddata();
          $('#new-review').val('')
          data.comment = '';
          data.rating = 0;
          this.rate = 0;
        },
        err => {
          this.toastr.error("Error posting review");
          console.log("Error: " + err.error.message);
        }
      )
    }
    else {
      this.toastr.warning("You must be logged in to post a comment!");
    }
  }

  // Load reviewOverall
  load_review() {
    for (var index = 0; index < this.productRating.list_rate.length; index++) {
      switch (this.productRating.list_rate[index].score) {
        case 1:
          this.reviewOverall.one++;
          break;
        case 2:
          this.reviewOverall.two++;
          break;
        case 3:
          this.reviewOverall.three++;
          break;
        case 4:
          this.reviewOverall.four++;
          break;
        case 5:
          this.reviewOverall.five++;
          break;
        default:
          index++;
          break;
      }
    }
  }

  // Thay review thành editor
  edit_clicked(review: Rating, index: number) {
    this.edit_trigger = true;
    this.edit_review = review.comment;
    this.edit_rating = review.score;
    this.edit_id = review._id;
    $(`#review${index}`).replaceWith($('#edit_review'));
  }
  // Sửa review
  update_review() {
    let headers = new HttpHeaders({
      'Content-type': 'application/x-www-form-urlencoded',
      'Authorization': localStorage.getItem('token')
    });
    const body = `id=${this.edit_id}&score=${this.edit_rating}&comment=${this.edit_review}`;
    this.http.put(api.product_rate, body, { headers: headers }).subscribe(
      res => {
        this.toastr.success("Update comment successfully!");
        window.location.reload();
      },
      err => {
        this.toastr.error("Error updating review!");
        console.log("Error: " + err.error.message);
      }
    )
  }

  // Xóa review
  delete_review(review: Rating) {
    let headers = new HttpHeaders({
      'Authorization': localStorage.getItem('token')
    });
    const options = {
      headers: headers,
      body: {
        id: review._id
      }
    }
    this.http.delete(api.product_rate, options).subscribe(
      res => {
        this.toastr.success("Delete comment successfully!");
        this.loaddata();
      },
      err => {
        this.toastr.error("Error deleting review!");
        console.log("Error: " + err.error.message);
      }
    )
  }

  // Get rating page
  get_rating_page(page: number) {
    this.productService.get_dishRating(this.productId, page).subscribe(
      res => {
        this.list_rate = (res.data as Dish_rating).list_rate;
        this.total_pages = res.data.total_page;
        this.page = page;
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }
}