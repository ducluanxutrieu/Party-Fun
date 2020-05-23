import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-pagination',
  templateUrl: './pagination.component.html',
  styleUrls: ['./pagination.component.css']
})
export class PaginationComponent implements OnInit {
  total_pages: number;
  current_index: number = 1;

  constructor() { }

  ngOnInit() {
  }
  // Đổi trang
  change_page(page: number) {
    if (page > 0 && page <= this.total_pages) {
      this.current_index = page;
    }
  }
}