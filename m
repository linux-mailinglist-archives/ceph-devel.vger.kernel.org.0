Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5EF2DD9C8
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Dec 2020 21:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgLQUV6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Dec 2020 15:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:32850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729978AbgLQUVx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 15:21:53 -0500
Subject: Re: [GIT PULL] Ceph updates for 5.11-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608236472;
        bh=Lieg413S9DPL9nRewgWeOhj5ih3O+Z3qsmV1FGKpv9k=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=PCTX2bxt1jfZzfYYL/Tahke65xxbLgRpwssdepZU8WoFoMsxuwJs6fAbLK2KXwvRk
         CrFxgqopBGuc2EyvSEiexJPpEGJCXXL2hHfukN4UPBKYSekji8PD54zMH68yzLdQyi
         Z4xW9LX2I8efEWuK6vehLrAFf2bPq393CeWdjt6eBwVqHjPCNpDwY8ZbC5+rwl193y
         EhiTxy0CmlU2ClU9B4zU61fLXu/lHFtYsKJRAVGpOBV+BNAauqjEENH899UI7/M2fy
         EVnrbmW1vHAdDeT/PoOZtMoDLRPtv6rGRq6c5sbLmhSH8grqgsscXr3g+QlIkTGZ9h
         XsGhtxPpeMrJQ==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201217162749.18811-1-idryomov@gmail.com>
References: <20201217162749.18811-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201217162749.18811-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.11-rc1
X-PR-Tracked-Commit-Id: 2f0df6cfa325d7106b8a65bc0e02db1086e3f73b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: be695ee29e8fc0af266d9f1882868c47da01a790
Message-Id: <160823647257.7820.17808407074234173595.pr-tracker-bot@kernel.org>
Date:   Thu, 17 Dec 2020 20:21:12 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Thu, 17 Dec 2020 17:27:49 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.11-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/be695ee29e8fc0af266d9f1882868c47da01a790

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
