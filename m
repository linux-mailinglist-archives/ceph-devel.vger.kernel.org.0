Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA611A2EA1
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Apr 2020 06:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgDIEzd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Apr 2020 00:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgDIEzc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 00:55:32 -0400
Subject: Re: [GIT PULL] Ceph updates for 5.7-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586408133;
        bh=9Whta/9PHFzOg9U9UvavgWEtC9sqqrhNap+vynEs3oc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=N6CFuWDUYwr3KbBGBjuYoBVjL3qqkJ8tqlboeyBFOvZhJyKZNKluyuIb5BAyiKZQ+
         TIPYREjGpFJETVZnFm6NYqiZE1cVI/TB/IbQfpYuLRBV765ZiYK458ibXbdc5A2g/F
         jBIhj73lab+0t2hsXrrhjmtenm/jnXwe5ylrqrVA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200408183007.19305-1-idryomov@gmail.com>
References: <20200408183007.19305-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200408183007.19305-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.7-rc1
X-PR-Tracked-Commit-Id: ef9157259fb7bb3bc2c61df227e36f1b861a4753
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fcc95f06403c956e3f50ca4a82db12b66a3078e0
Message-Id: <158640813310.3202.2935579625440754696.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Apr 2020 04:55:33 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Wed,  8 Apr 2020 20:30:07 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.7-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fcc95f06403c956e3f50ca4a82db12b66a3078e0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
