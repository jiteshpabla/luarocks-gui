<!DOCTYPE html>
<head>
  <title>LuaRocks GUI</title>
  <!-- styles and fonts -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.1/css/bulma.css">
  <link href="https://fonts.googleapis.com/css?family=Fira+Sans" rel="stylesheet">
  <link rel="stylesheet" href="list.css">
  <!-- styles and fonts end -->
</head>

<body>
  <!-- navbar -->
  <nav class="navbar">
    <div class="container">
      <div class="navbar-brand">
        <a class="navbar-item" href="index.lp"><img src="luarocks_logo_only.png"><strong>LuaRocks</strong></a>
      </div>
      <div id="navbarMenu" class="navbar-menu">
        <div class="navbar">
          <a class="navbar-item" href="list.lp">List rocks</a>
          <a class="navbar-item is-active">Search rocks</a>
          <a class="navbar-item" href="advanced.lp">Advanced</a>
        </div>
        <div class="navbar-end">
          <a class="navbar-item" href="about.lp">About</a>
          <a class="navbar-item" href="help.lp">Help</a>
        </div>
      </div>
    </div>
  </nav>
  <!-- navbar end -->

  <!-- page header -->
  <div class="main-header">
    <section class="hero">
      <div class="hero-body">
        <div class="container">
          <div class="has-text-left">
            <h3 class="title is-3">Search Rocks:</h3>
          </div>
        </div>
      </div>
    </section>
  </div>

  <!-- page header end -->

  <!-- main page content -->
  <div class="main-content">
    <div class="container">
      <div class="columns is-multiline">
        <div class="column is-12">

          <!-- search bar -->
          <div class="search-bar box column is-12">
            <form action="search.lp" method="post">
              <div class="field has-addons">
                <div class="control is-expanded">
                  <input class="input has-text-centered" type="search" placeholder="rock name to search" name="query">
                </div>
                <div class="control">
                  <button class="button" id="search" type="submit" name="search" value="submit" >search</button>
                </div>
              </div>
            </form>
          </div>
          <!-- search bar end -->

          <?lua
          local lr = require("luarocks")

          
          if cgilua.POST.query then
            sc = lr.search(cgilua.POST.query)
          else
            sc = lr.search("test rock")
          end

          for item, item_versions in pairs(sc.sources) do
          ?>

          <!-- list item -->
          <div class="box" id="vue-app">
            <!-- box header -->
            <div class="box-header columns">
              <div class="column is-2">
                <h4 class="title is-4"><?lua print(item) ?></h4>
              </div>
              <div class="column is-2">
                <a class="button" id="view_on" target="_blank" href="https://luarocks.org/search?q=<?lua= item ?>">View on luaRocks.org</a>
              </div>
            </div>
            <!-- box header end -->
            <!-- box content -->
            <div class="box-content">
                <!-- version select form -->
                <form action="install.lp" method="post">
                  <div class="has-text form">
                  
                    <div class="field is-horizontal">
                      <div class="field-label">
                        <label class="label">Select version:</label>
                      </div>
                      <div class="field-body">
                        <div class="field is-narrow">
                          <div class="control">
                            <div class="select">
                              <select name="version">
                                <option>Select</option>

                                <?lua
                                for version,_ in pairs(item_versions) do
                                ?>
                                
                                <option> <?lua print(version) ?> </option>

                                <?lua
                                end
                                ?>

                              </select>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div class="field is-horizontal">
                      <div class="field-label">
                        <!-- Left empty for spacing -->
                      </div>
                      <div class="field-body">
                        <div class="field">
                          <div class="control">
                            <button class="button" id="install" type="submit" name="rock_name" value="<?lua= item ?>" >Install</button>
                          </div>
                        </div>
                      </div>
                    </div>

                    
      
                  </div>
                </form>
                <!-- version select form end -->
            </div>
            <!-- box content end -->
          </div>
          <!-- list item end -->

          <?lua
          end
          ?>

        </div>

      </div>
    </div>
  </div>
  </div>
  <!-- main page content end -->

  <!-- footer -->
  <div class="footer">
    <div class="container">
      <div class="has-text-centered">
        <p>do we even need a footer?</p>
        <a href="https://luarocks.org">LuaRocks website</a>
      </div>
    </div>
  </div>
  <!-- footer end -->
</body>