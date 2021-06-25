Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A953B4866
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Jun 2021 19:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhFYRvV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Jun 2021 13:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhFYRvU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 13:51:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2EBD561954;
        Fri, 25 Jun 2021 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624643339;
        bh=3vpWE6f7wjyqq8GeDWYeP+oVg2sBTsxfXZhQW9g3ofA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=PsFlk1OJok0RNw7P5lTYdOgMPOnX2iir9zqTYcO2qdiHg0YJEaPhHWpKlbxut9trH
         3YIBj5yzvnzzc6aavouPIjyrjLurfd9zBDLaEHiV8t0qWcBX/CdoJdPUnmyNeSsYzb
         T207q1b6leRCGbN4f50eN+UoxBubkbbaAEzYFfPSl0sGUef4V8IKJPjLvi4AGcfPqe
         915IcCmKeAp3NIasFE3GnEVY6UMkz3TSIzF7BImUN0LPMcHMoY/BMI1Tc3ueGt+aaZ
         2TJNR9ODFIQ098zcxoUyHKGYJTlxyVGewbO45BSbKsbLeQWdGK15z4eguR713j+xSh
         6VwZu/vAYpyPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2338560A71;
        Fri, 25 Jun 2021 17:48:59 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 5.13-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210625141823.22507-1-idryomov@gmail.com>
References: <20210625141823.22507-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210625141823.22507-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.13-rc8
X-PR-Tracked-Commit-Id: 03af4c7bad8ca59143bca488b90b3775d10d7f94
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: edf54d9d0ae0a230199a58e57b46c2d4b37a1462
Message-Id: <162464333913.2214.12397192524434670483.pr-tracker-bot@kernel.org>
Date:   Fri, 25 Jun 2021 17:48:59 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 25 Jun 2021 16:18:23 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.13-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/edf54d9d0ae0a230199a58e57b46c2d4b37a1462

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
