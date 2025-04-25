Return-Path: <ceph-devel+bounces-3023-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9AF1A9D649
	for <lists+ceph-devel@lfdr.de>; Sat, 26 Apr 2025 01:35:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFCB51BA7E51
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Apr 2025 23:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9412973D3;
	Fri, 25 Apr 2025 23:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMr1QVrB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABF4296D04;
	Fri, 25 Apr 2025 23:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745624109; cv=none; b=N70YJOaFYNJQYKlt7dTR6VJWMa0ubnLo3qljQBMgK9XHGsrzeawtrP/gDp4PXws8HFD01cWv15HAOkfmvh9fhtdTN6tQFBm1HgM3RXgFJJErx7HS3Lb2lqlzGOOTUcZ7gU5PYVyCqcDy3dz9vAx5/zrU/ZnhVfoz4ibAfNDJh4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745624109; c=relaxed/simple;
	bh=9DOpeeDVNX/ufwNa4MPyCJJ0fjb+WNh2lMjb40IKwdo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=uJc1wG9PirROQ5T8qVZBflbwj5ICvBvbQYTa0/za4rZhlXyyyPtphoqcTfvIdGEj8/oue/5OzJoHT/nTg/hPvcgt0OhSutNGgh4hfihjgmBnRFOLWkOueo1arqT6hnLKM7xpigSKgBAv7qEr3+n0+DzeGreBmLPn7XqLt8JSU40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMr1QVrB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE0BC4CEE4;
	Fri, 25 Apr 2025 23:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745624109;
	bh=9DOpeeDVNX/ufwNa4MPyCJJ0fjb+WNh2lMjb40IKwdo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=CMr1QVrBlvYNATuwieOCwSVgKRb/vrsv5y/0sxaxWzh+svpK3OtfjTq8fVFg+uYXF
	 zYn8qhQFD/vN3zCzKtU9T/dvBuPoq1Jl1pZBBouGBYM8Ot/H6oBEvJ/Vt+xgQ2Fkx+
	 kAmUxC/AW/+HJZjSKwv0I8JrS0aJOqFrfKRRsY8lZ99mjJjAm41xsuZjoT9+tbNjAH
	 JPGvMvrUq6d5pCBLp2SsiGkhttxTkDGzyMnoJmz3yTkpsF40e0Rv/fPpkuCcRtlOwf
	 EM0UUh5oD4zkSEHG3TS/yB5tErmfFiQO88Largg6ZVO4Pho5qjCKLRnRxJJaqWs/iw
	 zkerof3THJrKw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33B82380CFD7;
	Fri, 25 Apr 2025 23:35:49 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.15-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250425183924.2739969-1-idryomov@gmail.com>
References: <20250425183924.2739969-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250425183924.2739969-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.15-rc4
X-PR-Tracked-Commit-Id: f452a2204614fc10e2c3b85904c4bd300c2789dc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 349b7d77f5a104cf4a81f5400184c6c446792bd3
Message-Id: <174562414790.3874874.10632399815417158299.pr-tracker-bot@kernel.org>
Date: Fri, 25 Apr 2025 23:35:47 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 25 Apr 2025 20:39:22 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.15-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/349b7d77f5a104cf4a81f5400184c6c446792bd3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

