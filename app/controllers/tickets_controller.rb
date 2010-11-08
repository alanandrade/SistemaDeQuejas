class TicketsController < ApplicationController
  # GET /tickets
  # GET /tickets.xml
  def index
    @pending_tickets  = Ticket.order('created_at DESC').pending
    @active_tickets   = Ticket.order('created_at DESC').active
    @finished_tickets = Ticket.order('created_at DESC').finished

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tickets }
      format.pdf  do
        @tickets_to_report = Ticket.find(cookies['tickets_to_report'].split(' '))
        send_data Ticket.to_pdf(@tickets_to_report)
      end
    end
  end

  # GET /tickets/1
  # GET /tickets/1.xml
  def show
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket }
      format.pdf  { send_data  Ticket.to_pdf(@ticket) }
    end
  end

  # GET /tickets/new
  # GET /tickets/new.xml
  def new
    @ticket = Ticket.new
    params.each_pair{|key, attr| @ticket.send("#{key}=", attr) if @ticket.respond_to?(key) }
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  # GET /tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
  end

  # POST /tickets
  # POST /tickets.xml
  def create
    @ticket = Ticket.new(params[:ticket])

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to(@ticket, :notice => 'Ticket was successfully created.') }
        format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.xml
  def update
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        format.html { redirect_to(@ticket, :notice => 'Ticket was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.xml
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
      format.xml  { head :ok }
    end
  end
  
  ## GET /tickets/1/assign_responsible
  def assign_responsible
    @ticket = Ticket.find(params[:id])
  end
    
end
