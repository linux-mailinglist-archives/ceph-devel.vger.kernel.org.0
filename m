Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0F71148B0
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2019 22:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbfLEVa0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Dec 2019 16:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfLEVa0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 16:30:26 -0500
Subject: Re: [GIT PULL] Ceph updates for 5.5-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575581426;
        bh=53gsHQqClcL7Aoql6lXSgoCQDVGew2OQgpP6KIPSa0A=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=eSpNdX9kP0dDK8YXRUf7OuUQUmrgmsqgGcxcWfnSP7GQV0hTUxW/kqhzUFQLD6Yuj
         myeFOXznzNzTNXzVSxWyVOCkUF95tmKlug84XDKGT1PAvhhs42OPSFgFlCGIg+fGEO
         YNA44a7dPeq0y/T4gXL/lIvomYeivgx21auy7ZW0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191204200307.21047-1-idryomov@gmail.com>
References: <20191204200307.21047-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191204200307.21047-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.5-rc1
X-PR-Tracked-Commit-Id: 82995cc6c5ae4bf4d72edef381a085e52d5b5905
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a231582359ec27e121bf4bb0ab3df8355f919d1d
Message-Id: <157558142612.8243.11548479580688352353.pr-tracker-bot@kernel.org>
Date:   Thu, 05 Dec 2019 21:30:26 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Wed,  4 Dec 2019 21:03:07 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.5-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a231582359ec27e121bf4bb0ab3df8355f919d1d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
