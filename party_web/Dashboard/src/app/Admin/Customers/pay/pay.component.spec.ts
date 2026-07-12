import { ComponentFixture, TestBed } from '@angular/core/testing';
import { of, throwError } from 'rxjs';
import { ToastrModule, ToastrService } from 'ngx-toastr';
import { PayComponent } from './pay.component';
import { PaymentService } from '../../../_services/payment.service';
import { Bill, Bill_item } from '../../../_models/bill.model';

describe('PayComponent', () => {
  let component: PayComponent;
  let fixture: ComponentFixture<PayComponent>;
  let paymentService: jasmine.SpyObj<PaymentService>;
  let toastr: ToastrService;

  const mockBill: Bill = {
    _id: 'bill1',
    dishes: [{ name: 'Pizza', quantity: 2 } as Bill_item],
    username: 'user1',
    total: 100000,
    status: 1,
    note: ''
  } as Bill;

  beforeEach(async () => {
    paymentService = jasmine.createSpyObj('PaymentService', ['get_bills_by_username', 'pay_bill', 'delete_bill']);

    await TestBed.configureTestingModule({
      imports: [ToastrModule.forRoot()],
      declarations: [PayComponent],
      providers: [{ provide: PaymentService, useValue: paymentService }]
    }).compileComponents();

    toastr = TestBed.inject(ToastrService);
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PayComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('sets bill_detail when itemClicked', () => {
    component.itemClicked(mockBill);
    expect(component.bill_detail).toEqual(mockBill.dishes);
  });

  it('populates bill_info on successful searchBill', () => {
    paymentService.get_bills_by_username.and.returnValue(of({ data: [mockBill], message: 'ok' }));
    component.searchBill({ username: 'user1' });
    expect(component.bill_info).toEqual([mockBill]);
    expect(component.haveBill).toBeTrue();
  });

  it('sets haveBill to false on searchBill error', () => {
    spyOn(toastr, 'error');
    paymentService.get_bills_by_username.and.returnValue(throwError({ error: { message: 'Not found' } }));
    component.searchBill({ username: 'unknown' });
    expect(component.haveBill).toBeFalse();
    expect(toastr.error).toHaveBeenCalled();
  });
});
