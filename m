Return-Path: <ceph-devel+bounces-3604-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BB91B56265
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Sep 2025 19:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAE8B7AA313
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Sep 2025 17:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C696821638D;
	Sat, 13 Sep 2025 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OrD0T12m"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D26213E6D;
	Sat, 13 Sep 2025 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757785809; cv=none; b=FQUf6xMekKK751q0WXw/xujG6rDO+VaRoAmTfuqWwmcf1oOUzKNtdm2VUA1phDqv+KOzovTb2ix7CEuYi1NW6sLOs+BRKgJOI/gpbCQrp3RSnfNKg3iv2AtpspSEocGK0Yk3/RIV+ydfUmhc1t0mZ1zKGm39D5B7mmoAj8yl874=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757785809; c=relaxed/simple;
	bh=Me2VK8B3yS3qdE9o8UQ6EC7qM1jLhNVcDooZE9Hcvww=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gUTqcIn5EVbg/MG0VFyM9HTX8C+3gR04D3NUCdY6AHFWADBXCxr+dAeZR5x09okXWidgl7BUQNimyRIHs++gYBJAZctwMDGlWp0hoJ0q0pC/WUzQAZd7fMZcj5gT1DaAZLHmlNEu2wromRpANsVAKYa3hZ0GTNMBXe0hDRZnxo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OrD0T12m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DF3C4CEF9;
	Sat, 13 Sep 2025 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757785809;
	bh=Me2VK8B3yS3qdE9o8UQ6EC7qM1jLhNVcDooZE9Hcvww=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OrD0T12mpqiPn+a59z50OoQDDmJP/JP8yFjf6wDv+/d5n0pGNUialWQ3wLB4TBqMX
	 aptBzihD/Fhnurt87hmDu8fe5B5pM/ZRmPYmVSHfczDW/ThmltDPsICmElDI/ScGek
	 IkBEYO+OToYrnavAVDF1h3+PmUt/TrVAkDBr8zY7Qkancy4vKmW2coaP7W3WXzfEtW
	 JEELKbxa+oHbAK/LzUqS6rsOtK4ipddP1q9r4NnFBVLo2eEL7w8hW/5meA4I5Z60Cf
	 uREpvdu37Gs89WBlAK2/ui84o0Qc4YhSwBNT2yjkAtAwLKJ/cZBznzjWf6vo6EVx2U
	 uz5vTvT2JQEzw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADD04383BF4E;
	Sat, 13 Sep 2025 17:50:12 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.17-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250913155830.96394-1-idryomov@gmail.com>
References: <20250913155830.96394-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250913155830.96394-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.17-rc6
X-PR-Tracked-Commit-Id: cdbc9836c7afadad68f374791738f118263c5371
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5cd64d4f92683afa691a6b83dcad5adfb2165ed0
Message-Id: <175778581135.3289187.11754596056717662172.pr-tracker-bot@kernel.org>
Date: Sat, 13 Sep 2025 17:50:11 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 13 Sep 2025 17:58:29 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.17-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5cd64d4f92683afa691a6b83dcad5adfb2165ed0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

