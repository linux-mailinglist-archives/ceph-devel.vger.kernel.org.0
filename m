Return-Path: <ceph-devel+bounces-1162-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A858CF171
	for <lists+ceph-devel@lfdr.de>; Sat, 25 May 2024 23:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E11B1F21568
	for <lists+ceph-devel@lfdr.de>; Sat, 25 May 2024 21:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD762128807;
	Sat, 25 May 2024 21:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NqZb+B0R"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAE012A144;
	Sat, 25 May 2024 21:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716672729; cv=none; b=Z3eirmT3rMh1R7h65EgGJgRjAcLNjkmfQsc/AnoGtVI5E2G7A4fkO4xpxI3Pndy8bdMxwl0qSBHaNbVf1P9owX4Po2vASZQFTUIXSv6qs0xN31X4kUvf9RTMciX0RfiKXdHbKeL/2qKU0Vl/gB+J1uboPZyixpWxhepuPIwYw+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716672729; c=relaxed/simple;
	bh=9Eg1k3p8BipcszsZLNndHQqZpvewIp55QoJUVm1TvSc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=r2muv19H7v77lHJYlmSl4ElhigQ0qvjJjqjMELFzYDUl1MO65sQOVinYn73rL4rV+b/kaYQXxqxPjdg0nZyorGA9FNpMmAqLJ3pUJgOIg+ozIYigAvTLF5l2zr1aAfwgrr0q1VPN/mD4FfTBf9FHoxN+WXET1xURRJjVV5QXQFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NqZb+B0R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61EC8C32789;
	Sat, 25 May 2024 21:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716672729;
	bh=9Eg1k3p8BipcszsZLNndHQqZpvewIp55QoJUVm1TvSc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=NqZb+B0RDBuKl7bf3VXA9zgKu0YDPmn1teyJDs9qQo2BEMVElzwsmKWiH4+UGvZuW
	 4IaLJUMU4ewOLry4H8p10G9yOgxvAMDxKJaI66uruVbJfim/sA1F1ExB/4Ak6lFHBN
	 x+swwn/0pUdG4RTv4uriNjaXuJymjfkRrFEG5VEafDq1iuliiVJIAtU+LVeIpNijFc
	 k0PUZX00dmjxYx6RIWyS81bShFjKkTaaB5SVnqLqQ+UjIDMcrtP9eoE9VNO083Yb6v
	 ZYsIibv++lObGod2dRHXurRp0QWoOjoHjAnF5Si+p1CHbk0MIDbX+SA58CJJViBVni
	 EYwfhzGFNN3VQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A3E0C433F2;
	Sat, 25 May 2024 21:32:09 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph updates for 6.10-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240525095738.3046298-1-idryomov@gmail.com>
References: <20240525095738.3046298-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240525095738.3046298-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.10-rc1
X-PR-Tracked-Commit-Id: 93a2221c9c1ae32643df67c482dc4c4c591b7514
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 74eca356f6d4429497a097a8ed4dfa76c441bab9
Message-Id: <171667272936.25058.2908553170380448829.pr-tracker-bot@kernel.org>
Date: Sat, 25 May 2024 21:32:09 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 25 May 2024 11:57:37 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.10-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/74eca356f6d4429497a097a8ed4dfa76c441bab9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

