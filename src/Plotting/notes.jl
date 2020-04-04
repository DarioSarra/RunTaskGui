function annotate_session!(plt,s::AbstractDataFrame)
	envs = union(s.Environment)
	env_message = "Environment:\n"*join(envs,",")

	rew_message = "Rewards: $(sum(s.Num_Rewards))"
	streak_message = "Streak: $(maximum(s.Streak))"
	block_message = "Block: $(maximum(s.Block))"
	messages = [env_message,rew_message,streak_message,block_message]
	series_ann = [Plots.text(m, 20, :black, :left) for m in messages]

	scatter!(plt,[1,1,1,1],[4,3,2,1],markersize = 0,series_annotations = series_ann)
end
