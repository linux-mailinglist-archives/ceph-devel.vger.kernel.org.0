Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89311E8998
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 23:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgE2VKI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 17:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbgE2VKG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 29 May 2020 17:10:06 -0400
Subject: Re: [GIT PULL] Ceph fixes for 5.7-rc8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590786605;
        bh=x7ak+HKJ19JERDJRy7L/qYqdy8S91ns4K/PnmrFInfc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=vv3FTqCzTGMVEl3lcd0EsHVWnFJ6o0cUtrS6MN2Uw9LsxZxArwfdSssL5DeXN/Fdm
         A3PuMf4AIbzIEPblSeMFEhPXtsYD37fMRpksoIcxDg1gy2hl36OpNGHZnn99KbLdn7
         c+bRRJ1M+f+lLQdgRMb/2jSl2vuWXoUi4KuesKCM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200529155257.21043-1-idryomov@gmail.com>
References: <20200529155257.21043-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200529155257.21043-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.7-rc8
X-PR-Tracked-Commit-Id: fb33c114d3ed5bdac230716f5b0a93b56b92a90d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e2fce151d2b4bd9722b3344ae381c768d249761f
Message-Id: <159078660588.32003.3531710216240216117.pr-tracker-bot@kernel.org>
Date:   Fri, 29 May 2020 21:10:05 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 29 May 2020 17:52:57 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.7-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e2fce151d2b4bd9722b3344ae381c768d249761f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
