class Api::ServersController < ApplicationController

    def create
        @server = Server.new(server_params)
        if @server.save
            ServerUser.create!(user_id: current_user.id, server_id: @server.id)
            @active_channels = {}
            @active_channels[@server.id] = @server.channels.first.id
            render :show
        else
            render json: @server.errors.full_messages, status: 422
        end
    end

    def show
        @server = Server.find_by(id: params[:id])
        if @server
            render :show
        else
            render json: ["Cannot find server"], status: 404
        end
    end

    def update 
        @server = Server.find_by(id: params[:server][:id])
        if @server.update(name: params[:server][:name])
            
            if !params[:server][:profile_pic].nil?
                @server.profile_pic.purge
                @server.profile_pic.attach(params[:server][:profile_pic])
            end
            @active_channels = {}
            @active_channels[@server.id] = @server.channels.first.id
            @messages = []
            @server.channels.each do |channel|
                if channel.messages.exists?
                    @messages += channel.messages
                end
            end
            render :show
        else
            render json: ["nwame can't be bwank !!"], status: 422
        end
    end

    def index
        @servers = current_user.servers.includes(:members, :memberships, :channels)
        @members = []
        @serverusers = []
        @channels = []
        @messages = []
        @active_channels = {}
        @servers.each do |server|
            @active_channels[server.id] = server.channels.first.id if server.channels.first
            @members += server.members
            @serverusers += server.memberships
            @channels += server.channels
        end

        @channels.each do |channel|
            if channel.messages.exists?
                @messages += channel.messages
            end
        end

        render :index
    end

    def destroy
        @server = current_user.owned_servers.find_by(id: params[:id])
        @server_membership = @server.memberships.find_by(user_id: current_user.id)
        if @server.destroy
           @active_channels = 0
            render :destroy
        else
            render json: ["Cannot destroy server"], status: 422
        end
    end

    def join
        @server = Server.find_by(invite: params[:invite]) 
        if @server
            ServerUser.create!(user_id: current_user.id, server_id: @server.id)
            @active_channels = {}
            @active_channels[@server.id] = @server.channels.first.id
            @messages = []
            @server.channels.each do |channel|
                if channel.messages.exists?
                    @messages += channel.messages
                end
            end
            render :show
        else
            
            render json: ["Cannot find server"], status: 404
        end

    end

    def leave 
        @server = current_user.servers.find_by(id: params[:serverId])
        if @server && @server.owner_id != current_user.id
            @server_membership = @server.memberships.find_by(user_id: current_user.id)
            @active_channels = {}
            @active_channels = @server.channels.first.id
            @server.members.delete(current_user)
            render :destroy
        else
            render json: ['Unable to leave server, please remove server instead!'], status: 400
        end
    end

    def server_params
        params.require(:server).permit(:name, :owner_id, :private, :profile_pic)
    end
end
