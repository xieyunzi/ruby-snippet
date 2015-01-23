# 获取目录列表
# 更新 git repository

wd = '/Users/xieyunzi/code/kaopubao-dev-box/own/*'

dirs = Dir.glob(wd)

dirs.each do |current_work_dir|
  git_status = `git -C #{current_work_dir} status -s -b`.split("\n")

  puts '='*60, current_work_dir, git_status

  if git_status.length == 1
    puts `git -C #{current_work_dir} checkout master`,
      `git -C #{current_work_dir} pull origin master`
      #`git branch`.split("\n").each { |branch| branch.strip!; puts branch if branch.match(/develop/) }
  else
    #git_status.slice(1)
  end

  exit
end
