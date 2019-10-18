Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECD8DD517
	for <lists+ceph-devel@lfdr.de>; Sat, 19 Oct 2019 00:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395095AbfJRWuJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Oct 2019 18:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:32880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729034AbfJRWuG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 18:50:06 -0400
Subject: Re: [GIT PULL] Ceph fixes for 5.4-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571439005;
        bh=KCSvp0ERsuqTZ6xhTbOYZl5RkXmC8gexcwDy3BL+tdo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=0DrlqKWuPxrMgDN34n70NHarJjYo+R5D5TqR9lJr9dKWF/Fp7wakDPzzOEhytLSAy
         StPzFw7Offj4CpoPTd2zRq70gW+csqIuZF5bj9U6hyoEwB2WQkj5/Xo1wtatMBqzy6
         /Hm6mKodjTKVHf2cvzC1wOTjkwwUwhRthBtqaYd0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191018181511.8844-1-idryomov@gmail.com>
References: <20191018181511.8844-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191018181511.8844-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.4-rc4
X-PR-Tracked-Commit-Id: 25e6be21230d3208d687dad90b6e43419013c351
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6b95cf9b8bb3cb647d9f43109a9c50a234b39781
Message-Id: <157143900578.13317.9811568128379617942.pr-tracker-bot@kernel.org>
Date:   Fri, 18 Oct 2019 22:50:05 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 18 Oct 2019 20:15:11 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.4-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6b95cf9b8bb3cb647d9f43109a9c50a234b39781

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
