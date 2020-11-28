package com.uit.party.data.rate

import androidx.paging.PagingSource
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.uit.party.model.DishRateRemoteKeys
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

    @Query("DELETE FROM rate_model WHERE id_dish = :dishID")
    suspend fun clearRateDishList(dishID: String)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertListRating(rateModel: List<RateModel>)

    //RatingRemoteKeys
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAllDishRatingRemoteKeys(remoteKeys: List<DishRateRemoteKeys>)

    @Query("SELECT * FROM DishRateRemoteKeys WHERE commentID = :commentID")
    suspend fun remoteKeysCommentId(commentID: String): DishRateRemoteKeys?

    @Query("DELETE FROM DishRateRemoteKeys")
    suspend fun clearRateDishRemoteKeys()
}