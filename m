Return-Path: <ceph-devel+bounces-4175-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 418E0CBB682
	for <lists+ceph-devel@lfdr.de>; Sun, 14 Dec 2025 04:45:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AED0830050A1
	for <lists+ceph-devel@lfdr.de>; Sun, 14 Dec 2025 03:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8FF4186E40;
	Sun, 14 Dec 2025 03:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jodxAK4u"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AA3F50F;
	Sun, 14 Dec 2025 03:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765683949; cv=none; b=lcTwjRSIKRbkKdGgEQyyKqaxfFsvRZdg4NdQwDRPUXthatRPLCFrR04iaCj7ROGHL7aeAxVl3BtL6z4U3jp7tOUxx5hYSvrERZYQE0yL03DRy7HCryGhfhfufeluOib0MkyjY+wF2Fm6blzlVOJpp5uHGWsHEi+TJcVmnzsVjNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765683949; c=relaxed/simple;
	bh=cD2jvXUwzooe4SuV8EKzMrFejeyQBcf3fePNm31A5E0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=A7M6/fxaFBfADEUgwM48MXGOA9lj6Hw4ah8V6xqZlUuiNgUe9eoZneMBwqpOlwB9jHAg/Z3SLUcbCpZLFI6ssKS3PXwci4xo/iSC5aHK1WDbu/J0Lepf9qIOqzfG4m9mdiBPBVc15PNE7vrZGjFCFIQalKcOjZVQ44LxM8dCEQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jodxAK4u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9A7C4CEF1;
	Sun, 14 Dec 2025 03:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765683949;
	bh=cD2jvXUwzooe4SuV8EKzMrFejeyQBcf3fePNm31A5E0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jodxAK4umnA6QJ9I9xYzPMt1ZEMv9O+5zSaJb/V3eIEOC/3l3/n99NVbZqzgsSI0F
	 6pnI41pl6Va14y43ZCdwIxgyymNOJ2NONqiDs4M0sZL3oo1VfhRl6OEVTiIUWXcX3b
	 swZHxSjpI5BJOymVakc3g/wAhs57Qdq4VLwB2/pbEAMQ73TvvDKohmW4YO7SuGlssV
	 SlHDZy4PN9p0kU3qkvY8okEc/mmI/LBpBry5/owl8vRjAn8cLDZuWMQPVq5t8R3hr9
	 Wx/fduaXx959VRIYLPllQi+9bY7US+OPcenrpXCp5jxCreGWXGPkjRDGnenqEZ9jNW
	 c2I4qr2AhWVJw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7B69A380A95F;
	Sun, 14 Dec 2025 03:42:42 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph updates for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251212190213.3275119-1-idryomov@gmail.com>
References: <20251212190213.3275119-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251212190213.3275119-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.19-rc1
X-PR-Tracked-Commit-Id: 21c1466ea25114871707d95745a16ebcf231e197
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0dfb36b2dcb666f116ba314e631bd3bc632c44d1
Message-Id: <176568376084.2694290.17580119946536949396.pr-tracker-bot@kernel.org>
Date: Sun, 14 Dec 2025 03:42:40 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 12 Dec 2025 20:02:12 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.19-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0dfb36b2dcb666f116ba314e631bd3bc632c44d1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

