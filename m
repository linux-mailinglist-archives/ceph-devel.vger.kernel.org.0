Return-Path: <ceph-devel+bounces-79-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A76A7E81F0
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Nov 2023 19:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C922BB20B7C
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Nov 2023 18:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3F7200D7;
	Fri, 10 Nov 2023 18:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IjOIb1Z0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7121C6BD
	for <ceph-devel@vger.kernel.org>; Fri, 10 Nov 2023 18:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B37A9C433C7;
	Fri, 10 Nov 2023 18:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699642079;
	bh=abRVdJbrQHoxpPW40qat4I6wx9/AKw0jaC4RFIiOfdI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IjOIb1Z0dxMHSTVqA9E4W+HQBd03hczU8YUVgOjBlSLY9hm55aw7U2AG0NuWoxt+7
	 93bu3ucm/xCIyCUm9jwKx4IcnFijwmvc50RmDPzAl5yGxZbnlFJO9tKcwF+dvzlLFu
	 38iVbGPOQxllcBqArAbyHk+CknzBg4DWTP/co9cxO0Mt1vFuDFXyE03xfn2diEDMUY
	 xB0RvJJfLqZcH2DAisE8L1g2oYK18kAIt/OVI45HQYkmp906Hj3Y2zWd/ofqtqQvrz
	 5s4mjwW5NfaPN/skExwStBBmtPH7Kdi1HvDGav7XBXaR8FagvVVd1evZOBPUifIObw
	 2itnGgV90WfFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A355BEAB08C;
	Fri, 10 Nov 2023 18:47:59 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph updates for 6.7-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231109174044.269054-1-idryomov@gmail.com>
References: <20231109174044.269054-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231109174044.269054-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.7-rc1
X-PR-Tracked-Commit-Id: 56d2e2cfa21315c12945c22e141c7e7ec8b0a630
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e21165bfbc6c5d259466a7b2eccb66630e807bfb
Message-Id: <169964207966.13214.15645286579277461920.pr-tracker-bot@kernel.org>
Date: Fri, 10 Nov 2023 18:47:59 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Thu,  9 Nov 2023 18:40:42 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.7-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e21165bfbc6c5d259466a7b2eccb66630e807bfb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

