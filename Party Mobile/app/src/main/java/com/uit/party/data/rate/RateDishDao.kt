package com.uit.party.data.rate

import androidx.paging.PagingSource
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.uit.party.model.ItemDishRateModel
import com.uit.party.model.RateModel

@Dao
interface RateDishDao {
    /*@Transaction
    @Query("SELECT * FROM ItemDishRateModel")
    fun getDishRating(): LiveData<List<ItemDishRateWithListRates>>*/

    @Query("SELECT * FROM rate_model WHERE id_dish = :dishID ORDER BY update_at DESC")
    fun getSingleDishRating(dishID: String): PagingSource<Int, RateModel>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertItemRating(rateModel: RateModel)

    @Query("DELETE FROM ItemDishRateModel WHERE dishId = :dishID")
    suspend fun clearRateDish(dishID: String)

    @Query("DELETE FROM rate_model WHERE id_dish = :dishID")
    suspend fun clearRateDishList(dishID: String)

    //Rating
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertDishRating(itemDishRateModel: ItemDishRateModel)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertListRating(rateModel: List<RateModel>)

    @Query("SELECT * FROM ItemDishRateModel WHERE dishId = :dishID")
    suspend fun getDishRating(dishID: String): ItemDishRateModel?
}