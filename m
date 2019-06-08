Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9413A274
	for <lists+ceph-devel@lfdr.de>; Sun,  9 Jun 2019 01:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfFHXUQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 8 Jun 2019 19:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfFHXUQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 8 Jun 2019 19:20:16 -0400
Subject: Re: [GIT PULL] Ceph fixes for 5.2-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560036015;
        bh=NPAj0LTbm23/h0bYT049hwbLN2GkGOpeqVdbgYEPxAw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=t9VVhTPVSSuext+LZecjZCrOHfH0BJpBJ8yqFt/cKKMuA5Ip5L691U2UM/vbhtg0w
         /n9GChTczPowamR1/uqy7hDUb34+EbYdZBsUP/OGcFkXJjkbK3kehSemFQNO7QThVR
         rBoz6Kj88F5upoQ7JlkMcw+uQOScnTT9f64Nvg1s=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190608190438.7665-1-idryomov@gmail.com>
References: <20190608190438.7665-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190608190438.7665-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.2-rc4
X-PR-Tracked-Commit-Id: 7b2f936fc8282ab56d4d21247f2f9c21607c085c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2759e05cdb2577a0e8970a9fa80a7f5ff092596f
Message-Id: <156003600933.32420.3897484961481092321.pr-tracker-bot@kernel.org>
Date:   Sat, 08 Jun 2019 23:20:09 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Sat,  8 Jun 2019 21:04:38 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.2-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2759e05cdb2577a0e8970a9fa80a7f5ff092596f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
