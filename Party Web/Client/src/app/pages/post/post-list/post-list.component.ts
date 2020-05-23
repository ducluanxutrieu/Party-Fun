import { Component, OnInit } from '@angular/core';
// Services
import { PostService } from '../../../_services/post.service';
// Models
import { Post } from '../../../_models/post.model';

declare var toastr;

@Component({
  selector: 'app-post-list',
  templateUrl: './post-list.component.html',
  styleUrls: ['./post-list.component.css']
})
export class PostListComponent implements OnInit {
  post_list: Post[] = [];
  total_pages: number;
  current_index: number = 1;
  constructor(
    private postService: PostService
  ) { }

  ngOnInit() {
    this.get_posts_list(1);
  }

  // Lấy danh sách bài viết
  get_posts_list(page: number) {
    this.postService.get_posts_list(page).subscribe(
      res => {
        this.post_list = res.data.value as Post[];
      },
      err => {
        console.log("Error: " + err.error.message);
        toastr.error("Error loading posts list!");
      }
    )
  }
  // Đổi trang
  change_page(page: number) {
    if (page > 0 && page <= this.total_pages) {
      this.get_posts_list(page);
      this.current_index = page;
    }
  }
}