Return-Path: <ceph-devel+bounces-3078-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C2DEAD0ACF
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Jun 2025 03:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45B5B3A9892
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Jun 2025 01:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A01BA2580F7;
	Sat,  7 Jun 2025 01:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CA+KFfUg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549891EA73;
	Sat,  7 Jun 2025 01:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749259039; cv=none; b=GJXQNWhBaf0E+qLPD05TEBN3fQJ398TVMUCGLX9HVz2HbbVItn46Pz7aVFND8/7UIIT2RVUW7pjR2iYsKDtCapgKGslte/qz6zbRE/JAWA9VbrVObi4G6lDC78MT/283YsNBbCZ9x4TQ2eKcluEqxNXOi7+qfbHBL8eOLClSApY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749259039; c=relaxed/simple;
	bh=WAbrwWok54fMblxXdWAKnZbSzWhmGyMI5rX9Bz/t8h4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=He6Mltsm8a9SxlD1+jD12gl/xMHhQH7Us5NwC46EtXa8aXlrS3nmV/iJiVf3JvYfUiKf4uVaR/JmiKkPthcCWvMVCJ1TaYDKruvJkKvv2awJHGAheCqR4YaS7p4rcXILw3W0gVwlAn2xqNY7OBYMhQf6QAnPJbA0cbofe3h54iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CA+KFfUg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3566AC4CEEB;
	Sat,  7 Jun 2025 01:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749259039;
	bh=WAbrwWok54fMblxXdWAKnZbSzWhmGyMI5rX9Bz/t8h4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=CA+KFfUgAC8GIGxXWLPA5tzGUsd3AlF0KYcLcxKwQl8lBrCePZ5fi0UV8JEKiSh9Z
	 s0plNUISxcXTnc4fjk0JqLDeI3Y+E0NVNA4mv1O4NM4f9lwbgUBcnfJ6SRp1sYoR61
	 SC0/rDTxutEofwrfyydtx3s3+aLN1fjsCSpjY1fq9OMQMMupxOlzh6pMJjw+Zu49Zj
	 TQLPBe2a15zwefUfckA3XNJ195k3z1U/5vdvLKAoT2uV2K3OeBCsJLokkmszzekFEA
	 v+VyG0MMaS2840mDdef8L6MGYugBYrTKEBpv5Q+Q7LF0ag04wvbNhLzVIG6FSPbb0P
	 eFlGr1jNTROAA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAE823822E05;
	Sat,  7 Jun 2025 01:17:51 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.16-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250606175250.218814-1-idryomov@gmail.com>
References: <20250606175250.218814-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250606175250.218814-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.16-rc1
X-PR-Tracked-Commit-Id: b828b4bf29d10a3e505a76a39c4daea969e19dc9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a3fb8a61e4a18f11dab281d5afa370e4aaded47b
Message-Id: <174925907043.4051830.9226740252386126959.pr-tracker-bot@kernel.org>
Date: Sat, 07 Jun 2025 01:17:50 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri,  6 Jun 2025 19:52:35 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.16-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a3fb8a61e4a18f11dab281d5afa370e4aaded47b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

