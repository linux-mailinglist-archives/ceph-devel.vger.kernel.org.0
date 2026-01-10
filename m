Return-Path: <ceph-devel+bounces-4358-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F4190D0CCD7
	for <lists+ceph-devel@lfdr.de>; Sat, 10 Jan 2026 03:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B2912302A476
	for <lists+ceph-devel@lfdr.de>; Sat, 10 Jan 2026 02:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449771CAA78;
	Sat, 10 Jan 2026 02:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sphLT/rA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF06E244692;
	Sat, 10 Jan 2026 02:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768011508; cv=none; b=jO0cnC6QMWlXdTbKvhfWfJSiSd0m9E1dTXz5hA1j555ZG701PigH7tms0xNWElgV1hUgxJYGtZ7s1hG0dsNB3ABqorxqRSk9x7T0+3LYoVj0gyGrKs9XdBhJbbxw/dIJVl09QdvFO6JGUbonsTo3uvii9fHWnS3a1uOBHIbrvZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768011508; c=relaxed/simple;
	bh=N5cSCbUMjQW+BMj3nlOaqz1w+BbPRr0JzfN8WzvYEp8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=XHxKWyK15mAdZ+f5pBYBv2f2yjqmlDV4mWtb/prnMFX6WAHqIG/3vHkN8qlqh5zfR6v1JbOCffKrZxLX/0j4vhecF3wclPmBU8o+7jCnhqEYRL59YKzKiWOmTnQbGZtAULZIZHrOfBjO9v8JjbKu3aA4wCfiF9nZGjwwcN+Ql0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sphLT/rA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4428C4CEF1;
	Sat, 10 Jan 2026 02:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768011507;
	bh=N5cSCbUMjQW+BMj3nlOaqz1w+BbPRr0JzfN8WzvYEp8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sphLT/rA2KcuWccP7YM+AfgaH6EXld2EtObLKGBxMISlU0kns6OSmw5Qenmf92LX6
	 U+6gbr+jKk4Wq9VCGqmHMW7kfAC3VhdRfhFGVyfbob7he9p28UGcchsMWRD15B9dVB
	 3/daS/0YSsCrK58lCExkVYUej1MK0e3ABjxYZjKqJM6W/VkQ+lYl+SYNIvQBe/4KtE
	 SmHaDRoW1dBdqabVw+3hdEl3L13aFYlpPnwnV/j7zpB2z7mwY1zQ3d3M/Wbcg4pg4Y
	 cRt1UAMka062lLvw4R/FOFOIO/28jUIoNHPoJSh6dSzYjL5EbcjuGl3pdd1wjGjwQ/
	 cCEktmNlm67jw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B59DE3AA9F46;
	Sat, 10 Jan 2026 02:15:04 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.19-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260109175103.174536-1-idryomov@gmail.com>
References: <20260109175103.174536-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260109175103.174536-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.19-rc5
X-PR-Tracked-Commit-Id: c0fe2994f9a9d0a2ec9e42441ea5ba74b6a16176
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4621c338d33f2e49c55d317fa5b1fbc0ae1cccb7
Message-Id: <176801130336.452892.1293487290760199008.pr-tracker-bot@kernel.org>
Date: Sat, 10 Jan 2026 02:15:03 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri,  9 Jan 2026 18:50:57 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.19-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4621c338d33f2e49c55d317fa5b1fbc0ae1cccb7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

