import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DishlistComponent } from './dishlist.component';

describe('DishlistComponent', () => {
  let component: DishlistComponent;
  let fixture: ComponentFixture<DishlistComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DishlistComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DishlistComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
