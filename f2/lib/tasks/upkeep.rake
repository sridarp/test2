namespace :upkeep do
  desc 'Show Date Relationships'
  task corners: :environment do
    current_date = Time.gm(2015, 2, 14, 0, 0, 0)
    puts
    puts '  current_date: ' + current_date.to_s

    class CalTest
      def self.months_run(curr, past)
        (curr.year * 12 + curr.month) - (past.year * 12 + past.month)
      end
    end

    puts
    puts '  [Y,M,D] If date components are the same then 1, Else 0'
    puts

    t = Time.gm(2015, 2, 14, 0, 0, 0)
    puts '  [111] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2015, 1, 14, 0, 0, 0)
    puts '  [101] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2014, 2, 14, 0, 0, 0)
    puts '  [011] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2014, 3, 14, 0, 0, 0)
    puts '  [001] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2015, 2, 13, 0, 0, 0)
    puts '  [110] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2015, 2, 15, 0, 0, 0)
    puts '  [110] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2015, 1, 13, 0, 0, 0)
    puts '  [100] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2015, 1, 15, 0, 0, 0)
    puts '  [100] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2014, 2, 13, 0, 0, 0)
    puts '  [010] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2014, 2, 15, 0, 0, 0)
    puts '  [010] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2014, 3, 13, 0, 0, 0)
    puts '  [000] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2014, 3, 15, 0, 0, 0)
    puts '  [000] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2014, 1, 13, 0, 0, 0)
    puts '  [000] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s

    t = Time.gm(2014, 1, 15, 0, 0, 0)
    puts '  [000] months_run: ' + CalTest.months_run(current_date, t).to_s + ' ' + t.to_s
    puts ''
  end

  desc 'Update Remaining Project Budgets'
  task update_budgets: :environment do
    Project.where(status: 1).each do |project|
      puts '[ project: ' + project.id.to_s + ' | name: ' + project.name.to_s + ' | spent/budget: ' + project.spent.to_s + '/' + project.budget.to_s + ' ]' if verbose == true

      current_date = Time.zone.now

      total_spent = 0

      project.orders.each do |order|
        start_date = order.created_at

        hours_run = ((current_date - start_date) / 60 / 60).ceil

        # TODO: WORK OUT CORRECT LOGIC FOR MONTHS RUN
        months_run = (start_date.year * 12 + current_date.month) - (start_date.year * 12 + start_date.month)

        if verbose == true
          puts '  product_name: ' + Product.find(id: order.product_id).name
          puts '  provision_status: ' + order.provision_status.to_s
          puts '  created_at: ' + start_date.to_s
          puts '  hourly_price: ' + order.hourly_price.to_s
          puts '  hours_run: ' + hours_run.to_s
          puts '  hourly_cost: ' + (hours_run * order.hourly_price).to_s
          puts '  monthly_price: ' + order.monthly_price.to_s
          puts '  months_run: ' + months_run.to_s
          puts '  monthly_cost: ' + (months_run * order.monthly_price).to_s
          puts '  setup_price: ' + order.setup_price.to_s
          puts '  total_cost: ' + (order.setup_price + (months_run * order.monthly_price) + (hours_run * order.hourly_price)).to_s
          puts '------------------------------'
        end

        total_spent += order.setup_price + (months_run * order.monthly_price) + (hours_run * order.hourly_price)
      end

      # puts ''
      puts '  project_spent: ' + total_spent.to_s if verbose == true

      project.spent = total_spent

      project.save
    end
  end

  desc 'Removes alerts older than 1 year.'
  task prune_alerts: :environment do
    Alert.destroy_all(['created_at < ?', 365.days.ago])
  end

  desc 'Show all alerts'
  task show_all_alerts: :environment do
    alerts = Alert.all.order('created_at ASC')
    alerts.each do |alert|
      Alert.new.attributes.keys.each { |attr| puts alert.to_s + ' ' + attr + ': ' + alert[attr].to_s }
      puts "\n"
    end
  end

  desc 'Show active alerts'
  task show_active_alerts: :environment do
    @alerts = Alert.where('(start_date IS NULL OR start_date <= ?) AND (end_date IS NULL OR end_date > ?)', Time.zone.now, Time.zone.now).order('created_at ASC')
    alerts.each do |alert|
      Alert.new.attributes.keys.each { |attr| puts alert.to_s + ' ' + attr + ': ' + alert[attr].to_s }
      puts "\n"
    end
  end

  desc 'Show inactive alerts'
  task show_inactive_alerts: :environment do
    @alerts = Alert.where('end_date < ? OR start_date > ?', Time.zone.now, Time.zone.now).order('created_at ASC')
    alerts.each do |alert|
      Alert.new.attributes.keys.each { |attr| puts alert.to_s + ' ' + attr + ': ' + alert[attr].to_s }
      puts "\n"
    end
  end

  desc 'Gets On Demand AWS pricing'
  task get_aws_od_pricing: :environment do
    # SPECIFY PATHS
    paths = []
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/linux-od.min.js') # On-demand Linux
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/rhel-od.min.js') # On-demand RedHat
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/sles-od.min.js') # On-demand SUSE
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/mswin-od.min.js') # On-demand Windows
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/mswinSQL-od.min.js') # On-demand SQL Standrad
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/mswinSQLWeb-od.min.js') # On-demand SQL Web
    # BUILD PRICING INFO FROM PATH RESPONSE
    aws_pricing_info = []
    paths.each do |path|
      url = URI.parse(path)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      # CONVERT JSONP TO JSON
      jsonp = res.body
      jsonp.gsub!(/^.*callback\(/, '') # removes the comment and callback function from the start of the string
      jsonp.gsub!(/\);$/, '') # removes the end of the callback function
      jsonp.gsub!(/(\w+):/, '"\1":') # puts all key values in quotes
      aws_data = JSON.parse(jsonp)
      aws_regions = aws_data['config']['regions']
      aws_regions.each do |aws_region|
        aws_instance_types = aws_region['instanceTypes']
        aws_instance_types.each do |aws_instance_type|
          aws_sizes = aws_instance_type['sizes']
          aws_sizes.each do |aws_size|
            aws_value_columns = aws_size['valueColumns']
            aws_value_columns.each do |aws_value|
              aws_prices = aws_value['prices']
              aws_prices.each do |currency, price|
                pricing_info = {}
                pricing_info['region'] = aws_region['region']
                pricing_info['type'] = aws_instance_type['type']
                pricing_info['size'] = aws_size['size']
                pricing_info['name'] = aws_value['name']
                pricing_info['hourly'] = price
                pricing_info['currency'] = currency
                aws_pricing_info.append(pricing_info)
              end
            end
          end
        end
      end
    end
    puts aws_pricing_info
  end

  desc 'Gets Reserved AWS pricing'
  task get_aws_reserved_pricing: :environment do
    # SPECIFY PATHS
    paths = []
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/ri-v2/linux-unix-shared.min.js') # Reserved Linux
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/ri-v2/red-hat-enterprise-linux-shared.min.js') # Reserved RedHat
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/ri-v2/suse-linux-shared.min.js') # Reserved SUSE
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/ri-v2/windows-shared.min.js') # Reserved Windows
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/ri-v2/windows-with-sql-server-standard-shared.min.js') # Reserved SQL Standard
    paths.append('http://a0.awsstatic.com/pricing/1/ec2/ri-v2/windows-with-sql-server-web-shared.min.js') # Reserved SQL Web
    # BUILD PRICING INFO FROM PATH RESPONSE
    aws_pricing_info = []
    paths.each do |path|
      url = URI.parse(path)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      # SPECIFY PATH TYPE (OS)
      path_type = 'tbd'
      case path
      when 'http://a0.awsstatic.com/pricing/1/ec2/ri-v2/linux-unix-shared.min.js'
        path_type = 'linux'
      when 'http://a0.awsstatic.com/pricing/1/ec2/ri-v2/red-hat-enterprise-linux-shared.min.js'
        path_type = 'rhel'
      when 'http://a0.awsstatic.com/pricing/1/ec2/ri-v2/suse-linux-shared.min.js'
        path_type = 'sles'
      when 'http://a0.awsstatic.com/pricing/1/ec2/ri-v2/windows-shared.min.js'
        path_type = 'mswin'
      when 'http://a0.awsstatic.com/pricing/1/ec2/ri-v2/windows-with-sql-server-standard-shared.min.js'
        path_type = 'mswinSQL'
      when 'http://a0.awsstatic.com/pricing/1/ec2/ri-v2/windows-with-sql-server-web-shared.min.js'
        path_type = 'mswinSQLWeb'
      end
      # CONVERT JSONP TO JSON
      jsonp = res.body
      jsonp.gsub!(/^.*callback\(/, '') # removes the comment and callback function from the start of the string
      jsonp.gsub!(/\);$/, '') # removes the end of the callback function
      jsonp.gsub!(/(\w+):/, '"\1":') # puts all key values in quotes
      aws_data = JSON.parse(jsonp)
      # PROCESS EACH REGION
      aws_regions = aws_data['config']['regions']
      aws_regions.each do |aws_region|
        aws_instance_types = aws_region['instanceTypes']
        aws_instance_types.each do |aws_instance_type|
          aws_terms = aws_instance_type['terms']
          aws_terms.each do |aws_term|
            # SPECIFY ON DEMAND PRICE
            on_demand_hourly = aws_term['onDemandHourly']
            on_demand_hourly[0]['prices'].each do |currency, price|
              pricing_info = {}
              pricing_info['region'] = aws_region['region']
              pricing_info['type'] = 'tbd' # DEFINE FROM SOURCE FILE PATH
              pricing_info['name'] = aws_instance_type['type']
              pricing_info['term'] = 'onDemandHourly'
              pricing_info['option'] = 'onDemandHourly'
              pricing_info['hourly'] = price
              pricing_info['upfront'] = '0.00'
              pricing_info['monthly'] = 'N/A'
              pricing_info['currency'] = currency
              # aws_pricing_info.append(pricing_info) # SHOULD COME FROM ON DEMAND PRICING TASK
            end
            # SPECIFY TERM PRICES
            purchase_options = aws_term['purchaseOptions']
            purchase_options.each do |purchase_option|
              pricing_info = {}
              pricing_info['region'] = aws_region['region']
              pricing_info['type'] = path_type # DEFINED FROM SOURCE FILE PATH ABOVE
              pricing_info['name'] = aws_instance_type['type']
              pricing_info['term'] = aws_term['term']
              pricing_info['option'] = purchase_option['purchaseOption']
              value_columns = purchase_option['valueColumns']
              value_columns.each do |value|
                value['prices'].each do |currency, price|
                  # ONLY REMEMVER CURRENCY IF IT'S NOT N/A OR USD
                  pricing_info['currency'] = currency if currency != 'N/A'
                  case value['name']
                  when 'upfront'
                    pricing_info['upfront'] = price
                  when 'monthlyStar'
                    pricing_info['monthly'] = price
                  when 'effectiveHourly'
                    pricing_info['hourly'] = price
                  end
                end
              end
              aws_pricing_info.append(pricing_info)
            end
          end
        end
      end
    end
    puts aws_pricing_info
  end
end
