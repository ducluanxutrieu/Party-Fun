import { Component, OnInit } from '@angular/core';

interface Location {
  latitude: number;
  longitude: number;
}

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrls: ['./map.component.css']
})

export class MapComponent implements OnInit {
  location: Location;


  constructor() {
    this.location = {
      latitude: 10.870148,
      longitude: 106.787261
    }
  }

  ngOnInit() {
  }

}
