Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1FE44F505
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Nov 2021 20:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbhKMTrN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 13 Nov 2021 14:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236057AbhKMTrK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 13 Nov 2021 14:47:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0439A61215;
        Sat, 13 Nov 2021 19:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636832658;
        bh=SVyeWuTfSD5QrriiasD8VNT+BHbUyOlzTZKcqTmWZMg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=iksKJqVF5fQAN7ye8iNr9081RcFHCL8qWAk2JeywjTsD2h6IqVvYmdfboSnlizmFu
         HONzYWWumVUWkdGs6L9thxdLCoqtZEMHEkJZj25zjpeCOOt+sDCs3Aj+qjZES+utCz
         NkQfEdQkM72FrBdQ377IHEIPsgmDfuLQuS9zyFncF6C+TJXsDJQylLEH6DEa/oqbqg
         q5J62eecBqPUYrJoY1UD/VC9LcLzt37MXuVlpsmgdC4D03aZwnb8BAlT1di5dx32Fo
         Uw611QUQOxiCYZ3Po6PlKM56JrfEQNNtBp0ueAuiPMwq2Vc0z5YJk0oaX6xDZqicho
         qXb1innjV2k6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ECC6A60987;
        Sat, 13 Nov 2021 19:44:17 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph updates for 5.16-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211112111132.27316-1-idryomov@gmail.com>
References: <20211112111132.27316-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211112111132.27316-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.16-rc1
X-PR-Tracked-Commit-Id: c02cb7bdc4501debc3e71a4d2daf7286c48e1d38
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0ecca62beb12eeb13965ed602905c8bf53ac93d0
Message-Id: <163683265796.24678.17555720309336887682.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Nov 2021 19:44:17 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 12 Nov 2021 12:11:32 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.16-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0ecca62beb12eeb13965ed602905c8bf53ac93d0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
