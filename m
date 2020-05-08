Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1341CB656
	for <lists+ceph-devel@lfdr.de>; Fri,  8 May 2020 19:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgEHRuF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 May 2020 13:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgEHRuF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 8 May 2020 13:50:05 -0400
Subject: Re: [GIT PULL] Ceph fixes for 5.7-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588960204;
        bh=TrNueBRdYzQt9mYSA71sGkB6vYCquUlYEtQ8RABmWNM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=L1WYyn5EFNgKvEtLSvdIAx6dgHzV1pXUzAsCAp3ldpM09azj77jpDQBh0rFlbTmB5
         AQMkRQrDaHvPOfTWYKkDepzImHpd0b+8kYR6lirDnpxqTm/VcK2sR0zjLV//lS2b/t
         cn4FhphGjem33o3js5sBjjuSSxwnhuATAYYqPL/U=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200508171613.27097-1-idryomov@gmail.com>
References: <20200508171613.27097-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200508171613.27097-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.7-rc5
X-PR-Tracked-Commit-Id: 12ae44a40a1be891bdc6463f8c7072b4ede746ef
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: eb24fdd8e6f5c6bb95129748a1801c6476492aba
Message-Id: <158896020488.31681.8447306784194982028.pr-tracker-bot@kernel.org>
Date:   Fri, 08 May 2020 17:50:04 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri,  8 May 2020 19:16:13 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.7-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/eb24fdd8e6f5c6bb95129748a1801c6476492aba

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
