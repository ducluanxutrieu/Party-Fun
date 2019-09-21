package com.uit.party.ui

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.uit.party.R
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.ui.signin.login.LoginFragment

class MainActivity : AppCompatActivity() {

    companion object{
        const val SHARE_REFERENCE_NAME = "com.uit.party.ui"
        const val SHARE_REFERENCE_MODE = Context.MODE_PRIVATE
        const val TAG = "TAGMain"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val intent = Intent(this, SignInActivity::class.java)
        startActivity(intent)
        finish()


    }
//    private class ProductAdapter(
//        private val activity: Activity,
//        private val productEntries: List<io.material.demo.shrine.products.ProductEntry>,
//        var imageRequester: io.material.demo.shrine.products.ImageRequester
//    ) :
//        RecyclerView.Adapter<ProductViewHolder>() {
//
//        override fun onCreateViewHolder(viewGroup: ViewGroup, i: Int): ProductViewHolder {
//            return ProductViewHolder(activity, viewGroup)
//        }
//
//        override fun onBindViewHolder(productViewHolder: ProductViewHolder, i: Int) {
//            productViewHolder.bind(activity, productEntries[i], imageRequester)
//        }
//
//        override fun getItemCount(): Int {
//            return productEntries.size
//        }
//    }
//
//    private class ProductViewHolder(context: Context, parent: ViewGroup) :
//        RecyclerView.ViewHolder(
//            LayoutInflater.from(context).inflate(
//                R.layout.shrine_product_entry,
//                parent,
//                false
//            )
//        ) {
//        private val productPriceView: TextView
//        private val productShopNameView: TextView
//        private val productEntryView: CardView
//
//        private val clickListener = { v ->
//            io.material.demo.shrine.products.ItemActivity.createItemActivityIntent(
//                v.getContext(),
//                v.getTag() as io.material.demo.shrine.products.ProductEntry
//            )
//        }
//
//        init {
//            val layoutParams = itemView.layoutParams
//            itemView.layoutParams = layoutParams
//            productPriceView = itemView.findViewById(R.id.ProductPrice)
//            productImageView = itemView.findViewById<View>(R.id.ProductImage)
//            productShopNameView = itemView.findViewById(R.id.ProductShopName)
//            productEntryView = itemView.findViewById(R.id.ProductEntry)
//            productEntryView.setOnClickListener(clickListener)
//        }
//
//        fun bind(
//            context: Context,
//            productEntry: io.material.demo.shrine.products.ProductEntry,
//            imageRequester: io.material.demo.shrine.products.ImageRequester
//        ) {
//            productPriceView.setText(productEntry.price)
//            imageRequester.setImageFromUrl(productImageView, productEntry.url)
//            productShopNameView.setText(productEntry.title)
//            productEntryView.tag = productEntry
//        }
//    }
}


