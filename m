Return-Path: <ceph-devel+bounces-1887-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B8DA990A60
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Oct 2024 19:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FED7281DF7
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Oct 2024 17:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 047C01DD865;
	Fri,  4 Oct 2024 17:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBKgm563"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79F11DACBE;
	Fri,  4 Oct 2024 17:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728064207; cv=none; b=aGHGwmmfdbO4wMVJEaE4HjLvcZKKuPJ7isYhVz4Hkaff7F1ubJNCs81dXNdXbeWvzeIqcwHC2Fvua332yLuGS6VZqBGAZ9qzeMQkn2gFfH+Y+grlCA7EPoMoEWsYYN6M5Ux+FoC4KbKurfOomic9vfkQ5oxKKDC34Lo7PzlPiMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728064207; c=relaxed/simple;
	bh=jgdML/3ztlQAG27D/LlMyBH91rSZzIgfhSi9pIlvEyQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qyLyvrKBglXHGeuQiV08ZA8nQWG1jyn0fidLUuktTuMy6iFIvdhkta5XIATkcJjR5fC36c0mgscWWbJLCi4exLt8xfPMoYeWXsStjvDdzbhkgOwsW++KfyYrXQqdhrUN9HcnSCAutKA1Vi28o6wBSuMnkaoodhJPs9Q8GwAHmis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBKgm563; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BB1C4CEC6;
	Fri,  4 Oct 2024 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728064207;
	bh=jgdML/3ztlQAG27D/LlMyBH91rSZzIgfhSi9pIlvEyQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FBKgm563VPHnYts9pwPkLhhvEvHt5cXY0ixDbfBuEiCXVNNkmEj/a49lq7dDsKbYi
	 kd2qaOazhPublxSlG4Q+ed48gIFBQtPGkwAjlpXF6yN9/hVZYXGyVo4VKfrs7xhbvM
	 nTNHaf8kzETuXrh8KV+wzPUJEQoacfoAzh1+xfGzx/dWpkiKG8MTl4G+/3oNa+x8js
	 a7j8G7jPBml2AllWmvLmfnfSJhT2Muh/lO0cRhPxZPn44o1TjHKY8BeISJfaFa18Yb
	 y/cACq7mQjZcZCKoqj/92A9vgiSDvLQ8tl3PO87hMUWyaYhC4er9wTMX32Pwz57L26
	 ToJtG8jQue3Dg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 716BE3ACF641;
	Fri,  4 Oct 2024 17:50:12 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.12-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241004170658.479285-1-idryomov@gmail.com>
References: <20241004170658.479285-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241004170658.479285-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.12-rc2
X-PR-Tracked-Commit-Id: ccda9910d8490f4fb067131598e4b2e986faa5a0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a3a37691e662b76d9c8a4d74cd856b5a4ae8286e
Message-Id: <172806421120.2676326.10147533197506663248.pr-tracker-bot@kernel.org>
Date: Fri, 04 Oct 2024 17:50:11 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri,  4 Oct 2024 19:06:56 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.12-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a3a37691e662b76d9c8a4d74cd856b5a4ae8286e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

