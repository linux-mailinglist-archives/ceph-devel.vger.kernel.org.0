Return-Path: <ceph-devel+bounces-3605-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 521C0B56266
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Sep 2025 19:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6A7916F06D
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Sep 2025 17:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1442E21ABA2;
	Sat, 13 Sep 2025 17:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxS1ox4y"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24FA21257B;
	Sat, 13 Sep 2025 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757785809; cv=none; b=T7Pd1kYvUdLkNhgeNDgTZC662aAmii30huQWwL4+JXV0RnhwF3hgiV1xytp3AI6p+AWgUzkAxvzJXTpnbtHDPgWnizNMASqgWb5kk3Bl41Cai58DcU9s6HVJpReWxmLluRuvlJjC50mewvh3vM10AFeZvQEJ42h1rLcmbrwk4FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757785809; c=relaxed/simple;
	bh=Me2VK8B3yS3qdE9o8UQ6EC7qM1jLhNVcDooZE9Hcvww=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=r97L6TVzOx/o1Pt1Gf8FPN/sj8JLni9k2k9g6Y1X9flBp5dJJfxHifeZwY49mTF7RGJ8gHWDChdOkGOPNnHPYeL2dBndDq6AAekIT9PQSu+/znTq4UUK/xSYghe1kDPx+lvyrLksX8EVQPdDIrjXTEBRxhYptWwybyW5+dD9FKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxS1ox4y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A6AC4CEEB;
	Sat, 13 Sep 2025 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757785809;
	bh=Me2VK8B3yS3qdE9o8UQ6EC7qM1jLhNVcDooZE9Hcvww=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=nxS1ox4yE0jMCv6PV/YTOA4ycA82c5HpZd5giAMkx9ZjewM8hB/1fg6uCvjuNdoL0
	 kecv9nOidkmuvlEkERLIZKq/Sp2+lzA90T+Q3672DVVG2UtjfiQIHuAk1a6qRgV1pT
	 RvzKI3IxmNp/zTH+SfeczzwlD95wMXJleDXMdT612Y/W85QH5p1a+vEzH5zLvDbJD3
	 vRb6HlGVNWu5Xo/jA59colAEGGHDJ5CqnTfoDmVZTjmI9RK9TCtPZ0OjkHDAteg+7Z
	 gtgSXWFN1M5HQ6iYvWrJXgyCRGc2xGiEiGNWqDQ4Bg/7tFZ1Lc28m5pI8naENQuxOB
	 ZV/ge35UBG+yQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AED71383BF57;
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
Message-Id: <175778581239.3289160.15887766996970675406.pr-tracker-bot@kernel.org>
Date: Sat, 13 Sep 2025 17:50:12 +0000
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

