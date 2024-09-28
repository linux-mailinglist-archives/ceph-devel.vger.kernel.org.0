Return-Path: <ceph-devel+bounces-1851-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F53989085
	for <lists+ceph-devel@lfdr.de>; Sat, 28 Sep 2024 18:45:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27FA11F2241A
	for <lists+ceph-devel@lfdr.de>; Sat, 28 Sep 2024 16:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0096F099;
	Sat, 28 Sep 2024 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/jZH9+Z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5E441C7F;
	Sat, 28 Sep 2024 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727541900; cv=none; b=YGUXa3hSEHsT5K3AFYl++jCzklhDjfqSFjgy7OZrhk4fL2JXub9sjd8KQQByqzk35D+yUfxoWUpaPGizQT3goH+rtJcN9t554XVKSS2NU77d99nx0qd1CxZMnpj8Qec7Ybs43iMI22C7Fk4Q+kmcRqHGHJV/rogHVsnz456CbpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727541900; c=relaxed/simple;
	bh=n+2FOMOPrt8TvPY95vA1Hh4z5CLQC3xMPbPLwTzJm8c=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ZcSMpsTgfWHpOnF3mXJlMQ0EPMGN72jhDMi7wW3eTGjmLCx7SnAgh28PB8C4m8dc648cTbHYOdya3xsQRxHbf/2kSDNHKxdAiVWXpeauG5krgQRVVHaPf0DrP42WpldcaH/gxyassOxxVyWqh1gDkJt7Hb7/7oVUlGINDLgttcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/jZH9+Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80052C4CEC3;
	Sat, 28 Sep 2024 16:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727541900;
	bh=n+2FOMOPrt8TvPY95vA1Hh4z5CLQC3xMPbPLwTzJm8c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=j/jZH9+ZJlc9myX1ErCPqLGhf860ZMAl8Bg0x6OvdsyWQ2DcAuwjzOOlqPSL1ZJ2D
	 obcXLSRhpSecdsx7Vgu0FRMNqyRN6500nZbIrxkqHN0sNDpszv7K5ORW5s68xDnj2h
	 CKG0fJ7U6QqNepgDjFlg5nLtw4qHOcue0Y5oSfxw3j4GEvHK8iiYkfBgNipksOfj6e
	 6FhEb+N98r7mIPVH7l3C3lPK9Xi7FL/gwZ2gwLEYshh9GVOJov7hN/+3TXSojMnslX
	 kqWVqefWLOfEER+t5ea3XoQQ4PpQ1CLvxGtvBFHq9mwAVvbaGKsn8c2e5h+lHiHUkG
	 gPCTx7AkV21ew==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71DE73809A80;
	Sat, 28 Sep 2024 16:45:04 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.12-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240927214629.141146-1-idryomov@gmail.com>
References: <20240927214629.141146-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240927214629.141146-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.12-rc1
X-PR-Tracked-Commit-Id: c08dfb1b49492c09cf13838c71897493ea3b424e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 894b3c35d1de9cfa4f72b21e280d80d278879c20
Message-Id: <172754190310.2302262.3989008838768415801.pr-tracker-bot@kernel.org>
Date: Sat, 28 Sep 2024 16:45:03 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Sep 2024 23:46:17 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.12-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/894b3c35d1de9cfa4f72b21e280d80d278879c20

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

