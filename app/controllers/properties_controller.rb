class PropertiesController < ApplicationController
  before_action :check_search_params

  # GET /properties
  def index
    @properties = Property.filter(property_filter_params).filter_by_location(location_filter_params)

    if @properties.empty?
      raise ActiveRecord::RecordNotFound.new("No Data")
    else
      render json: @properties
    end
  end

  private
    # location params is mandatory in filter
    def location_filter_params
      params.slice(:lat, :lng)
    end

    # other property attributes is optional
    def property_filter_params
      params.slice(:property_type, :marketing_type, :offer_type)
    end

    # This function to validate search params
    # location params as mandatory params
    # type params as optional params
    def check_search_params
      filters = [Validate::FilterLocation.new(params), Validate::FilterType.new(params)]
      errors = {}
      filters.each do |filter|
        unless filter.valid?
          errors[filter.class] = filter.errors
        end
      end

      unless errors.blank?
        render json: { errors: errors }, status: :unprocessable_entity
      end
    end
end
