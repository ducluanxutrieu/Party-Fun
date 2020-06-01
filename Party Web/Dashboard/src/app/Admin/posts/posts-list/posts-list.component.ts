import { Component, OnInit } from '@angular/core';
// Services
import { PostService } from '../../../_services/post.service';
// Models 
import { Post } from '../../../_models/post.model';
@Component({
  selector: 'app-posts-list',
  templateUrl: './posts-list.component.html',
  styleUrls: ['./posts-list.component.css']
})
export class PostsListComponent implements OnInit {
  total_pages: number
  posts_list: Post[] = [];

  constructor(
    private postService: PostService,
  ) { }

  ngOnInit() {
    this.get_posts_list(1);
  }

  // Lấy danh sách bài viết
  get_posts_list(page: number) {
    this.postService.get_posts_list(page).subscribe(
      res => {
        this.posts_list = res.data.value as Post[];
        this.total_pages = res.data.total_page;
      },
      err => {
        console.log("Error: " + err.error.message);
      }
    )
  }

  // Xóa bài viết 
  post_delete(id: string) {

  }
}
