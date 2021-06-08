class ScoreboardController < ApplicationController

  def index

    limit = 10

    @users_total_correct =
      User.all.joins(:user_taxon_data)
          .select("users.username, (sum(user_taxon_data.sci_correct) + sum(user_taxon_data.common_correct)) as score")
          .order("score": :desc).group("users.id")
          .each_with_index
          .map { |res, i| { username: res['username'], rank: i + 1, score: res['score'] } }
          .filter { |rank| rank[:score] > 0 }

    @users_sci_acc =
      User.all.joins(:user_taxon_data)
          .select("users.username, IF(sum(user_taxon_data.sci_seen) > 50, sum(user_taxon_data.sci_correct)/sum(user_taxon_data.sci_seen), 0) as score")
          .order("score": :desc).group("users.id")
          .each_with_index
          .map { |res, i| { username: res['username'], rank: i + 1, score: res['score'] } }
          .filter { |rank| rank[:score] > 0 }

    @users_com_acc =
      User.all.joins(:user_taxon_data)
          .select("users.username, IF(sum(user_taxon_data.common_seen) > 50, sum(user_taxon_data.common_correct)/sum(user_taxon_data.common_seen), 0) as score")
          .order("score": :desc).group("users.id")
          .each_with_index
          .map { |res, i| { username: res['username'], rank: i + 1, score: res['score'] } }
          .filter { |rank| rank[:score] > 0 }

    @users_reports = User.all.select("users.username,
                    (SELECT count(bad_id_reports.id) from bad_id_reports where bad_id_reports.approved = true and bad_id_reports.user_id = users.id) +
                    (SELECT count(bad_region_reports.id) from bad_region_reports where bad_region_reports.approved = true and bad_region_reports.user_id = users.id) +
                    (SELECT count(dead_herp_reports.id) from dead_herp_reports where dead_herp_reports.approved = true and dead_herp_reports.user_id = users.id) +
                    (SELECT count(no_herp_reports.id) from no_herp_reports where no_herp_reports.approved = true and no_herp_reports.user_id = users.id) +
                    (SELECT count(venom_reports.id) from venom_reports where venom_reports.approved = true and venom_reports.user_id = users.id) as score")
                         .where("users.username != ''")
                         .order("score": :desc).group("users.id")
                         .each_with_index
                         .map { |res, i| { username: res['username'], rank: i + 1, score: res['score'] } }
                         .filter { |rank| rank[:score] > 0 }
  end
end