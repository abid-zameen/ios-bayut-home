//
//  PopularSearchWorker.swift
//  Home
//
//  Created by Hammad Shahid on 27/04/2026.
//

import Foundation
import NetworkLayer

protocol PopularSearchWorkerLogic: AnyObject {
    func fetchPopularSectionMetadata(locationQuery: String) async throws -> PopularSectionResponse
}

final class PopularSearchWorker: PopularSearchWorkerLogic {
    private let networking: Networking
    private let dldBaseUrl: String
    
    init(networking: Networking, dldBaseUrl: String) {
        self.networking = networking
        self.dldBaseUrl = dldBaseUrl
    }
    
    func fetchPopularSectionMetadata(locationQuery: String) async throws -> PopularSectionResponse {
        let requestBody = """
{}
{"size": 0,"query": {"query_string": { "query": "purpose_id:1 AND \(locationQuery) AND property_type_category_id:(1 OR 2) AND num_bedrooms:total AND num_bathrooms:total AND furnishing_status_id:total AND advanced_filter_id:total AND rent_is_paid_frequency_id:total AND property_completion_status_id:total" }},"aggs": {"group": {"terms": { "field": "property_type_id", "size": 30},"aggs": {"sum": { "sum": { "field": "count_live_listings_last_1_day"}},"sort_by_count": {"bucket_sort": { "sort": [ { "sum": { "order": "desc" }}], "size": 4}}}}}, "_source": false, "track_total_hits": false}
{}
{"size": 0,"query": {"query_string": { "query": "purpose_id:2 AND \(locationQuery) AND property_type_category_id:(1 OR 2) AND num_bedrooms:total AND num_bathrooms:total AND furnishing_status_id:total AND advanced_filter_id:total AND rent_is_paid_frequency_id:total AND property_completion_status_id:total" }},"aggs": {"group": {"terms": { "field": "property_type_id", "size": 30},"aggs": {"sum": { "sum": { "field": "count_live_listings_last_1_day"}},"sort_by_count": {"bucket_sort": { "sort": [ { "sum": { "order": "desc" }}], "size": 4}}}}}, "_source": false, "track_total_hits": false}
{}
{"size": 0,"query": {"query_string": { "query": "purpose_id:1 AND \(locationQuery) AND property_type_category_id:(1 OR 2) AND num_bedrooms:total AND num_bathrooms:total AND furnishing_status_id:total AND advanced_filter_id:total AND rent_is_paid_frequency_id:total AND property_completion_status_id:off_plan" }},"aggs": {"group": {"terms": { "field": "property_type_id", "size": 30},"aggs": {"sum": { "sum": { "field": "count_live_listings_last_1_day"}},"sort_by_count": {"bucket_sort": { "sort": [ { "sum": { "order": "desc" }}], "size": 4}}}}}, "_source": false, "track_total_hits": false}

"""
        let url = "\(dldBaseUrl)property_filters_metadata_prod_alias/_msearch"
        
        let request = APIRequestBuilder.create(
            path: "",
            type: .post,
            encoding: .raw,
            headers: [
                "Content-Type": "application/x-ndjson",
                "Accept": "application/json",
                "Authorization": "Basic YmF5dXRfcmVhZF9hcHBfZXMyOjEjLjVjLTFcditKWlFFeiw="
            ],
            cache: .none,
            shouldHandleCookies: true,
            fullURL: url,
            requestBody: requestBody
        )
        
        return try await networking.execute(request: request)
    }
}
