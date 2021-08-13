Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BD83EAEC1
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Aug 2021 04:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhHMC7s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Aug 2021 22:59:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234260AbhHMC7p (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 22:59:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7CF8660F21;
        Fri, 13 Aug 2021 02:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628823559;
        bh=GlH1w0D3K1zwaPSFWAzyNpvmScMIl9hgWA50wCvf7Ws=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=pfmNAGUxQUJVAmsEUBOh3jKu7/TavVyXzwgRyPSd3b10kOKzPfGnElsHFhxe1YMx3
         fNUY+A1wlJGOQRosugDGUmAsz5Tr2TP8gxNQdMohiecyIetR9EgWmr1J6Z2Um9gtz/
         stf0pp7mtD08B2WPYPSUD8mItVlgDK9BJaMMLvHRJS0N5xEaKyisHb5VS3iyGQwydo
         5MLGmv2mr5yD3Eg6z04Ygs/FsyEBwYOciIaF9/NU2SV8gVoiN1122Gx4scSPG3g8Gq
         5oGwHi8LwH3uE+O4LDNgPI9/nCd6xKiGh6qdLsDttB/X5n9wcdTWpvP936TTZdHVmw
         xUgJcJRF8rbpQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6A19260A54;
        Fri, 13 Aug 2021 02:59:19 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 5.14-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210812184409.8832-1-idryomov@gmail.com>
References: <20210812184409.8832-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210812184409.8832-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.14-rc6
X-PR-Tracked-Commit-Id: 8434ffe71c874b9c4e184b88d25de98c2bf5fe3f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3a03c67de276a6abb412771311f93a73e192b615
Message-Id: <162882355937.1107.14113022987401355511.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Aug 2021 02:59:19 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Thu, 12 Aug 2021 20:44:09 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.14-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3a03c67de276a6abb412771311f93a73e192b615

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
