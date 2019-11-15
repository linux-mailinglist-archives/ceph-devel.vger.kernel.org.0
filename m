Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F95FE4FC
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Nov 2019 19:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKOSfG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 15 Nov 2019 13:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfKOSfF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 13:35:05 -0500
Subject: Re: [GIT PULL] Ceph fixes for 5.4-rc8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573842905;
        bh=OHKgzOUpXnPdoGshHR7HdVDvkl5j8Sw42Ea4LafCam4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=M4gzUJPNFwjqxqKM9fxj95/Dn6W91WbTBlYm6oMTDBININqJJtXh9wGD5zRXkhNyQ
         lyfsQ8KHJbjBv4t+459wBN+7YNyktfHIJEkLeNPTbWjj9vwB+sAWKmn7TnHu6xT1co
         XJRoo5radsCNvEEQ88tZpGfrxZcNj6CJnwfEDxjc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191115170309.28988-1-idryomov@gmail.com>
References: <20191115170309.28988-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191115170309.28988-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.4-rc8
X-PR-Tracked-Commit-Id: 633739b2fedb6617d782ca252797b7a8ad754347
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 875fef493f21e54d20d71a581687990aaa50268c
Message-Id: <157384290529.19807.1502940485438146004.pr-tracker-bot@kernel.org>
Date:   Fri, 15 Nov 2019 18:35:05 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 15 Nov 2019 18:03:09 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.4-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/875fef493f21e54d20d71a581687990aaa50268c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
