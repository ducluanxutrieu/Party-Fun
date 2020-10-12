package com.uit.party.data.home


import android.content.Context
import androidx.lifecycle.LiveData
import androidx.room.*
import com.uit.party.model.CartModel
import com.uit.party.model.DishModel
import com.uit.party.model.ImageConverter


/***
 * Very small database that will hold one title
 */
@Dao
interface HomeDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertDish(dish: DishModel)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAllDish(list: ArrayList<DishModel>)

    @Query("DELETE FROM dish_table WHERE id = :id")
    fun deleteDish(id: String)

    @Query("DELETE FROM dish_table")
    suspend fun deleteMenu()

    @Update(entity = DishModel::class)
    suspend fun updateDish(dishModel: DishModel)

    @get:Query("SELECT * FROM dish_table")
    val allDish: LiveData<List<DishModel>>

    //cart

    @Query("SELECT * FROM cart_table WHERE id = :id")
    suspend fun getCartItem(id: String): List<CartModel>

    @Query("UPDATE cart_table SET quantity=:quantity WHERE id = :id")
    suspend fun updateQuantityCart(quantity: Int, id: String)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCart(cartModel: CartModel)

    @Delete
    suspend fun deleteCart(cartModel: CartModel)

    @get:Query("SELECT * FROM cart_table WHERE quantity > 0")
    val getCart: LiveData<List<CartModel>>
}

/**
 * TitleDatabase provides a reference to the dao to repositories
 */
@TypeConverters(ImageConverter::class)
@Database(entities = [DishModel::class, CartModel::class], version = 1, exportSchema = false)
abstract class PartyBookingDatabase : RoomDatabase() {
    abstract val homeDao: HomeDao
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
