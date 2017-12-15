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

  def associations_except_victorcmoura_and_RochaCarla
    @victorcmoura_associations = AssociationWithUser.where(:user_one => User.find_by_name("victorcmoura")) + AssociationWithUser.where(:user_two => User.find_by_name("victorcmoura"))
    @rochacarla_associations = AssociationWithUser.where(:user_one => User.find_by_name("RochaCarla")) + AssociationWithUser.where(:user_two => User.find_by_name("RochaCarla"))
    @association_with_users = AssociationWithUser.all - (@victorcmoura_associations + @rochacarla_associations)
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

          @new_association_with_user = AssociationWithUser.new
          @new_association_with_user.user_two_id = analysed.user.id
          @new_association_with_user.user_one_id = possible_match.user.id
          @new_association_with_user.save
        end
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

  def dijkstra
    AssociationWithUser.update_all(cost: 1)
    @paths = AssociationWithUser.all
    @visited_ids = []
    @visited_paths = []
    @possible_paths = []

    @start = association_with_user_params["user_one_id"].to_i
    @end = association_with_user_params["user_two_id"].to_i

    @current_node_id = @start

    while @current_node_id != @end

      @possible_paths = @possible_paths + @paths.where(:user_one_id => @current_node_id) - @visited_paths - @paths.where(:user_two_id => @visited_ids)
      @possible_paths = @possible_paths.sort_by {|path| path[:cost]}

      @selected_path = nil

      if @possible_paths.count != 0
        @selected_path = @possible_paths.first
      end

      if @selected_path != nil

        @visited_paths.push(@selected_path)
        @visited_ids.push(@selected_path.user_two_id)

        @paths.where(:user_one_id => @selected_path.user_two_id).update_all(cost: @selected_path.cost + 1)
        @paths = AssociationWithUser.all

        @current_node_id = @selected_path.user_two_id
      end
    end

    @solution = []

    @current_node_id = @selected_path.user_two_id

    puts "=" *80
    @visited_paths.each do |s|
      puts ".."
      puts s.user_one_id
      puts s.user_two_id
    end
    puts "=" *80

    @solution.push(@visited_paths.pop())

    while true
      @insert = @visited_paths.pop()

      if(@insert == nil)
        break
      end

      if @insert.user_two_id == @solution.last.user_one_id
        @solution.push(@insert)
        if @insert.user_one_id == @start
          break
        end
      end
    end

      @solution = make_list_of_nodes(@solution.reverse)

      render json: @solution


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
