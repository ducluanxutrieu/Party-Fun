package com.uit.party.ui.main.payment_party

import androidx.lifecycle.ViewModelProvider
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.navigation.findNavController
import androidx.navigation.fragment.navArgs
import com.google.gson.Gson
import com.uit.party.R
import com.uit.party.databinding.PaymentPartyFragmentBinding
import com.uit.party.model.BillResponseModel
import com.uit.party.util.TimeFormatUtil.formatTime12hToClient
import com.uit.party.util.UiUtil.toVNCurrency

class PaymentPartyFragment : Fragment() {
    lateinit var mBinding: PaymentPartyFragmentBinding

    private lateinit var viewModel: PaymentPartyViewModel
//    private val myArgs: PaymentPartyFragmentArgs by navArgs()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        mBinding = DataBindingUtil.inflate(inflater, R.layout.payment_party_fragment, container, false)
        return mBinding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        viewModel = ViewModelProvider(this).get(PaymentPartyViewModel::class.java)
        mBinding.viewModel = viewModel

/*        val model = myArgs.billModel

        if ( model == null){
            mBinding.root.findNavController().popBackStack()
        }else
            viewModel.mBillModel = model*/

        val json =
            "{\"message\":\"Booking success\",\"data\":{\"date_party\":\"2020-11-13T16:18:00.000Z\",\"dishes\":[{\"_id\":\"5f6225162b454c00048213c2\",\"count\":1,\"name\":\"Khoai tây chiên\",\"feature_image\":\"http://nauco29.com/files/thumb/767/450//uploads/content/khoai-tay-chien.jpg\",\"price\":50000,\"discount\":0,\"currency\":\"vnd\",\"total_money\":50000},{\"_id\":\"5f60e8268974750004b8bf8f\",\"count\":1,\"name\":\"Mực xào cần tỏi\",\"feature_image\":\"http://nauco29.com/files/thumb/767/450//uploads/content/mựcxàocầntỏi.jpg\",\"price\":200000,\"discount\":5,\"currency\":\"vnd\",\"total_money\":190000},{\"_id\":\"5f6224c02b454c00048213bf\",\"count\":1,\"name\":\"Súp ngô xay thịt hầm\",\"feature_image\":\"http://nauco29.com/files/thumb/767/450//uploads/content/supngo.jpg\",\"price\":80000,\"discount\":0,\"currency\":\"vnd\",\"total_money\":80000}],\"count_customer\":50,\"table\":5,\"total\":1600000,\"customer\":\"luan\",\"create_at\":\"2020-11-13T09:18:11.339Z\",\"confirm_status\":0,\"confirm_at\":\"2020-11-13T09:18:11.339Z\",\"confirm_by\":\"\",\"confirm_note\":\"\",\"currency\":\"vnd\",\"payment_status\":0,\"payment_type\":0,\"payment_at\":\"2020-11-13T09:18:11.339Z\",\"payment_by\":\"\",\"_id\":\"5fae4f53c4909700041191b3\"}}"
        val temp = Gson().fromJson(json, BillResponseModel::class.java).billModel
        if (temp != null) {
            viewModel.mBillModel = temp

            mBinding.tvTotalBill.text = temp.total.toString().toVNCurrency()
            mBinding.tvNumberTable.text = temp.table.toString()
            mBinding.tvTimeBooking.text = temp.date_party.formatTime12hToClient()
        }
    }

}