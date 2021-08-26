Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302CA3F8E3A
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Aug 2021 20:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243427AbhHZSxo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Aug 2021 14:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243350AbhHZSxn (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 26 Aug 2021 14:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3230161037;
        Thu, 26 Aug 2021 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630003976;
        bh=jGK9z7VnsfDQbBtoI8QPPnhsyNljWbSzll0gW0U9WO0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=sKGDTa6ODv63LawRnlpz+wRF/Dx8PdaibBAhpC6wde1Qz4cT3oP10OdbPLEOsvr9x
         m4N46hhHHs8xA4dygjUqETdmicMwSOeHmt/hRoBPexsKgAm/TE3MJ1Tn8ttXgWsGhY
         9rhnQYmreKU7cj0zqYQzjqBV4FqRz2w3bynYNaXNRqokVpOUJMCjSC8x9VCyDUnVqo
         l8dJPm1dBTqPeORIx0TFcsdtBbWsGdio4hHe0DPFufZwmRQMFPa54t1qIZOKRBH9Qk
         M0KiluG6wKQHiAU/si+DF6mYk4nzbYHZ1xHGgtL60kB6PoR7MEFvxSzBP+pi/3z3Eq
         fdA+f6FFC/HJA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2C1FA609EA;
        Thu, 26 Aug 2021 18:52:56 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 5.14-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210826155142.31960-1-idryomov@gmail.com>
References: <20210826155142.31960-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210826155142.31960-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.14-rc8
X-PR-Tracked-Commit-Id: a9e6ffbc5b7324b6639ee89028908b1e91ceed51
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 97d8cc20085f63cfbf0b123295e12cf9ad66a03c
Message-Id: <163000397617.15844.17618892086136538010.pr-tracker-bot@kernel.org>
Date:   Thu, 26 Aug 2021 18:52:56 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Thu, 26 Aug 2021 17:51:42 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.14-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/97d8cc20085f63cfbf0b123295e12cf9ad66a03c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
