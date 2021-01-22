Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79E1300F95
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Jan 2021 23:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbhAVWEd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Jan 2021 17:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730703AbhAVWBU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 22 Jan 2021 17:01:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DFDE423B1F;
        Fri, 22 Jan 2021 22:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611352839;
        bh=Jde4JDN+krmqkjCY3s3Tt+sCpxSUIQjuZG6YsoWqjU4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=aoOrG+j6XbCuTkdHgN8+UMHiPeW+wNAjJVDh7QhNjp/vGaSBg3Y4A4emfVzZEZp5p
         vA5HCJL4brO9+oyuAhkS3PYMhvZugruu1O/iEBy4wI9EQUtKHGU2YC/C2LKA8DmiHr
         6RS3dRknECNew9BvUYeClYqNnaGwXQik9ZK4hm+KgtPLFe/6sW/V35hJi5uv/2YlGj
         M1yK5g3aeACGxiOuoX/ACAZwa0axXku88jYglZTNXuAQkg6xAkbZshn8nWMqecwM1c
         S0FCStfZ1+69kZvKiZaaJCZJ3/arovhhcZ6szgag3q3sdwYjbc5DYtiv2v48u4eKDL
         tZCqkS/0+3jZw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC301652D1;
        Fri, 22 Jan 2021 22:00:39 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph fixes for 5.11-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210122160605.5939-1-idryomov@gmail.com>
References: <20210122160605.5939-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210122160605.5939-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.11-rc5
X-PR-Tracked-Commit-Id: 9d5ae6f3c50a6f718b6d4be3c7b0828966e01b05
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a9034304ff7b3569af4f159d0c1d4ba33d86cf47
Message-Id: <161135283989.4174.16804179094768483379.pr-tracker-bot@kernel.org>
Date:   Fri, 22 Jan 2021 22:00:39 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 22 Jan 2021 17:06:05 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.11-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a9034304ff7b3569af4f159d0c1d4ba33d86cf47

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
