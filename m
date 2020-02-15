Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8EF615FFC0
	for <lists+ceph-devel@lfdr.de>; Sat, 15 Feb 2020 19:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgBOSkU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 15 Feb 2020 13:40:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbgBOSkT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 15 Feb 2020 13:40:19 -0500
Subject: Re: [GIT PULL] Ceph fixes for 5.6-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581792019;
        bh=nmrC8Gv/Y1Cox/igouzLpzsYakwEcuZMZUQp9HRg8Ak=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ANuDMHcrzFeweHvHX5kOCKZ+3RuNHTe6e32/YP/MGgQ/C4N1OMsx5SU876taXdPiQ
         49Hec8b9TvK/OiESViwmdmvILYTQPKGlovt9GBA2BPYxl2ckcG1x46VxlBi5LqBWlT
         GtJXAkfMfyVExK0qhCN85r3ToK5F2s+QCYeDrgic=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200214164944.6044-1-idryomov@gmail.com>
References: <20200214164944.6044-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200214164944.6044-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.6-rc2
X-PR-Tracked-Commit-Id: 3b20bc2fe4c0cfd82d35838965dc7ff0b93415c6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cf556edfde6cfc293ce63de02ac23f725e41dfb1
Message-Id: <158179201914.28665.11052799318253522198.pr-tracker-bot@kernel.org>
Date:   Sat, 15 Feb 2020 18:40:19 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 14 Feb 2020 17:49:44 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.6-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cf556edfde6cfc293ce63de02ac23f725e41dfb1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
