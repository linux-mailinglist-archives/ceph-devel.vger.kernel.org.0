Return-Path: <ceph-devel+bounces-1569-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4462993D7F6
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2024 20:07:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE737B20B73
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2024 18:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80BA17D347;
	Fri, 26 Jul 2024 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2rmbS6b"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C36917CA0C;
	Fri, 26 Jul 2024 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722017251; cv=none; b=Gog0M22z79uOQBGLWdNIXi58tLQR9e3xPlr4J/W9OF/HBYRp4MHlxwWlv+eiJbA6SHJDzS6mg3xgs4URY/ESbNJ099Xt84NrwVi4fpjJFpLaU7X5OW5Qiwfl/g7VFBWbsOoKQo3mVTY+oLrLhF3bKNxIqyF0djAZJNyEQ4We0D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722017251; c=relaxed/simple;
	bh=JF/b1/6Cha116FFPL0XUll6mcIi5ySTusKOcLsK21+A=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tLmMcP6mBu2X3oVJCo+d4bVAwAamDJQPxwunSoBdaaYj02X8NYs05w/irlWitEGSQt1tnADD70n4jtOiaLcXg/arW7VxdYivXINMxQkusUy4ADkzCSWBB1Elmv/wvmYPin+md5LUwM5A4Bm+34mfGxK9YI/VxZbJlysBBeSz8GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2rmbS6b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3010BC4AF07;
	Fri, 26 Jul 2024 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722017251;
	bh=JF/b1/6Cha116FFPL0XUll6mcIi5ySTusKOcLsK21+A=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=U2rmbS6bjTiyXqT0bRILyr6x8hR8EUxvs/23L5Pii69mCMPUtj1Wo3rmzzRJqi9Zv
	 mjkuoDs2+4vV3CmfaRx1T3C/5LviaIXKxkZuQZmnzlEYKoJ2jfKr1wSAcnC7j7gyqL
	 pZWaR69df9WuAVLHhnfoN0+ruTvgNlrIhx6GIeoWd16ion3tkx7QQIUockzAMeiRGZ
	 +sWeEzRPN8rJwcIBu2WwU09fbrZydk/tJF0d1BbHn32qnpvge0O/0AbIMcawRO5QTK
	 jswMUlq1DMfCewbA/ZF4EHcDksRJt/tLohPZE5SroBzmOZDRmiDElBnKZ35+94A6aw
	 wLbDEaGdU2CMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 292CFC43443;
	Fri, 26 Jul 2024 18:07:31 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.11-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240726144215.738251-1-idryomov@gmail.com>
References: <20240726144215.738251-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240726144215.738251-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.11-rc1
X-PR-Tracked-Commit-Id: 3ceccb14f5576e02b81cc8b105ab81f224bd87f6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6467dfdfc94cfefed728bb1d9eb78493760469e0
Message-Id: <172201725116.32235.16117757101716699385.pr-tracker-bot@kernel.org>
Date: Fri, 26 Jul 2024 18:07:31 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 26 Jul 2024 16:42:11 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.11-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6467dfdfc94cfefed728bb1d9eb78493760469e0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

