package com.uit.party.data


import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.uit.party.data.cart.CartDao
import com.uit.party.data.home.HomeDao
import com.uit.party.model.*


/**
 * TitleDatabase provides a reference to the dao to repositories
 */
@TypeConverters(ImageConverter::class)
@Database(entities = [DishModel::class, CartModel::class, RateModel::class, ItemDishRateModel::class], version = 3, exportSchema = false)
abstract class PartyBookingDatabase : RoomDatabase() {
    abstract val homeDao: HomeDao
    abstract val rateDao: RateDishDao
    abstract val cartDao: CartDao
}

private lateinit var INSTANCE: PartyBookingDatabase

/**
 * Instantiate a database from a context.
 */
fun getDatabase(context: Context): PartyBookingDatabase {
    synchronized(PartyBookingDatabase::class) {
        if (!::INSTANCE.isInitialized) {
            INSTANCE = Room
                .databaseBuilder(
                    context.applicationContext,
                    PartyBookingDatabase::class.java,
                    "party_booking_db"
                )
                .fallbackToDestructiveMigration()
                .build()
        }
    }
    return INSTANCE
}
