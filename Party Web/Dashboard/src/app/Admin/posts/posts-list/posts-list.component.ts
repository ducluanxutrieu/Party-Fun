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
  posts_list: Post[] = [];

  constructor(
    private postService: PostService,
  ) { }

  ngOnInit() {
    this.get_posts_list();
  }

  // Lấy danh sách bài viết
  get_posts_list() {
    this.postService.get_posts_list(1).subscribe(
      res => {
        this.posts_list = res.data.value as Post[];
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
