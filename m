Return-Path: <ceph-devel+bounces-2619-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 00FFCA24412
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2025 21:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B040188B709
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2025 20:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9851C1F4710;
	Fri, 31 Jan 2025 20:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EavGf45T"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BEB1F4706;
	Fri, 31 Jan 2025 20:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738355220; cv=none; b=OM/D9IR6cAxSEiJJA7HK120SLZH4hezAB8oPLd+ANR2/q+JazobCGYw74g+LZvL6a438less9Dq5a/8+DXRodginQgiq+HYZOi0Z0+UnBk8yZ3dO8gUDQ9lmAbc/us4pGVswyda4YrrjCqGx/s855yX/vqI3exw15azUTyX6uVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738355220; c=relaxed/simple;
	bh=UWBwnZyAQeVr9/fBdPaIaXb5flEix//Ihiq2RtbiUCs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sBpi/9nYJY9wsUQVpsp2sbsA9iEuAIOvolB67yT2ZH169aWgZBaFU6A/ZhwS84P5c2f9/WsbmL5KRn9KSAdlF6kijcO8ZGPeab5vomqf2CtcZqskz0ID91ldJbDNdsol3HmAVhX096wEcPRzmERJFaa9gBZd8Ipi1Rvu761RPGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EavGf45T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F41EC4CED1;
	Fri, 31 Jan 2025 20:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738355220;
	bh=UWBwnZyAQeVr9/fBdPaIaXb5flEix//Ihiq2RtbiUCs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EavGf45TgHNEruqvEhEaRe7BUOLeVEh+d38dlPA1M5Ism9BQSB2x6VgMgfi6DrzSg
	 a6GyDjNprMgCOFx346Dlu9kZYeOt9kKw4QkekZo0dggWoduhVohm5MuXBkwEYWumOd
	 1R3cWGA+jm07H5VN+T2tXRho9yXLsGwRUHnMELr+ypTGYhJ8cyKJd/9XXqzD3Q1GEm
	 R5ugtpRaDddaqjt7F60HPt3g1mhusLZwA4X2JTp0zbGUnRqzury3yNW1XsWKA3vk3j
	 0+UbhADgBW8w2LjhoEJDVbTYiSkiYbtGamjltvjmfTFos8o1F/LhxnNsh1ktUBS5RN
	 y4tJnwgvEGNpQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAF0D380AA7D;
	Fri, 31 Jan 2025 20:27:27 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.14-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250131181425.3962976-1-idryomov@gmail.com>
References: <20250131181425.3962976-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250131181425.3962976-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.14-rc1
X-PR-Tracked-Commit-Id: 3981be13ec1baf811bfb93ed6a98bafc85cdeab1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 626d1a1e99583f846e44d6eefdc9d1c8b82c372d
Message-Id: <173835524656.1719808.2903667915229670938.pr-tracker-bot@kernel.org>
Date: Fri, 31 Jan 2025 20:27:26 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 31 Jan 2025 19:14:22 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.14-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/626d1a1e99583f846e44d6eefdc9d1c8b82c372d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

