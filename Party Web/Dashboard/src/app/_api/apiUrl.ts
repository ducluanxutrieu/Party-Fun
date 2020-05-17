export const apiUrl = "http://139.180.131.30:3000";
export const api = {
    signin: `${apiUrl}/user/signin`,                            // Đăng nhập
    signout: `${apiUrl}/user/signout`,                          // Đăng xuất
    signup: `${apiUrl}/user/signup`,                            // Đăng ký

    get_profile: `${apiUrl}/user/get_me`,                       // Lấy thông tin user
    uploadavatar: `${apiUrl}/user/uploadavatar`,                // Cập nhật avatar
    update_user: `${apiUrl}/user/update`,                       // Cập nhật thông tin user
    upgrade_role: `${apiUrl}/user/add_staff`,                   // Nâng cấp tài khoản thành nhân viên
    downgrade_role: `${apiUrl}/user/del_staff`,                 // Hạ cấp thành tài khoản khách hàng
    get_customerList: `${apiUrl}/user/customers`,               // Lấy danh sách khách hàng
    get_staffList: `${apiUrl}/user/staffs`,                     // Lấy danh sách nhân viên

    productStatistics: `${apiUrl}/product/statistic_dish`,      // Thống kê món ăn được gọi trong 1 ngày
    moneyStatistics: `${apiUrl}/product/statistic_money`,       // Thống kê tổng hóa đơn theo 7 ngày gần nhất
    billStatistics: `${apiUrl}/product/findallbill`,            //  

    findbill: `${apiUrl}/product/findbill`,                 //find user bill info
    pay: `${apiUrl}/product/pay`,                           //pay bill
    delete_bill: `${apiUrl}/product/deletebill`,            //delete bill

    add_dish: `${apiUrl}/product/dish`,                     // Thêm món ăn mới
    get_dishList: `${apiUrl}/product/dishs`,                // Lấy danh sách món ăn
    update_dish: `${apiUrl}/product/dish`,                  // Cập nhật món ăn có sẵn
    deleteDish: `${apiUrl}/product/deletedish`,             // delete existed dish

    orderConfirm: `${apiUrl}/product/book`,                 //confirm order

    upload_image: `${apiUrl}/product/upload_image`,         // Upload ảnh
};