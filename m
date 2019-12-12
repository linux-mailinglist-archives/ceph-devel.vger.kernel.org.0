Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD12A11D686
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Dec 2019 20:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbfLLTAU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Dec 2019 14:00:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730261AbfLLTAT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 14:00:19 -0500
Subject: Re: [GIT PULL] Ceph fixes for 5.5-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576177219;
        bh=e5iEmKXSwBW4stCxNjzaIyjzXmWMgd+4ZU5KXVy1yLQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=AfLOwtSJvqLir3srn0Xm8Gvea/fDbJvupeYb4wrDVo/ZO0FSkcrr+Jm7QZXUaurl4
         TgqJp6NqGH5iIlvYDvqFdFUMuyJ5RxC4zwWLs5AqJVfgZtGAJ+a+vQUVE0kE5icKfc
         AEtGeDKH6KuFGTbbezBo+Te2bG9qvqzM+aybs4p4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191212184356.7143-1-idryomov@gmail.com>
References: <20191212184356.7143-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191212184356.7143-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.5-rc2
X-PR-Tracked-Commit-Id: da08e1e1d7c3f805f8771ad6a6fd3a7a30ba4fe2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 37d4e84f765bb3038ddfeebdc5d1cfd7e1ef688f
Message-Id: <157617721920.9887.11221829530650580146.pr-tracker-bot@kernel.org>
Date:   Thu, 12 Dec 2019 19:00:19 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Thu, 12 Dec 2019 19:43:56 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.5-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/37d4e84f765bb3038ddfeebdc5d1cfd7e1ef688f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
