Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753EE4354BD
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 22:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhJTUsO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Oct 2021 16:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230343AbhJTUsN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 16:48:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 29ADD611CC;
        Wed, 20 Oct 2021 20:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634762759;
        bh=2sIjICmeBt7p6F2VH/35FGrOu045IvITF5KjL8yPs4E=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=BIyaqxlc1sdPma2v0j8VueQZOEfpDrOl5sCqJCxfT6waPJ+8zq+cGR9CyNtwg4glL
         gFrAxQag0m3H2HiNHPJUvSHwkXsMAaYsZ8VTY0CsQHJnCTqnF5DXp26TXmO7w6QT8Q
         GmmFiw/ldXRydn8CUwaEjMPHfooSkGlSoDa0Kl/bvDHgJVwzKHpKBdTFWdu/tUDMTy
         eNRBOgutuB8XxNDYZc3HFWAvWgq+po9YF4AyKDOchr3rM0C7slMPNV+KwulJ1QGdZo
         8KPSJvCdCetb2BuwnAGtkfW7/CS64N2ImylPBVPX2Xai4XTxlM8eB+1be5Z7xznp0h
         /sOmNwHul8nAQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1DC9960A47;
        Wed, 20 Oct 2021 20:45:59 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 5.15-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211020181210.31975-1-idryomov@gmail.com>
References: <20211020181210.31975-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211020181210.31975-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.15-rc7
X-PR-Tracked-Commit-Id: 1bd85aa65d0e7b5e4d09240f492f37c569fdd431
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2f111a6fd5b5297b4e92f53798ca086f7c7d33a4
Message-Id: <163476275911.17864.5549789792838274874.pr-tracker-bot@kernel.org>
Date:   Wed, 20 Oct 2021 20:45:59 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Wed, 20 Oct 2021 20:12:10 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.15-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2f111a6fd5b5297b4e92f53798ca086f7c7d33a4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
