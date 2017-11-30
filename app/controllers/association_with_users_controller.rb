class AssociationWithUsersController < ApplicationController
  before_action :set_association_with_user, only: [:show, :update, :destroy]





  # GET /association_with_users
  def index
    @association_with_users = AssociationWithUser.all
    @not_duplicated_associations = []

    @association_with_users.each do |association|
      if @not_duplicated_associations.find {|possible_duplicate| possible_duplicate.user_one_id == association.user_two_id and possible_duplicate.user_two_id == association.user_one_id} == nil
        @not_duplicated_associations.push(association)
      end
    end

    render json: @not_duplicated_associations
  end

  # GET /association_with_users/1
  def show
    render json: @association_with_user
  end

  # POST /association_with_users
  def create
    @association_with_user = AssociationWithUser.new(association_with_user_params)

    if @association_with_user.save
      render json: @association_with_user, status: :created, location: @association_with_user
    else
      render json: @association_with_user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /association_with_users/1
  def update
    if @association_with_user.update(association_with_user_params)
      render json: @association_with_user
    else
      render json: @association_with_user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /association_with_users/1
  def destroy
    @association_with_user.destroy
  end

  def create_associations_from_database
    @all_associations = Association.all

    @all_associations.each do |analysed|
      @all_associations.each do |possible_match|
        if analysed.repository == possible_match.repository
          @new_association_with_user = AssociationWithUser.new
          @new_association_with_user.user_one_id = analysed.user.id
          @new_association_with_user.user_two_id = possible_match.user.id
          @new_association_with_user.save
        end
      end
    end
  end

  def get_next(current_node, list_of_lists, visited_ids, previous_nodes, end_node)

    if current_node == end_node
      return previous_nodes + [current_node]
    end

    visited_ids.push(current_node)

    @possible_next_nodes = list_of_lists.find {|element| element[0] == current_node}
    @possible_next_nodes = @possible_next_nodes[1] - visited_ids

    if @possible_next_nodes.count == 0
      return previous_nodes
    else
      @solutions = []
      @possible_next_nodes.each do |node|
        @solutions.push(get_next(node, list_of_lists, visited_ids, previous_nodes, end_node))
      end

      @solution = @solutions.find {|list| list.last == end_node}

      if @solution == nil
        return previous_nodes
      else
        return previous_nodes + [current_node] + @solution
      end
    end
  end

  def make_list_of_nodes(edges)
    @first_edge = edges.first

    if @first_edge
      @first_node = @first_edge.user_one_id
    else
      return []
    end
    @list_of_nodes = [@first_node]

    edges.each do |edge|
      @list_of_nodes.push(edge.user_two_id)
    end

    return @list_of_nodes
  end

  def shortest_path_between_two_users
    @total_associations = AssociationWithUser.all
    @possible_edges = @total_associations.where(:user_one_id => association_with_user_params["user_one_id"])
    @possible_edges_list = [[]]
    @visited_ids = []

    @possible_edges.each do |edge|
      @possible_edges_list[0].push(edge)
    end

    @visited_ids.push(association_with_user_params["user_one_id"].to_i)

    @layer = 0

    @run = true

    @solution = []

    while @run
      @possible_edges_list[@layer].each do |edge|
        if edge.user_two_id == association_with_user_params["user_two_id"].to_i
          # reached last node
          @run = false

          @last_node_id = edge.user_one_id

          @solution.push(edge)

          @possible_edges_list.reverse.each do |current_layer|
            current_layer.each do |current_edge|
              if current_edge.user_two_id == @last_node_id
                @solution.push(current_edge)
                @last_node_id = current_edge.user_one_id
                break
              end
            end
          end
          break
        end
      end

      if @run
        @possible_edges_list.push([])

        @possible_edges_list[@layer].each do |edge|
          @total_associations.where(:user_one_id => edge.user_two_id).each do |possible_edge|
            @inserts = true
            @possible_edges_list.each do |current_layer|
              if current_layer.include?(possible_edge) || current_layer.find {|possible_inverse| possible_inverse.user_one_id == possible_edge.user_two_id and possible_inverse.user_two_id == possible_edge.user_one_id} != nil
                @inserts = false
              end
            end

            if @inserts
              if !@visited_ids.include?(possible_edge.user_two_id)
              @possible_edges_list[@layer+1].push(possible_edge)
              @visited_ids.push(possible_edge.user_two_id)
              end
            end
          end
        end

        @layer += 1

      end

      if @possible_edges_list[@layer].count == 0
        @run = false
      end
    end

    @shortest_path = make_list_of_nodes(@solution.reverse)

    render json: @shortest_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_association_with_user
      @association_with_user = @total_associations.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def association_with_user_params
      params.require(:association_with_user).permit(:user_one_id, :user_two_id)
    end
end
