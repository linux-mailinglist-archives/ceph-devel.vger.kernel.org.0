Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C3F4179E2
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Sep 2021 19:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344333AbhIXRfT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Sep 2021 13:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344204AbhIXRfT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 13:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 16CD26103B;
        Fri, 24 Sep 2021 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632504826;
        bh=Nb5U16HKk3BcY9XwkBB9fPow+I7pIioYkKtVaOcRETQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=M/O1aZgUbusPK7uA/vbq7wGGzRS76yV32ysACFydQ9EXEP6H/yn6uMYwf6q7YLmJ4
         0ozo8n+VhH4JYz5bAlqgmnL3P5sGFZJJ1nfjrH7qeqHIWFf2/CcIiyRkAQI5a50Qn/
         KdczEHOIipQT+GII+FUI5nw5cg0+PIqUsGgJzpvF8OI4oer/F+08bt0eUJ6yClRxH6
         4G21BESUHcYoB3rtq2FoVmf3P2fTh/yNnVo7HQiVqsGAXNi2tpPONY8xrudYFnFffI
         1yAXv1dRWjEiyx3i9lLlYUhRphl3wir8BoKpipflYSWexTOLDwxZ8vunAsm3rGRB2/
         ux9gOj3k48g0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D98060A88;
        Fri, 24 Sep 2021 17:33:46 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fix for 5.15-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210924115201.1182-1-idryomov@gmail.com>
References: <20210924115201.1182-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210924115201.1182-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.15-rc3
X-PR-Tracked-Commit-Id: 708c87168b6121abc74b2a57d0c498baaf70cbea
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4c4f0c2bf3415a5fe7512d17d841bc1f8020b2cb
Message-Id: <163250482604.13479.5671490287353873021.pr-tracker-bot@kernel.org>
Date:   Fri, 24 Sep 2021 17:33:46 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 24 Sep 2021 13:52:01 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.15-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4c4f0c2bf3415a5fe7512d17d841bc1f8020b2cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
