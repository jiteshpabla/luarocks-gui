<!DOCTYPE html>
<head>
  <title>LuaRocks GUI</title>
  <!-- styles -->
  <link rel="stylesheet" href="bulma.min.css">
  <link rel="stylesheet" href="main.css">
  <link rel="stylesheet" href="list.css">
  <script src="https://cdn.jsdelivr.net/npm/vue@2.5.16/dist/vue.js"></script>
  <!-- styles end -->
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
          <a class="navbar-item is-active">List rocks</a>
          <a class="navbar-item" href="search.lp">Search rocks</a>
          <a class="navbar-item" href="advanced.lp">Advanced</a>
        </div>
        <div class="navbar-end">
          <a class="navbar-item" href="about.lp">About</a>
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
            <h3 class="title is-3">Installed Rocks:</h3>
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

          <div class="box">
            <form action="list.lp" id="query_form" method="post">
              <div class="columns is-multiline">

                <div class="field is-vcentered columns column is-4">
                  <div class="field-label column is-6">
                    <label class="label">Select Rock tree:</label>
                  </div>
                  <div class="field-body column is-6">
                    <div class="field is-narrow">
                      <div class="control">
                        <div class="select">
                          <select name="rock_tree">
                            <option>All</option>

                            <?lua
                            local lr = require "luarocks"

                            list_of_rock_trees = lr.list_rock_trees()

                            for i, tree in ipairs(list_of_rock_trees) do
                            ?>

                            <option value="<?lua= tree['root'] ?>"> <?lua print(tree["name"]) ?> </option>

                            <?lua
                            end
                            ?>

                          </select>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- search bar -->
                <div class="search-bar column is-8">

                    <div class="field has-addons">
                      <div class="control is-expanded">
                        <input class="input has-text-centered" type="search" placeholder="rock name to search" name="query">
                      </div>
                      <div class="control">
                        <button class="button" id="search" type="submit" name="search" value="submit" >search</button>
                      </div>
                    </div>
                </div>
                <!-- search bar end -->

                <div class="column is-12 has-text-centered">
                  <h5 class="title is-5"> Current Rock tree: <?lua print(cgilua.POST.rock_tree) ?> </h5>
                </div>

              </div>
            </form>
          </div>


          <?lua

          os.execute("touch list.lp")

          local list_of_rocks = nil
          local query = nil
          local rock_tree = nil

          -- Initialise query and rock_tree to filter the results based on on the values given in the form (id = query_form).
          if cgilua.POST.query then
            query = cgilua.POST.query
          end
          if cgilua.POST.rock_tree ~= "All" then
            rock_tree = cgilua.POST.rock_tree
          else
            rock_tree = nil
          end

          list_of_rocks = lr.list(query, nil, nil, rock_tree)

          local count_of_rocks = 0
          for rock_name, data_table in pairs(list_of_rocks) do
            for rock_version, location_table in pairs(data_table) do
              for _, location in pairs(location_table) do
                local rock_location = location.repo

                local lib_start, lib_end = string.find(rock_location , "lib")
                local rock_tree = string.sub(rock_location, 1, lib_start-1)

                local show = lr.show(rock_name, rock_version, rock_tree)
                local doc_dir, doc_file = lr.doc(rock_name, rock_version, rock_tree)
                local homepage = lr.homepage(rock_name, rock_version, rock_tree)
                count_of_rocks = count_of_rocks + 1
          ?>

            <!-- list item -->
            <div class="box" id="box<?lua= count_of_rocks ?>">
              <!-- box header -->
              <div class="box-header columns is-multiline">
                <div class="column is-2">
                  <h4 class="title is-4"> <?lua print(rock_name) ?> </h4>
                </div>
                <div class="column is-10">
                  <small> <?lua print(rock_version) ?> </small>
                </div>
                <div class="column is-10">
                  <small> <?lua print(rock_location) ?> </small>
                </div>
                <br>
                <small> <?lua if show["summary"] then print(show["summary"]) end ?> </small>
              </div>
              <!-- box header end -->
              <!-- box content -->
              <div class="box-content">
                <div class="has-text columns">
                  <div class="column is-1">
                    <a class="button" id="details" v-on:click="is_active = !is_active">Details</a>
                  </div>
                  <div class="column is-8">
                    <form action="open_doc_dir.lp" method="post">
                      <input style="display:none;" name="doc_file" id="doc_file" value="<?lua= doc_file ?>">
                      <button class="button" id="doc_dir" type="submit" name="doc_dir" value="<?lua= doc_dir ?>" >Documentation</button>
                    </form>
                  </div>
                  <div class="column is-2">
                    <form action="remove.lp" method="post">
                      <input style="display:none;" name="version" id="version" value="<?lua= rock_version ?>">
                      <input style="display:none;" name="rock_tree" id="rock_tree" value="<?lua= rock_location ?>">
                      <input style="display:none;" name="force_fast" id="force_fast" value="no">
                      <button class="button" id="remove" type="submit" name="rock_name" value="<?lua= rock_name ?>" >Remove</button>
                    </form>
                  </div>

                </div>
                <div class="box-content-text" v-show="is_active">
                  <p> <?lua if show["detailed"] then print(show["detailed"]) end ?> </p>
                  <a href="<?lua print(homepage) ?>" target="_blank"> <?lua print(homepage) ?> </a>
                </div>
              </div>
              <!-- box content end -->
            </div>
            <!-- list item end -->

          <?lua
              end
            end
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
    <small>
    <div class="container">
      <div class="has-text-centered">
        <a href="https://luarocks.org">LuaRocks</a>
      </div>
      <div class="has-text-centered">
        <a href="https://github.com/jiteshpabla/luarocks-gui">Source</a>
        &#9679;
        <a href="https://github.com/jiteshpabla/luarocks-gui/issues">Issues</a>
        &#9679;
        <a href="https://gitter.im/luarocks/luarocks">Gitter-chat</a>
      </div>
    </div>
    </small>
  </div>
  <!-- footer end -->
</body>

<script>
// loop to initialize a new Vue instance for every rock in the list
for (x = 1; x-1 <= <?lua= count_of_rocks ?> ; x++) {
  new Vue({
  el: '#box'+x,
  data: {
      is_active: false
  }
});
}
</script>