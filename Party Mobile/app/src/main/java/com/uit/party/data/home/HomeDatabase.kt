package com.uit.party.data.home


import android.content.Context
import androidx.lifecycle.LiveData
import androidx.room.*
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

    @Query("DELETE FROM dish_table")
    suspend fun deleteMenu()

    @Update(entity = DishModel::class)
    suspend fun updateDish(dishModel: DishModel)

    @get:Query("SELECT * FROM dish_table")
    val allDish: LiveData<List<DishModel>>

    @Query("UPDATE dish_table SET quantity=:quantity WHERE id = :id")
    suspend fun updateCart(quantity: Int, id: String)

    @Query("UPDATE dish_table SET quantity=0 WHERE id = :id")
    suspend fun deleteCart(id: String)

    @get:Query("SELECT * FROM dish_table WHERE quantity > 0")
    val getCart: LiveData<List<DishModel>>
}

/**
 * TitleDatabase provides a reference to the dao to repositories
 */
@TypeConverters(ImageConverter::class)
@Database(entities = [DishModel::class], version = 2, exportSchema = false)
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
