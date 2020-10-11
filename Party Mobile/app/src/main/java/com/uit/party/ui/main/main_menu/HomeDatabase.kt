package com.uit.party.ui.main.main_menu


import android.content.Context
import androidx.lifecycle.LiveData
import androidx.room.*
import com.uit.party.model.DishModel


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

    @get:Query("SELECT * FROM dish_table")
    val allDish: LiveData<List<DishModel>>
}

/**
 * TitleDatabase provides a reference to the dao to repositories
 */
@Database(entities = [DishModel::class], version = 1, exportSchema = false)
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
                    "tiki_demo_db"
                )
                .fallbackToDestructiveMigration()
                .build()
        }
    }
    return INSTANCE
}
