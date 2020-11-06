Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD6B2AA18C
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Nov 2020 00:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgKFXv2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Nov 2020 18:51:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbgKFXvY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 6 Nov 2020 18:51:24 -0500
Subject: Re: [GIT PULL] Ceph fix for 5.10-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604706684;
        bh=Ozzy98JSnAVmhU32d4UpVKkWORHdzxl7GQTipU8Yslw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=nmcgsdj4dR3wCVpRPOBwkBEwAIst4890kIj7Q379QDkLzECtySZQnfYdhPL0nM06h
         +VpdHy6hw0UFaQZVLhkhD7v+kJUMQoccJXcNjTcwYodvZEPlrH+wOltlOeh5rojbW4
         iqxF1W7tKnbzARm5eYOJg+wxwVQCl3CnqxnklsL0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201106192750.32141-1-idryomov@gmail.com>
References: <20201106192750.32141-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201106192750.32141-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.10-rc3
X-PR-Tracked-Commit-Id: 62575e270f661aba64778cbc5f354511cf9abb21
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 659caaf65dc9c7150aa3e80225ec6e66b25ab3ce
Message-Id: <160470668410.27031.3576455118713554705.pr-tracker-bot@kernel.org>
Date:   Fri, 06 Nov 2020 23:51:24 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri,  6 Nov 2020 20:27:50 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.10-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/659caaf65dc9c7150aa3e80225ec6e66b25ab3ce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
