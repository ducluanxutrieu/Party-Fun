export const apiUrl = "http://138.91.33.161:3000";
export const api ={
    signin:`${apiUrl}/user/signin`,                     //login
    signout:`${apiUrl}/user/signout`,                   //logout
    signup:`${apiUrl}/user/signup`,                     //signup

    changepassword:`${apiUrl}/user/changepassword`,     //changepass
    resetpassword:`${apiUrl}/user/resetpassword`,       //forgotpass-1:   
    resetconfirm:`${apiUrl}/user/resetconfirm`,         //forgotpass-2: resetpassword with confirm code
 
    uploadavatar:`${apiUrl}/user/uploadavatar`,         //upload avatar
    profile:`${apiUrl}/user/profile`,                   //get user profile
    updateuser:`${apiUrl}/user/updateuser`,             //update user's info
    upgraderole:`${apiUrl}/user/upgraderole`,           //upgrade from customer to admin

    adddish:`${apiUrl}/product/adddish`,                //add new dish to database
    getdishlist:`${apiUrl}/product/finddish`,           //get list of all dishes
    updateDish:`${apiUrl}/product/update`,              //update existed dish

    orderConfirm:`${apiUrl}/product/book`,              //confirm order
};