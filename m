Return-Path: <ceph-devel+bounces-4124-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B5528C90145
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Nov 2025 21:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 40D12352E64
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Nov 2025 20:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537B830EF7A;
	Thu, 27 Nov 2025 20:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qAmSp+g6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB4130E0C8;
	Thu, 27 Nov 2025 20:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764273944; cv=none; b=gBQEt0bifi1kF/QzToaxiOpWWYGbaSkZ1yA6gBnFcrbacaeOtBss6ZpwBfWyER3WFRMtdC4oz0p8rjwgwSv1Bzn8Vw0V0nUkbf6cLKMbtIQhEUQ9fo33gy6hAa1UKkcG0HfdGfihsFgHrbO+SKPh3PW+iY/z1i0iJQtElM9Z+mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764273944; c=relaxed/simple;
	bh=SP2eauiFu9PLdQT+UsBG4p3Rz3gO1JLJBPE9DpRtcGk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TCCefi2PmNJdbghbZSANnJcoc534yvjxW4k00eK4IcsiXJw5OZG5ZUGyIJHZWpiy/lSy/Xsn369poWpOsvt1NhZCnsFzK0H+jBPERWsPhzbA/DNab3bytOz+opIUrr6yDnwLQXZ5SWGAyvLuLQ39WXLgVBR0NmjSOt42aGbnVbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qAmSp+g6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882CAC113D0;
	Thu, 27 Nov 2025 20:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764273943;
	bh=SP2eauiFu9PLdQT+UsBG4p3Rz3gO1JLJBPE9DpRtcGk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qAmSp+g6iyEHzOyrZDBbRKtBuNzbJ/dOniLFyLEWWFm+T2tQhnKRNiDbOLXsk3YBB
	 PSGvTf8jQv3WRa1oJ90RCugyzAmj7Olo2+TaT6v/6n4vQDd/VswFgP98QBqzQ3Rr+h
	 4rZ0Cx7gf+VC2QPhC01EYGQAEBaF2FSW2eD3zLXeS3W0EfvvAoZi6O9hybIix3xlXj
	 h8+3AdQ7pJmoMfFnwU7L9RckuAjNR1fovWdjbSlFm2bAwD7pRdFEzUPtA03Gln1lal
	 ttYwRonJAux8MALcR/xuKuqQcwhaTW+aQAjSOH2Fo2g44kuUlPCn4qqOg/SZot/KY4
	 qwuWJWvxy5dkQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B7C93808204;
	Thu, 27 Nov 2025 20:02:47 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.18-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251127184958.2776540-1-idryomov@gmail.com>
References: <20251127184958.2776540-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251127184958.2776540-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.18-rc8
X-PR-Tracked-Commit-Id: 7fce830ecd0a0256590ee37eb65a39cbad3d64fc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e1afacb68573c3cd0a3785c6b0508876cd3423bc
Message-Id: <176427376575.20489.18398247980926572316.pr-tracker-bot@kernel.org>
Date: Thu, 27 Nov 2025 20:02:45 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 27 Nov 2025 19:49:56 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.18-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e1afacb68573c3cd0a3785c6b0508876cd3423bc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

