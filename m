Return-Path: <ceph-devel+bounces-2396-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CAF69FA1C4
	for <lists+ceph-devel@lfdr.de>; Sat, 21 Dec 2024 18:37:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7622A188DE72
	for <lists+ceph-devel@lfdr.de>; Sat, 21 Dec 2024 17:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D229616DEA9;
	Sat, 21 Dec 2024 17:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jL4AFbC5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4FC33C9;
	Sat, 21 Dec 2024 17:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734802655; cv=none; b=sJcZhjlSOTYeGZ+WryoVlZPyyYTi9JK5hHD9UZ8hrgiYvzOyXikTTJkr2ER2/7pvXJMiEqDX86Q8R7u9LYYW4YtnE1cmPK7FDXbjUiTRMjsRJFYcBHjd/0z2X0e0xYbh3zjSxhSGkizsdto2SNJyP3059p2zNBM3LIhI+SkYf7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734802655; c=relaxed/simple;
	bh=//SkUEoD9TWgRvTkpAlOtRs1w09BRM6gE+g2HMWUaO0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=L3xFNCsXJrq0kufnJiHaBfhffsi98hoY3LCH3BrRSCpOHnS0skUxl2crax0xyWDm5+RGSIAUqQM+4/MdnzS4isJPd3bTBC9UMZ5a8BqJoOr5S0f55PIWc1GHz9PuqodFAY+UF8btjO4/eezSCtB/3OoEEltMcKeICUQjEoNNEuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jL4AFbC5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D016C4CECE;
	Sat, 21 Dec 2024 17:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734802655;
	bh=//SkUEoD9TWgRvTkpAlOtRs1w09BRM6gE+g2HMWUaO0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jL4AFbC5R3HQhDP9DcAC1DQolaz6T7ZfEjbkat9PlcNwe0yzrDqURIel/aDy0f61V
	 Voz+yGLC9mGQNS9t1ylkA44Meu2v+tsE+kywDTjQmV+6TuGVL/CK44SwJ1cY/yhtft
	 NVeMTxgnzH5NwqXQi40aoc/KQn+MFUPkgIHPSFt96/7ZKHm3uu6HGdP1RTzojbD7ap
	 jbXO3T9b0tS9ucg0GwnD6FYw7nmFEZLq5zwnMc89cU4F8C9Dp/tXbCsO5HDVUa7GuR
	 J762zlFAmJgRmbzoV8Z8TYr/yN6fT9MM6vgKAM1y9MaWUZ4v1+7A2dq5kmEoCIlT25
	 sXraGxgJg8WVQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADFE83806656;
	Sat, 21 Dec 2024 17:37:54 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.13-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241220194104.1350097-1-idryomov@gmail.com>
References: <20241220194104.1350097-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241220194104.1350097-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.13-rc4
X-PR-Tracked-Commit-Id: 18d44c5d062b97b97bb0162d9742440518958dc1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7684392f17b05a9881a5f05b6ca5684321598140
Message-Id: <173480267338.3197313.9922637984905522905.pr-tracker-bot@kernel.org>
Date: Sat, 21 Dec 2024 17:37:53 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 20 Dec 2024 20:40:54 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.13-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7684392f17b05a9881a5f05b6ca5684321598140

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

