Return-Path: <ceph-devel+bounces-3833-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57340BCE469
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Oct 2025 20:45:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77CBE19A7954
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Oct 2025 18:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4CA221F1C;
	Fri, 10 Oct 2025 18:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eASnlPZY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2583032C8B;
	Fri, 10 Oct 2025 18:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760121933; cv=none; b=ntIg+MZQLd6KDWe0SCCU69U7QGhpyy55bN+pNHgKTBliHabIyWKQDaNGvCy05Wt7/xhowrLWhmXnppt2bSZ8g1Yc5+TJw+m7Z8cKPaFNEWpmrtV/zxcYmiaLiLaTAIXLO0A2DrDc6DXi/Wl65JC5f+Y0d/zR+Q/shGdFi4t/v0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760121933; c=relaxed/simple;
	bh=7QRARD1mem4lnHtsl56ZrDVSw5QKgPuxWcHZdcJcblI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=b2zejwnhG+1LNgtSP4/rt0I4l7i1QjzGVUzxwlP1NsUapUbRgXocFWdNxz2CWK1DxcecpgSz4aYWNXH5lhu2xibbhBWI9/mSYHm0oyv+0osdZS+pluPVGXPCxYvphmRhJNBRvZWPzU+9Q8r/Xfduw1sbXLDbzqv3HpQYRhkREXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eASnlPZY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05385C4CEF1;
	Fri, 10 Oct 2025 18:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760121933;
	bh=7QRARD1mem4lnHtsl56ZrDVSw5QKgPuxWcHZdcJcblI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=eASnlPZYIj4kpYT7Jg7M2kmI5eD830ghxXlA3chswjYgJhW9KNJkPoyskUp8ki4f5
	 ebkNRMjvuRpm9m8W6NA7vozgNOwatjA0y2tNpO2rvPRbuofNJNQmxpnxxq/evJUFDU
	 3tM9VYDBXx0jbgJ5C6xzf80r+03/wr8VB/pvDSItwmqH6pfWs7zceJMz/Gaxje64uz
	 90vXDfwUXYk1smcUI62JMEx735qDFs43SPiCtMV90SJI678+xSic1RHwPLwiFZpnZC
	 gPI2JoiruXupTuf+IorZIaANA8LleEo5Mc7WWJGExXfjm5Sk8p4BnoG5PtJxnYq2ne
	 VGN6XaQCCQErg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE4EE3809A00;
	Fri, 10 Oct 2025 18:45:21 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251010180728.1007863-1-idryomov@gmail.com>
References: <20251010180728.1007863-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251010180728.1007863-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-6.18-rc1
X-PR-Tracked-Commit-Id: d74d6c0e98958aa0bdb6f0a93258a856bda58b97
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8bd9238e511d02831022ff0270865c54ccc482d6
Message-Id: <176012192036.1082823.11911265326689703984.pr-tracker-bot@kernel.org>
Date: Fri, 10 Oct 2025 18:45:20 +0000
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 Oct 2025 20:07:25 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-6.18-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8bd9238e511d02831022ff0270865c54ccc482d6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

