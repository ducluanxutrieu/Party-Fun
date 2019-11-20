module.exports = function (app) {

    var controller = require('./product.controllers')
    var auth=require('../authorization')
    //tao mon an
    app.post('/product/adddish',auth.isAuthenticated, auth.isStaff, controller.adddish);

    // cap nhat mon an
    app.post('/product/updatedish',auth.isAuthenticated, auth.isStaff, auth.checkinDataDish, controller.update);

    // upload anh, cong don vao danh sach anh hien tai
    app.post('/product/uploadimage', auth.isAuthenticated, auth.isStaff ,controller.uploadimage);

    //delete mon an
    app.delete('/product/deletedish', auth.isAuthenticated, auth.isStaff, controller.deletedish);

    // in danh sach mon an
    app.get('/product/finddish', controller.finddish);

    // dat ban
    app.post('/product/book', auth.isAuthenticated, auth.checkinDataBookDish, controller.book);

    // in ra id bill theo ten nguoi dung username
    app.get('/product/findbill', controller.findbill);

    // thanh toan
    app.post('/product/pay', auth.isAuthenticated, auth.isStaff, controller.pay);

    // thong ke
    app.get('/product/statistical', auth.isAuthenticated, auth.isStaff, controller.statistical);

    // danh gia mon an
    app.post('/product/ratedish', auth.isAuthenticated, controller.rate);
}