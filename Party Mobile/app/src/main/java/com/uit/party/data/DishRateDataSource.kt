package com.uit.party.data

import androidx.paging.*
import com.uit.party.data.home.HomeRepository
import com.uit.party.model.RateModel
import com.uit.party.util.ServiceRetrofit
import retrofit2.HttpException
import java.io.IOException
import java.io.InvalidObjectException

private const val GITHUB_STARTING_PAGE_INDEX = 1
@OptIn(ExperimentalPagingApi::class)
class DishRateDataSource(private val service: ServiceRetrofit, private val dishId: String):
    PagingSource<Int, RateModel>() {
    override suspend fun load(params: LoadParams<Int>): LoadResult<Int, RateModel> {
        val position = params.key ?: GITHUB_STARTING_PAGE_INDEX
        return try {
            val response = service.getDishRates(dishId, position)
            val repos = response.itemDishRateModel ?: throw InvalidObjectException("Return data null")
            LoadResult.Page(
                data = repos.listRatings,
                prevKey = if (position == GITHUB_STARTING_PAGE_INDEX) null else position - 1,
                nextKey = if (repos.listRatings.isEmpty()) null else position + 1
            )
        } catch (exception: IOException) {
            return LoadResult.Error(exception)
        } catch (exception: HttpException) {
            return LoadResult.Error(exception)
        }
    }

}