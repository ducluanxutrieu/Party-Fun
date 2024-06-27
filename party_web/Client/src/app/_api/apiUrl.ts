export const apiUrl = "http://139.180.131.30:3000";
export const api = {
    signin: `${apiUrl}/user/signin`,                            // Đăng nhập
    signout: `${apiUrl}/user/signout`,                          // Đăng xuất
    signup: `${apiUrl}/user/signup`,                            // Đăng ký

    change_password: `${apiUrl}/user/change_pwd`,               // Đổi mật khẩu (Trong profile)
    reset_password: `${apiUrl}/user/reset_password`,            // Yêu cầu quên mật khẩu   
    confirm_otp: `${apiUrl}/user/confirm_otp`,                  // Xác nhận đổi mật khẩu với mã OTP 

    profile: `${apiUrl}/user/get_me`,                           // Lấy thông tin user
    cart_history: `${apiUrl}/user/get_history_cart`,            // Lấy lịch sử đơn hàng
    update_user: `${apiUrl}/user/update`,                       // Cập nhật thông tin user
    update_avt: `${apiUrl}/user/avatar`,                        // Cập nhật avatar

    get_dishlist: `${apiUrl}/product/dishs`,                    // Lấy danh sách món ăn
    get_category: `${apiUrl}/product/get_dish_by_categories`,   // Lấy danh sách món ăn trong 1 category
    get_dish: `${apiUrl}/product/dish`,                         // Lấy thông tin của 1 món
    product_rate: `${apiUrl}/product/rate`,                     // Các thao tác liên quan đến comment và rating món ăn

    book: `${apiUrl}/product/book`,                             // Đặt đơn hàng
    get_payment: `${apiUrl}/payment/get_payment`,               // Lấy Stripe session

    post: `${apiUrl}/product/posts`,                            // Liên quan đến post
}