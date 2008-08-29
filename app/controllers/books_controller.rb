require 'amazon/ecs'
class BooksController < ApplicationController
  before_filter :set_dev_key

  ACCESS_ID = '00D8NKFQ2R8W9EC0J182'
  DEV_KEY = 'abf2540f35f09cc617430071dbeb09c4'

  def search
    if params[:query]
      Amazon::Ecs.options = {:aWS_access_key_id => [ACCESS_ID]}
      res = Amazon::Ecs.item_search(params[:query], :type => 'Title', :response_group => 'Medium,Reviews')
      @debug = { :items => res.items().size, :pages => res.total_pages().size,
        :doc => res.items.first }
      set_book(res.items.first)
    end
    respond_to do |format|
      format.html # search.html.erb
      format.xml  { render :xml => @book }
    end
  end

  def set_book(item)
    @book = { :title => item.get('title'), :author => item.get('author'),
      :asin => item.get('asin'), :pubdate => item.get('publicationdate'),
      :salesrank => item.get('salesrank'), :isbn => item.get('isbn'),
      :reviewpages => item.get('customerreviews/totalreviewpages'),
      :reviewcount => item.get('customerreviews/totalreviews'),
      :reviewrating => item.get('customerreviews/averagerating'),
      :price => item.get('listprice/formattedprice') }
  end

  def show_books
    Amazon::Ecs.options = {:aWS_access_key_id => [ACCESS_ID]}
    res = Amazon::Ecs.item_search(params[:query], :type => 'Title', :response_group => 'Medium,Reviews')
    @books = res.items.collect do |item|
      { :title => item.get('title'), :author => item.get('author'),
        :asin => item.get('asin'), :pubdate => item.get('publicationdate'),
        :salesrank => item.get('salesrank'), :isbn => item.get('isbn'),
        :reviewpages => item.get('customerreviews/totalreviewpages'),
        :reviewcount => item.get('customerreviews/totalreviews'),
        :reviewrating => item.get('customerreviews/averagerating'),
        :price => item.get('listprice/formattedprice') }
    end
    respond_to do |format|
      format.html # show_books.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books
  # GET /books.xml
  def index
    @books = Book.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @books }
    end
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  def add
    p=params[:book]
    @book = Book.new({:title => p[:title], :author => p[:author], :price => p[:price].to_s, :pubdate => p[:pubdate], :asin => p[:asin], :reviews => p[:reviewcount], :rating => p[:reviewrating]})
    if @book.save
      flash[:notice]='Book was successfully added.'
      respond_to do |format|
        format.html { redirect_to(show(@book[:title])) }
        format.xml { render :xml => p.to_xml }
      end
    else
      format.html { render :action => :search, :params => @book }
    end
  end

  # POST /books
  # POST /books.xml
  def create
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        flash[:notice] = 'Book was successfully created.'
        format.html { redirect_to(@book) }
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        flash[:notice] = 'Book was successfully updated.'
        format.html { redirect_to(@book) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to(books_url) }
      format.xml  { head :ok }
    end
  end

  private
  def set_dev_key
     @devkey = DEV_KEY
  end

end
