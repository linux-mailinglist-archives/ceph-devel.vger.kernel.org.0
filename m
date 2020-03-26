Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D68D194BD6
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Mar 2020 23:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgCZWzI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Mar 2020 18:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbgCZWzI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 18:55:08 -0400
Subject: Re: [GIT PULL] Ceph fixes for 5.6-rc8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585263307;
        bh=ykgN7vSNukui7er8OSPcb4iomGAuvoHq1tX3NKrR6SI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=GwvF0ogthRVl4rXhneE4xDWcs4WnSzeq2zAPk+JMtvSfDy9WPBukEyRSAFauPJhdq
         sDgcAmugvYh3GgBmCeaJYSRJzOWNUQtST3mFSPCaXBjApPQVt3QIaFUcngbtJqkS+n
         dd1Lqe5Pcv3ImSktzClZdNk923x0chXHNU6uBHgQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200326201453.7227-1-idryomov@gmail.com>
References: <20200326201453.7227-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200326201453.7227-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.6-rc8
X-PR-Tracked-Commit-Id: c8d6ee01449cd0d2f30410681cccb616a88f50b1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 60268940cd15491be6db4503d6f74f27fb38ae42
Message-Id: <158526330769.848.2322945349643657136.pr-tracker-bot@kernel.org>
Date:   Thu, 26 Mar 2020 22:55:07 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Thu, 26 Mar 2020 21:14:53 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.6-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/60268940cd15491be6db4503d6f74f27fb38ae42

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
