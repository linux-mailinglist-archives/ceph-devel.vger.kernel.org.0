Return-Path: <ceph-devel+bounces-1630-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D439462AA
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Aug 2024 19:40:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 963EEB24EE1
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Aug 2024 17:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D671AE028;
	Fri,  2 Aug 2024 17:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJclct2l"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D031AE023;
	Fri,  2 Aug 2024 17:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722620409; cv=none; b=Kh5a7d9eaDLqqBNWQUFjaNZQywC6EoTCEhnKTjjOmqmIriMB3AGkhkVu/MnMV4BH9/nXFAZs4fYKAnxJWvtpjICvKVEXpyZahF1CUf/LVVD2wBJ8t9zs3/IaDjUqb1dql42uSwrmrgX0Q11t8G1rvmyy/oRDen33/s2fNDdxoXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722620409; c=relaxed/simple;
	bh=sBJNIQPyXwbbNB/4i0QDtUIWb/5aRWTc7gGPe0Yp+0Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=T7NErcGyClyLpatOgb4LCVUWghHpXRzrPiyPy+MIdTQ4C+8wMOy4FROHPXdJhPmhznnaND+gI1ukgOoDEBwWYrViSJgMXQqH2HhCQJ2ikf4wKE8L4HRvrOhAHeY/MtpoAXt+iAoum7o5IHlx8w7+6haV9MRNQ90IECLNLIO/tH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJclct2l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3994AC4AF0C;
	Fri,  2 Aug 2024 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722620409;
	bh=sBJNIQPyXwbbNB/4i0QDtUIWb/5aRWTc7gGPe0Yp+0Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=iJclct2lloscHT8Xev+/yEbFmBBreEo3JR6DXfe7r2woU2abUSnZiOjJ138Ac7sbi
	 lXla0I6twE5T45UfVYv2dHcv2k6iRiFw8q95XlHQD6g/sTjJmd8vlWBiqV5dj6j81g
	 C7UnHZTpDrDzvBePbWADaOouejij/3AK3veQw2QvN+aCekJG5QAktNWBVrV7aw8S7K
	 99oLBFJExzLrApezeOMzKYIG2ZoL8dYz9p0qGuiu3Hqg0ujU1re85BXh+Xedijszlo
	 CTQzhAc3M299LcfwtmQJ4feEIYOR7Skb+HnfROnUTtMdM3IppYGWjCY2xMaRmxDoVB
	 WeAXzVmhcJmSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2CAF0D0C60C;
	Fri,  2 Aug 2024 17:40:09 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fix for 6.11-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240802164638.900157-1-idryomov@gmail.com>
References: <20240802164638.900157-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240802164638.900157-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.11-rc2
X-PR-Tracked-Commit-Id: 31634d7597d8c57894b6c98eeefc9e58cf842993
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1c4246294c9841c50805cec0627030c083e019c6
Message-Id: <172262040917.22533.6293043183273641130.pr-tracker-bot@kernel.org>
Date: Fri, 02 Aug 2024 17:40:09 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri,  2 Aug 2024 18:46:36 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.11-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1c4246294c9841c50805cec0627030c083e019c6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

