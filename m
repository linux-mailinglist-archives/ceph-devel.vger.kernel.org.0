Return-Path: <ceph-devel+bounces-1527-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0D79300BE
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Jul 2024 21:13:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87CB32812EC
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Jul 2024 19:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A039329D1C;
	Fri, 12 Jul 2024 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StvEza8X"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412E03B298;
	Fri, 12 Jul 2024 19:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720811566; cv=none; b=CN2By0YLmjGI9qxhcID9rvZ4BfREWXx6mLWaK2RLsNUPAtN9EXL4YiJC64oEaCnby72fqAxC+GNRO6getoN2WcurFMjv3u8LyeLYK9Ze4Ds4thgaT9cCfwY4HoQquINytdpUh2NjZtd2IqXXI9CVPTIWGZ60NVTCg0mC7m1ZyPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720811566; c=relaxed/simple;
	bh=+xZB+bI4xEcKISeHQ7aJrkAbhBugyBO7JIKkctNxKww=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=o3Uh1GeBp9GPhjGJRVD+0FojzxftuHMWHDRMbyKR+X7Dt0TjL9A94tnIyxrcdlZZUWk5/1p8wJNPLGFAd5njNG9UGk0SwFc2HxvU2rFGZgp2fA4Mx+SeOGDLmHGLeIWT87aD5RnjttbPBGe0T2XvmFU7HV62OPGy6rIKm2NxOvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StvEza8X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C63ABC4AF07;
	Fri, 12 Jul 2024 19:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720811565;
	bh=+xZB+bI4xEcKISeHQ7aJrkAbhBugyBO7JIKkctNxKww=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=StvEza8XBYh4CprG1AlFQi3ZdobcqF0yzUd8dpdRUZgN19qsW/UASjigXhhI/8rR6
	 KAawkVgo+Oq/X+uAFUmJFsG84BeTELVfub899xxKSIifWpwuLHr+BDyOq8WGHL4kPp
	 59oaja0iJJZeiNadoPUmiEpZGQYt1fGJMwynTzQO17C77qwHNG3gVM/r0nk3qj0P29
	 gWLfthuITO8dBHPcTjVFov7ry1s1jQDk+tHvn/04azsafpyjV9bk9DRP/u2MwSiVi3
	 DLPcH2ygT8I5vZ1OzWNYwS8zzeIUMzHzzUwsB8hVtDPEJyRRAqCJVSDr1k+BqRJNA/
	 GtwtKPfcbZGXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA1A7C43153;
	Fri, 12 Jul 2024 19:12:45 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.10-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240712164745.409957-1-idryomov@gmail.com>
References: <20240712164745.409957-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240712164745.409957-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.10-rc8
X-PR-Tracked-Commit-Id: 359bc01d2ecc9093216d21cfa03a545c44413cb6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a52ff901a17432a86efffa4d6fb41cca59042802
Message-Id: <172081156575.20584.14095664804037981002.pr-tracker-bot@kernel.org>
Date: Fri, 12 Jul 2024 19:12:45 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 12 Jul 2024 18:47:43 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.10-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a52ff901a17432a86efffa4d6fb41cca59042802

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

