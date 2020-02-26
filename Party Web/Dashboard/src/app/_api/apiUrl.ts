export const apiUrl = "http://139.180.131.30:3000";
export const api = {
    signin: `${apiUrl}/user/signin`,                        //login
    signout: `${apiUrl}/user/signout`,                      //logout
    signup: `${apiUrl}/user/signup`,                        //signup

    changepassword: `${apiUrl}/user/changepassword`,        //changepass
    resetpassword: `${apiUrl}/user/resetpassword`,          //forgotpass-1:   
    resetconfirm: `${apiUrl}/user/resetconfirm`,            //forgotpass-2: resetpassword with confirm code

    uploadavatar: `${apiUrl}/user/uploadavatar`,            //upload avatar
    profile: `${apiUrl}/user/profile`,                      //get user profile
    updateuser: `${apiUrl}/user/updateuser`,                //update user's info
    upgraderole: `${apiUrl}/user/upgraderole`,              //upgrade from customer to staff
    downgraderole: `${apiUrl}/user/demotionrole`,           //downgrade from staff to customer
    getCustomerlist: `${apiUrl}/user/finduserkh`,           //get customers list
    getStafflist: `${apiUrl}/user/findusernv`,              //get staffs list

    productStatistics: `${apiUrl}/product/statisticaldish`,        //get products statistics (current day)
    moneyStatistics: `${apiUrl}/product/statisticalmoney`,         //get money statistics by day (last 7 day)
    billStatistics: `${apiUrl}/product/findallbill`,               //get bill statistics in last 20 days 

    findbill: `${apiUrl}/product/findbill`,                 //find user bill info
    pay: `${apiUrl}/product/pay`,                           //pay bill
    delete_bill: `${apiUrl}/product/deletebill`,            //delete bill

    adddish: `${apiUrl}/product/adddish`,                   //add new dish to database
    getdishlist: `${apiUrl}/product/finddish`,              //get list of all dishes
    updateDish: `${apiUrl}/product/updatedish`,             //update existed dish
    uploadDishImage: `${apiUrl}/product/uploadimage`,       //
    deleteDish: `${apiUrl}/product/deletedish`,             //delete existed dish

    orderConfirm: `${apiUrl}/product/book`,                 //confirm order
};