import { Component, OnInit } from '@angular/core';

//Services
import { UserService } from '../../../_services/user.service';

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css']
})
export class SidebarComponent implements OnInit {

  constructor(
    public userService: UserService,
  ) { }

  ngOnInit() { }
}